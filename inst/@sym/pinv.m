%% Copyright (C) 2014 Colin B. Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @deftypefn  {Function File} {@var{B} =} pinv (@var{A})
%% Symbolic Moore-Penrose pseudoinverse of a matrix.
%%
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function z = pinv(x)

  cmd = { 'x, = _ins'
          'if not x.is_Matrix:'
          '    x = sp.Matrix([[x]])'
          'return x.pinv(),' };

  z = python_cmd (cmd, x);

end


%!test
%! % scalar
%! syms x
%! assert (isequal (pinv(x), 1/x))

%!test
%! % 2x3
%! A = [1 2 3; 4 5 6];
%! assert (max (max (abs (double (pinv (sym (A))) - pinv(A)))) <= 10*eps)
