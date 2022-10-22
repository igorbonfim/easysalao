unit UnitServico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmServico = class(TForm)
    Rectangle1: TRectangle;
    lblTitulo: TLabel;
    imgVoltar: TImage;
    lvServicos: TListView;
    imgIconeValor: TImage;
    imgIconeReservar: TImage;
    procedure FormShow(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure lvServicosItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    FCod_Categoria: integer;
    FDesc_Categoria: string;
    procedure AddServico(cod_servico: integer; descricao: string; valor: double);
    procedure ListarServicos;
    { Private declarations }
  public
    { Public declarations }
    property Cod_Categoria: integer read FCod_Categoria write FCod_Categoria;
    property Desc_Categoria: string read FDesc_Categoria write FDesc_Categoria;
  end;

var
  FrmServico: TFrmServico;

implementation

{$R *.fmx}

uses DataModule.Global, UnitReserva;

procedure TFrmServico.AddServico(cod_servico: integer;
                                 descricao: string;
                                 valor: double);
var
  item: TListViewItem;
begin
  item := lvServicos.Items.Add;

  with item do
  begin
    Height := 60;
    Tag := cod_servico;

    TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := descricao;
    TListItemText(item.Objects.FindDrawable('txtValor')).Text := FormatFloat('#,##0.00',valor);

    TListItemImage(Objects.FindDrawable('imgValor')).Bitmap := imgIconeValor.Bitmap;

    TListItemImage(Objects.FindDrawable('imgReservar')).Bitmap := imgIconeReservar.Bitmap;
    TListItemImage(Objects.FindDrawable('imgReservar')).TagFloat := cod_servico.ToDouble;
  end;
end;

procedure TFrmServico.FormShow(Sender: TObject);
begin
  lblTitulo.Text := Desc_Categoria;
  ListarServicos;
end;

procedure TFrmServico.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmServico.ListarServicos;
begin
  lvServicos.Items.Clear;

  DmGlobal.ListarServicos(Cod_Categoria);

  with DmGlobal.TabServico do
  begin
    while NOT eof do
    begin
      AddServico(FieldByName('cod_servico').AsInteger,
                 FieldByName('descricao').AsString,
                 FieldByName('valor').AsFloat);
      Next;
    end;
  end;
end;

procedure TFrmServico.lvServicosItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if Assigned(ItemObject) then
    if ItemObject.Name = 'imgReservar' then
    begin
      if NOT Assigned(FrmReserva) then
        Application.CreateForm(TFrmReserva, FrmReserva);

        FrmReserva.Cod_servico := Trunc(ItemObject.TagFloat);
        FrmReserva.Show;
    end;
end;

end.
