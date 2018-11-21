[![Build Status](https://travis-ci.org/gap-packages/Thelma.svg?branch=master)](https://travis-ci.org/gap-packages/Thelma)
[![Code Coverage](https://codecov.io/github/gap-packages/Thelma/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/Thelma)

The GAP 4 package `thelma'
==================================

Introduction
------------

This is release 1.0.1 of  the package `thelma'.

The features of this package include

         - checking the single threshold element realizability of a given boolean function;
         - finding the threshold element representation of a boolean function;
         - finding the boolean function from the given network of threshold elements;

There is a manual in the sub-directory 'doc' written using the GAP package
gapdoc which describes the available functions in detail. The pdf and html
versions of the manual are also available there.


If you have used this package, please let us know by sending
us an email.  If you  have found important features missing or if there is a
bug, we would appreciate it very much if you will use the github issue tracker:
https://github.com/gap-packages/Thelma/issues.

Victor Bovdi   <vbovdi@gmail.com>
Vasyl Laver     <vasyl.laver@uzhnu.edu.ua>

Contents
--------
With this version you should have obtained the following files and
directories:

        README          this file

        COPYING         license information

        doc             the manual

        lib             the GAP code

        tst             some tests

        init.g          the file that initializes this package

        read.g          the file that reads in the package     

	    PackageInfo.g	information file for automatic processing

    	version		the version number

Installation
------------

As this package does not contain any C code, to install it just unpack the archive in the "pkg" directory of your
GAP installation folder. Then enter command "LoadPackage( "thelma" );".


Good luck!
