program genetic;

uses
  Forms,
  main in 'main.pas' {FMain},
  genel in 'genel.pas',
  bilgi in 'bilgi.pas' {FBilgi};

{$R *.RES}

begin
  Randomize;
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFBilgi, FBilgi);
  Application.Run;
end.
