unit Conq04;     // Routines fin de jeu

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, jpeg;

type
  TDlgFin = class(TForm)
    OKBtn: TButton;
    Perdu: TImage;
    Gagne: TImage;
    PnFin: TPanel;

    procedure Affiche;
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgFin: TDlgFin;
  motif : byte;

implementation

{$R *.DFM}

procedure TDlgFin.Affiche;
begin
  case motif of
    1 : begin
          DlgFin.Color := clYellow;
          DlgFin.PnFin.Caption := 'VICTOIRE';
          DlgFin.Gagne.Visible := true;
        end;
    2 : begin
         DlgFin.Color := clRed;
         DlgFin.PnFin.Caption := 'On se rend...';
         DlgFin.Gagne.Visible := false;
       end;
  end;
end;

procedure TDlgFin.FormActivate(Sender: TObject);
begin
  Affiche;
end;

end.
