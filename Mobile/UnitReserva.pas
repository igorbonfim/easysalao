unit UnitReserva;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Calendar, FMX.Layouts,
  FMX.ListBox;

type
  TFrmReserva = class(TForm)
    Rectangle1: TRectangle;
    Label3: TLabel;
    Image1: TImage;
    Label1: TLabel;
    Calendar1: TCalendar;
    Label2: TLabel;
    ListBox1: TListBox;
    rectConfirmar: TRectangle;
    btnAcessar: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmReserva: TFrmReserva;

implementation

{$R *.fmx}

end.
