#############################################################################
##
#W  mvthrel.gi                           Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: mvthrel.gi,v 1.02 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file contains some generic methods for multi-valued threshold elements.
##
#############################################################################
##
#############################################################################
##
#R
###########################################################################
DeclareRepresentation("IsMVThresholdElementRep", IsComponentObjectRep, ["weights","threshold"]);

######################################################################
##(st,kq,F)
#F  MVThresholdElement(Structure, Dimension of Variables and Output, GF(p^k))
##
##  Produces a multi-valued logic neuron.
##  Structure is given as a list [Weights, Threshold] with elements from GF(p^k),
##  Dimension of Variables and Output is a list of integers.
##
InstallGlobalFunction( MVThresholdElement, function(st,kq,F)

  local n,U,eps,groups,u,lg,tup,t,out,mvtel,MVT,fam,k,i;

  if not (IsDenseList(st) and IsFFECollection(st[1]) and IsFFE(st[2])) then
    Error("Structure has to be a dense list with a list of FF elements as the first entry and a FF element as the second entry.");
  fi;

  if not (IsPosInt(kq) or IsDenseList(kq)) then
    Error("Dimesions should be presented either by a positive integer or by a list of positive integers.");
  fi;

  if IsPosInt(kq) and kq=1 then
    Error("Dimension cannot be less than 2.");
  fi;

  if IsDenseList(kq) and Size(st[1])<>(Size(kq)-1) then
        Error("Structure vector and the dimension vector should of the same size.\n");
	fi;

  if not (IsField(F) and IsFinite(F)) then
        Error("F should be a finite field.\n");
  fi;

  # Construct the family of all multi-valued threshold elements.
  fam:= NewFamily( "MV Threshold Elements" , IsMVThresholdElementObj );

  n:=Size(st[1]);
  U:=Units(F);

  eps:=PrimitiveElement(F);

  if IsList(kq) then k:=Lcm(kq); else k:=kq; fi;
  if IsInt(kq) then kq:=ListWithIdenticalEntries(Size(st[1])+1,kq); fi;
  u:=Size(F)-1;
  if (u mod k <> 0) then Error("k must divide Size(F)-1!"); fi;
  groups:=[];
  for i in kq do Add(groups,Group(eps^(u/i))); od;
  lg:=List(groups, i->Elements(i));
  tup:=Elements(DirectProductOp(groups{[1..Size(groups)-1]},groups[1]));

  out:=[];
  for t in tup do
    if st[2]+st[1]*List(t)<>Zero(F) then
      Add(out,THELMA_INTERNAL_FSign(F,eps,st,kq[Size(kq)],st[2]+st[1]*List(t)));
    else
      Print("Please change the structure of MVThresholdElement, because FSign function on the current structure is undefined.\n");
      return fail;
    fi;
  od;

  mvtel := rec(struct := st,
               dim := kq,
               func := out,
               field:= F,
               );

  MVT := Objectify( NewType( fam, IsMVThresholdElementObj and IsMVThresholdElementRep and IsAttributeStoringRep ),
                 mvtel );
    # Return the multi-valued threshold element.
  return MVT;
end);


######################################################################
##
#F  OutputOfMVThresholdElement(TE)
##
InstallGlobalFunction( OutputOfMVThresholdElement, function(TE)
local k,kq,u,F,groups,i,eps,lg,tup,t,st,n;
    if not IsMVThresholdElementObj(TE) then
         Error("The argument to OutputOfMVThresholdElement must be a multi-valued threshold element");
    fi;

    st:=TE!.struct;
    kq:=TE!.dim;
    F:=TE!.field;

    n:=Size(st[1]);

    eps:=PrimitiveElement(F);
    if IsInt(kq) then k:=kq; else k:=kq[Size(kq)]; fi;

    u:=Size(F)-1;

    groups:=Group(eps^(u/k));
    lg:=Elements(groups);

    return LogicFunction(n,kq,List(TE!.func,i->Position(lg,i)-1));
end);

######################################################################
##
#F  StructureOfMVThresholdElement(TE)
##
InstallGlobalFunction( StructureOfMVThresholdElement, function(TE)
	if not IsMVThresholdElementObj(TE) then
        Error("The argument to OutputOfMVThresholdElement must be a multi-valued threshold element");
    fi;
    return(TE!.struct);
end);


#############################################################################
##
#M  ViewObj( <A> ) . . . . . . . . . . . print multi-valued threshold element
##
InstallMethod( ViewObj,
        "displays a multi valued threshold element",
        true,
        [IsMVThresholdElementObj and IsMVThresholdElementRep], 0,
        function( A )
		if IsList(A!.dim) then
      Print("< multivalued threshold element over ",A!.field," with structure [",IntVecFFE(A!.struct[1]),", ",IntFFE(A!.struct[2]),"] and dimension vector ",List(A!.dim)," >");
    else
      Print("< multivalued threshold element over ",A!.field," with structure [",IntVecFFE(A!.struct[1]),", ",IntFFE(A!.struct[2]),"] and dimension ",A!.dim," >");
    fi;
end);


