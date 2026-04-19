unit bilgi;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Genel, ExtCtrls, Buttons;

type
  TFBilgi = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FBilgi: TFBilgi;

 Procedure ClearBilgi ;
 Procedure AddLine(St:String) ;
 Procedure ShowBilgi ;

implementation

 Uses Main;

{$R *.DFM}

 Procedure ClearBilgi ;

  Begin
   FBilgi.ListBox1.Clear;
  End;

 Procedure AddLine(St:String) ;

  Begin
   FBilgi.ListBox1.Items.Add(St);
  End;

 Procedure ShowBilgi ;

  Var
   I  : Integer ;
   Sz : Integer ;

  Begin
   FBilgi.Label1.Caption:=IntToStr(StepCount)+'/'+IntToStr(Round(MaxStep))+
                          '  (%'+IntToStr(Round(StepCount/MaxStep*100.0))+')';

   Case ShowAllBilgi Of
    0 : Exit          ;
    1 : Sz:=BestCnt+5 ;
    2 : Sz:=PopCnt    ;
    3 : Begin
         FBilgi.ListBox1.ItemIndex:=0;
         FBilgi.ListBox1Click(Nil);
         Exit ;
        End;
   End;
   If Sz>PopCnt Then Sz:=PopCnt;
   ClearBilgi ;
   FBilgi.ListBox1.Items.BeginUpdate;
   For I:=1 To Sz Do
    AddLine(PopArray[I]+'  '+IntToStr(Round(EvalArray[I]))+'km.');
   FBilgi.ListBox1.Items.EndUpDate;
   FBilgi.ListBox1.ItemIndex:=0;
   FBilgi.ListBox1Click(Nil);
  End;

procedure TFBilgi.ListBox1Click(Sender: TObject);
begin
 If ListBox1.ItemIndex<0 Then Exit;
 FMain.DrawGraph(PopArray[ListBox1.ItemIndex+1]);
end;

procedure TFBilgi.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);

Const
 PrevColor : TColor = clBlack ;
 OkeyCount : Word = 0         ;

Var
 St : String ;

begin
 St:=(Control As TListBox).Items[Index];
 With (Control As TListBox).Canvas Do
  Begin
   If Index<BestCnt Then Font.Color:=clGreen
                    Else Font.Color:=clBlack;
   If Index=0 Then Font.Color:=clRed;
   If (Index>0) And (Index<BestCnt) Then
    Begin
     If (EvalArray[Index]=EvalArray[Index+1]) And (PrevColor=clRed) Then
      Begin
       Font.Color:=clRed;
       If Index+1=BestCnt Then
        Begin
         Inc(OkeyCount);
         If OkeyCount=100 Then
          Begin
           ShowMessage('Optimum bir Sonuc Bulundu...!');
           OkeyCount:=0;
          End;
        End;
      End Else OkeyCount:=0;
    End;
   PrevColor:=Font.Color;
   FillRect(Rect);
   TextOut(Rect.Left,Rect.Top,St);
  End;
end;

procedure TFBilgi.SpeedButton1Click(Sender: TObject);
begin
 ShowAllBilgi:=(ShowAllBilgi+1) Mod 4;
 If Not StartedOto Then  ShowBilgi;
end;

end.
