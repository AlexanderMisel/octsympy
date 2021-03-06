%% Copyright (C) 2014, 2015 Colin B. Macdonald
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
%% @deftypefn  {Function File} {@var{s} =} ccode (@var{f})
%% @deftypefnx {Function File} {@var{s} =} ccode (@var{f1}, @dots{}, @var{fn})
%% @deftypefnx {Function File} {} ccode (@dots{}, 'file', @var{filename})
%% @deftypefnx {Function File} {[@var{c_stuff}, @var{h_stuff}] =} ccode (@dots{}, 'file', '')
%% Convert symbolic expression into C code.
%%
%% FIXME: make sure this works
%% @example
%% syms x
%% g = taylor(log(1+x),x,0,6)  % a polynomial
%% g = horner(g)   % optimize w/ Horner's nested evaluation
%% ccode(g)
%% @end example
%%
%% We can write to a file or obtain the contents directly:
%% @example
%% [C, H] = ccode(f, 'file', '')
%% C.name   % .c filename
%% C.code   % .c file contents
%% H.name   % similarly for .h file
%% H.code
%% @end example
%%
%% FIXME: This doesn't write "optimized" code like Matlab's
%% Symbolic Math Toolbox; it doesn't do "Common Subexpression
%% Elimination".  Presumably the compiler would do that for us
%% anyway.  Sympy has a "cse" module that will do it.  See:
%% http://stackoverflow.com/questions/22665990/optimize-code-generated-by-sympy
%%
%% @seealso{fortran, latex, matlabFunction}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function varargout = ccode(varargin)

  [flg, meh] = codegen(varargin{:}, 'lang', 'C');

  if flg == 0
    varargout = {};
  elseif flg == 1
    varargout = meh(1);
  elseif flg == 2
    varargout = {meh{1}, meh{2}};
  else
    error('whut?');
  end
end



%!shared x,y,z
%! syms x y z

%!test
%! % basic test
%! f = x*sin(y) + abs(z);
%! source = ccode(f);
%! expected = 'x*sin(y) + fabs(z)';
%! assert(strcmp(source, expected))

%!test
%! % output test
%! f = x*sin(y) + abs(z);
%! [C, H] = ccode(f, 'file', '', 'show_header', false);
%! expected_c_code_075 = sprintf('#include \"file.h\"\n#include <math.h>\n\ndouble myfun(double x, double y, double z) {\n\n   return x*sin(y) + fabs(z);\n\n}\n');
%! % change in behaviour in 0.7.5 -> 0.7.6
%! expected_c_code = sprintf('#include \"file.h\"\n#include <math.h>\n\ndouble myfun(double x, double y, double z) {\n\n   double myfun_result;\n   myfun_result = x*sin(y) + fabs(z);\n   return myfun_result;\n\n}\n');
%! expected_h_code = sprintf('\n#ifndef PROJECT__FILE__H\n#define PROJECT__FILE__H\n\ndouble myfun(double x, double y, double z);\n\n#endif\n\n');
%! assert(strcmp(C.name, 'file.c'))
%! assert(strcmp(H.name, 'file.h'))
%! hwin = strrep(expected_h_code, sprintf('\n'), sprintf('\r\n'));
%! assert (strcmp (H.code, expected_h_code) || strcmp (H.code, hwin))
%! s1 = expected_c_code_075;
%! s2 = expected_c_code;
%! s3 = strrep(expected_c_code_075, sprintf('\n'), sprintf('\r\n'));
%! s4 = strrep(expected_c_code, sprintf('\n'), sprintf('\r\n'));
%! assert (strcmp (C.code, s1) || strcmp (C.code, s2) || strcmp(C.code, s3) || strcmp (C.code, s4))
