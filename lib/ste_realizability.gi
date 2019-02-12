#############################################################################
##
#W  ste_realizability.gi                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: ste_realizability.gi,v 1.02 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file contains some methods for determination of a single threshold element
##	realizability of Boolean functions.
##
#############################################################################

##############################################################
BindGlobal("THELMA_INTERNAL_SolveZW",function(z1,z2,w)
# Arguments: z1,z2 - two rows of a given tolerance matrix, lists of the same size over GF(2);
# Arguments: w - list of the known weights;
# Output: a list t with new weight value added. Size(t)=Size(w)+1.
	local zz1,zz2,sum1, sum2, i0, n, t, i;
	i0:=Size(w);
	n:=Size(z1);
	t:=ShallowCopy(w);

	zz1:=ShallowCopy(z1);
	zz2:=ShallowCopy(z2);

	for i in [1..Size(zz1)] do
		if zz1[i]=zz2[i] then
			zz1[i]:=Zero(GF(2));
			zz2[i]:=Zero(GF(2));
		fi;
	od;

	sum1:=List(zz1,Order){[1..i0]}*t;
	sum2:=List(zz2,Order){[1..i0]}*t;
	Add(t,sum1-sum2);
	return t;
end);

##############################################################
BindGlobal("THELMA_INTERNAL_ActionOnVector",function(a,x)
# Arguments: a - a vector over GF(2);
# Arguments: x - a vector of rational numbers, the weight vector;
# Output: vector x, in which elements with index i (a[i]=1) are multiplied by (-1).
	local aminus, i;
	aminus:=List(a,i->(-1)^(Order(i)));
	for i in [1..Size(x)] do
		x[i]:=x[i]*aminus[i];
	od;
	return x;
end);

#############################################################
BindGlobal("THELMA_INTERNAL_CheckZeroMat",function(mat)
# Arguments: mat - a matrix over GF(2);
# Output: "true" if all elements of the matrix are equal to 0, "false" otherwise.
	local i,bool;
	for i in mat do
		if Position(i,One(GF(2)))<>fail then return false; fi;
	od;
	return true;
end);

#############################################################
BindGlobal("THELMA_INTERNAL_FindMaxSet2",function(ker,n)
# Arguments: ker - a matrix over GF(2);
# Arguments: n - the number of variables (columns) which we consider;
# Output: a list in which
#					- a maximal p(A) matrix (see GecheRobotyshyn83);
#					- cardinality of the first block of p(A);
#					- the number of the inverse tolerance matrices;
#					- a list of the cardinalities of the inverse tolerance matrices blocks;
#					- the list of last rows of the blocks.
	local tk, i00,rq,qlist,tempw,tempi,res, aminus, maxi,i0, l,t,prows,pcols,
		j0, i, w, z, q, LS, qtest, temp, bool, ptest, tt, mout, templist;


	if (Size(ker) = 1) and (Position(ker[1],One(GF(2)))=fail) then
		return [[ker[1]], 1, 0, [], []]; #output: ker, i0, t0, q, z
	fi;

	qlist:=[];
	mout:=[]; #tolerance matrix L
	bool:=true;

	i:=1;
	#Check if first row of reduced kernel coincide with the first rows of tolerance matrix
	while  (i<=n) and (2^(i-1)<=Size(ker)) do
		if (ker{[1..2^(i-1)]}{[1..i]} <> THELMA_INTERNAL_BuildToleranceMatrix(i)
			or THELMA_INTERNAL_CheckZeroMat(ker{[1..2^(i-1)]}{[i+1..n]})=false)=true
			then break;
		fi;
		i:=i+1;
	od;


	if i=2  then
		return [[ker[1]], 1, 0, [], []];
	fi;

	#i0 shows the size of the considered tolerance matrices
	i0:=i-1; i00:=i0;
	#j0 number of the considered row
	j0:=2^(i0-1)+1;

	if n=Size(ker[1]) then
		maxi:=n-Position(Reversed(ker[Size(ker)]),One(GF(2)))+1;
	else
		tk:=ker[Size(ker)];
		tk:=tk{[1..n]};
		maxi:=n-Position(Reversed(tk),One(GF(2)))+1;

	fi;
	z:=[];

	mout:=ker{[1..j0-1]};

	#Second stage. We are seeking for all L* matrices
	while ((bool<>false) and (i0<maxi))=true do
		LS:=THELMA_INTERNAL_BuildInverseToleranceMatrix(i0);
		q:=0;
		if qlist=[] then
			while ((j0+q<=Size(ker)) and (q<2^(i0-1))
				and ker{[j0..j0+q]}{[1..i0]}=LS{[1..q+1]}
				and THELMA_INTERNAL_CheckZeroMat(ker{[j0..j0+q]}{[i0+1..n]})=true)=true do
				Add(mout,ker[j0+q]);
				q:=q+1;
			od;
		else
			while ((j0+q<=Size(ker)) and (q<2^(i0-1)) and (q<=qlist[Size(qlist)])
				and ker{[j0..j0+q]}{[1..i0]}=LS{[1..q+1]}
				and THELMA_INTERNAL_CheckZeroMat(ker{[j0..j0+q]}{[i0+1..n]})=true)=true do
				Add(mout,ker[j0+q]);
				q:=q+1;
			od;
		fi;

		if q=0 then
			bool:=false;
			return [ker{[1..j0-1]}, i00, 0, [], []];
		fi;

		Add(qlist,q);

		i0:=i0+1; j0:=j0+q;
		templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
		templist[i0]:=One(GF(2));
		if Position(ker,templist)<>fail then
			j0:=Position(ker,templist);
		fi;

		Add(z,ker[j0-1]);
	od;

	LS:=THELMA_INTERNAL_BuildInverseToleranceMatrix(i0);

	templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
	templist[maxi]:=One(GF(2));
	if i0=maxi and Position(ker,templist)<>fail then
		j0:=Position(ker,templist);
	fi;

	q:=0;

	if (bool<>false) then
		while (j0+q<=Size(ker) and ker{[j0..j0+q]}{[1..i0]}=LS{[1..q+1]}
		and THELMA_INTERNAL_CheckZeroMat(ker{[j0..j0+q]}{[i0+1..n]})=true)=true do
			Add(mout,ker[j0+q]);
			q:=q+1;
		od;
		Add(qlist,q);

		if j0+q-1<>Size(ker) then bool:=false;fi;
	fi;
	if bool = true then Add(z,ker[Size(ker)]); fi;
	return [mout, i00, Size(qlist), qlist, z];
end);

