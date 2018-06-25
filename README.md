
The GAP 4 package `thelma'
==================================

Introduction
------------

This is release 1.00 of  the package `thelma'.

The features of this package include

         - checking the single threshold element realizability of a given boolean function;
         - finding the threshold element representation of a boolean function;
         - finding the boolean function from the given network of threshold elements;
         
There is a manual in the sub-directory 'doc' written using the GAP package
gapdoc which describes the available functions in detail. The dvi, pdf, html
versions of the manual are also available there.


If you have used this package, please let us know by sending
us an email.  If you  have found important features missing or if there is a
bug, we would appreciate it very much if you send us an email.

Victor Bovdi   <vbovdi@gmail.com>
Vasyl Laver     <vasyl.laver@uzhnu.edu.ua>

Contents
--------
With this version you should have obtained the following files and
directories:

        README          this file

        doc             the manual
    
        lib             the GAP code

        init.g          the file that initializes this package

        read.g          the file that reads in the package     

	PackageInfo.g	information file for automatic processing

	version		the version number   

Unpacking
---------

You may get `thelma' as a compressed tar archive (file name ends with
.tar.gz). Use the  appropriate  command  on  your system   to unpack the
archive.

On UNIX systems the compressed tar archive may be unpacked by

    tar xzf thelma-<version>.tar.gz

or, if tar on your system does not understand the option z, by

    gunzip thelma-<version>.tar.gz
    tar xf thelma-<version>.tar

which will in each case unpack the code into a directory 'thelma'
in the current directory. We assume that the current directory is the
directory /usr/local/lib/gap4r4/pkg/.

Installation
------------

You may have to start GAP with the -l option, for instance,

gap -l "/usr/local/lib/gap4r4"

Then try the following

gap> LoadPackage( "thelma" ); 
true
gap>

Good luck!

If you use a LINUX system, you may have to, in order to save typing, write
aliases: 

in the file `.bashrc' (or something equivalent, maybe with another syntax): 

alias gap='gap -l "/usr/local/lib/gap4r4;"'

and in the file `.gaprc'

LoadPackage( "thelma" ); 


----------
In other systems, there are equivalent ways to do the same.



