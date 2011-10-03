def _chdir_resource():
    import os
    os.chdir(os.environ['RESOURCEPATH'])
_chdir_resource()


def _disable_linecache():
    import linecache
    def fake_getline(*args, **kwargs):
        return ''
    linecache.orig_getline = linecache.getline
    linecache.getline = fake_getline
_disable_linecache()


def _run(*scripts):
    global __file__
    import os, sys, site
    sys.frozen = 'macosx_app'
    base = os.environ['RESOURCEPATH']
    site.addsitedir(base)
    site.addsitedir(os.path.join(base, 'Python', 'site-packages'))
    if not scripts:
        import __main__
    for script in scripts:
        path = os.path.join(base, script)
        sys.argv[0] = __file__ = path
        execfile(path, globals(), globals())

import os
import sys
mypwd = os.getcwd()
print mypwd
mypwd=os.path.split(mypwd)
mypwd=os.path.split(mypwd[0])
print mypwd
print 'hamidshpal'
sys.path.insert(0,mypwd[0]+"/Contents/Resources/lib/python2.6/lib-dynload")
_run('nirviz.py')
