function out = MedianFilter(in,mask)
%% Apply a median filter
%
% out = MedianFilter(in, mask)
%
% Input parameters (required):
%
% in   : input image. (array)
% mask : 2D array with odd number of rows and columns. Center will be the mid
%        pixel along every direction. Entries serve as weights. NaNs mark pixels
%        to be ignored.
%
% Input parameters (parameters):
%
% Parameters are either struct with the following fields and corresponding
% values or option/value pairs, where the option is specified as a string.
%
% -
%
% Input parameters (optional):
%
% The number of optional parameters is always at most one. If a function takes
% an optional parameter, it does not take any other parameters.
%
% -
%
% Output parameters:
%
% out : Resulting image.
%
% Output parameters (optional):
%
% -
%
% Description:
%
% Applies a median filter on a given image. The mask is cropped at the image
% boundaries. No padding at all is being performed.
%
% Example:
%
% mask = [nan 1 1 ; 1 4 nan ; 0 0 2 ];
% I = double(rand(16,16) > 0.2);
% MedianFilter(I,mask);
%
% See also MeanFilter

% Copyright 2012, 2013 Laurent Hoeltgen <laurent.hoeltgen@gmail.com>
%
% This program is free software; you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation; either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
% Street, Fifth Floor, Boston, MA 02110-1301, USA.

% Last revision on: 27.02.2013 06:53

%% Notes

%% Parse input and output.

narginchk(2,2);
nargoutchk(0,1);

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('in', @(x) validateattributes( x, {'numeric'}, ...
    {'2d', 'nonempty', 'nonsparse', 'nonnan', 'finite'}, mfilename, 'in', 1) );

parser.addRequired('mask', @(x) validateattributes( x, {'numeric'}, ...
    {'2d', 'nonempty', 'nonsparse'}, ...
    mfilename, 'WinSize', 1) );

parser.parse(in, mask);

%% Run code.

SigSize = size(in);
WinSize = size(mask);
M = Im2ColSignalMask(SigSize,WinSize);
S = im2col(                                            ...
    ImagePad( in,                                      ...
    'left',   nan(SigSize(1), (WinSize(2)-1)/2),       ...
    'right',  nan(SigSize(1), (WinSize(2)-1)/2),       ...
    'top',    nan((WinSize(1)-1)/2, SigSize(2)),       ...
    'bottom', nan((WinSize(1)-1)/2, SigSize(2)),       ...
    'uleft',  nan((WinSize(1)-1)/2,(WinSize(2)-1)/2),  ...
    'uright', nan((WinSize(1)-1)/2,(WinSize(2)-1)/2),  ...
    'bleft',  nan((WinSize(1)-1)/2,(WinSize(2)-1)/2),  ...
    'bright', nan((WinSize(1)-1)/2,(WinSize(2)-1)/2)), ...
    WinSize, 'sliding');

% Add mask and weights.
S = S .* M .* repmat(mask(:),[1 size(M,2)]);
% Sort columns. NaNs will be placed at the end.
S = sort(S);
% Compute position of median element (excluding NaNs).
mid = size(S,1)-sum(isnan(S))+1;
% For each column get the index of the middle element(s) (in case of 2).
ind1 = sub2ind(size(S), floor(mid/2), 1:size(S,2));
ind2 = sub2ind(size(S), ceil(mid/2), 1:size(S,2));
% Average both. If a column has an odd number of elements ind1 = ind2.
T = (S(ind1)+S(ind2))/2;
% Reshape into an image.
out = col2im(T, [1 1], SigSize);

end

