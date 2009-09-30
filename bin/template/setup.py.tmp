#!/usr/bin/python

import glob
from distutils.core import setup
from distutils.core import setup
from shutil import copy2
from os import unlink

def rename(a, b):
    # Cygwin safe rename
    copy2(a,b)
    unlink(a)

setup(name='program',
      description='',
      keywords='',
      version='',
      url='',
      download_url='',
      license='GPL',
      author='',
      author_email='',
      long_description="""
      """,
      scripts = [''],
      packages = ['''],
      data_files = [('share/doc/package/templates',
			glob.glob('templates/*.tmpl'))],
		    ('share/doc/package/examples',
			['package.conf'])],

"""
      package_dir={'lib.plugins.email':'.',
                   'lib.plugins.email.tests':'tests'},
      packages=['lib.plugins.email',
                'lib.plugins.email.tests']
"""
      )
