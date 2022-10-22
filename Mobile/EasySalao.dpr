program EasySalao;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitServico in 'UnitServico.pas' {FrmServico},
  UnitReserva in 'UnitReserva.pas' {FrmReserva},
  uFunctions in 'Units\uFunctions.pas',
  uHorizontalMenu in 'Units\uHorizontalMenu.pas',
  DataModule.Global in 'DataModule\DataModule.Global.pas' {DmGlobal: TDataModule},
  Frame.Categoria in 'Frames\Frame.Categoria.pas' {FrameCategoria: TFrame},
  Frame.Horario in 'Frames\Frame.Horario.pas' {FrameHorario: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.Run;
end.
