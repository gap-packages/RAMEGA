#############################################################################
##
#W  random.gi                         Zsolt Adam Balogh <baloghzsa@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#Y  Copyright (C)  2020,  UAE University, UAE
##
#############################################################################
##
##  This file contains random methods for group algebras.
##
#############################################################################
##

#############################################################################
##
##  BasicGroup( <KG> )
##
##  Returns the basic group of the group algebra KG as a subgroup of the
##  normalized group of units.
##
InstallMethod( BasicGroup,"Group Ring" ,true, [IsGroupRing],1,
function(kg)
    local emb,g;

    g:=UnderlyingGroup(kg);
    emb:=Embedding(g,kg);

    return Image(emb);
end);

#############################################################################
##
##  IsLienEngel( <KG> )
##
##  Returns true if KG is Lie n-Engel.
##  [x,y,y,...,y]=0 for all x,y where the number of y's in the Lie operator is n.
##
##
InstallMethod( IsLienEngel, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local g,ns,er,p,h;

   if not(IsGroupRing(kg)) then
	      Error("Input should be a Group Ring.");
   fi;
   er:=false;
   p:=Characteristic(kg);
   if IsPrime(p) then
      g:=UnderlyingGroup(kg);
      if not(IsAbelian(g)) and IsNilpotent(g) then
	       ns:=NormalSubgroups(g);
	       for h in ns do
#	  if ( IsPPrimePower(Order(g)/Order(h),p) and IsPGroup(DerivedSubgroup(h))  ) then
#    	  if ( IsPosInt(LogInt(Order(g)/Order(h),p)) and IsPGroup(DerivedSubgroup(h))  ) then
          if ((p^(LogInt(Order(g)/Order(h),p))=Order(g)/Order(h)) and IsPGroup(DerivedSubgroup(h))  ) then
        	   if PrimePGroup(DerivedSubgroup(h))=p then
			            er:=true;
		         fi;
	        fi;
	       od;
     fi;
   else er:=true;
   fi;
   return er;
end);


#############################################################################
##
##  GetRandomUnit( <KG> )
##
##  Returns a random unit of KG.
##
##
InstallMethod( GetRandomUnit, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local x,o;
   o:=Zero(UnderlyingField(kg));
   repeat
      x:=Random(kg);
   until(x^-1<>fail);
   return x;
end);

#############################################################################
##
##  GetRandomNormalizedUnit( <KG> )
##
##  Returns a random normalized unit of the modular group algebra KG.
##
##
InstallMethod( GetRandomNormalizedUnit, "Group Algebra", true, [IsGroupRing],1,
function(kg)

   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   return RAMEGA_GetRandomNormalizedUnit(kg);
end);

#############################################################################
##
##  GetRandomUnitaryUnit( <KG> )
##
##  Returns a random unitary unit of KG related to the involution specified as second parameter.
##  If the second parameter is not specified the default involution is the canonical involution.
##
InstallMethod( GetRandomUnitaryUnit, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local x,e;
   e:=One(kg);
   repeat
      x:=GetRandomUnit(kg);
   until(x*Involution(x) = e);
   return x;
end);

InstallOtherMethod( GetRandomUnitaryUnit, "Group Algebra, Involution", true, [IsGroupRing, IsMapping],2,
function(kg, sigma)
   local x,e;
   e:=One(kg);
   repeat
      x:=GetRandomNormalizedUnit(kg);
   until(x*RAMEGA_InvolutionKG(x,sigma,kg) = e);
   return x;
end);

#############################################################################
##
##  GetRandomNormalizedUnitaryUnit( <KG> )
##
##  Returns a random normalized unitary unit of the modular group algebra KG related to the involution specified as second parameter.
##  If the second parameter is not specified the default involution is the canonical involution.
##
InstallMethod( GetRandomNormalizedUnitaryUnit, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local x,e;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   e:=One(kg);
   repeat
      x:=GetRandomNormalizedUnit(kg);
   until(x*Involution(x) = e);
   return x;
end);