#############################################################
BindGlobal("THELMA_INTERNAL_FormNList2",function(ker,rker, onezero)
# Arguments: ker - a matrix over GF(2), the kernel of some Boolean function;
# Arguments: rker - a list of matrices over GF(2), the reduced kernel of some Boolean function;
# Arguments: onezero - the value (0 or 1) on which the kernel is achieved;
# Output: a list in which
#					- a maximal p(A) matrix (see GecheRobotyshyn83);
#					- number of the reduced kernels on which p(A) is achieved;
#					- cardinality of the first block of p(A);
#					- the permutation of columns of p(A);
#					- the list of last rows of the blocks.
	local temp, q, w, kk, t, i, maxi, maxs,sc,pcols,prows, maxi0, maxt0, pcolsmax, zmax,
			tempw, zt, a, w1, az;

	pcols:=THELMA_INTERNAL_SortCols(rker[1]);
	kk:=TransposedMat(Permuted(TransposedMat(rker[1]),pcols));

	prows:=THELMA_INTERNAL_SortRows(kk);
	kk:=Permuted(kk,prows);

	maxi:=1;

	t:=THELMA_INTERNAL_FindMaxSet2(kk, Size(kk[1]));
	maxs:=t[1];
	maxi0:=t[2];
	pcolsmax:=pcols;
	maxi0:=t[2]; maxt0:=t[3]; zmax:=t[5];

	for i in [1..Size(rker)] do
		pcols:=THELMA_INTERNAL_SortCols(rker[i]);
		kk:=TransposedMat(Permuted(TransposedMat(rker[i]),pcols));

		prows:=THELMA_INTERNAL_SortRows(kk);
		kk:=Permuted(kk,prows);


		t:=THELMA_INTERNAL_FindMaxSet2(kk, Size(kk[1]));
		if Size(t[1])>Size(maxs) then
			maxs:=t[1]; maxi:=i; maxi0:=t[2]; maxt0:=t[3]; pcolsmax:=pcols; zmax:=t[5];
		fi;
	od;

	return [maxs, maxi, maxi0, maxt0, pcolsmax, zmax];
end);

#############################################################
BindGlobal("THELMA_INTERNAL_BuildUSet",function(j)
# Arguments: positive integer j;
# Output: a set of order compositions of (j-1).
  local u,i,l,t,tup, temp,n0;

	t:=j-1;
	u:=[];

	tup:=UnorderedTuples([0..t],t);
	tup:=List(Filtered(tup,i->Sum(i)=t));
	for i in tup do
		temp:=Reversed(i);
		if Position(temp,0)<>fail then n0:=Position(temp,0)-1; else n0:=Size(temp); fi;
		Add(u,temp{[1..n0]});

	od;
	return u;
end);

#############################################################
BindGlobal("THELMA_INTERNAL_BuildFMatU",function(j0, s0, wght, u)
# Arguments: j0 - cardinality of tolerance matrix;
# Arguments: s0 - number of vectors in zlist;
# Arguments: wght - weight vector; u - a list of integers;
# Output: a tolerance matrix.
	local fmat, i, j, ls, tmp, row, n, sum;

	n:=Size(wght);
	tmp:=THELMA_INTERNAL_BuildToleranceMatrix(j0);

	fmat:=[];
	for i in tmp do
		row:=i;
		while Size(row)<n do Add(row,Zero(GF(2))); od;
		Add(fmat,row);
	od;

	sum:=0;

	for i in [1..Size(u)] do
		sum:=sum+u[i]*2^(i-1);
	od;

	for j in [0..s0] do
		tmp:=THELMA_INTERNAL_BuildInverseToleranceMatrix(j0+j);
		for i in tmp do
			row:=i;
			while Size(row)<n do Add(row,Zero(GF(2))); od;
			if List(row,Order)*wght<=sum then
				Add(fmat,row);
			fi;
		od;
	od;

	return fmat;
end);