#############################################################################
##
#M  PrintObj( <A> ) . . . . . . . . . . . print multi-valued threshold element
##
InstallMethod( PrintObj,
        "displays a multi-valued threshold element",
        true,
        [IsMVThresholdElementObj and IsMVThresholdElementRep], 0,
        function( A )
    Print("[",IntVecFFE(A!.struct[1]),", ",IntFFE(A!.struct[2]),"], ",A!.dim,",  ",A!.field,"]\n");
end);

#############################################################################
##
#M  Display( <A> ) . . . . . . . . . . . print multi-valued threshold element
##
InstallMethod( Display,
       "displays a multi-valued threshold element",
        true,
        [IsMVThresholdElementObj and IsMVThresholdElementRep], 0,
        function( A )
		local i,t,ff,k,eps,groups,lg,tup,u,F,st,kq;

		if A!.struct<>[] then
      F:=A!.field;
      kq:=A!.dim;
      st:=A!.struct;
      Print("Structure vector = [",IntVecFFE(st[1]),", ",IntFFE(st[2]),"] \n");
      if IsPosInt(kq) then Print("Dimension = [",kq,"] \n"); else Print("Dimension vector = [",kq,"] \n"); fi;
      Print("Field: ",F," \n");

			Print("Multi-Valued Threshold Element realizes the function f : \n");

      if IsPosInt(kq) then kq:=ListWithIdenticalEntries(Size(st[1])+1,kq); fi;

        ff:=A!.func;
        u:=Size(A!.field)-1;
        eps:=PrimitiveElement(A!.field);
        groups:=[];
        for i in kq do Add(groups,Group(eps^(u/i))); od;
        lg:=List(groups, i->Elements(i));
        tup:=Elements(DirectProductOp(groups{[1..Size(groups)-1]},groups[1]));

        for t in [1..Size(tup)] do
          Print(IntVecFFE(List(tup[t])),"  ||  ",IntFFE(A!.func[t]),"\n");
        od;
    fi;
end);

#############################################################################
##
#F  IsMVThresholdElement(A)
##
##  Tests if A is a multi-valued threshold element
##
InstallGlobalFunction( IsMVThresholdElement, function(A)
    return(IsMVThresholdElementObj(A));
end);

#############################################################################
##
#F  MVBooleanFunctionBySTE
##
##  Tests if function fin with dimension vector kq can be relized by STE over field F.
##
InstallGlobalFunction( MVBooleanFunctionBySTE, function(ff,F)
    local f, U, eps,k,u,groups,lg,i,tup,it,kk,i1,t,temp,dp,mat,www, t1,fin,kq;

    if (IsLogicFunction(ff)=false) then
  		Error("f has to be a logic function.");
  	fi;

    if (IsPrimeField(F)=false) then
  		Error("F has to be a prime field.");
  	fi;



    fin:=ff!.output;
    kq:=ff!.dimension;

    U:=Units(F);
    eps:=PrimitiveElement(F);

    if IsInt(kq) then k:=kq; else k:=Lcm(kq); fi;

    if IsInt(kq) then kq:=ListWithIdenticalEntries(ff!.numvars+1,kq); fi;

    u:=Size(F)-1;
    if (u mod k <> 0) then Error("k must divide Size(F)-1!"); fi;
    groups:=[];
    for i in kq do Add(groups,Group(eps^(u/i))); od;

    lg:=List(groups, i->Elements(i));
    f:=List(fin,i->(eps^(u/kq[Size(kq)]))^i);

    kk:=ShallowCopy(kq{[1..Size(kq)-1]});

    tup:=[]; it:=true;
    for i in kk do
      if it=true then for i1 in [0..i-1] do Add(tup,[i1]); od; it:=false;
      else
        temp:=[];
        for t in tup do
          for i1 in [0..i-1] do
            t1:=ShallowCopy(t); Add(t1,i1); Add(temp,t1);
          od;
        od;
        tup:=ShallowCopy(temp);
      fi;
    od;

    dp:=DirectProductOp(groups{[1..Size(groups)-1]},groups[1]);

    mat:=THELMA_INTERNAL_CharTable(Elements(dp),tup,F);

#    www:=THELMA_INTERNAL_FindWeights(mat,f,kq[Size(kq)],F);
    www:=THELMA_INTERNAL_FindWeights(mat,f,kq,F);

    if www<>[] then return MVThresholdElement(www,kq,F); else return []; fi;
end);
