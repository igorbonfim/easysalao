unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.Edit, FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uHorizontalMenu, uFunctions, uLoading;

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
    edtNome: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtEmail: TEdit;
    rectAcessar: TRectangle;
    btnPerfil: TSpeedButton;
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
    procedure btnPerfilClick(Sender: TObject);
    procedure lbCategoriasItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    banners: THorizontalMenu;
    FCod_Usuario: integer;
    FEmail: string;
    FNome: string;
    procedure SelecionarAba(Img: TImage);
    procedure ListarBanners;
    procedure ListarCategorias;
    procedure CarregarTelaInicial;
    procedure AddReserva(cod_reserva: integer; descricao, dt, hora: string;
      valor: double);
    procedure ListarReservas;
    procedure ThreadInicialTerminate(Sender: TObject);

    {$IFDEF MSWINDOWS}
    procedure ClickBanner(Sender: TObject);
    {$ELSE}
    procedure ClickBanner(Sender: TObject; const Point: TPointF);
    {$ENDIF}

    { Private declarations }
  public
    { Public declarations }
    property Cod_Usuario: integer read FCod_Usuario write FCod_Usuario;
    property Email: string read FEmail write FEmail;
    property Nome: string read FNome write FNome;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses DataModule.Global, Frame.Categoria, UnitServico;

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

{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.ClickBanner(Sender: TObject);
begin
  //ShowMessage(TMyLayout(Sender).codInteger.ToString);
  ShowMessage(TMyLayout(Sender).codString);
end;
{$ELSE}
procedure TFrmPrincipal.ClickBanner(Sender: TObject, const Point: TPointF);
begin
  //ShowMessage(TMyLayout(Sender).codInteger.ToString);
  ShowMessage(TMyLayout(Sender).codString);
end;
{$ENDIF
}
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

      TThread.Synchronize(TThread.CurrentThread, procedure
      begin
        banners.AddItem(FieldByName('banner').AsString,
                        icone,
                        '',
                        300,
                        $FFCCCCCC,
                        0,
                        $FF6E6E6E,
                        '',
                        ClickBanner,
                        FieldByName('cod_banner').AsInteger);
      end);

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
      item.TagString := FieldByName('categoria').AsString;

      frame := TFrameCategoria.Create(item);
      frame.Parent := item;
      frame.Align := TAlignLayout.Client;
      frame.lblCategoria.Text := FieldByName('categoria').AsString;
      frame.imgCategoria.Bitmap := icone;

      TThread.Synchronize(TThread.CurrentThread, procedure
      begin
        lbCategorias.AddObject(item);
      end);

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

procedure TFrmPrincipal.btnPerfilClick(Sender: TObject);
begin
  if btnPerfil.Text = 'Editar Perfil' then
  begin
    edtNome.Enabled := true;
    edtEmail.Enabled := true;
    btnPerfil.Text := 'Salvar Perfil';
  end
  else
  begin
    try
      DmGlobal.EditarPerfil(Cod_Usuario, edtNome.Text, edtEmail.Text);
      btnPerfil.Text := 'Editar Perfil';
      edtNome.Enabled := false;
    edtEmail.Enabled := false;
    except on ex:exception do
      ShowMessage('Erro ao editar perfil: ' +ex.Message);
    end;
  end;
end;

procedure TFrmPrincipal.ThreadInicialTerminate(Sender: TObject);
begin
  TLoading.Hide;

  if Sender is TThread then
    if Assigned(TThread(Sender).FatalException) then
      ShowMessage(Exception(TThread(Sender).FatalException).Message);
end;

procedure TFrmPrincipal.CarregarTelaInicial;
var
  t: TThread;
begin
  TLoading.Show(FrmPrincipal, '');

  edtNome.Text := Nome;
  edtEmail.Text := Email;

  banners.DeleteAll;
  lbCategorias.Items.Clear;

  t := TThread.CreateAnonymousThread(procedure
  begin
    sleep(3000);
    ListarBanners;
    ListarCategorias;
  end);

  t.OnTerminate := ThreadInicialTerminate;
  t.Start;
end;

procedure TFrmPrincipal.imgAba1Click(Sender: TObject);
begin
  SelecionarAba(TImage(Sender));
end;

procedure TFrmPrincipal.lbCategoriasItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if NOT Assigned(FrmServico) then
    Application.CreateForm(TFrmServico, FrmServico);

  FrmServico.Cod_Categoria := Item.Tag;
  FrmServico.Desc_Categoria := Item.TagString;
  FrmServico.Show;
end;

end.
