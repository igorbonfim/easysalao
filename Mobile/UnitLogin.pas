unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TabControl;

type
  TFrmLogin = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    rectAcessar: TRectangle;
    btnAcessar: TSpeedButton;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Layout2: TLayout;
    Image2: TImage;
    Edit3: TEdit;
    Edit4: TEdit;
    Rectangle3: TRectangle;
    SpeedButton1: TSpeedButton;
    Edit5: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

end.