InstallOtherMethod( GetRandomNormalizedUnitaryUnit, "Group Algebra, Involution", true, [IsGroupRing, IsMapping],2,
function(kg, sigma)
   local x,e;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   e:=One(kg);
   repeat
      x:=GetRandomNormalizedUnit(kg);
   until(x*RAMEGA_InvolutionKG(x,sigma,kg) = e);
   return x;
end);


#############################################################################
##
##  GetRandomElementFromAugmentationIdeal( <KG> )
##
##  Returns a random nilpotent element of the modular group algebra KG.
##
##
InstallMethod( GetRandomElementFromAugmentationIdeal, "Group Algebra", true, [IsGroupRing],1,
function(kg)
   local x,o;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   o:=Zero(UnderlyingField(kg));
   repeat
      x:=Random(kg);
   until(Augmentation(x) = o);
   return x;
end);


#############################################################################
##
##  RandomLienEngelLength( <KG,n> )
##
##  Returns the Lie n-Engel length of KG by random way.
##  [x,y,y,...,y]=0 for all x,y where the number of y's in the Lie operator is the Lie n-Engel length.
##
##
InstallMethod( RandomLienEngelLength, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,n)
	local g,er,i,j,x,y,max;

	if not(IsGroupRing(kg)) then
	      Error("Input should be a Group Ring.");
	fi;
	if not(IsLienEngel(kg)) then
	      Error("The group ring is not Lie n-Engel");
	fi;
	max:=0;
    g:=BasicGroup(kg);
    for j in [1..n] do
       x:=Random(kg);
       for i in g do
         y:=i;
         er:=0;
         repeat
           y:=RAMEGA_LieComm(y,x);
           er:=er+1;
         until(y=Zero(kg));
		 if (max < er) then
		   max:=er;
		 fi;
       od;
    od;
    return max;
end);


#############################################################################
##
##  RandomExponent( <KG,m> )
##
##  Returns the Exponent of the group of normalized units in a modular group algebra by random way.
##
##
InstallMethod( RandomExponent, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,m)
   local order,x,er,max;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   if not( IsPGroup(UnderlyingGroup(kg))) then
       Error("G should be a p group.");
   fi;
   er:=0;
   max:=1;
   order:=0;
   repeat
     x:=GetRandomNormalizedUnit(kg);
     order:=Order(x);
     er:=er+1;
	 if (max < order) then
	   max:=order;
	 fi;
   until(er = m);
   return max;
end);

#############################################################################
##
##  RandomExponentOfNormalizedUnitsCenter( <KG,m> )
##
##  Returns the exponent of the center of the group of normalized units in the modular group algebra KG by random way.
##
##
InstallMethod( RandomExponentOfNormalizedUnitsCenter, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,m)
   local x,e,er,order,max,c;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("Input should be a Modular Group Algebra.");
   fi;
   if not( IsPGroup(UnderlyingGroup(kg))) then
       Error("G should be a p group.");
   fi;
   er:=0;
   max:=0;
   e:=One(UnderlyingField(kg));
   c:=Center(kg);
   repeat
     x:=Random(c);
     if (Augmentation(x) = e) then
        order:=Order(x);
		if (max < order) then
		  max:=order;
		fi;
        er:=er+1;
     fi;
   until(er = m);
   return max;
end);

#############################################################################
##
##  RandomNilpotencyClass( <KG,m> )
##
##  Returns the nilpotency class of the group of normalized units of the group algebra KG by random way.
##
##
InstallMethod( RandomNilpotencyClass, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,m)
   local cl,x,y,e,er,class;
   if not(RAMEGA_IsLieNilpotent(LieAlgebra(kg))) then
	   Error("The Group Algebra is not nilpotent.");
   fi;
   e:=One(kg);
   class:=0;
   er:=1;
   while (er < m) do
     x:=GetRandomNormalizedUnit(kg);
     cl:=0;
     repeat
        y:=GetRandomNormalizedUnit(kg);
        x:=Comm(x,y);
        cl:=cl+1;
     until(x = e);
     if (class < cl) then
	   class:=cl;
	 fi;
     er:=er+1;
   od;
   return class;
