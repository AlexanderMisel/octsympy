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
%% @deftypefn {Function File}  {@var{s} =} priv_disp_name (@var{f})
%% A string appropriate for representing the name of this symfun.
%%
%% Private method: this is not the method you are looking for.
%%
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function s = priv_disp_name(f, input_name)

  vars = f.vars;
  if length(vars) == 0
    varstr = '';
  else
    v = vars{1};
    varstr = v.flat;
  end
  for i = 2:length(vars);
    v = vars{i};
    varstr = [varstr ', ' v.flat];
  end
  s = [input_name, '(', varstr, ')'];

end


%!test
%! syms f(x)
%! s = priv_disp_name(f, 'f');
%! assert (strcmp (s, 'f(x)'))

%!test
%! syms x y
%! g(y, x) = x + y;
%! s = priv_disp_name(g, 'g');
%! assert (strcmp (s, 'g(y, x)'))