#############################################################
BindGlobal("THELMA_INTERNAL_ThresholdOperator3G",function(ker, rker, onezero, nlist)
# Arguments: ker - a matrix over GF(2), the kernel of some Boolean function;
# Arguments: rker - a list of matrices over GF(2), the reduced kernel of some Boolean function;
# Arguments: onezero - the value (0 or 1) on which the kernel is achieved;
# Arguments: a list, which is outout of THELMA_INTERNAL_FormNList2;
# Output: a threshold element if function is realizable, [] otherwise.
# We call this method when other cases fail
	local templist,ihi , w,zt,az,thr,w1,fmat, tmp, wght, r, n,
	kkk, mat, j0, t0, pcols, prows, zlist, a, s, i, j, sum, n0, uset,u, bool, r0, rr, stop;

	n:=Size(ker[1]);
	mat:=rker[nlist[2]];

	pcols:=THELMA_INTERNAL_SortCols(mat);
	mat:=TransposedMat(Permuted(TransposedMat(mat),pcols));

	prows:=THELMA_INTERNAL_SortRows(mat);
	mat:=Permuted(mat,prows);

	j0:=nlist[3];
	t0:=nlist[4];
	pcols:=nlist[5];
	zlist:=nlist[6];
	a:=ker[nlist[2]];
	s:=Size(zlist)-1;

	uset:=THELMA_INTERNAL_BuildUSet(j0);

	zlist:=[];

	for j in [j0..j0+s] do
		templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
		templist[j+1]:=One(GF(2));

		if Position(mat,templist)<>fail then
			ihi:=Position(mat,templist)-1;
			Add(zlist,mat[ihi]);
		else
			Add(zlist,mat[Size(mat)]);
		fi;
	od;

	r:=THELMA_INTERNAL_FormVectR(n,j0);
	bool:=false;
	stop:=false;
	for u in uset do
		for r0 in r do
			wght:=THELMA_INTERNAL_MappingBoolToInt(ListWithIdenticalEntries(n,One(GF(2))),r0,j0,u);
			s:=Size(r0)-1;

			fmat:=THELMA_INTERNAL_BuildFMatU(j0, s,wght,u);
			if mat=fmat then
				bool:=true;
				sum:=0;

				for i in [1..Size(u)] do
					sum:=sum+u[i]*2^(i-1);
				od;
				rr:=r0;
				stop:=true;
				break;
			fi;
			if mat<=fmat or fmat<=mat then
				sum:=0;

				for i in [1..Size(u)] do
					sum:=sum+u[i]*2^(i-1);
				od;
				rr:=r0;
			fi;

		od;
		if bool=true then break; fi;
	od;

	w:=[];
	kkk:=1;

	i:=1;j:=1;

	while i<j0 do
		if i<Sum(u{[1..j]}) then
			Add(w,-kkk);
		elif i=Sum(u{[1..j]}) then
			Add(w,-kkk);
			j:=j+1; kkk:=kkk*2;
		fi;
		i:=i+1;
	od;

	for i in [j0..j0+s] do Add(w,rr[i-j0+1]-(sum+1)); od;

	while Size(w)<n do Add(w,-sum-1); od;

	w:=THELMA_INTERNAL_ActionOnVector(a,Permuted(w,pcols^(-1)));

	zt:=Permuted(zlist[1],pcols^(-1));
	az:=a+zt;
	thr:=w*List(az,Order);
	if bool=true then
		if onezero=1 then return ThresholdElement(w,thr); else return ThresholdElement(-w,-thr+1); fi;
	else
		if onezero=1 then
			return ThresholdElementTraining(ThresholdElement(w,thr),1,THELMA_INTERNAL_FindFunctionFromKernel(ker,onezero),1000);
		else
			return ThresholdElementTraining(ThresholdElement(-w,-thr+1),1,THELMA_INTERNAL_FindFunctionFromKernel(ker,onezero),1000);
		fi;
	fi;
end);


