#############################################################################
##
#W  boolfunc_def.gi                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: boolfunc_def.gi,v 1.00 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file contains some generic methods for Boolean functions,
##	represented as vectors over GF(2).
##
#############################################################################
##


######################################################################
##
#F  CharacteristicVectorOfFunction(f)
##
##  Returns the charateristic vector of Boolean function.
##
InstallMethod(CharacteristicVectorOfFunction, "f", true, [IsFFECollection], 1,
function(f)
	local t, n, f1, i, l, m,m2;

	n:=Size(f);

	if not IsFFECollection(f) then
	    Error("Function should be presented as a vector over GF(2)");
	fi;

	if n<>2^LogInt(n,2) then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	t:=Tuples([0,1],LogInt(Size(f),2));
	t:=TransposedMat(t);
	f:=List(f,Order);
	m:=Sum(f);
	l:=[];
	for i in t do
		m2:=4*i*f-2*m;
		Add(l, m2);
	od;
	Add(l,2*m-Size(f));


	l:=List(l,AbsInt);
	Sort(l);

	return Reversed(l);
end);

InstallOtherMethod(CharacteristicVectorOfFunction, "f", true, [IsPolynomial], 1,
function(f)
	local t, n, f1, i, l, m,m2, var, k;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");

	t:=IteratorOfTuples(GF(2),n);
	f1:=[];
	for i in t do
		Add(f1,Order(Value(f,var,i)));
	od;


	t:=Tuples([0,1],n);
	t:=TransposedMat(t);
	f:=f1;
	m:=Sum(f);
	l:=[];
	for i in t do
		m2:=4*i*f-2*m;
		Add(l, m2);
	od;
	Add(l,2*m-Size(f));


	l:=List(l,AbsInt);
	Sort(l);

	return Reversed(l);
end);


InstallOtherMethod(CharacteristicVectorOfFunction, "f", true, [IsString], 1,
function(f)
	local t, n, f1, i, l, m,m2, var, k;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	f1:=[];
	k:=1;
	for i in [1..Size(f)] do
		if f[k]='1' then Add(f1,1); else Add(f1,0); fi;
		k:=k+1;
	od;

	t:=Tuples([0,1],n);
	t:=TransposedMat(t);

	f:=f1;
	m:=Sum(f);
	l:=[];
	for i in t do
		m2:=4*i*f-2*m;
		Add(l, m2);
	od;
	Add(l,2*m-Size(f));


	l:=List(l,AbsInt);
	Sort(l);

	return Reversed(l);
end);

## Check if given vector is a ch.vect. of realizable function
InstallMethod(IsCharacteristicVectorOfSTE, "check if function is realizable for n<=6", true, [IsVector], 1,
function(v)
	if Size(v)>7 then
		Error("Enter characteristic vectors for n<=6 variables.\n");
	else
		return (v in THELMA_INTERNAL_CharVectSet);
	fi;
end);

######################################################################
##
#F  KernelOfBooleanFunction(f)
##
##  Returns the kernel of Boolean function.
##

InstallMethod(KernelOfBooleanFunction, "f", true, [IsFFECollection], 1,
function(f)

	local t,f1,f0,i,n,k;

	n:=Size(f);
	if n<>2^LogInt(n,2) then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	t:=IteratorOfTuples(GF(2),LogInt(Size(f),2));
	f1:=[]; f0:=[];
	k:=1;
	for i in t do
		if f[k]=One(GF(2)) then Add(f1,i); else Add(f0,i); fi;
		k:=k+1;
	od;

	if Size(f1)<=Size(f0) then return [f1,1]; else return [f0,0]; fi;
end);


#f-polynomial
InstallOtherMethod(KernelOfBooleanFunction, "f", true, [IsPolynomial], 1,
function(f)

	local t,f1,f0,i,n,var,v,k;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables n (n>=",Size(var),"):\n");
	t:=IteratorOfTuples(GF(2),n);

	if Size(var)<n then
		k:=Size(var)+1;
		var:=ShallowCopy(var);
		for i in [k..n] do Add(var,k); od;
	fi;

	t:=IteratorOfTuples(GF(2),n);

	f1:=[]; f0:=[];
	for i in t do
		v:=Value(f,var,i);
		if v=One(GF(2)) then Add(f1,i); else Add(f0,i); fi;
	od;

	if Size(f1)<=Size(f0) then return [f1,1]; else return [f0,0]; fi;
end);

