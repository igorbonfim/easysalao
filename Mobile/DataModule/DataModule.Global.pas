unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes;

type
  TDmGlobal = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmGlobal: TDmGlobal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
