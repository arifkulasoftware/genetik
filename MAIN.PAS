unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons,Genel,Bilgi;

type
  TFMain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Bevel1: TBevel;
    Image1: TImage;
    BitBtn1: TBitBtn;
    PaintBox1: TPaintBox;
    BitBtn2: TBitBtn;
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
   Procedure DrawLine(SX,SY,Ex,EY:Integer) ;
   Procedure PutPointer(X,Y,C:Integer);
   Procedure DrawGraph(St:ChromType);
  end;

var
  FMain: TFMain;

Function EvalChrom(St:ChromType):Extended ;  

implementation

{$R *.DFM}

{*}
Function CityDist(F,S:Byte):Extended ;

 Begin
  CityDist:=Sqrt(Sqr(CityPos[F].X-CityPos[S].X)+Sqr(CityPos[F].Y-CityPos[S].Y));
 End;

Function EvalChrom(St:ChromType):Extended ;

 Var
  Top : Extended ;
  I   : Integer  ;

 Begin
  Top:=0;
  For I:=1 To CityCount Do
   Top:=Top+CityDist(Byte(St[I])-64,Byte(St[I+1])-64);
  EvalChrom:=Top;
 End;

Function RandomChrom:ChromType ;

 Var
  DummyCity : Array[1..MaxCities] Of Byte ;
  St        : ChromType ;
  I,R,N     : Byte      ;

 Begin
  St:='';For I:=1 To CityCount+1 Do St:=St+'0';
  St[1]:=Char(StartCity+64);
  St[CityCount+1]:=Char(StartCity+64);
  N:=0;
  For I:=1 To CityCount Do
   Begin
    If I<>StartCity Then
     Begin
      Inc(N);
      DummyCity[N]:=I;
     End;
   End;
  I:=2;
  While N>0 Do
   Begin
    R:=Random(N)+1;
    St[I]:=Char(DummyCity[R]+64);
    Inc(I);
    DummyCity[R]:=DummyCity[N];
    Dec(N);
   End;
  RandomChrom:=St;
 End;

Procedure InitPop ;

 Var I : Integer ;

 Begin
  For I:=1 To PopCnt Do PopArray[I]:=RandomChrom;
  SortPop;
  ShowBilgi;
 End;

 Type
  PercentsType = Array[1..MaxPop] Of Real ;

 Var
  Percents : PercentsType ;

Function SelectChrom:ChromType ;

 Var
  Top : Extended ;
  I,R : Integer  ;
  F   : Extended ;

 Begin
  Top:=0;
  For I:=1 To PopCnt Do Top:=Top+EvalArray[I] ;
  For I:=1 To PopCnt Do Percents[I]:=EvalArray[I]/Top*100 ;
  F:=Percents[1];
  Percents[1]:=Percents[PopCnt];
  For I:=2 To PopCnt-1 Do Percents[I]:=Percents[1]*(F/Percents[I]);
  R:=Random(100)+1;
  Top:=Percents[1];I:=1;
  While (Top<R) And (I<PopCnt) Do
   Begin
    Inc(I);
    Top:=Top+Percents[I];
   End;
  SelectChrom:=PopArray[I];
 End;

Function CrossOver(Par1,Par2:ChromType):ChromType ;

 Var
  Chl : ChromType ;
  St  : String    ;
  I,J : Integer   ;
  P   : Integer   ;

 Begin
  St:='';
  Chl:=Par1;
  For I:=2 To CityCount Do
   If Random(2)=0 Then
    Begin
     Chl[I]:='0';
     St:=St+Par1[I];
    End;
   While St<>'' Do
    Begin
     P:=CityCount;J:=1;
     For I:=1 To LenGth(St) Do
      If Pos(St[I],Par2)<P Then
       Begin
        P:=Pos(St[I],Par2);
        J:=I;
       End;
     Chl[Pos('0',Chl)]:=St[J];
     Delete(St,J,1);
    End;
   CrossOver:=Chl;
 End;

Procedure Mutation(Var Chl:ChromType);

 Var
  Ch : Char    ;
  I  : Integer ;
  R1 : Integer ;
  R2 : Integer ;

 Begin
  For I:=1 To CityCount Div 3 Do
   Begin
    R1:=Random(CityCount-1)+2;
    R2:=Random(CityCount-1)+2;
    Ch:=Chl[R1] ;
    Chl[R1]:=Chl[R2];
    Chl[R2]:=Ch;
   End;
 End;

