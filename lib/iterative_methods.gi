#############################################################################
##
#W  iterative_methods.gi                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: iterative_methods.gi,v 1.02 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file contains some iterative methods for threshold element training.
##
#############################################################################


######################################################################
##
#F  ThresholdElementTraining(te,step,f)
##
##  Returns the Threshold Element realizing the Boolean function f
##  or [] if the function is not realizable.
##

InstallMethod(ThresholdElementTraining, "threshold element, step, function, max_iter", true, [IsThresholdElementObj, IsPosInt, IsObject, IsPosInt], 4,
function(te,step,f,maxit)
local t, l, i,y,err,j,tup,w,T,st, niter, n;

	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f!.numvars;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	f:=f!.output;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	st:=StructureOfThresholdElement(te);
	w:=st[1]; T:=st[2];

	if (Size(w)<>n) then
		Error("Theshold element and f should be of one dimension!\n");
	fi;

	if w=[] then
		for i in [1..LogInt(Size(f),2)+1] do Add(w,1); od;
	fi;
	l:=ShallowCopy(w);
	niter:=maxit;
	return THELMA_INTERNAL_ThrTr(l,T,step,f,niter);
end);


InstallOtherMethod(ThresholdElementTraining, "threshold element, step, function, max_iter", true, [IsThresholdElementObj, IsPosInt, IsFFECollection, IsPosInt], 4,
function(te,step,f,maxit)
local t, l, i,y,err,j,tup,w,T,st, niter, n;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
			Error("Number of elements of the vector must be a power of 2! \n");
			return [];
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	st:=StructureOfThresholdElement(te);
	w:=st[1]; T:=st[2];

	if (Size(w)<>n) then
		Error("Theshold element and f should be of one dimension!\n");
	fi;

	f:=List(f,Order);

	if w=[] then
		for i in [1..LogInt(Size(f),2)+1] do Add(w,1); od;
	fi;
	l:=ShallowCopy(w);
	niter:=maxit;
	return THELMA_INTERNAL_ThrTr(l,T,step,f,niter);
end);

#f - is a polynomial over GF(2)
InstallOtherMethod(ThresholdElementTraining, "threshold element, step, function, max_iter", true, [IsThresholdElementObj, IsPosInt, IsPolynomial, IsPosInt], 4,
function(te,step,f1,maxit)
local t, l, i,y,err,j,tup,w,T,st, niter,f, var, n;
	st:=StructureOfThresholdElement(te);
	w:=st[1]; T:=st[2];
	f:=[];

	n:=Size(w);

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	f:=THELMA_INTERNAL_PolToOneZero(f1,n);
	if w=[] then
		for i in [1..LogInt(Size(f),2)+1] do Add(w,1); od;
	fi;

	l:=ShallowCopy(w);
	niter:=maxit;

	if (Size(f)<>2^n) then
		Error("Theshold element and f should be of one dimension!\n");
	fi;

	return THELMA_INTERNAL_ThrTr(l,T,step,f,niter);
end);

