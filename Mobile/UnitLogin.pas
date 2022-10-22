unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.TabControl,
  uLoading;

type
  TFrmLogin = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    lblConta: TLabel;
    Image1: TImage;
    edtLoginEmail: TEdit;
    edtLoginSenha: TEdit;
    rectAcessar: TRectangle;
    btnLogin: TSpeedButton;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Rectangle2: TRectangle;
    lblLogin: TLabel;
    Layout2: TLayout;
    Image2: TImage;
    edtEmail: TEdit;
    edtSenha: TEdit;
    Rectangle3: TRectangle;
    SpeedButton1: TSpeedButton;
    edtNome: TEdit;
    procedure btnLoginClick(Sender: TObject);
    procedure lblContaClick(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
  private
    procedure TThreadLoginTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Global;

procedure TFrmLogin.TThreadLoginTerminate(Sender: TObject);
begin
  TLoading.Hide;

  if Sender is TThread then
    if Assigned(TThread(Sender).FatalException) then
    begin
      ShowMessage(Exception(TThread(Sender).FatalException).Message);
      exit;
    end;

  if NOT Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

  FrmPrincipal.Show;
end;

procedure TFrmLogin.btnLoginClick(Sender: TObject);
var
  t: TThread;
begin
  TLoading.Show(FrmLogin, '');

  t := TThread.CreateAnonymousThread(procedure
  begin
    sleep(2000);
    DmGlobal.Login(edtLoginEmail.Text, edtLoginSenha.Text);
  end);

  t.OnTerminate := TThreadLoginTerminate;
  t.Start;
end;

procedure TFrmLogin.lblContaClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.lblLoginClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0);
end;

end.