end);

#############################################################################
##
##  RandomDerivedLength( <KG,m> )
##
##  Returns the derived length of the modular group algebra KG by random way.
##
##
InstallMethod( RandomDerivedLength, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,m)
   local e,n,x,depth,bol;
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
   fi;
   e:=One(kg);
   bol:=false;
   depth:=1;
   while(not(bol)) do
     n:=1;
     while(n < m) do
        x:=RAMEGA_GetDerivedDepthN(kg,depth);
        if (not(x=e)) then
           bol:=true;
        fi;
        n:=n+1;
     od;
     if (bol) then
        depth:=depth+1;
        bol:=false;
     else
        bol:=true;
     fi;
   od;
   return depth-1;
end);

##############################################################################
##
##  RandomCommutatorSubgroup( < G, n > )
##
##  Returns the commutator subgroup of G using random method.
##  Returns the commutator subgroup of the unit group of the group algebra KG using random method.
##
InstallMethod( RandomCommutatorSubgroup, "Group, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(KG,n)
    local i,x1,x2,A,g;
	A:=[];
	for i in [1..n] do
    x1:=GetRandomUnit(KG);
	  x2:=GetRandomUnit(KG);
	  AddSet(A,x1^-1*x2^-1*x1*x2);
	od;
	return Group(A);
end);

InstallOtherMethod( RandomCommutatorSubgroup, "Group, Number of Iterations", true, [IsGroup,IsPosInt],2,
function(G,n)
    local i,x1,x2,A,g;
	g:=Set(G);
	A:=[];
	for i in [1..n] do
      x1:=Random(g);
	  x2:=Random(g);
	  AddSet(A,Comm(x1,x2));
	od;
	return Group(A);
end);

##############################################################################
##
##  RandomCommutatorSubgroupOfNormalizedUnits( < kg, n > )
##
##  Returns the commutator subgroup of the normalized unit group of the modular group algebra KG
##  using random method.
##
InstallMethod( RandomCommutatorSubgroupOfNormalizedUnits, "Group Ring, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(kg,n)
    local i,x1,x2,A;
	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;
	A:=[];
	for i in [1..n] do
      x1:=GetRandomNormalizedUnit(kg);
	  x2:=GetRandomNormalizedUnit(kg);
	  AddSet(A,Comm(x1,x2));
	od;
	return Group(A);
end);

##############################################################################
##
##  RandomNormalizedUnitGroup( < KG > )
##
##  Returns the normalized group of units of the modular group algebra KG by random search.
##
##
InstallMethod( RandomNormalizedUnitGroup, "Group Ring", true, [IsGroupRing],1,
function(kg)
    local x,A,g,f,h;
	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;
	A:=[];
	g:=UnderlyingGroup(kg);

  if not(IsPGroup(g)) then
    Error("The underlying group should be a p-group.");
  fi;

	f:=UnderlyingField(kg);
	repeat
       x:=GetRandomNormalizedUnit(kg);
	   AddSet(A,x);
	   h:=Group(A);
	until (Size(h) = Size(f)^(Size(g)-1));
	return h;
end);

##############################################################################
##
##  RandomCommutatorSeries( < kg, n > )
##
##  Returns the commutator series of the normalized unit group of a modular group algebra using random method.
##
##
InstallMethod( RandomCommutatorSeries, "Group Ring, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(kg,n)
    local series,g;
	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;

    g:=UnderlyingGroup(kg);

    if not(IsPGroup(g)) then
      Error("The underlying group should be a p-group.");
    fi;

	series:=[RandomNormalizedUnitGroup(kg)];
	g:=RandomCommutatorSubgroupOfNormalizedUnits(kg,n);
	AddSet(series,g);
	repeat
	   g:=RandomCommutatorSubgroup(g,n);
	   Add(series,g);
	until IdGroup(g)=[1,1];
	return series;
end);

