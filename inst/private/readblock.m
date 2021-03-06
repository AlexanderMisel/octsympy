function [A, err] = readblock(fout, timeout)
%private function: read one block

  % how long to wait before displaying "Waiting..."
  wait_disp_thres = 2.0;

  tagblock = '<output_block>';
  tagendblock = '</output_block>';
  err = false;

  EAGAIN = errno ('EAGAIN');
  % Windows emits this when pipe is waiting (see
  % octave/libinterp/corefcn/syscalls.cc test code)
  EINVAL = errno ('EINVAL');
  done = false;
  started = false;
  nwaits = 0;
  dispw = false;
  start = time();

  fclear (fout);  % otherwise, fails on next call

  do
    if (ispc () && (~isunix ()))
      errno (0);  % win32, see syscalls.cc test code
    end
    s = fgets (fout);
    if (ischar (s))
      %fputs (stdout, s);
      if (started)
        A = [A s];
      end
      % here is the <start block> tag, so start recording output
      if (strncmp(s, tagblock, length(tagblock)))
        started = true;
        A = s;
      end
      % if we see the end tag, we're done
      if (strncmp(s, tagendblock, length(tagendblock)))
        done = true;
      end

    elseif (errno() == EAGAIN || errno() == EINVAL)
      waitdelta = exp(nwaits/10)/1e4;
      if (time() - start <= wait_disp_thres)
        %fprintf(stdout, 'W'); % debugging, in general do nothing
      elseif (~dispw)
        fprintf(stdout, 'Waiting...')
        dispw = true;
      else
        fprintf(stdout, '.')
      end
      fclear (fout);
      %if (ispc () && (~isunix ()))
      %errno (0);   % maybe can do this on win32?
      %end
      sleep (waitdelta);
      nwaits = nwaits + 1;
    elseif (errno() == 0)
      waitdelta = exp(nwaits/10)/1e4;
      if (time() - start <= wait_disp_thres)
        %fprintf(stdout, 'W'); % debugging, in general do nothing
      elseif (~dispw)
        fprintf(stdout, '[usually something wrong if you see stars] Waiting***')
        dispw = true;
      else
        fprintf(stdout, '*')
      end
      fclear (fout);
      %if (ispc () && (~isunix ()))
      %errno (0);   % maybe can do this on win32?
      %end
      sleep (waitdelta);
      nwaits = nwaits + 1;
    else
      warning ('OctSymPy:readblock:invaliderrno', ...
        sprintf('readblock: s=%d, errno=%d, perhaps error in the command?', s, errno()))
      sleep(0.1)  % FIXME; replace with waitdelta etc
    end
    %disp('paused'); pause

    if (time() - start > timeout)
      warning('OctSymPy:readblock:timeout', ...
        sprintf('readblock: timeout of %g exceeded, breaking out', timeout));
      if (started)
        disp('output so far:')
        A
      else
        disp('no output so far')
        A = '';
      end
      A = [A '\nFAILED TIMEOUT\n'];
      err = true;
      break
    end
  until (done)

  if (dispw)
    fprintf(stdout, '\n')
  end
  %fclose (fout);
  %waitpid (pid);