#############################################################
BindGlobal("THELMA_INTERNAL_ThresholdOperator2",function(ker, rker, onezero, nlist)
# Arguments: ker - a matrix over GF(2), the kernel of some Boolean function;
# Arguments: rker - a list of matrices over GF(2), the reduced kernel of some Boolean function;
# Arguments: onezero - the value (0 or 1) on which the kernel is achieved;
# Arguments: a list, which is outout of THELMA_INTERNAL_FormNList2;
# Output: a threshold element if function is realizable, [] otherwise.
	local zt,z00,thr,az,temp,tempw,w,T,templist,pcols, prows, tmat, n, z,q, bool, mat,a,ilo, ihi,j0,t0,ilist,qllist,fms,n0,zlist,i, qlist;

	n:=Size(ker[1]);

	if Size(nlist[1])=Size(ker) then
		mat:=nlist[1];
		j0:=nlist[3];
		t0:=nlist[4];
		pcols:=nlist[5];
		zlist:=nlist[6];
		a:=ker[nlist[2]];

		mat:=TransposedMat(Permuted(TransposedMat(mat),pcols));

		w:=[];

		if (Size(ker) = 1) and (Position(mat[1],One(GF(2)))=fail) then
			for i in [1..n] do Add(w,-i); od;
			w:=THELMA_INTERNAL_ActionOnVector(a,Permuted(w,pcols^(-1)));
			thr:=w*List(a,Order);

			if onezero=1 then return ThresholdElement(w,thr); else return ThresholdElement(-w,-thr+1); fi;
		fi;

		for i in [1..j0] do Add(w,Sum(w)-1); od;

		#if there is no L*
		if Size(mat)=2^(j0-1) then
			temp:=w[Size(w)]-1;
			for q in [j0+1..n] do Add(w,temp); od;
			w:=THELMA_INTERNAL_ActionOnVector(a,Permuted(w,pcols^(-1)));
			zt:=Permuted(zlist[1],pcols^(-1));
			az:=a+zt;
			thr:=w*List(az,Order);

			if onezero=1 then return ThresholdElement(w,thr); else return ThresholdElement(-w,-thr+1); fi;
		fi;
		if Size(zlist)=1 then Add(w,Sum(w)-1); fi;


		if Size(zlist)>1 then
			for i in [1..Size(zlist)-1] do
				w:=THELMA_INTERNAL_SolveZW(zlist[i],zlist[i+1],w);
			od;
		fi;

		i:=Size(w);

		tempw:=ShallowCopy(w);

		while Size(tempw)< n do Add(tempw,0); od;

		temp:=List(zlist[Size(zlist)],Order)*tempw-1;
		for q in [i+1..n] do Add(w,temp); od;

		w:=THELMA_INTERNAL_ActionOnVector(a,Permuted(w,pcols^(-1)));
		zt:=Permuted(zlist[1],pcols^(-1));
		az:=a+zt;
		thr:=w*List(az,Order);

		if onezero=1 then return ThresholdElement(w,thr); else return ThresholdElement(-w,-thr+1); fi;

	fi;


	mat:=rker[nlist[2]];

	pcols:=THELMA_INTERNAL_SortCols(mat);
	mat:=TransposedMat(Permuted(TransposedMat(mat),pcols));

	prows:=THELMA_INTERNAL_SortRows(mat);
	mat:=Permuted(mat,prows);

	a:=ker[nlist[2]];
	j0:=nlist[3];
	t0:=nlist[4];
	ilist:=[];
	qllist:=[];

	ilo:=2^(j0-1)+1;
	templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
	templist[j0+1]:=One(GF(2));

	if Position(mat,templist)<>fail then
		ihi:=Position(mat,templist)-1;
	else
		return [];
	fi;

	for n0 in [j0..j0+t0-1] do
		fms:=THELMA_INTERNAL_FindMaxSet2(mat{[ilo..ihi]},n0-1);
		if ilist=[] then
			Add(ilist,fms[2]);
		else
			if ilist[Size(ilist)]<>fms[2] then
				return [];
			fi;
		fi;

		if n0=j0 then zlist:=fms[5]; fi;

		if qllist=[] then Add(qllist,fms[4]); else
			if fms[3]=Size(qllist[Size(qllist)]) then Add(qllist,fms[4]); else return []; fi;
		fi;

		ilo:=ihi+1;
		templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
		templist[n0+2]:=One(GF(2));
		if Position(mat,templist)<>fail then
			ihi:=Position(mat,templist)-1;
		else
			ihi:=Size(mat);
		fi;
	od;

	qlist:=[];
	if Size(qllist)>1 then
		for i in [2..Size(qllist)] do
			q:=qllist[i-1]-qllist[i];
			if q=ListWithIdenticalEntries(Size(q),q[1]) then Add(qlist,q[1]); else return []; fi;
		od;
	fi;

	w:=[];
	for i in [1..ilist[1]] do Add(w,-2^(i-1)); od;

	if Size(zlist)=1 then Add(w,Sum(w)-1); fi;
	if Size(zlist)>1 then
		for i in [1..Size(zlist)-1] do
			w:=THELMA_INTERNAL_SolveZW(zlist[i],zlist[i+1],w);
		od;
	fi;

	if zlist=[] then return []; fi;


	if (j0-(ilist[1]+Size(qllist[1])-1))>1 then
		tempw:=ShallowCopy(w);
		while Size(tempw)<Size(zlist[Size(zlist)]) do Add(tempw,0); od;
		temp:=List(zlist[Size(zlist)],Order)*tempw-1;
		for i in [ilist[1]+1..j0-1] do Add(w,temp); od;
	fi;


	if (j0-(ilist[1]+Size(qllist[1])-1))=1 then
		Add(w,Sum(w)-1);
	fi;

	for i in [1..Size(qlist)] do Add(w,w[Size(w)]-q[i]); od;

	tempw:=w{[1..ilist[1]]};

	while Size(tempw)<Size(zlist[Size(zlist)]) do Add(tempw,0); od;

	temp:=List(zlist[1],Order)*tempw+w[j0]-1;
	for i in [j0+t0..n] do Add(w,temp); od;

	w:=THELMA_INTERNAL_ActionOnVector(a,Permuted(w,pcols^(-1)));
	zt:=Permuted(zlist[1],pcols^(-1));
	az:=a+zt;
	thr:=w*List(az,Order);
	if onezero=1 then return ThresholdElement(w,thr); else return ThresholdElement(-w,-thr+1); fi;
end);