##############################################################################
##
##  RandomLowerCentralSeries( < kg, n > )
##
##  Returns the lower central series of the normalized unit group by random search.
##
##
InstallMethod( RandomLowerCentralSeries, "Group Ring, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(kg,n)
    local series,g,m,x1,x2,A,i;
	if not(RAMEGA_IsLieNilpotent(LieAlgebra(kg))) then
	   Error("The Group Algebra is not nilpotent.");
    fi;
	series:=[RandomNormalizedUnitGroup(kg)];
	g:=RandomCommutatorSubgroupOfNormalizedUnits(kg,n);
	m:=2;
	AddSet(series,g);
	repeat
	    A:=[];
	   	for i in [1..n] do
            x1:=GetRandomNormalizedUnit(kg);
	        x2:=Random(AsSet(series[m]));
	        AddSet(A,Comm(x1,x2));
	    od;
		m:=m+1;
		g:=Group(A);
	    Add(series,g);
	until IdGroup(g)=[1,1];
	return series;
end);

#############################################################################
##
##  RandomUnitaryOrder( <kg,n> )
##
##  Returns the order of unitary subgroup of normalized group of units
##  where p=char(k) and g is a finite p-group by random search. The number of trials is n.
##
InstallMethod( RandomUnitaryOrder, "Group Ring, Number of Iterations", true, [IsGroupRing,IsPosInt],2,
function(kg,n)
   local k,g,p,mean,trials,m,x,counter,i,position,min,index;

   k:=UnderlyingField(kg);
   g:=UnderlyingGroup(kg);
   p:=Characteristic(k);
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
     Error("Input should be a Modular Group Algebra.");
   fi;
   if not( IsPGroup(g)) then
       Error("G should be a p group.");
   fi;
   if not(0 < p) then
       Error("The characteristif of k should be positive.");
   fi;

   mean:=0;
   trials:=[];
   counter:=0;
   repeat
     m:=0;
     repeat
        x:=GetRandomNormalizedUnit(kg);
	    m:=m+1;
     until(x*Involution(x)=One(kg));
	 Add(trials,m);
	 counter:=counter+1;
   until (counter=n);
   mean:=Sum(trials)/Number(trials);
   position:=0;
   min:=(n*(mean-p)^2)/p;   
   if (1 < mean) then
	 for i in [1..LogInt(Number(k),p)*(Number(g)-1)] do
	    index:=(n*(mean-p^i)^2)/(p^i*(p^i-1));
	    if (index < min) then
		  min:=index;
		  position:=i;
		fi;
	 od;
   fi;	 
   return Number(k)^(Number(g)-1)/p^position;
end);

#############################################################################
##
##  RandomUnitaryOrder( <kg,sigma,n> )
##
##  Returns the order of unitary subgroup with respect to the involution sigma of normalized group of units
##  where p=char(k) and g is a finite p-group by random search. The default involution is the canonical involution.
##  The number of trials is n.
##
InstallOtherMethod( RandomUnitaryOrder, "Group Ring, Involution, Number of Iterations", true, [IsGroupRing,IsMapping,IsPosInt],3,
function(kg,sigma,n)
   local k,g,p,mean,trials,m,x,counter,i,position,min,index;

   k:=UnderlyingField(kg);
   g:=UnderlyingGroup(kg);
   p:=Characteristic(k);
   if not(RAMEGA_IsModularGroupAlgebra(kg)) then
     Error("Input should be a Modular Group Algebra.");
   fi;
   if not( IsPGroup(g)) then
       Error("G should be a p group.");
   fi;
   if not(0 < p) then
       Error("The characteristif of k should be positive.");
   fi;

   mean:=0;
   trials:=[];
   counter:=0;
   repeat
     m:=0;
     repeat
        x:=GetRandomNormalizedUnit(kg);
	    m:=m+1;
     until(x*RAMEGA_InvolutionKG(x,sigma,kg)=One(kg));
	 Add(trials,m);
	 counter:=counter+1;
   until (counter=n);
   mean:=Sum(trials)/Number(trials);
   position:=0;
   min:=(n*(mean-p)^2)/p;   
   if (1 < mean) then
	 for i in [1..LogInt(Number(k),p)*(Number(g)-1)] do
	    index:=(n*(mean-p^i)^2)/(p^i*(p^i-1));
	    if (index < min) then
		  min:=index;
		  position:=i;
		fi;
	 od;
   fi;	 
   return Number(k)^(Number(g)-1)/p^position;
end);

