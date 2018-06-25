#############################################################################
##
#W  iterative_methods.gd                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: iterative_methods.gd,v 1.00 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file contains some iterative methods for threshold element training.
##
#############################################################################

DeclareOperation("ThresholdElementTraining",[IsThresholdElementObj, IsInt, IsFFECollection, IsInt]);
DeclareOperation("ThresholdElementBatchTraining",[IsThresholdElementObj, IsInt, IsFFECollection, IsInt]);
DeclareOperation("WinnowAlgorithm",[IsFFECollection, IsInt, IsInt]);
DeclareOperation("Winnow2Algorithm",[IsFFECollection, IsInt, IsInt]);
DeclareOperation("STESynthesis",[IsFFECollection]);


#E
##