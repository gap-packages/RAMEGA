#############################################################################
##
#W  threl_def.gi                         Victor Bovdi <vbovdi@gmail.com>
#W                                       Vasyl Laver  <vasyllaver@uzhnu.edu.ua>
##
##
#H  @(#)$Id: threl_def.gi,v 1.02 $
##
#Y  Copyright (C)  2018,  UAE University, UAE
##
#############################################################################
##
##  This file contains some generic methods for threshold elements.
##
#############################################################################
##
##
## Example
## gap> t:=ThresholdElement([1,2],3);
## < threshold element with weight vector [ 1, 2 ] and threshold 3 >
## gap> Display(t);
## Weight vector = [ 1, 2 ], Threshold = 3.
## Threshold Element realizes the function f =
## [ 0, 0 ] || 0
## [ 0, 1 ] || 0
## [ 1, 0 ] || 0
## [ 1, 1 ] || 1
##
#############################################################################
##
#R
###########################################################################
DeclareRepresentation("IsThresholdElementRep", IsComponentObjectRep, ["weights","threshold"]);

######################################################################
##
#F  ThresholdElement(Weights, Threshold)
##
##  Produces a threshold element
##  Weights are given as a list, the threshold is represented
##  by a single number.
##
InstallGlobalFunction( ThresholdElement, function(Weights, Threshold)

    local t,Func,A, alph, tel, F, i, j, x, y, TE, l;

	if not IsVector(Weights) then
        Error("Weights have to be presented as a vector");
	fi;

	if not IsRat(Threshold) then
        Error("Please present Threshold as a rational number");
	fi;

    # Construct the family of all threshold elements.
    F:= NewFamily( "Threshold Elements" , IsThresholdElementObj );

    tel := rec(weights := Weights,
               threshold := Threshold,
               );

    TE := Objectify( NewType( F, IsThresholdElementObj and IsThresholdElementRep and IsAttributeStoringRep ),
                 tel );

    # Return the threshold element.
    return TE;
end);

######################################################################
##
#F  OutputOfThresholdElement(TE)
##
InstallGlobalFunction( OutputOfThresholdElement, function(TE)
  local Func,t,i;
	if not IsThresholdElementObj(TE) then
        Error("The argument to OutputOfThresholdElement must be a threshold element");
    fi;

    if TE!.weights = [] then
        Error("There must be an assigned weights vector to a threshold element");
    fi;

    Func:=[];
  	t:=IteratorOfTuples([0,1], Size(TE!.weights));
  	for i in t do
  		if i*TE!.weights<TE!.threshold then Add(Func,0);
  		else
  			Add(Func,1);
  		fi;
  	od;

    return(LogicFunction(Size(TE!.weights),2,Func));
end);

######################################################################
##
#F  StructureOfThresholdElement(TE)
##
InstallGlobalFunction( StructureOfThresholdElement, function(TE)
	if not IsThresholdElementObj(TE) then
        Error("The argument of StructureOfThresholdElement must be a threshold element");
    fi;
    if TE!.weights = [] then
        Error("There must be an assigned weights vector to a threshold element");
    fi;
    return([TE!.weights,TE!.threshold]);
end);


#############################################################################
##
#M  ViewObj( <A> ) . . . . . . . . . . . print threshold element
##
InstallMethod( ViewObj,
        "displays a threshold element",
        true,
        [IsThresholdElementObj and IsThresholdElementRep], 0,
        function( A )
		Print("< threshold element with weight vector ", A!.weights, " and threshold ", A!.threshold, " >");
end);


#############################################################################
##
#M  PrintObj( <A> ) . . . . . . . . . . . print threshold element
##
InstallMethod( PrintObj,
        "displays a threshold element",
        true,
        [IsThresholdElementObj and IsThresholdElementRep], 0,
        function( A )
    Print("[",A!.weights,", ",A!.threshold,"]");
end);

#############################################################################
##
#M  Display( <A> ) . . . . . . . . . . . print threshold element
##
InstallMethod( Display,
       "displays a threshold element",
        true,
        [IsThresholdElementObj and IsThresholdElementRep], 0,
        function( A )
		local i,t,ff,k;

		if A!.weights<>[] then

			Print("Weight vector = ",A!.weights,", Threshold = ",A!.threshold,".\n");
			Print("Threshold Element realizes the function f : \n");

			ff:=OutputOfThresholdElement(A);

			k:=1;
			if Size(A!.weights)<=4 then
        Display(ff);
			fi;

			Print(THELMA_INTERNAL_VectorToFormula(THELMA_INTERNAL_BFtoGF(ff)),"\n");
    fi;
end);

#############################################################################
##
#F  IsThresholdElement(A)
##
##  Tests if A is a threshold element
##
InstallGlobalFunction( IsThresholdElement, function(A)
    return(IsThresholdElementObj(A));
end);

#############################################################################
##
#F  RandomThresholdELement(N)
##
##  Given the number of the input variables, this function returns a pseudo
##  random threshold element.
##
##
InstallGlobalFunction(RandomThresholdElement, function(N, lo, hi)
    local i,w,t;

    if not IsPosInt(N) then
        Error("The number of variables must be a positive integer");
    fi;

    if lo>hi then
      Error("The lower bound has to be less or equal than the upper bound!");
    fi;

	w:=List([1..N],i->Random([lo..hi]));
	t:=Random([lo..hi]);
    return ThresholdElement(w,t);
end);


############################################################################
##
#M Methods for the comparison operations for threshold elements.
##
InstallMethod( \=,
        "for two threshold elements",
        [ IsThresholdElementObj and IsThresholdElementRep,
          IsThresholdElementObj and IsThresholdElementRep,  ],
        0,
        function( x, y )
    return(OutputOfThresholdElement(x) = OutputOfThresholdElement(y));

end );


InstallMethod( \<,
        "for two threshold elements",
        [ IsThresholdElementObj and IsThresholdElementRep,
          IsThresholdElementObj and IsThresholdElementRep,  ],
        0,
        function( x, y )
    return(OutputOfThresholdElement(x) < OutputOfThresholdElement(y));
end );



#E
##
