from zipfile import *
import os, sys, md5

exp_path = r"..\..\..\binaries-pc"

prog = """
import md5
expected = "%s"
fname = r"%s"
print "expected digest", expected
received = md5.md5(file(fname, "rb").read()).hexdigest()
print ("matched", "NOT MATCHED!!") [received != expected]
raw_input("press enter to continue")
"""

filenames = "python24 stackless _tkinter".split()
# no longer needed
filenames = "python24".split()
for debug in ("", "_d"):
    zname = os.path.join(exp_path, "python24%s.dll.zip" % debug)
    z = ZipFile(zname, "w", ZIP_DEFLATED)
    for name in filenames:
        name += debug
        for ext in ".dll .exp .lib .pyd".split():
            export = name + ext
            if os.path.exists(export):
                z.write(export)
    z.close()
    expected = md5.md5(file(zname, "rb").read()).hexdigest()
    signame = zname+".md5.py"
    shortname = os.path.split(zname)[-1]
    file(signame, "w").write(prog % (expected, shortname))

# generate a reST include for upload time.
import time
txt = ".. |uploaded| replace:: " + time.ctime()
print >> file(os.path.join(exp_path, "uploaded.txt"), "w"), txt
