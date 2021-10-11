unit Conq02;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Jpeg, StdCtrls, ExtCtrls, Buttons;

type
  Tgri = array[0..41,0..31] of integer;

  TFOpt = class(TForm)
    Label1: TLabel;
    EdNbc: TEdit;
    Imacol: TImage;
    ImaMod: TImage;
    Label2: TLabel;
    SB_gr01: TSpeedButton;
    SB_gr02: TSpeedButton;
    SB_gr03: TSpeedButton;
    Bt_OK: TButton;
    procedure InitColor;
    procedure ImaModMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImacolMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EdNbcChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SB_gr01Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

const
  jcolor : array[1..2] of TColor =($00FFE6BC,clNavy);

var
  FOpt: TFOpt;
  couleur : array[0..9] of TColor;  // table des couleurs
  nbcol : byte = 6;                 // nbre de couleurs
  nogr : byte = 1;                  // numéro de grille
  bgri : TBitmap;                   // image de la grille
  cl1,lg1,cl2,lg2 : integer;        // positions initiales
  cd,cc,co,cs : integer;
  gr1,gr2 : Tgri;
  jr,ct : integer;
  tbc : array[0..9] of integer;
  fin : boolean;
  eca,lgs : integer;
  ncol : TColor;
  chemin : string;

  procedure Trace(n1,n2 : integer);

implementation

{$R *.dfm}

procedure Trace(n1,n2 : integer);
begin
  ShowMessage(Format('%d - %d',[n1,n2]));
end;

procedure TFOpt.FormCreate(Sender: TObject);
begin
  InitColor;
  bgri := TBitmap.Create;
  bgri.LoadFromFile(chemin+'gr01.bmp');
end;

procedure TFOpt.FormActivate(Sender: TObject);
begin
  InitColor;
end;

procedure TFOpt.InitColor;        // Création table des couleurs
var i : integer;
    c : TColor;
begin
  for i := 0 to 9 do
  begin
    c := ImaMod.Canvas.Pixels[i*20+10,10];
    couleur[i] := c;
    ImaCol.Canvas.Brush.Color := c;
    ImaCol.Canvas.FloodFill(i*20+10,10,clBlack,fsBorder);
  end;
end;

procedure TFOpt.ImaModMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ncol := ImaMod.Canvas.Pixels[X,Y];
end;

procedure TFOpt.ImaColMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var  cl : integer;
begin
  cl := X div 20;
  couleur[cl] := ncol;
  ImaCol.Canvas.Brush.Color := ncol;
  ImaCol.Canvas.FloodFill(cl*20+10,10,clBlack,fsBorder);
end;

procedure TFOpt.EdNbcChange(Sender: TObject);
begin
  nbcol := StrToInt(EdNbc.Text);
  ImaCol.Width := nbcol * 20 + 1;
end;

procedure TFOpt.SB_gr01Click(Sender: TObject);
begin
  nogr := (Sender as TSpeedButton).Tag;
  bgri.LoadFromFile(chemin+'gr0'+IntToStr(nogr)+'.bmp');
end;

end.