Function Mute:ChromType ;

 Var
  Par1,Par2 : ChromType ;
  Chl       : ChromType ;

 Begin
  Par1:=SelectChrom;
  Par2:=SelectChrom;
  If Random(100)<CrosPer Then
   Chl:=CrossOver(Par1,Par2) Else Chl:=Par1 ;
  If Random(100)<MutPer Then Mutation(Chl);
  Mute:=Chl;
 End;

Procedure NewPop ;

 Var
  I : Integer ;

 Begin
  For I:=BestCnt+1 To PopCnt Do PopArray[I]:=Mute;
  SortPop ;
 End;

{*}
Procedure TFMain.DrawGraph(St:ChromType);

 Var I : Integer ;

 Begin
  PaintBox1.RePaint;
  With PaintBox1.Canvas Do
   Begin
    MoveTo(CityPos[Byte(St[1])-64].X,CityPos[Byte(St[1])-64].Y);
    For I:=2 To CityCount+1 Do
     LineTo(CityPos[Byte(St[I])-64].X,CityPos[Byte(St[I])-64].Y);
   End;

 End;

Procedure TFMain.DrawLine(SX,SY,Ex,EY:Integer) ;

 Begin
  With PaintBox1.Canvas Do
   Begin
    MoveTo(Sx,Sy);
    LineTo(Ex,Ey);
   End;
 End;

Procedure TFMain.PutPointer(X,Y,C:Integer);

 Begin
  If C=StartCity Then PaintBox1.Canvas.Pen.Color:=clRed
                 Else PaintBox1.Canvas.Pen.Color:=clBlack;
  PaintBox1.Canvas.Ellipse(X-4,Y-4,X+4,Y+4);
  PaintBox1.Canvas.TextOut(X+3,Y+3,Char(64+C));
 End;

procedure TFMain.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 Var
  I : Byte ;
begin
 If Started Then Exit;
 Case Button Of
  mbLeft : Begin
   If CityCount=MaxCities Then
    Begin
     ShowMessage('Maksimum 25 Þehir Girilebilir.');
     Exit;
    End;
   Inc(CityCount);
   CityPos[CityCount].X:=X;
   CityPos[CityCount].Y:=Y;
   PutPointer(X,Y,CityCount);
  End;
  mbRight: Begin
   For I:=1 To CityCount Do
     If (X>CityPos[I].X-4) And (X<CityPos[I].X+4) And
        (Y>CityPos[I].Y-4) And (Y<CityPos[I].Y+4) Then
         Begin
          StartCity:=I;
          PaintBox1.RePaint;
          Break;
         End;
  End;
  End;
end;

procedure TFMain.PaintBox1Paint(Sender: TObject);

Var
 I : Byte ;

begin
 For I:=1 To CityCount Do PutPointer(CityPos[I].X,CityPos[I].Y,I);
end;

procedure TFMain.BitBtn1Click(Sender: TObject);

Var
 St:String ;

begin
 PopCnt :=StrToInt(Edit1.Text);
 MutPer :=StrToInt(Edit2.Text);
 CrosPer:=StrToInt(Edit3.Text);
 BestCnt:=StrToInt(Edit4.Text);
 MaxStep:=Fact(CityCount-1);

 If Not Started Then
  Begin
   If (PopCnt*(MutPer+CrosPer)=0) Or (CityCount<4) Then
    Begin
     ShowMessage('Deðerleri Kontrol Ediniz...!');
     Exit;
    End;
    Started:=True;
    BitBtn1.Caption:='Devam' ;
    Edit1.Enabled:=False;
    FBilgi.Show;
    InitPop ;
    Exit;
  End;
 Inc(StepCount);
 NewPop;
 ShowBilgi;
End;

procedure TFMain.BitBtn2Click(Sender: TObject);
Var
 St:String ;

begin
 PopCnt :=StrToInt(Edit1.Text);
 MutPer :=StrToInt(Edit2.Text);
 CrosPer:=StrToInt(Edit3.Text);
 BestCnt:=StrToInt(Edit4.Text);
 MaxStep:=Fact(CityCount-1);

 If Not Started then
  Begin
   If (PopCnt*(MutPer+CrosPer)=0) Or (CityCount<4) Then
    Begin
     ShowMessage('Deðerleri Kontrol Ediniz...!');
     Exit;
    End;
    Started:=True;
    BitBtn1.Caption:='Devam' ;
    Edit1.Enabled:=False;
    FBilgi.Show;
    InitPop ;
  End;
  If Not StartedOto Then
   Begin
    StartedOto:=True;
    BitBtn2.Caption:='Durdur' ;    
    Repeat
     Inc(StepCount);
     NewPop;
     ShowBilgi;
     Application.ProcessMessages;
    Until Not StartedOto;
   End;
  StartedOto:=False;
  BitBtn2.Caption:='Devam' ;
End;

end.