#############################################################################
##
##  GetRandomCentralNormalizedUnit( <KG> )
##
##  Returns a central normalized unit of the modular group algebra KG by random way.
##
##
InstallMethod( GetRandomCentralNormalizedUnit, "Group Ring", true, [IsGroupRing],1,
function(kg)
   local x,e,c;
   	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;
   c:=Center(kg);
   e:=One(UnderlyingField(kg));
   repeat
      x:=Random(c);
   until(Augmentation(x) = e);
   return x;
end);


#############################################################################
##
##  RandomUnitarySubgroup( <KG,n> )
##
##  Returns the group of normalized unitary units of the modular group algebra KG by random search.
##
##
InstallMethod( RandomUnitarySubgroup, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,n)
    local A,i,x;
   	if not(RAMEGA_IsModularGroupAlgebra(kg)) then
	   Error("The Group Algebra should be modular.");
    fi;
    A:=[];
   	for i in [1..n] do
        x:=GetRandomNormalizedUnitaryUnit(kg);
	    AddSet(A,x);
    od;
	return Group(A);
end);

#############################################################################
##
##  RandomDihedralDepth( <KG,n> )
##
##  Returns the dihedral depth of a group or a group algebra in a random way.
##
##

InstallMethod( RandomDihedralDepth, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(KG,n)
    local a,b,dd,g,s,k,i,j,exp;
    if not( IsPGroup(UnderlyingGroup(KG))) then
        Error("G should be a p group.");
    fi;

    k:=0;
    for i in [1..n] do
      a:=GetRandomUnit(KG); b:=GetRandomUnit(KG);
      if Order(a)>=2 and Order(b)>=2 and a*b<>b*a then
        g:=Group(a,b); s:=Size(g);
       if RAMEGA_IsDihedralGroup(g) and s>k then
           k:=s;
       fi;
      fi;
    od;

    if k<>0 then return LogInt(k,2)-1; else return 0; fi;
end);

#InstallMethod( RandomDihedralDepth, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
#function(KG,n)
#local a,b,dd,g,s,k,i,j,exp;
#if not( IsPGroup(UnderlyingGroup(KG))) then
#    Error("G should be a p group.");
#fi;
#    k:=0;
#    for i in [1..n] do
#      a:=GetRandomUnit(KG); b:=GetRandomUnit(KG);
#      if Order(a)>=2 and Order(b)>=2 and a*b<>b*a then
#        g:=Group(a,b); s:=Size(g);
    #    Print(s,"  ",Exponent(g),"\n");
#        exp:= Lcm(Set(List(Elements(g),j->Order(j))));
#        if s/exp=2 then
#          if Size(Filtered(Elements(g),j->Order(j)<=2))>=s/2+2 and s>k then k:=s; fi;
#        fi;
#      fi;
#    od;

#    if k<>0 then return LogInt(k,2)-1; else return 0; fi;
#end);

#############################################################################
##
##  RandomDihedralDepth( <G,n> )
##
##  Returns the dihedral depth of a group or a group algebra in a random way.
##
##
InstallOtherMethod( RandomDihedralDepth, "Group, Number of iterations", true, [IsGroup, IsPosInt],2,
function(G,n)
local a,b,k,s,g,i;
if not( IsPGroup(G)) then
    Error("G should be a p group.");
fi;
    k:=0;
    if IsAbelian(G) then
  Error("The Group should be a non abelian p-group.");
    fi;
    for i in [1..n] do
       a:=Random(Elements(G)); b:=Random(Elements(G));
       g:=Group(a,b);
  s:=Size(g);
       if RAMEGA_IsDihedralGroup(g) and s>k then
           k:=s;
       fi;
    od;
    if k>0 then return LogInt(k,2)-1; else return 0; fi;
end);