#f is a string
InstallOtherMethod(KernelOfBooleanFunction, "f", true, [IsString], 1,
function(f)

	local t,f1,f0,i,n,k;

	n:=Size(f);
	if n<>2^LogInt(n,2) then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	t:=IteratorOfTuples(GF(2),LogInt(Size(f),2));
	f1:=[]; f0:=[];
	k:=1;
	for i in t do
		if f[k]='1' then Add(f1,i); else Add(f0,i); fi;
		k:=k+1;
	od;

	if Size(f1)<=Size(f0) then return [f1,1]; else return [f0,0]; fi;
end);

######################################################################
##
#F  ReducedKernelOfBooleanFunction(k)
##
##  Given the kernel of Boolean function, returns the reduced kernel.
##
InstallGlobalFunction(ReducedKernelOfBooleanFunction, function(k)
	local i,j,l,rk;

	if not IsFFECollColl(k) then
	    Error("Kernel should be presented as a matrix over GF(2)");
	fi;

	rk:=[];
	for i in k do
		l:=[];
		for j in k do
			Add(l,i+j);
		od;
		Add(rk,l);
	od;
	return rk;
end);



######################################################################
##
#F  IsInverseInKernel(k)
##
##  This function checks if there are any inverse vectors in the kernel.
##	If yes - the given function can't be implemented by a single
##  threshold element.
##
##
# f - vector over GF(2)
InstallMethod(IsInverseInKernel, "f", true, [IsFFECollection],1,
function(f)
	local ker, i, j, inv, bool;

	bool:=false;
	ker:=KernelOfBooleanFunction(f)[1];
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

InstallOtherMethod(IsInverseInKernel, "f", true, [IsPolynomial],1,
function(f)
	local ker, i, j, inv, bool;

	bool:=false;
	ker:=KernelOfBooleanFunction(f)[1];
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

InstallOtherMethod(IsInverseInKernel, "f", true, [IsString],1,
function(f)
	local ker, i, j, inv, bool;

	bool:=false;
	ker:=KernelOfBooleanFunction(f)[1];
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

InstallOtherMethod(IsInverseInKernel, "kernel", true, [IsFFECollColl],1,
function(ker)
	local i, j, inv, bool;

	bool:=false;
	for i in ker do
		inv:=List(i, j->j+Z(2)^0);
		if Position(ker,inv)<>fail then
			bool:=true;
			break;
		fi;
	od;

	return bool;
end);

######################################################################
##
#F  IsKernelContainingPrecedingVectors(k)
##
##  This function checks if there the kernel contains the preceding vectors
##	for all vectors in the kernel. If no - the given function can't be implemented by a single
##  threshold element.
##
##
InstallMethod(IsKernelContainingPrecedingVectors, "f", true, [IsFFECollection],1,
function(f)
	local i,j,rk,ma,r,tbool,check,kern;

	rk:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

InstallOtherMethod(IsKernelContainingPrecedingVectors, "f", true, [IsString],1,
function(f)
	local i,j,rk,ma,r,tbool,check,kern;

	rk:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

InstallOtherMethod(IsKernelContainingPrecedingVectors, "f", true, [IsPolynomial],1,
function(f)
	local i,j,rk,ma,r,tbool,check,kern;

	rk:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

InstallOtherMethod(IsKernelContainingPrecedingVectors, "ker", true, [IsFFECollColl],1,
function(ker)
	local i,j,rk,ma,r,tbool,check,kern;

	rk:=ReducedKernelOfBooleanFunction(ker);
	tbool:=true;
	for kern in rk do
		tbool:=true;
		for j in kern do
			if IsSubset(kern,THELMA_INTERNAL_FindPrecedingVectors(j))=false then
				tbool:=false; break;
			fi;
		od;
		if tbool=true then break; fi;
	od;

	return tbool;
end);

#############################################################################
##
#F  IsRKernelBiggerOfCombSum(rker)
##  Another neccessary condition
##
InstallMethod(IsRKernelBiggerOfCombSum, "f", true, [IsFFECollection], 1,
function(f)
	local n, sum, i, m, k, j, rker;
	rker:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);

InstallOtherMethod(IsRKernelBiggerOfCombSum, "reduced kernel", true, [IsFFECollCollColl], 1,
function(rker)
	local n, sum, i, m, k, j;
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);

InstallOtherMethod(IsRKernelBiggerOfCombSum, "f", true, [IsString], 1,
function(f)
	local n, sum, i, m, k, j, rker;
	rker:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);

InstallOtherMethod(IsRKernelBiggerOfCombSum, "f", true, [IsPolynomial], 1,
function(f)
	local n, sum, i, m, k, j, rker;
	rker:=ReducedKernelOfBooleanFunction(KernelOfBooleanFunction(f)[1]);
	n:=Size(rker[1][1]);
	m:=Minimum(List(List(rker,i->List(i,j->Sum(j,Order))), k->Maximum(k)));
	sum:=0;
	for i in [0..m] do sum:=sum+NrCombinations([1..m],i); od;
	if Size(rker)>=sum then return true;
	else return false; fi;
end);


#############################################################################
##
#F  IsUnateInVariable(f,v)
##
##
##  f - vector over GF(2)

InstallMethod(IsUnateInVariable,"function, integer", true, [IsFFECollection, IsInt], 2,
function(f, v)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return THELMA_INTERNAL_IsUnateInVar(f,v);
end);


#f - string
InstallOtherMethod(IsUnateInVariable, "function", true, [IsString,IsInt], 1,
function(f,v)
local n;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	return THELMA_INTERNAL_IsUnateInVar(f,v);
end);

#f - polynomial
InstallOtherMethod(IsUnateInVariable, "function", true, [IsPolynomial,IsInt], 1,
function(f,v)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToOneZero(f,n);
	return THELMA_INTERNAL_IsUnateInVar(f1,v);
end);

#############################################################################
##
#F  IsUnateBooleanFunction(f)
##  Another neccessary condition
##
## f - vector over GF(2)
InstallMethod(IsUnateBooleanFunction, "function", true, [IsFFECollection], 1,
function(f)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return THELMA_INTERNAL_IsUnateBFunc(f);
end);

#f - string
InstallOtherMethod(IsUnateBooleanFunction, "function", true, [IsString], 1,
function(f)
local n;

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	return THELMA_INTERNAL_IsUnateBFunc(f);
end);

#f - polynomial
InstallOtherMethod(IsUnateBooleanFunction, "function", true, [IsPolynomial], 1,
function(f)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToOneZero(f,n);
	return THELMA_INTERNAL_IsUnateBFunc(f1);
end);



#############################################################################
##
#F  SelfDualExtensionOfBooleanFunction(f)
##
## f - vector over GF(2)
InstallMethod(SelfDualExtensionOfBooleanFunction, "function", true, [IsFFECollection], 1,
function(f)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return THELMA_INTERNAL_SelfDualExtensionOfBooleanFunction(f);
end);

#f - string
InstallOtherMethod(SelfDualExtensionOfBooleanFunction, "function", true, [IsString], 1,
function(f)
local n,f1,i;

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


	return THELMA_INTERNAL_SelfDualExtensionOfBooleanFunction(f1);
end);

#f - polynomial
InstallOtherMethod(SelfDualExtensionOfBooleanFunction, "function", true, [IsPolynomial], 1,
function(f)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToGF2(f,n);
	return THELMA_INTERNAL_SelfDualExtensionOfBooleanFunction(f1);
end);


#############################################################################
##
#F  InfluenceOfVariable(f)
##
## f - vector over GF(2)
InstallMethod(InfluenceOfVariable, "function, var", true, [IsFFECollection, IsInt], 2,
function(f,v)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;
	return THELMA_INTERNAL_InfluenceOfVariable(f,v);
end);

#f - string
InstallOtherMethod(InfluenceOfVariable, "function, var", true, [IsString, IsInt], 2,
function(f, v)
local i, n, f1;

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


	return THELMA_INTERNAL_InfluenceOfVariable(f1,v);
end);

#f - polynomial
InstallOtherMethod(InfluenceOfVariable, "function, var", true, [IsPolynomial, IsInt], 2,
function(f, v)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToGF2(f,n);
	return THELMA_INTERNAL_InfluenceOfVariable(f1,v);
end);

#############################################################################
##
#F  SplitBooleanFunction(f,v,b)
##
## f - vector over GF(2)
InstallMethod(SplitBooleanFunction, "function, var, bool", true, [IsFFECollection, IsInt, IsBool], 3,
function(f,v,b)
	local n;
	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	return THELMA_INTERNAL_SplitBooleanFunction(f,v,b);
end);

#f - string
InstallOtherMethod(SplitBooleanFunction, "function, var, bool", true, [IsString, IsInt, IsBool], 3,
function(f,v,b)
local i, n, f1;

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

	return THELMA_INTERNAL_SplitBooleanFunction(f1,v,b);
end);

#f - polynomial
InstallOtherMethod(SplitBooleanFunction, "function, var, bool", true, [IsPolynomial, IsInt, IsBool], 3,
function(f, v, b)
local f1,var,n;

	var:=OccuringVariableIndices(f);
	n:=InputFromUser("Enter the number of variables (n>=",Size(var),"):\n");
	f1:=THELMA_INTERNAL_PolToGF2(f,n);
	return THELMA_INTERNAL_SplitBooleanFunction(f1,v,b);
end);


#E
##
