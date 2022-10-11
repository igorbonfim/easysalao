unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.Edit, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, uHorizontalMenu;

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
  private
    banners: THorizontalMenu;
    procedure SelecionarAba(Img: TImage);
    procedure ListarBanners;
    procedure ListarCategorias;
    procedure CarregarTelaInicial;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses DataModule.Global, uFunctions;

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
begin

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