#f - string
InstallOtherMethod(ThresholdElementTraining, "threshold element, step, function, max_iter", true, [IsThresholdElementObj, IsPosInt, IsString, IsPosInt], 4,
function(te,step,f1,maxit)
local t, l, i,y,err,j,tup,w,T,st, niter,f, n;
	st:=StructureOfThresholdElement(te);
	w:=st[1]; T:=st[2];
	f:=[];

	n:=LogInt(Size(f1),2);
	if Size(f1)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f1,'1'))+Size(Positions(f1,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	if (Size(w)<>n) then
			Error("Theshold element and f should be of one dimension!\n");
	fi;

	for i in [1..Size(f1)] do
		if f1[i]='1' then Add(f, 1);
		elif f1[i]='0' then Add(f, 0);
		fi;
	od;

	if w=[] then
		for i in [1..LogInt(Size(f),2)+1] do Add(w,1); od;
	fi;
	l:=ShallowCopy(w);
	niter:=maxit;
	return THELMA_INTERNAL_ThrTr(l,T,step,f,niter);
end);

######################################################################
##
#F  ThresholdElementBatchTraining(te,step,f)
##
##  Returns the Threshold Element realizing the Boolean function f
##  or [] if the function is not realizable.
##

#f - vector over GF(2)
InstallMethod(ThresholdElementBatchTraining, "threshold element, step, function, max_iter", true, [IsThresholdElementObj, IsPosInt, IsObject, IsPosInt], 4,
function(te,step,f, maxit)
local t, l, i, y,err,j,Tc,wc,tup,st,w,T,niter,n;

	st:=StructureOfThresholdElement(te);
	w:=st[1];
	T:=st[2];

	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f!.numvars;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	f:=f!.output;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	if w=[] then
		for i in [1..LogInt(Size(f),2)+1] do Add(w,1); od;
	fi;
	l:=ShallowCopy(w);

	if (Size(w)<>n) then
		Error("Theshold element and f should be of one dimension!\n");
	fi;

	niter:=maxit;
	return THELMA_INTERNAL_ThrBatchTr(l,T,step,f,niter);
end);


InstallOtherMethod(ThresholdElementBatchTraining, "threshold element, step, function, max_iter", true, [IsThresholdElementObj, IsPosInt, IsFFECollection, IsPosInt], 4,
function(te,step,f, maxit)
local t, l, i, y,err,j,Tc,wc,tup,st,w,T,niter,n;

	st:=StructureOfThresholdElement(te);
	w:=st[1];
	T:=st[2];
	f:=List(f,Order);
	n:=LogInt(Size(f),2);

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	if w=[] then
		for i in [1..LogInt(Size(f),2)+1] do Add(w,1); od;
	fi;
	l:=ShallowCopy(w);

	if (Size(w)<>n) then
		Error("Theshold element and f should be of one dimension!\n");
	fi;

	niter:=maxit;
	return THELMA_INTERNAL_ThrBatchTr(l,T,step,f,niter);
end);

# f is a polynomial
InstallOtherMethod(ThresholdElementBatchTraining, "threshold element, step, function, max_iter", true, [IsThresholdElementObj, IsPosInt, IsPolynomial, IsPosInt], 4,
function(te,step,f1,maxit)
local t, l, i, y,err,j,Tc,wc,tup,st,w,T,niter, var, n, f;

	st:=StructureOfThresholdElement(te);
	w:=st[1]; T:=st[2];
	f:=[];

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	var:=OccuringVariableIndices(f1);
	n:=Size(w);

	f:=THELMA_INTERNAL_PolToOneZero(f1,n);

	if w=[] then
		for i in [1..LogInt(Size(f),2)+1] do Add(w,1); od;
	fi;
	l:=ShallowCopy(w);
	niter:=maxit;

	if (LogInt(Size(f),2)<>n) then
		Error("Theshold element and f should be of one dimension!\n");
	fi;

	return THELMA_INTERNAL_ThrBatchTr(l,T,step,f,niter);
end);

#f is a string
InstallOtherMethod(ThresholdElementBatchTraining, "threshold element, step, function, max_iter", true, [IsThresholdElementObj, IsPosInt, IsString, IsPosInt], 4,
function(te,step,f1, maxit)
local t, l, i, y,err,j,Tc,wc,tup,st,w,T,niter,f,n;

	st:=StructureOfThresholdElement(te);
	w:=st[1]; T:=st[2];
	f:=[];

	n:=LogInt(Size(f1),2);

	if (Size(w)<>n) then
		Error("Theshold element and f should be of one dimension!\n");
	fi;

	if Size(f1)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f1,'1'))+Size(Positions(f1,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	for i in [1..Size(f1)] do
		if f1[i]='1' then Add(f, 1);
		elif f1[i]='0' then Add(f, 0);
		fi;
	od;

	if w=[] then
		for i in [1..LogInt(Size(f),2)+1] do Add(w,1); od;
	fi;
	l:=ShallowCopy(w);
	niter:=maxit;
	return THELMA_INTERNAL_ThrBatchTr(l,T,step,f,niter);
end);

######################################################################
##
#F  WinnowAlgorithm(f,step)
##  The algorithm for learing the monotone disjunctions
##

#f - vector over GF(2)
InstallMethod(WinnowAlgorithm, "function, step, maxiter", true, [IsObject, IsPosInt, IsPosInt], 3,
function(f,step,maxit)
local f1,niter;

	if step=1 then
		Error("Step must be integer > 1. \n");
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	f1:=f!.output;

	niter:=maxit;
	return THELMA_INTERNAL_Winnow(f1,step,niter);
end);


InstallOtherMethod(WinnowAlgorithm, "function, step, maxiter", true, [IsFFECollection, IsPosInt, IsPosInt], 3,
function(f,step,maxit)
local f1,niter;

	if step=1 then
		Error("Step must be integer > 1. \n");
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	f1:=List(f,Order);
	niter:=maxit;
	return THELMA_INTERNAL_Winnow(f1,step,niter);
end);

#f - string
InstallOtherMethod(WinnowAlgorithm, "function, step, maxiter", true, [IsString, IsPosInt, IsPosInt], 3,
function(f,step, maxit)
local f1,niter,n,i;

	f1:=[];

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	for i in [1..Size(f)] do
		if f[i]='1' then Add(f1, 1);
		elif f[i]='0' then Add(f1, 0);
		fi;
	od;


	if step=1 then
		Error("Step must be integer > 1. \n");
	fi;

	niter:=maxit;
	return THELMA_INTERNAL_Winnow(f1,step,niter);
end);

#f - polynomial
InstallOtherMethod(WinnowAlgorithm, "function, step, maxiter", true, [IsPolynomial, IsPosInt, IsPosInt], 3,
function(f,step,maxit)
local f1,niter,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");

	f1:=THELMA_INTERNAL_PolToOneZero(f,n);

	if step=1 then
		Error("Step must be integer > 1. \n");
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	niter:=maxit;
	return THELMA_INTERNAL_Winnow(f1,step,niter);
end);

######################################################################
##
#F  Winnow2Algorithm(f,step)
##  The algorithm, which generalizaes Winnow1
##

#f - vector over GF(2)
InstallMethod(Winnow2Algorithm, "function, step, maxiter", true, [IsObject, IsPosInt, IsPosInt], 3,
function(f,step,maxit)
local f1,niter;

	if step=1 then
		Error("Step must be integer > 1. \n");
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	f1:=f!.output;

	niter:=maxit;
	return THELMA_INTERNAL_Winnow2(f1,step,niter);
end);

InstallOtherMethod(Winnow2Algorithm, "function, step, maxiter", true, [IsFFECollection, IsPosInt, IsPosInt], 3,
function(f,step,maxit)
local f1,niter;

	if step=1 then
		Error("Step must be integer > 1. \n");
	fi;

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	f1:=List(f,Order);
	niter:=maxit;
	return THELMA_INTERNAL_Winnow2(f1,step,niter);
end);

#f - string
InstallOtherMethod(Winnow2Algorithm, "function, step, maxiter", true, [IsString, IsPosInt, IsPosInt], 3,
function(f,step,maxit)
local f1,niter,n,i;

	f1:=[];

	n:=LogInt(Size(f),2);
	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	for i in [1..Size(f)] do
		if f[i]='1' then Add(f1, 1);
		elif f[i]='0' then Add(f1, 0);
		fi;
	od;

	if step=1 then
		Error("Step must be integer > 1. \n");
	fi;

	niter:=maxit;
	return THELMA_INTERNAL_Winnow2(f1,step,niter);
end);

#f - polynomial
InstallOtherMethod(Winnow2Algorithm, "function, step, max_iter", true, [IsPolynomial, IsPosInt, IsPosInt], 3,
function(f,step,maxit)
local f1,niter,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");

	if step<1 then
		Error("Step has to be a positive integer!\n");
		return [];
	fi;

	if maxit<1 then
		Error("Maximal number of iterations has to be a positive integer!\n");
		return [];
	fi;

	f1:=THELMA_INTERNAL_PolToOneZero(f,n);

	if step=1 then
		Error("Step must be integer > 1. \n");
	fi;

	niter:=maxit;
	return THELMA_INTERNAL_Winnow2(f1,step,niter);
end);

######################################################################
##
#F  STESynthesis(f,step)
##  The algorithm, which generalizaes Winnow1
##

#Build threshold element (find w and T). Input - f with values from GF(2), output - structure vector (w;T) in [0,1] base;
#if such vector does not exist - return [].


#f - vector over GF(2)
InstallMethod(STESynthesis, "function", true, [IsObject], 1,
function(f)
	local n,i;

	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	f:=List(f!.output,i->Elements(GF(2))[i+1]);

	return THELMA_INTERNAL_STESynthesis(f);
end);

InstallOtherMethod(STESynthesis, "function", true, [IsFFECollection], 1,
function(f)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	return THELMA_INTERNAL_STESynthesis(f);
end);

#f - string
InstallOtherMethod(STESynthesis, "function", true, [IsString], 1,
function(f)
	local i,f1,n;

		n:=LogInt(Size(f),2);
		if Size(f)<>2^n then
		    Error("Number of elements of the vector must be a power of 2");
			return [];
		fi;

		if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
			Error("Input string should contain only '1' and '0'. \n");
			return [];
		fi;
	  f1:=[];
	  for i in [1..Size(f)] do
	    if f[i]='1' then Add(f1, Z(2)^0);
	    elif f[i]='0' then Add(f1, 0*Z(2));
	    fi;
	  od;

		return THELMA_INTERNAL_STESynthesis(f1);
end);

#f - polynomial
InstallOtherMethod(STESynthesis, "function", true, [IsPolynomial], 1,
function(f)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToGF2(f,n);
	return THELMA_INTERNAL_STESynthesis(f1);
end);


#E
##