BindGlobal("THELMA_INTERNAL_ThresholdOperator4",function(ker, rker, onezero, nlist)
# Arguments: ker - a matrix over GF(2), the kernel of some Boolean function;
# Arguments: rker - a list of matrices over GF(2), the reduced kernel of some Boolean function;
# Arguments: onezero - the value (0 or 1) on which the kernel is achieved;
# Arguments: a list, which is outout of THELMA_INTERNAL_FormNList2;
# Output: a threshold element if function is realizable, [] otherwise.
# Case if rker=p^m(A)
	local kk,ntemp, tempmat, zt,z00,thr,az,temp,tempw,w,T,templist,
	pcols, prows, tmat, n, z,q, bool, mat,a,ilo, ihi,m,k,
	j0,t0,ilist,qllist,fms,n0,zlist,i, qlist, jlist, sum, to4;

	n:=Size(ker[1]);

	j0:=nlist[3];
	t0:=nlist[4];

	jlist:=[]; Add(jlist,j0);

	pcols:=nlist[5];
	zlist:=nlist[6];
	a:=ker[nlist[2]];

	mat:=rker[nlist[2]];

	pcols:=THELMA_INTERNAL_SortCols(mat);
	mat:=TransposedMat(Permuted(TransposedMat(mat),pcols));

	prows:=THELMA_INTERNAL_SortRows(mat);
	mat:=Permuted(mat,prows);

	ilo:=2^(j0-1)+1;
	ntemp:=ilo-1;

	tempmat:=mat{[ilo..Size(ker)]};

	while t0=1 do
		nlist:=THELMA_INTERNAL_FindMaxSet2(tempmat,j0-1);
		j0:=nlist[2];
		Add(jlist,j0);

		zlist:=nlist[5];

		t0:=nlist[3];

		ilo:=ilo+2^(j0-1);
		tempmat:=mat{[ilo..Size(ker)]};
		if t0=1 then ntemp:=ntemp+2^(j0-1); else
			ntemp:=ntemp+Size(nlist[1]);
		fi;
	od;

	if ntemp<>Size(ker) then return[]; fi;

	w:=[];
	for i in [1..j0] do Add(w,Sum(w)-1); od;

	if Size(zlist)=1 then
		Add(w,Sum(w)-1);
	fi;


	if Size(zlist)>1 then
			for i in [1..Size(zlist)-1] do
				w:=THELMA_INTERNAL_SolveZW(zlist[i],zlist[i+1],w);
			od;
	fi;

	if jlist[Size(jlist)-1]=jlist[Size(jlist)]+t0 then Add(w,Sum(w)-1); fi;

	if jlist[Size(jlist)-1]>jlist[Size(jlist)]+t0 then
		tempw:=ShallowCopy(w);

		while Size(tempw)<Size(zlist[Size(zlist)]) do Add(tempw,0); od;
		temp:=List(zlist[Size(zlist)],Order)*tempw-1;
		for i in [jlist[Size(jlist)]+t0..jlist[Size(jlist)-1]-1] do Add(w,temp); od;
		Add(w,Sum(w)-1);
	fi;

	m:=Size(jlist);
	for k in [3..m] do
		if jlist[m-k+1]-jlist[m-k+2]=1 then Add(w,Sum(w)-1); fi;
		if jlist[m-k+1]-jlist[m-k+2]>1 then
			tempw:=w{[1..jlist[Size(jlist)]+t0-1]};

			while Size(tempw)<Size(zlist[Size(zlist)]) do Add(tempw,0); od;
			sum:=0;
			for i in [2..k-1] do sum:=sum+w[jlist[i]]; od;

			temp:=List(zlist[Size(zlist)],Order)*tempw + sum -1;
			for i in [jlist[m-k+2]+1..jlist[m-k+1]-1] do Add(w,temp); od;
			Add(w,Sum(w)-1);
		fi;
	od;

	tempw:=w{[1..jlist[Size(jlist)]+t0-1]};
	while Size(tempw)<Size(zlist[Size(zlist)]) do Add(tempw,0); od;

	sum:=0;
	for i in [2..m] do sum:=sum+w[jlist[m-i+1]]; od;
	temp:=List(zlist[Size(zlist)],Order)*tempw + sum -1;
	while Size(w)<Size(zlist[Size(zlist)]) do Add(w,temp); od;

	w:=THELMA_INTERNAL_ActionOnVector(a,Permuted(w,pcols^(-1)));
	zt:=Permuted(zlist[1],pcols^(-1));
	az:=a+zt;
	thr:=w*List(az,Order);

	if onezero=1 then return ThresholdElement(w,thr); else return ThresholdElement(-w,-thr+1); fi;
end);

