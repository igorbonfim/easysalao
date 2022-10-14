unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.Edit, FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uHorizontalMenu, uFunctions;

type
  TFrmPrincipal = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    Layout1: TLayout;
    Image2: TImage;
    hscrollBanners: THorzScrollBox;
    Label2: TLabel;
    lbCategorias: TListBox;
    rectAbas: TRectangle;
    imgAba1: TImage;
    imgAba2: TImage;
    imgAba3: TImage;
    rectToolBarAgenda: TRectangle;
    Label1: TLabel;
    Rectangle1: TRectangle;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    rectAcessar: TRectangle;
    btnAcessar: TSpeedButton;
    lvReservas: TListView;
    imgIconeData: TImage;
    imgIconeHora: TImage;
    imgIconeValor: TImage;
    imgIconeCancelar: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgAba1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lvReservasItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    banners: THorizontalMenu;
    FCod_Usuario: integer;
    procedure SelecionarAba(Img: TImage);
    procedure ListarBanners;
    procedure ListarCategorias;
    procedure CarregarTelaInicial;
    procedure AddReserva(cod_reserva: integer; descricao, dt, hora: string;
      valor: double);
    procedure ListarReservas;
    { Private declarations }
  public
    { Public declarations }
    property Cod_Usuario: integer read FCod_Usuario write FCod_Usuario;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses DataModule.Global, Frame.Categoria;

procedure TFrmPrincipal.AddReserva(cod_reserva: integer;
                                   descricao, dt, hora: string;
                                   valor: double);
var
  item: TListViewItem;
begin
  item := lvReservas.Items.Add;

  with item do
  begin
    Height := 110;
    Tag := cod_reserva;

    TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := descricao;
    TListItemText(item.Objects.FindDrawable('txtData')).Text := dt;
    TListItemText(item.Objects.FindDrawable('txtHora')).Text := hora;
    TListItemText(item.Objects.FindDrawable('txtValor')).Text := FormatFloat('#,##0.00',valor);

    TListItemImage(Objects.FindDrawable('imgData')).Bitmap := imgIconeData.Bitmap;
    TListItemImage(Objects.FindDrawable('imgHora')).Bitmap := imgIconeHora.Bitmap;
    TListItemImage(Objects.FindDrawable('imgValor')).Bitmap := imgIconeValor.Bitmap;

    TListItemImage(Objects.FindDrawable('imgCancelar')).Bitmap := imgIconeCancelar.Bitmap;
    TListItemImage(Objects.FindDrawable('imgCancelar')).TagFloat := cod_reserva.ToDouble;
  end;
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FrmPrincipal := nil;
end;

procedure TFrmPrincipal.SelecionarAba(Img: TImage);
begin
  imgAba1.Opacity := 0.3;
  imgAba2.Opacity := 0.3;
  imgAba3.Opacity := 0.3;

  Img.Opacity := 1;
  TabControl.GotoVisibleTab(Img.Tag);

  if Img.Tag = 1 then
    ListarReservas;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  banners := THorizontalMenu.Create(hscrollBanners);
  banners.MarginPadrao := 10;
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  banners.DisposeOf;
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
begin
  lbCategorias.Columns := Trunc(lbCategorias.Width / 150);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  CarregarTelaInicial;
end;

procedure TFrmPrincipal.ListarBanners;
var
  icone: TBitmap;
begin
  DmGlobal.ListarBanners;

  with DmGlobal.TabBanner do
  begin
    while NOT eof do
    begin
      icone := TBitmap.Create;
      LoadImageFromURL(icone, FieldByName('foto').AsString);

      banners.AddItem(FieldByName('banner').AsString,
                      icone,
                      '',
                      300,
                      $FFCCCCCC,
                      0,
                      $FF6E6E6E,
                      '',
                      nil,
                      FieldByName('cod_banner').AsInteger);

      icone.DisposeOf;
      Next;
    end;
  end;
end;

procedure TFrmPrincipal.ListarCategorias;
var
  icone: TBitmap;
  item: TListBoxItem;
  frame: TFrameCategoria;
begin
  DmGlobal.ListarCategorias;

  with DmGlobal.TabCategoria do
  begin
    while NOT eof do
    begin
      icone := TBitmap.Create;
      LoadImageFromURL(icone, FieldByName('icone').AsString);

      item := TListBoxItem.Create(lbCategorias);
      item.Text := '';
      item.Width := 150;
      item.Height := 170;
      item.Selectable := false;
      item.Tag := FieldByName('cod_categoria').AsInteger;

      frame := TFrameCategoria.Create(item);
      frame.Parent := item;
      frame.Align := TAlignLayout.Client;
      frame.lblCategoria.Text := FieldByName('categoria').AsString;
      frame.imgCategoria.Bitmap := icone;

      lbCategorias.AddObject(item);

      icone.DisposeOf;
      Next;
    end;
  end;
end;

procedure TFrmPrincipal.ListarReservas;
begin
  lvReservas.Items.Clear;

  DmGlobal.ListarReservas(Cod_Usuario);

  with DmGlobal.TabReserva do
  begin
    while NOT eof do
    begin
      AddReserva(FieldByName('cod_reserva').AsInteger,
                 FieldByName('servico').AsString,
                 FieldByName('data').AsString,
                 FieldByName('hora').AsString,
                 FieldByName('valor').AsFloat);
      Next;
    end;
  end;
end;

procedure TFrmPrincipal.lvReservasItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  try
    if Assigned(ItemObject) then
      if ItemObject.Name = 'imgCancelar' then
      begin
        DmGlobal.CancelarReserva(Trunc(ItemObject.TagFloat));
        lvReservas.Items.Delete(ItemIndex);
      end;
      
  except on ex:exception do
    ShowMessage('Erro ao cancelar reserva: ' +ex.Message);
  end;
end;

procedure TFrmPrincipal.CarregarTelaInicial;
begin
  banners.DeleteAll;
  lbCategorias.Items.Clear;

  ListarBanners;
  ListarCategorias;
end;

procedure TFrmPrincipal.imgAba1Click(Sender: TObject);
begin
  SelecionarAba(TImage(Sender));
end;

end.
