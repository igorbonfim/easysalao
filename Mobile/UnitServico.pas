unit UnitServico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmServi�o = class(TForm)
    Rectangle1: TRectangle;
    Label3: TLabel;
    Image1: TImage;
    lvServicos: TListView;
    imgIconeValor: TImage;
    imgIconeReservar: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmServi�o: TFrmServi�o;

implementation

{$R *.fmx}

end.