BindGlobal("THELMA_INTERNAL_ThresholdOperator41",function(ker, rker, onezero, nlist)
# Arguments: ker - a matrix over GF(2), the kernel of some Boolean function;
# Arguments: rker - a list of matrices over GF(2), the reduced kernel of some Boolean function;
# Arguments: onezero - the value (0 or 1) on which the kernel is achieved;
# Arguments: a list, which is outout of THELMA_INTERNAL_FormNList2;
# Output: a threshold element if function is realizable, [] otherwise.
# Another case for p(A)^m
	local kk,ntemp, tempmat, zt,z00,thr,az,temp,tempw,w,T,templist,
	pcols, prows, tmat, n, z,q, bool, mat,a,ilo, ihi,m,k,tmlist,tm,
	j0,t0,t01,ilist,qllist,fms,n0,zlist,i, qlist, jlist, sum, tsize,tj0;

	n:=Size(ker[1]);

	j0:=nlist[3];
	t0:=nlist[4];
	t01:=t0;
	jlist:=[]; Add(jlist,j0);

	pcols:=nlist[5];
	zlist:=nlist[6];
	a:=ker[nlist[2]];

	mat:=rker[nlist[2]];

	pcols:=THELMA_INTERNAL_SortCols(mat);
	mat:=TransposedMat(Permuted(TransposedMat(mat),pcols));

	prows:=THELMA_INTERNAL_SortRows(mat);
	mat:=Permuted(mat,prows);

	ilo:=2^(j0-1)+1;
	ntemp:=ilo-1;

	templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
	templist[j0+1]:=One(GF(2));

	tj0:=j0;
	if Position(mat,templist)<>fail then
		ihi:=Position(mat,templist)-1;
	else
		return [];
	fi;

	tempmat:=mat{[ilo..ihi]};

	tsize:=Size(mat{[ilo..ihi]});

	tm:=TransposedMat(mat{[ilo..ihi]});
	tm:=TransposedMat(tm{[1..j0-1]});

	tmlist:=[]; Add(tmlist,tm);

	while ihi<Size(mat) do
		tj0:=tj0+1;
		ilo:=ihi+1;
		templist:=ListWithIdenticalEntries(n,Zero(GF(2)));
		templist[tj0+1]:=One(GF(2));

		if Position(mat,templist)<>fail then
			ihi:=Position(mat,templist)-1;
		else
			ihi:=Size(mat);
		fi;
		if tsize<>Size(mat{[ilo..ihi]}) then return []; fi;

		tm:=TransposedMat(mat{[ilo..ihi]});
		tm:=TransposedMat(tm{[1..j0-1]});
		Add(tmlist,tm);
	od;

	tm:=tmlist[1];
	for i in [2..Size(tmlist)] do
		if tmlist[i]<>tm then return []; fi;
	od;

	t0:=1;

	ilo:=ntemp+1;
	ihi:=ntemp+Size(tm);
	tempmat:=mat{[ilo..ihi]};
	while t0=1 do
		nlist:=THELMA_INTERNAL_FindMaxSet2(tempmat,j0-1);
		j0:=nlist[2];
		Add(jlist,j0);
		zlist:=nlist[5];
		t0:=nlist[3];

		ilo:=ilo+2^(j0-1);
		tempmat:=mat{[ilo..ihi]};
		if t0=1 then ntemp:=ntemp+2^(j0-1); else
			ntemp:=ntemp+Size(nlist[1]);
		fi;
	od;

	if ntemp<>ihi then return[]; fi;

	w:=[];
	for i in [1..j0] do Add(w,Sum(w)-1); od;

	if Size(zlist)=1 then
		Add(w,Sum(w)-1);
	fi;

	if Size(zlist)>1 then
			for i in [1..Size(zlist)-1] do
				w:=THELMA_INTERNAL_SolveZW(zlist[i],zlist[i+1],w);
			od;
	fi;

	if jlist[Size(jlist)-1]=jlist[Size(jlist)]+t0 then Add(w,Sum(w)-1); fi;

	if jlist[Size(jlist)-1]>jlist[Size(jlist)]+t0 then
		tempw:=ShallowCopy(w);

		while Size(tempw)<Size(zlist[Size(zlist)]) do Add(tempw,0); od;
		temp:=List(zlist[Size(zlist)],Order)*tempw-1;
		for i in [jlist[Size(jlist)]+t0..jlist[Size(jlist)-1]-1] do Add(w,temp); od;
		Add(w,Sum(w)-1);
	fi;

	m:=Size(jlist);
	for k in [3..m] do
		if jlist[m-k+1]-jlist[m-k+2]=1 then Add(w,Sum(w)-1); fi;
		if jlist[m-k+1]-jlist[m-k+2]>1 then
			tempw:=w{[1..jlist[Size(jlist)]+t0-1]};

			while Size(tempw)<Size(zlist[Size(zlist)]) do Add(tempw,0); od;

			sum:=0;
			for i in [2..k-1] do sum:=sum+w[jlist[i]]; od;

			temp:=List(zlist[Size(zlist)],Order)*tempw + sum -1;
			for i in [jlist[m-k+2]+1..jlist[m-k+1]-1] do Add(w,temp); od;
			Add(w,Sum(w)-1);
		fi;
	od;

	for i in [jlist[1]+1..jlist[1]+t01-1] do Add(w,w[Size(w)]); od;

	tempw:=w{[1..jlist[Size(jlist)]+t0-1]};
	while Size(tempw)<Size(zlist[Size(zlist)]) do Add(tempw,0); od;

	sum:=0;
	for i in [2..m] do sum:=sum+w[jlist[m-i+1]]; od;
	temp:=List(zlist[Size(zlist)],Order)*tempw + sum -1;
	while Size(w)<Size(zlist[Size(zlist)]) do Add(w,temp); od;

	w:=THELMA_INTERNAL_ActionOnVector(a,Permuted(w,pcols^(-1)));
	zt:=Permuted(zlist[1],pcols^(-1));
	az:=a+zt;
	thr:=w*List(az,Order);

	if onezero=1 then return ThresholdElement(w,thr); else return ThresholdElement(-w,-thr+1); fi;
end);

######################################################################
##
#F  BooleanFunctionBySTE(f)
##
##  Returns the Threshold Element realizing the Boolean function
##  or [] if the function is not realizable.
##

