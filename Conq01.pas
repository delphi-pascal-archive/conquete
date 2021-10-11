unit Conq01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Jpeg, Conq02, Conq03, Conq04;

type
  TFMain = class(TForm)
    Tablo: TImage;
    Bt_Nouveau: TButton;
    Color0: TShape;
    Color1: TShape;
    Color2: TShape;
    Color3: TShape;
    Color4: TShape;
    Color5: TShape;
    Pctjo: TPanel;
    Pctor: TPanel;
    Shjo: TShape;
    Shor: TShape;
    Color6: TShape;
    Color7: TShape;
    Color8: TShape;
    Color9: TShape;
    Bt_Options: TButton;
    Bt_Aide: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DispoCouleurs;
    procedure AfficheTablo;
    procedure Bt_NouveauClick(Sender: TObject);
    procedure Color0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JeuOrdi;
    procedure Examine;
    procedure Marque;
    procedure ChangeCouleur(cl,lg : integer);
    procedure Compte(cn : byte; cl,lg : integer);
    function FShape(x : integer) : TShape;
    procedure TabloMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TraceBases;
    procedure FinJeu(jr : byte);
    procedure Bt_OptionsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bt_AideClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

procedure TFMain.FormCreate(Sender: TObject);
var i : byte;
begin
  Randomize;
  cl1 := 1;
  lg1 := 1;
  cl2 := 40;
  lg2 := 30;
  for i := 0 to 41 do
  begin
    gr1[i,0] := -1;
    gr1[i,31] := -1;
  end;
  for i := 0 to 31 do
  begin
    gr1[0,i] := -1;
    gr1[41,i] := -1;
  end;
  fin := true;
  chemin := ExtractFilePath(Application.ExeName)+'Images\';
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  bgri.Free;
end;

procedure TFMain.DispoCouleurs;
var  i : byte;
begin
  for i := 0 to 9 do
  begin
    eca := 270 div nbcol;
    lgs := eca-5;
    with FShape(i) do
    begin
      Width := lgs;
      Left := 120 + eca * i;
      Brush.Color := Couleur[i];
      if i > nbcol - 1 then Visible := false
      else Visible := true;
    end;
  end;
end;

procedure TFMain.AfficheTablo;
var  cl,lg : integer;
begin
  for lg := 1 to 30 do
    for cl := 1 to 40 do
    begin
      Tablo.Canvas.Brush.Color := couleur[gr1[cl,lg]];
      Tablo.Canvas.FloodFill(cl*20-10,lg*20-10,clBlack,fsBorder);
    end;
  TraceBases;
  DispoCouleurs;
  Shjo.Brush.Color := couleur[gr1[cl1,lg1]];
  Shor.Brush.Color := couleur[gr1[cl2,lg2]];
end;

procedure TFMain.TabloMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var  df : integer;
begin
  if not fin then exit;
  gr1[cl1,lg1] := Random(nbcol);
  while gr1[cl2,lg2] = gr1[cl1,lg1] do gr1[cl2,lg2] := Random(nbcol);
  cl1 := X div 20 + 1;
  lg1 := Y div 20 + 1;
  df := 40 - cl1;
  cl2 := 1 + df;
  df := 30 - lg1;
  lg2 := 1 + df;
  TraceBases;
end;

procedure TFMain.Bt_NouveauClick(Sender: TObject);
var  cl,lg : integer;
begin
  Tablo.Canvas.Draw(0,0,bgri);
  for lg := 1 to 30 do
    for cl := 1 to 40 do
      gr1[cl,lg] := Random(nbcol);
  while gr1[cl2,lg2] = gr1[cl1,lg1] do
    gr1[cl2,lg2] := Random(nbcol);
  AfficheTablo;
  Pctjo.Caption := '0';
  Pctor.Caption := '0';
  jr := Random(2)+1;
  fin := false;
  if jr = 1 then
  begin
    cs := gr1[cl2,lg2];
    FShape(cs).Visible := false;
  end
  else JeuOrdi;
end;

procedure TFMain.Color0MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  cc := (Sender as TShape).Tag;
  co := gr1[cl1,lg1];
  if cc = co then exit;
  ChangeCouleur(cl1,lg1);
  Shjo.Brush.Color := couleur[gr1[cl1,lg1]];
  gr2 := gr1;
  ct := 1;
  Compte(cc,cl1,lg1);
  Marque;
  FShape(cs).Visible := true;
  if ct >= 600 then FinJeu(1)
  else
    begin
      jr := 2;
      JeuOrdi;
    end;
end;

//------------------------------------------------------------------------------

procedure TFMain.JeuOrdi;
var i,n : integer;
begin
  Examine;
  n := -1;
  for i := 0 to nbcol - 1 do
    if tbc[i] > n then
    begin
      n := tbc[i];
      cc := i;
    end;
  if cc = gr1[cl1,lg1] then inc(cc);
  if cc = gr1[cl2,lg2] then inc(cc);
  if cc >= nbcol then cc := 0;
  ChangeCouleur(cl2,lg2);
  Shor.Brush.Color := couleur[gr1[cl2,lg2]];
  gr2 := gr1;
  ct := 1;
  Compte(cc,cl2,lg2);
  Marque;
  cs := gr1[cl2,lg2];
  if ct >= 600 then Finjeu(2)
  else
    begin
      FShape(cs).Visible := false;
      jr := 1;
    end;
end;

