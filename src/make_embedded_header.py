#!/usr/bin/python
"""make_embedded_header.py

FIXME: move .py file here to src/ eventually?
"""

import sys
import os

#def embed():
if 1==1:
    base = 'python_header'
    finname = '../inst/private/%s.py' % base
    foutname = '../inst/private/%s_embed.m' % base


    fd = open(finname, "r")
    l = fd.readlines()
    fd.close()

    fd = open(foutname, "w")

    fd.write("function s = %s()\n" % base)
    fd.write("%")
    fd.write("%s  private\n" % base.upper())
    fd.write("%\n%")
    fd.write("  autogenerated from %s.py, edit that instead!\n\n" % base)

    fd.write("  s = '");
    for i in range(0, len(l)):
      #fd.write(l[i].encode("string_escape"))
      # bit odd, order matters, octave ok with \'' but not \'\'
      fd.write( l[i].encode("string_escape").replace("'","''") )
    fd.write("';\n");
    fd.write("\ns = sprintf(s);\n")
    fd.close()



#if __name__ == "__main__":
#    embed()
