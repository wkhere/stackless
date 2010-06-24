from zipfile import *
import os, sys, md5

exp_path = r""

prog = """
import md5
expected = "%s"
fname = r"%s"
print "expected digest", expected
received = md5.md5(file(fname, "rb").read()).hexdigest()
print ("matched", "NOT MATCHED!!") [received != expected]
raw_input("press enter to continue")
"""

fileList = [
    r"..\Lib\copy_reg.py",
    r"..\Lib\distutils\command\build_ext.py",
    r"..\Lib\pickle.py",
    r"..\Lib\platform.py",
    r"..\Lib\test\exception_hierarchy.txt",
    r"..\Lib\test\test_platform.py",
    r"..\Lib\test\test_pep352.py",
]

for debug in ("", "_d"):
    for suffix in ("dll", "lib", "exp"):
        fileList.append("python27%s.%s" % (debug, suffix))

pathBySuffix = {
    "dll":  "",
    "lib":  "libs/",
    "exp":  "libs/",
    "txt":  "Lib/test/",
}

# Maps to what is built in Tools\msi\msi.py.
includeFileList = []
slpdir = "..\Stackless"
for f in os.listdir(slpdir):
    subdir = os.path.join(slpdir, f)
    if os.path.isdir(subdir):
        if f not in ("core", "module", "pickling", "platf"):
            continue
        for f2 in os.listdir(subdir):
            if f2.endswith(".h"):
                includeFileList.append([ "include/Stackless/"+ f +"/"+ f2, os.path.join(subdir, f2) ])
    elif f.endswith(".h"):
        includeFileList.append([ "include/Stackless/"+ f, os.path.join(slpdir, f) ])

zname = os.path.join(exp_path, "python26.zip")
z = ZipFile(zname, "w", ZIP_DEFLATED)
for fileName in fileList:
    if os.path.exists(fileName):
        if fileName.endswith(".py"):
            outFileName = fileName[3:].replace("\\", "/")
        else:
            suffix = fileName[fileName.rfind(".")+1:]
            outFileName = pathBySuffix[suffix] + os.path.basename(fileName)
        s = open(fileName, "rb").read()
        z.writestr(outFileName, s)
    else:
        print "File not found:", fileName
for zipPath, relPath in includeFileList:
    if os.path.exists(fileName):
        s = open(relPath, "rb").read()
        z.writestr(zipPath, s)
    else:
        print "File not found:", fileName
z.close()

signame = zname+".md5.py"
expected = md5.md5(file(zname, "rb").read()).hexdigest()
shortname = os.path.split(zname)[-1]
file(signame, "w").write(prog % (expected, shortname))

# generate a reST include for upload time.
#import time
#txt = ".. |uploaded| replace:: " + time.ctime()
#print >> file(os.path.join(exp_path, "uploaded.txt"), "w"), txt
