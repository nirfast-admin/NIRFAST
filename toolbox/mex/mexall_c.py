import os
mydir= os.getcwd();

def mex(s):
	foo = "mex " + s
	print foo
	os.system(foo)
	print ""

def myfun(dummy, dirr, filess):
     for child in filess:
         if '.c' == os.path.splitext(child)[1] and os.path.isfile(dirr+'/'+child):
             mex(child)

os.path.walk(mydir, myfun, 3)