#############################################################################
##
##  RandomQuaternionDepth( <KG,n> )
##
##  Returns the quaternion depth of a group or a group algebra in a random way.
##
##
InstallMethod( RandomQuaternionDepth, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(KG,n)
    local a,b,dd,g,s,k,i,j,exp;
    if not( IsPGroup(UnderlyingGroup(KG))) then
        Error("G should be a p group.");
    fi;
    k:=0;
    for i in [1..n] do
      a:=GetRandomUnit(KG); b:=GetRandomUnit(KG);
      if Order(a)>=2 and Order(b)>=2 and a*b<>b*a then
        g:=Group(a,b); s:=Size(g);
        exp:= Lcm(Set(List(Elements(g),j->Order(j))));

        if s/exp=2 then
          if Size(Filtered(Elements(g),j->Order(j)<=2))=2 and s>k then k:=s; fi;
        fi;
      fi;
    od;

    if k<>0 then return LogInt(k,2)-1; else return 0; fi;
end);

#############################################################################
##
##  RandomQuaternionDepth( <G,n> )
##
##  Returns the quaternion depth of a group or a group algebra in a random way.
##
##
InstallOtherMethod( RandomQuaternionDepth, "Group, Number of iterations", true, [IsGroup, IsPosInt],2,
function(G,n)
local a,b,k,s,g,i;
if not( IsPGroup(G)) then
    Error("G should be a p group.");
fi;
    k:=0;
   	if IsAbelian(G) then
	   Error("The Group should be a non abelian p-group.");
    fi;
    for i in [1..n] do
       a:=Random(G); b:=Random(G);
       g:=Group(a,b);
	     s:=Size(g);
       if RAMEGA_IsGeneralisedQuaternionGroup(g) and s>k then
           k:=s;
       fi;
    od;
    if k>0 then return LogInt(k,2)-1; else return 0; fi;
end);

#############################################################################
##
##  RandomOmega( <KG,m,n> )
##
##
##  Returns the subgroup of V(KG), that is generated by the elements g for which g^{p^m}=1,
##  where G is a finite p-group by random search.
##
InstallMethod( RandomOmega, "Group Algebra, Power of p, Number of iterations", true, [IsGroupRing, IsPosInt, IsPosInt],3,
function(kg,m,n)
    local e,i,A,x,p,k,G;
    G:=BasicGroup(kg);
    if not( IsPrimePowerInt(Size(G))) then
        Error("G should be a p group.");
    fi;
    e:=One(G);
  A:=[];
    if ( IsPGroup(G) ) then
   p:=PrimePGroup(G);
        for i in [1..n] do
           x:=GetRandomNormalizedUnit(kg);
  if (x^(p^m) = e) then
      AddSet(A,x);
  fi;
od;
    fi;
return Group(A);
end);

InstallOtherMethod( RandomOmega, "Group, Power of p, Number of iterations", true, [IsGroup, IsPosInt, IsPosInt],3,
function(G,m,n)
    local e,i,A,x,p,k;
    e:=One(G);

    if not( IsPGroup(G)) then
        Error("G should be a p group.");
    fi;

    A:=[];
    if ( IsPGroup(G) ) then
   p:=PrimePGroup(G);
        for i in [1..n] do
           x:=Random(Elements(G));
  if (x^(p^m) = e) then
      AddSet(A,x);
  fi;
od;
    fi;
return Group(A);
end);
#############################################################################
##
##  RandomAgemo( <KG,m,n> )
##
##
##  Returns the subgroup of V(KG), that is generated by the elements g^{p^m},
##  where G is a finite p-group by random search.
##
InstallMethod( RandomAgemo, "Group Algebra, Power of p, Number of iterations", true, [IsGroupRing, IsPosInt, IsPosInt],3,
function(kg,m,n)
    local i,A,x,p,k,g,e,G;
    G:=BasicGroup(kg);
    e:=One(G);

    if not( IsPrimePowerInt(Size(G))) then
        Error("G should be a p group.");
    fi;

A:=[];
    if ( IsPGroup(G) ) then
       p:=PrimePGroup(G);
        for i in [1..n] do
           x:=GetRandomNormalizedUnit(kg);
      AddSet(A,x^(p^m));
   od;
    fi;
return Group(A);
end);