BindGlobal("THELMA_INTERNAL_IsRlzbl",function(f)
# Arguments: f - a truth vector of Boolean function over GF(2);
# Output: a threshold element if function is realizable, [] otherwise.
local temp,k,onezero,t,nlist,to2,to4,to41;
	temp:=KernelOfBooleanFunction(f);
	k:=temp[1];
	onezero:=temp[2];
	t:=ReducedKernelOfBooleanFunction(k);

	if IsInverseInKernel(k) then
		return [];
	fi;

	if Size(t)<=2^(Size(t[1][1])-1) then
		if IsRKernelBiggerOfCombSum(t)=false then
			return [];
		fi;
	fi;

	if IsKernelContainingPrecedingVectors(k)=false then
		return [];
	fi;

	nlist:=THELMA_INTERNAL_FormNList2(k,t,onezero);

	to2:=THELMA_INTERNAL_ThresholdOperator2(k, t, onezero,nlist);
	#ThrOp3G contains in it ThrOp3

	if to2<>[] then return to2; fi;

	to4:=THELMA_INTERNAL_ThresholdOperator4(k, t, onezero,nlist);
	if to4<>[] then return to4; fi;

	to41:=THELMA_INTERNAL_ThresholdOperator41(k, t, onezero,nlist);
	if to41<>[] then return to41; fi;

	return THELMA_INTERNAL_ThresholdOperator3G(k, t, onezero,nlist);
end);

InstallMethod(BooleanFunctionBySTE, "f", true, [IsObject], 1,
function(f)
	local n, k, i, t, w, res, j, bool, onezero, temp, struct, to2, to4, to41, nlist;
	w:=[];

	if (IsLogicFunction(f)=false) then
		Error("f has to be a logic function.");
	fi;

	n:=f!.numvars;

	if (f!.dimension<>2) then
		Error("f has to be a Boolean function.");
	fi;

	f:=THELMA_INTERNAL_BFtoGF(f);

	if Position(f,Z(2)^0) = fail then
		for i in [1..LogInt(Size(f),2)] do Add(w,i); od;
		return ThresholdElement(w,Sum(w)+1);
	fi;
	if Position(f,0*Z(2)) = fail then
		for i in [1..LogInt(Size(f),2)] do Add(w,i); od;
		return ThresholdElement(w,0);
	fi;

	return THELMA_INTERNAL_IsRlzbl(f);
end);


InstallOtherMethod(BooleanFunctionBySTE, "f", true, [IsFFECollection], 1,
function(f)
	local n, k, i, t, w, res, j, bool, onezero, temp, struct, to2, to4, to41, nlist;
	w:=[];

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
	fi;

	if Position(f,Z(2)^0) = fail then
		for i in [1..LogInt(Size(f),2)] do Add(w,i); od;
		return ThresholdElement(w,Sum(w)+1);
	fi;
	if Position(f,0*Z(2)) = fail then
		for i in [1..LogInt(Size(f),2)] do Add(w,i); od;
		return ThresholdElement(w,0);
	fi;

	return THELMA_INTERNAL_IsRlzbl(f);
end);


#IsRealizable if f is a polynomial over GF(2)
InstallOtherMethod(BooleanFunctionBySTE, "f", true, [IsPolynomial], 1,
function(f)
	local n,k, i, t, w, res, j, bool, onezero, temp, struct, to2, to4, to41, nlist;
	w:=[];

	if f=Zero(GF(2)) then
		n:=InputFromUser("Enter the number of weights:\n");
		for i in [1..n] do Add(w,i); od;
		return ThresholdElement(w,Sum(w)+1);
	fi;
	if f=One(GF(2)) then
		n:=InputFromUser("Enter the number of weights:\n");
		for i in [1..n] do Add(w,i); od;
		return ThresholdElement(w,0);
	fi;
	return THELMA_INTERNAL_IsRlzbl(f);
end);


#If f is a string
InstallOtherMethod(BooleanFunctionBySTE, "f", true, [IsString], 1,
function(f)
	local n,k, i, t, w, res, j, bool, onezero, temp, struct, to2, to4, to41, nlist;
	w:=[];

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1' and '0'. \n");
		return [];
	fi;

	if Position(f,'1') = fail then
		for i in [1..LogInt(Size(f),2)] do Add(w,i); od;
		return ThresholdElement(w,Sum(w)+1);
	fi;

	if Position(f,'0') = fail then
		for i in [1..LogInt(Size(f),2)] do Add(w,i); od;
		return ThresholdElement(w,0);
	fi;

	return THELMA_INTERNAL_IsRlzbl(f);
end);

#If input is a KernelOfBooleanFunction
InstallOtherMethod(BooleanFunctionBySTE, "k, onezero", true, [IsFFECollColl, IsInt], 1,
function(k,onezero)
	local n, i, t, w, res, j, bool, temp, struct, to2, to4, to41, nlist,f;
	w:=[];

	f:=THELMA_INTERNAL_FindFunctionFromKernel(k,onezero);
	t:=ReducedKernelOfBooleanFunction(k);

	if IsInverseInKernel(f) then
		return [];
	fi;

	if Size(t)<=2^(Size(t[1][1])-1) then
		if IsRKernelBiggerOfCombSum(t)=false then
			return [];
		fi;
	fi;

	if IsKernelContainingPrecedingVectors(f)=false then
		return [];
	fi;

	nlist:=THELMA_INTERNAL_FormNList2(k,t,onezero);
	to2:=THELMA_INTERNAL_ThresholdOperator2(k, t, onezero,nlist);
	#ThrOp3G contains in it ThrOp3

	if to2<>[] then return to2; fi;

	to4:=THELMA_INTERNAL_ThresholdOperator4(k, t, onezero,nlist);
	if to4<>[] then return to4; fi;

	to41:=THELMA_INTERNAL_ThresholdOperator41(k, t, onezero,nlist);
	if to41<>[] then return to41; fi;

	return THELMA_INTERNAL_ThresholdOperator3G(k, t, onezero,nlist);
end);



