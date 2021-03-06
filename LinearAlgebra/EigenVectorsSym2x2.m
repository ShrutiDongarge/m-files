function [v varargout] = EigenVectorsSym2x2(M, varargin)
%% Returns the normalised eigenvectors of a symmetric 2 times 2 matrix.
%
% [v w] = EigenVectorsSym2x2(M, tol)
%
% Input parameters (required):
%
% M : 2 x 2 real symmetric matrix. (array)
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
% tol : threshold below which entries and eigenvectors should be considered to
%       be zero. Setting this parameter too large may yield incorrect results!
%       (positive scalar, default = 1e-12)
%
% Output parameters:
%
% v : if only one output parameter is specified, the v is a 2x2 matrix
%     containing the eigenvectors as columns. If two output argmunts are
%     required, v represents the first eigenvector.
%
% Output parameters (optional):
%
% w : if required, w contains the second eigenvector.
%
% Description:
%
% Computes the eigenvectors of a real symmetric 2x2 matrix.
%
% Example:
%
% M = [3 1 ; 1 3];
% [v1 v2] = EigenVectorsSym2x2(M)
%
% See also eig, eigs

% Copyright 2012 Laurent Hoeltgen <laurent.hoeltgen@gmail.com>
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

% Last revision on: 08.12.2012 20:45

%% Notes.

%% Parse input and output.

narginchk(1, 2);
nargoutchk(0, 2);

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('M', @(x) validateattributes(x, {'numeric'}, ...
    {'size', [2 2], 'nonsparse'}, mfilename, 'M'));

parser.addOptional('tol', 1e-12, @(x) validateattributes(x, {'numeric'}, ...
    {'scalar', 'positive'}, mfilename, 'tol'));

parser.parse(M, varargin{:});
opts = parser.Results;

ExcM = ExceptionMessage('Input', 'message', 'Input matrix must be symmetric.');
assert(IsSymmetric(M), ExcM.id, ExcM.message);

%% Run code.

a = M(1,1);
b = M(2,1);
c = M(2,2);

if abs(b) < opts.tol
    
    if nargout < 2
        v = [1 0 ; 0 1];
    else
        v = [1;0];
        varargout{1} = [0;1];
    end
    
else
    
    v1 = [ a-c-sqrt(4*b^2+(a-c)^2) ; 2*b ];
    v2 = [ a-c+sqrt(4*b^2+(a-c)^2) ; 2*b ];
    
    if norm(v1,2) > opts.tol
        v1 = v1/norm(v1);
    end
    
    if norm(v2,2) > opts.tol
        v2 = v2/norm(v2);
    end
    
    if nargout < 2
        v = [ v1 v2 ];
    else
        v = v1;
        varargout{1} = v2;
    end
    
end
end