InstallOtherMethod( RandomAgemo, "Group, Power of p, Number of iterations", true, [IsGroup, IsPosInt, IsPosInt],3,
function(G,m,n)
    local i,A,x,p,k,g,e;
    e:=One(G);
    if not( IsPGroup(G)) then
        Error("G should be a p group.");
    fi;

  A:=[];
    if ( IsPGroup(G) ) then
       p:=PrimePGroup(G);
        for i in [1..n] do
           x:=Random(Elements(G));
      AddSet(A,x^(p^m));
   od;
    fi;
return Group(A);
end);

##############################################################################
##
##  GetRandomSubgroupOfNormalizedUnitGroup( < kg, n > )
##
##  Returns a subgroup of the normalized group of units generated by n
##  random normalized units.
##
InstallMethod(GetRandomSubgroupOfNormalizedUnitGroup, "Group Algebra, Number of random normalized units", true, [IsGroupRing, IsPosInt],2,
function(kg,n)
    local H,i,x;
H:=[];
for i in [1..n] do
   x:=GetRandomNormalizedUnit(kg);
   Add(H,x);
od;
    return Group(H);
end);

##############################################################################
##
##  RandomConjugacyClass( < kg, n > )
##
##  Returns the random conjugacy class of a random element of the group of
##  normalized units.
##
InstallMethod(RandomConjugacyClass, "Group Algebra, Number of random normalized units", true, [IsGroupRing, IsPosInt],2,
function(kg,n)
    local x,H,i,y;
H:=[];
    x:=GetRandomNormalizedUnit(kg);
for i in [1..n] do
  y:=GetRandomNormalizedUnit(kg);
  Add(H,y^-1*x*y);
od;
    return AsSet(H);
end);

##############################################################################
##
##  RandomConjugacyClasses( < kg, n > )
##
##  Returns the conjugacy classes of the group of
##  normalized units by random way.
##
InstallMethod(RandomConjugacyClasses, "Group Algebra, Number of random normalized units", true, [IsGroupRing, IsPosInt],2,
function(kg,n)
    local u,x,H,C,i,y,counter,order,center,exist,p;

if not(RAMEGA_IsModularGroupAlgebra(kg)) then
      Error("Input should be a Modular Group Algebra.");
fi;

p:=Factors(Number(BasicGroup(kg)))[1];
H:=[];
order:=Number(UnderlyingField(kg))^(Number(BasicGroup(kg))-1);
    center:=Center(kg);
center:=Filtered(center,x->Augmentation(x)=One(UnderlyingField(kg)));
for u in center do
     C:=[u];
     Add(H,C);
od;
counter:=Number(center);
while not(counter = order) do
  exist:=true;
  while exist do
          u:=GetRandomNormalizedUnit(kg);
     if (u in center) then
      exist:=true;
   else exist:=false;
     fi;
  od;
       C:=[u];
  exist:=true;
  while exist do
    for i in [1..n] do
       y:=GetRandomNormalizedUnit(kg);
       Add(C,y^-1*u*y);
    od;
    x:=AsSet(Factors(Number(AsSet(C))));
    if Number(x)=1 and x[1]=p then
            exist:=false;
   else exist:=true;
    fi;
  od;
  Add(H,AsSet(C));
  center:=Union(center,C);
  counter:=counter+Number(AsSet(C));
od;
    return H;
end);

