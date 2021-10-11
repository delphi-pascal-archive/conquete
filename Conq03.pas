unit Conq03;     // Mode d'emploi

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg;

type
  TFAide = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Memo1: TMemo;
    Image2: TImage;
    Label1: TLabel;
    Image3: TImage;
    Label2: TLabel;
    Image4: TImage;
    Memo2: TMemo;
    Label3: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FAide: TFAide;

implementation

{$R *.dfm}

end.
