program Conquete;

uses
  Forms,
  Conq01 in 'Conq01.pas' {FMain},
  Conq02 in 'Conq02.pas' {FOpt},
  Conq03 in 'Conq03.pas' {FAide},
  Conq04 in 'Conq04.pas' {DlgFin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFOpt, FOpt);
  Application.CreateForm(TFAide, FAide);
  Application.CreateForm(TDlgFin, DlgFin);
  Application.Run;
end.