##############################################################################
##
##  RandomIsCentralElement( < kg, u, n > )
##
##  Returns true if u is a central element by random way.
##
##
InstallMethod(RandomIsCentralElement, "Group Algebra, Element of Group Ring, Number of iterations", true, [IsGroupRing, IsElementOfFreeMagmaRing, IsPosInt],3,
function(kg,u,n)
    local i,x;
for i in [1..n] do
  x:=Random(kg);
  if not(x*u=u*x) then
     return false;
  fi;
od;
    return true;
end);

##############################################################################
##
##  RandomIsNormal( < kg, N, n > )
##
##  Returns true if N is normal in the normalized group of units by random way.
##
##
InstallMethod(RandomIsNormal, "Group Algebra, Normalized group of units, Number of iterations", true, [IsGroupRing, IsGroup, IsPosInt],3,
function(kg,N,n)
    local x,i,u;
for i in [1..n] do
  x:=GetRandomNormalizedUnit(kg);
  u:=Random(AsSet(N));
  if not(x^-1*u*x in N) then
     return false;
  fi;
od;
    return true;
end);

##############################################################################
##
##  RandomCommutatorSubgroup( < kg, n > )
##
##  Returns the commutator subgroup of the normalized unit group
##  using random method.
##
#InstallMethod(RandomCommutatorSubgroup, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
#function(kg,n)
#    local i,x1,x2,A;
#	A:=[];
#	for i in [1..n] do
#      x1:=GetRandomNormalizedUnit(kg);
#	  x2:=GetRandomNormalizedUnit(kg);
#	  AddSet(A,Comm(x1,x2));
#	od;
#	return Group(A);
#end);

##############################################################################
##
##  RandomCenterOfCommutatorSubgroup( < kg, n > )
##
##  Returns the center of the commutator subgroup of the normalized
##  unit group using random method.
##
InstallMethod(RandomCenterOfCommutatorSubgroup, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
function(kg,n)
    local i,x1,x2,A,B,x,h,m,gen,GEN;
	A:=[];
	for i in [1..n] do
      x1:=GetRandomNormalizedUnit(kg);
	  x2:=GetRandomNormalizedUnit(kg);
	  AddSet(A,Comm(x1,x2));
	od;
	gen:=GeneratorsOfGroup(UnderlyingGroup(kg));
	GEN:=List(gen,x->x^Embedding( UnderlyingGroup(kg), kg));
    B:=[];
    for x in A do
	  m:=Filtered(GEN,y->y*x=x*y);
	  if (m=GEN) then
		AddSet(B,x);
	  fi;
	od;
	return Group(B);
end);

##############################################################################
##
##  RandomLowerCentralSeries( < kg, n > )
##
##  Returns the lower central series of the normalized group of units
##  using random method.
##
#InstallMethod(RandomLowerCentralSeries, "Group Algebra, Number of iterations", true, [IsGroupRing, IsPosInt],2,
#function(kg,n)
#    local i,x1,x2,A,G,Gn,B;
#	A:=[];
#	G:=NormalizedUnitGroup(kg);
#	Add(A,G);
#	Gn:=G;
#	while (Number(Gn)>1) do
#	  B:=[];
#	  for i in [1..n] do
#        x1:=Random(G);
#	    x2:=Random(Gn);
#	    AddSet(B,Comm(x1,x2));
#	  od;
#	  Gn:=Group(B);
#	  Add(A,Gn);
#	od;
#	return A;
#end);

##############################################################################
##
##  RandomConjugacyClassByElement( < kg, u, n > )
##
##  Returns the random conjugacy class of the normalized unit u.
##  n is the number of trials.
##
InstallMethod(RandomConjugacyClassByElement, "Group Algebra, Element, Number of iterations", true, [IsGroupRing, IsElementOfFreeMagmaRing, IsPosInt],3,
function(kg,u,n)
    local x,H,i,y;
H:=[];
for i in [1..n] do
  y:=GetRandomNormalizedUnit(kg);
  Add(H,y^-1*u*y);
od;
    return AsSet(H);
end);



#E
##
