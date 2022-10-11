program EasySalao;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitServico in 'UnitServico.pas' {FrmServiço},
  UnitReserva in 'UnitReserva.pas' {FrmReserva},
  uFunctions in 'Units\uFunctions.pas',
  uHorizontalMenu in 'Units\uHorizontalMenu.pas',
  DataModule.Global in 'DataModule\DataModule.Global.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
