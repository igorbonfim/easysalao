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
    imgVoltar: TImage;
    Label1: TLabel;
    Calendar: TCalendar;
    Label2: TLabel;
    lbHorario: TListBox;
    rectConfirmar: TRectangle;
    btnReservar: TSpeedButton;
    Layout1: TLayout;
    procedure CalendarDateSelected(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbHorarioItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnReservarClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
  private
    FCod_servico: integer;
    procedure ListarHorarios;
    procedure AddHorario(hora: string);
    procedure ResetHorario;
    { Private declarations }
  public
    { Public declarations }
    property Cod_servico: integer read FCod_servico write FCod_servico;
  end;

var
  FrmReserva: TFrmReserva;

implementation

{$R *.fmx}

uses DataModule.Global, Frame.Horario, UnitPrincipal;

procedure TFrmReserva.AddHorario(hora: string);
var
  item: TListBoxItem;
  frame: TFrameHorario;
begin
  item := TListBoxItem.Create(lbHorario);
  item.Text := '';
  item.Selectable := false;
  item.Width := 90;
  item.TagString := hora;

  frame := TFrameHorario.Create(item);
  frame.Parent := item;
  frame.Align := TAlignLayout.Client;
  frame.lblHora.Text := hora;

  lbHorario.AddObject(item);
end;

procedure TFrmReserva.ListarHorarios;
begin
  lbHorario.Items.Clear;

  DmGlobal.ListarHorarios(Cod_servico, FormatDateTime('yyyy-mm-dd',Calendar.Date));

  with DmGlobal.TabHorario do
  begin
    while NOT Eof do
    begin
      AddHorario(FieldByName('hora').AsString);
      Next;
    end;
  end;

  ResetHorario;
end;

procedure TFrmReserva.btnReservarClick(Sender: TObject);
begin
  try
    DmGlobal.ConfirmarReserva(cod_servico, FrmPrincipal.Cod_Usuario, FormatDateTime('yyyy-mm-dd', Calendar.Date), lbHorario.TagString);
    Close;
  except on ex:exception do
    ShowMessage('Erro ao fazer a reserva: ' +ex.Message);
  end;
end;

procedure TFrmReserva.CalendarDateSelected(Sender: TObject);
begin
  ListarHorarios;
end;

procedure TFrmReserva.FormShow(Sender: TObject);
begin
  Calendar.Date := Date;
  ListarHorarios;
end;

procedure TFrmReserva.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmReserva.ResetHorario;
var
  frame: TFrameHorario;
  i: integer;
begin
  rectConfirmar.Visible := false;

  for i := 0 to lbHorario.Items.Count - 1 do
  begin
    frame := TFrameHorario(lbHorario.ItemByIndex(i).Components[0]);
    frame.rectHora.Fill.Color := $FFFFFFFF;
    frame.rectHora.Stroke.Color := $F4444444;
    frame.lblHora.FontColor := $FF72717F;
  end;
end;

procedure TFrmReserva.lbHorarioItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  frame: TFrameHorario;
begin
  ResetHorario;

  frame := TFrameHorario(Item.Components[0]);
  frame.rectHora.Fill.Color := $FF872BC9;
  frame.rectHora.Stroke.Color := $FF872BC9;
  frame.lblHora.FontColor := $FFFFFFFF;

  rectConfirmar.Visible := true;
  lbHorario.TagString := Item.TagString; // Hora selecionada
end;

end.
