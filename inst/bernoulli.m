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
%% @deftypefn  {Function File} {@var{b} =} bernoulli (@var{n})
%% @deftypefnx {Function File} {@var{p} =} bernoulli (@var{n}, @var{x})
%% Return Bernouilli numbers and polynomials.
%%
%%
%% @seealso{euler}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function r = bernoulli(n, x)

  if (nargin == 1)
    r = python_cmd ('return sp.bernoulli(*_ins),', sym(n));
  else
    r = python_cmd ('return sp.bernoulli(*_ins),', sym(n), sym(x));
  end

end


%!assert (isequal (bernoulli (8), -sym(1)/30))
%!assert (isequal (bernoulli (9), 0))
%!test syms x
%! assert (isequal (bernoulli(3,x), x^3 - 3*x^2/2 + x/2))