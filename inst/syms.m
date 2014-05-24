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
%% @deftypefn  {Function File} {} syms @var{x}
%% @deftypefnx {Function File} {} syms @var{f(x)}
%% @deftypefnx {Function File} {} syms
%% Create symbolic variables and symbolic functions.
%%
%% This is a convenience function.  For example:
%% @example
%% syms x y z
%% @end example
%% instead of:
%% @example
%% x = sym('x');
%% y = sym('y');
%% z = sym('z');
%% @end example
%%
%% The last argument can provide an assumption (type or
%% restriction) on the variable (@xref{sym}, for details.)
%% @example
%% syms x y z positive
%% @end example
%%
%% Symfun's represent abstract or concrete functions.  Abstract
%% symfun's can be created with @code{syms}:
%% @example
%% syms f(x)
%% @end example
%% If @code{x} does not exost in the callers workspace, it
%% is created as a @strong{side effect} in that workspace.
%%
%% Called without arguments, @code{syms} displays a list of
%% all symbolic functions defined in the current workspace.
%%
%% Caution: On Matlab, you may not want to use @code{syms} within
%% functions.
%%   In particular, if you shadow a function name, you may get
%%   hard-to-track-down bugs.  For example, instead of writing
%%   @code{syms alpha} use @code{alpha = sym('alpha')} in functions.
%%   [https://www.mathworks.com/matlabcentral/newsreader/view_thread/237730]
%%
%% @seealso{sym}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic, symbols, CAS

function syms(varargin)

  %% No inputs
  %output names of symbolic vars
  if (nargin == 0)
    S = evalin('caller', 'whos');
    disp('Symbolic variables in current scope:')
    for i=1:numel(S)
      %S(i)
      if strcmp(S(i).class, 'sym')
        disp(['  ' S(i).name])
      elseif strcmp(S(i).class, 'symfun')
        % FIXME improve display of symfun
        disp(['  ' S(i).name ' (symfun)'])
      end
    end
    return
  end

  % Check if final input is assumption
  asm = varargin{end};
  if ( strcmp(asm, 'real') || strcmp(asm, 'positive') || strcmp(asm, 'integer') || ...
       strcmp(asm, 'even') || strcmp(asm, 'odd') || strcmp(asm, 'rational') || ...
       strcmp(asm, 'clear') )
    last = nargin-1;
  else
    asm = '';
    last = nargin;
  end

  % loop over each input
  for i = 1:last
    expr = varargin{i};

    % look for parenthesis: check if we're making a symfun
    if (isempty (strfind (expr, '(') ))  % no
      assert(isvarname(expr)); % help prevent malicious strings
      if isempty(asm)
        assignin('caller', expr, sym(expr))
      else
        assignin('caller', expr, sym(expr, asm))
      end

    else  % yes, this is a symfun
      assert(isempty(asm), 'mixing symfuns and assumptions not supported')
      tok = mystrsplit(varargin{i}, {'(', ')', ','});
      name = strtrim(tok{1});
      vars = {};  varnames = {};  c = 0;
      for i = 2:length(tok)
        vs = strtrim(tok{i});
        if ~isempty(vs)
          assert(isvarname(vs)); % help prevent malicious strings
          exists = evalin('caller',['exist(''' vs ''', ''var'')']);
          if (exists)
            vs_sym = evalin('caller', vs);
          else
            vs_sym = sym(vs);
            assignin('caller', vs, vs_sym);
          end
          c = c + 1;
          vars{c} = vs_sym;;
          varnames{c} = vs;
        end
      end
      sf = symfun(name, vars);
      assignin('caller', name, sf);
    end

  end