procedure TFMain.Examine;   // Recherche de la couleur à jouer
var  i,cl,lg : integer;
begin
  co := gr1[cl2,lg2];       // couleur ordi
  cd := gr1[cl1,lg1];       // couleur joueur
  for i := 0 to nbcol-1 do tbc[i] := -1;
  lg := lg2;
  repeat
    cl := cl2;
    if gr1[cl,lg] = co then
    begin
      repeat
        if gr1[cl,lg] <> co then
        begin
          cc := gr1[cl,lg];
          if cc <> cd then inc(tbc[cc]);
          cl := 0;
        end;
        dec(cl);
      until cl < 1;
    end
    else
      begin
        cc := gr1[cl,lg];
        if cc <> cd then inc(tbc[cc]);
        lg := 0;
      end;
    dec(lg);
  until lg < 1;
end;

//----------------------------------------- Communs ----------------------------

procedure TFMain.Marque;      // Affiche les points
begin
  if jr = 1 then
  begin
    Pctjo.Caption := IntToStr(ct);
    Pctjo.Repaint;
  end
  else
    begin
      Pctor.Caption := IntToStr(ct);
      Pctor.Repaint;
    end;
end;

procedure TFMain.ChangeCouleur(cl,lg : integer);
var  x,y : integer;
begin
  if (cl = 0) or (cl = 41) then exit;
  if (lg = 0) or (lg = 31) then exit;
  x := cl;
  y := lg;
  if gr1[x,y] = co then
  begin
    gr1[x,y] := cc;
  end;
  if gr1[x-1,y] = co then
  begin
    gr1[x-1,y] := cc;
    ChangeCouleur(x-1,y);
  end;
  if gr1[x+1,y] = co then
  begin
    gr1[x+1,y] := cc;
    ChangeCouleur(x+1,y);
  end ;
  if gr1[x,y-1] = co then
  begin
    gr1[x,y-1] := cc;
    ChangeCouleur(x,y-1);
  end;
  if gr1[x,y+1] = co then
  begin
    gr1[x,y+1] := cc;
    ChangeCouleur(x,y+1);
  end;
end;

procedure TFMain.Compte(cn : byte; cl,lg : integer);
var  x,y : integer;
begin
  if (cl = 0) or (cl = 41) then exit;
  if (lg = 0) or (lg = 31) then exit;
  x := cl;
  y := lg;
  if gr2[x,y] = cn then
  begin
    gr2[x,y] := 20;
    Tablo.Canvas.Brush.Color := jcolor[jr];
    Tablo.Canvas.FloodFill(x*20-10,y*20-10,clBlack,fsBorder);
    if gr2[x-1,y] = cn then
    begin
      inc(ct);
      gr2[x,y] := 20;
      Tablo.Canvas.Brush.Color := jcolor[jr];
      Tablo.Canvas.FloodFill((x-1)*20-10,y*20-10,clBlack,fsBorder);
      Compte(cn,x-1,y);
    end;
    if gr2[x+1,y] = cn then
    begin
      inc(ct);
      gr2[x,y] := 20;
      Tablo.Canvas.Brush.Color := jcolor[jr];
      Tablo.Canvas.FloodFill((x+1)*20-10,y*20-10,clBlack,fsBorder);
      Compte(cn,x+1,y);
    end ;
    if gr2[x,y-1] = cn then
    begin
      inc(ct);
      gr2[x,y] := 20;
      Tablo.Canvas.Brush.Color := jcolor[jr];
      Tablo.Canvas.FloodFill(x*20-10,(y-1)*20-10,clBlack,fsBorder);
      Compte(cn,x,y-1);
    end;
    if gr2[x,y+1] = cn then
    begin
      inc(ct);
      gr2[x,y] := 20;
      Tablo.Canvas.Brush.Color := jcolor[jr];
      Tablo.Canvas.FloodFill(x*20-10,(y+1)*20-10,clBlack,fsBorder);
      Compte(cn,x,y+1);
    end;
  end;
end;

//-------------------------------------------------- Divers --------------------
function TFMain.FShape(x : integer) : TShape;
begin
  Result := Color0;
  try
   Result := FMain.FindComponent('Color'+inttostr(x)) as TShape;
  except
    showmessage(inttostr(x)+' non trouvé');
  end;
end;

procedure TFMain.TraceBases;
var  x,y : integer;
begin
  x := (cl1-1)*20;
  y := (lg1-1)*20;
  Tablo.Canvas.Brush.Color := jcolor[1];
  Tablo.Canvas.Pen.Color := jcolor[1];
  Tablo.Canvas.Ellipse(x+5,y+5,x+15,y+15);
  x := (cl2-1)*20;
  y := (lg2-1)*20;
  Tablo.Canvas.Brush.Color := jcolor[2];
  Tablo.Canvas.Pen.Color := jcolor[2];
  Tablo.Canvas.Ellipse(x+5,y+5,x+15,y+15);
end;

procedure TFMain.FinJeu(jr : byte);
begin
  fin := true;
  motif := jr;
  DlgFin.ShowModal;
end;

procedure TFMain.Bt_OptionsClick(Sender: TObject);
begin
  FOpt.ShowModal;
  Tablo.Canvas.Draw(0,0,bgri);
  DispoCouleurs;
end;

procedure TFMain.Bt_AideClick(Sender: TObject);
begin
  FAide.ShowModal;
end;

end.
