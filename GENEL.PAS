unit genel;

interface

 Uses Windows ;

 Const
  CityCount : Byte = 0 ;
  StartCity : Byte = 1 ;
  MaxCities = 25       ;
  StepCount : Word = 0 ;
  Started   : Boolean = False ;
  StartedOto: Boolean = False ;

  MaxPop = 500 ;

  ShowAllBilgi : Byte = 1 ;

 Type
  ChromType    = String[MaxCities+1] ;
  CityPosType  = Array[1..MaxCities] Of TPoint ;
  PopArrayType = Array[1..MaxPop] Of ChromType ;
  EvalArrayType= Array[1..MaxPop] Of Extended  ;

  Var
   CityPos     : CityPosType   ;
   PopArray    : PopArrayType  ;
   EvalArray   : EvalArrayType ;

   PopCnt  : Word ;
   MutPer  : Byte ;
   CrosPer : Byte ;
   BestCnt : Byte ;

   MaxStep : Extended ;


 Procedure SortPop ;
 Function Fact(N:Integer):LongInt;

implementation

 Uses Main;

 Function Fact(N:Integer):LongInt;

  Var
   K : LongInt ;
   I : Integer ;
   
  Begin
   K:=1;
   For I:=2 To N Do K:=K*I ;
   Fact:=K;
  End;

 Procedure SortPop ;

  Var
   I,J : Integer   ;
   Cr  : ChromType ;
   Ev  : Extended  ;

  Begin
   For I:=1 To PopCnt Do EvalArray[I]:=EvalChrom(PopArray[I]);
   For I:=1 To PopCnt-1 Do
    For J:=I+1 To PopCnt Do
     If EvalArray[I]>EvalArray[J] Then
      Begin
       Ev:=EvalArray[I];
       EvalArray[I]:=EvalArray[J];
       EvalArray[J]:=Ev;
       Cr:=PopArray[I];
       PopArray[I]:=PopArray[J];
       PopArray[J]:=Cr;
      End;
  End ;

end.