######################################################################
##
#F  PDBooleanFunctionBySTE(f)
##
##  Returns the Threshold Element realizing the Boolean function
##  or [] if the function is not realizable.
##
##  Determines whether partially defined boolean function can be realized by a single threshold element
InstallMethod(PDBooleanFunctionBySTE, "f", true, [IsString], 1,
function(f)
	local n, k, i, t, w, res, j, bool, onezero, temp, struct, to2, to4, to41, nlist, ker1, ker0, kerx, te, ker, rker, ind, a,
	tind, pcols;

	w:=[];

	n:=LogInt(Size(f),2);
	if Size(f)<>2^n then
	    Error("Number of elements of the vector must be a power of 2");
		return [];
	fi;

	if 2^n<>(Size(Positions(f,'x'))+Size(Positions(f,'1'))+Size(Positions(f,'0'))) then
		Error("Input string should contain only '1', '0' and 'x'. \n");
		return [];
	fi;

	t:=IteratorOfTuples(GF(2),LogInt(n,2));

	ker1:=[]; ker0:=[]; kerx:=[];

	for i in [1..Size(f)] do
		if f[i]='1' then Add(ker1,THELMA_INTERNAL_ConvertDecToBin(i-1,n));
		elif f[i]='0' then Add(ker0,THELMA_INTERNAL_ConvertDecToBin(i-1,n));
		fi;
	od;

	if ker1 = [] then
		for i in [1..LogInt(Size(f),2)] do Add(w,i); od;
		return ThresholdElement(w,Sum(w)+1);
	fi;

	if ker0 = [] then
		for i in [1..LogInt(Size(f),2)] do Add(w,i); od;
		return ThresholdElement(w,0);
	fi;

	if Size(ker1)<=Size(ker0) then
		ker:=ShallowCopy(ker1);
		onezero:=1;
	else
		ker:=ShallowCopy(ker0);
		onezero:=0;
	fi;

	te:=BooleanFunctionBySTE(ker,onezero);
	if te<>[] then return te; fi;

	rker:=ReducedKernelOfBooleanFunction(ker);

	nlist:=THELMA_INTERNAL_FormNList2(ker,rker, onezero);

	ind:=THELMA_INTERNAL_PIndex(rker[nlist[2]]);
	pcols:=THELMA_INTERNAL_SortCols(rker[nlist[2]]);
	a:=ker[nlist[2]];

	for i in t do
		if not( (i in ker0) or i in (ker1) ) then
			tind:=Positions(Permuted(i+a,pcols^(-1)),One(GF(2)));
			if Size(tind)=1 and (Intersection(tind,ind)<>[]) then
				Add(ker,i);
			fi;
		fi;
	od;

	te:=BooleanFunctionBySTE(ker,onezero);
	return te;
end);


InstallOtherMethod(PDBooleanFunctionBySTE, "ker1, ker0", true, [IsList, IsList], 1,
function(ker1, ker0)
	local n, k, i, t, w, res, j, bool, onezero, temp, struct, to2, to4, to41, nlist, kerx, te, ker, rker, ind, a,
	tind, pcols;

	w:=[];
	if Size(ker1) <> 0 then n:=Size(ker1[1]); fi;
	if Size(ker0) <> 0 then n:=Size(ker0[1]); fi;

	if Size(ker1) <> 0 then
		if not(IsFFECollColl(ker1)) then Error("Input matrix should contain elements of GF(2) only!\n"); fi;
		n:=Size(ker1[1]);
	elif Size(ker0) <> 0 then
		if not(IsFFECollColl(ker0)) then Error("Input matrix should contain elements of GF(2) only!\n"); fi;
		n:=Size(ker0[0]);
	else
		Error("Both sets could not be empty at the same time. \n");
	fi;

	if Intersection(ker1, ker0)<>[] then
		Error("Kernels should not intersect!\n");
	fi;

	if ((Size(ker1)+Size(ker0))=2^n) then
		if Size(ker1)<=Size(ker0) then
			return BooleanFunctionBySTE(ker1,1);
		else
			return BooleanFunctionBySTE(ker0,0);
		fi;
	fi;

	t:=IteratorOfTuples(GF(2),LogInt(n,2));

	kerx:=[];

	if ker1 = [] then
		for i in [1..n] do Add(w,i); od;
		return ThresholdElement(w,Sum(w)+1);
	fi;

	if ker0 = [] then
		for i in [1..n] do Add(w,i); od;
		return ThresholdElement(w,0);
	fi;

	if Size(ker1)<=Size(ker0) then
		ker:=ShallowCopy(ker1);
		onezero:=1;
	else
		ker:=ShallowCopy(ker0);
		onezero:=0;
	fi;


	te:=BooleanFunctionBySTE(ker,onezero);
	if te<>[] then return te; fi;

	rker:=ReducedKernelOfBooleanFunction(ker);

	nlist:=THELMA_INTERNAL_FormNList2(ker,rker, onezero);

	ind:=THELMA_INTERNAL_PIndex(rker[nlist[2]]);
	pcols:=THELMA_INTERNAL_SortCols(rker[nlist[2]]);
	a:=ker[nlist[2]];

	for i in t do
		if not( (i in ker0) or i in (ker1) ) then
			tind:=Positions(Permuted(i+a,pcols^(-1)),One(GF(2)));
			if Size(tind)=1 and (Intersection(tind,ind)<>[]) then
				Add(ker,i);
			fi;
		fi;
	od;

	te:=BooleanFunctionBySTE(ker,onezero);
	return te;
end);



#E
##
