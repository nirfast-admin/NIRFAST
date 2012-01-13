# for building the exe:
# python setup.py py2exe --includes sip

from distutils.core import setup
from py2exe.build_exe import py2exe
from glob import glob
import py2exe
import sys

sys.path.append("C:\\Program Files (x86)\\Microsoft Visual Studio 9.0\\VC\\redist\\x86\\Microsoft.VC90.CRT")
data_files = [("Microsoft.VC90.CRT", glob(r'C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\redist\x86\Microsoft.VC90.CRT\*.*'))]
setup(
	data_files=data_files,
	console=[{"script": "nirviz.py"}]
)