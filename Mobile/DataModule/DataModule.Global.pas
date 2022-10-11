unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DataSet.Serialize, DataSet.Serialize.Config;

type
  TDmGlobal = class(TDataModule)
    TabBanner: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ListarBanners;
    { Public declarations }
  end;

var
  DmGlobal: TDmGlobal;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGlobal.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

procedure TDmGlobal.ListarBanners;
var
  json: string;
begin
  json := '[{"cod_banner": "0001", "banner": "Qualquer serviço está com desconto de 25%",' +
          '"foto": "https://easysalao.s3.amazonaws.com/banner.png"},' +
          '{"cod_banner": "0002", "banner": "Chegaram os novos produtos Wella. Venha conferir!",' +
          '"foto": "https://easysalao.s3.amazonaws.com/banner2.png"},' +
          '{"cod_banner": "0003", "banner": "Conheça o kit da linha Nutri-Enrich",' +
          '"foto": "https://easysalao.s3.amazonaws.com/banner3.png"}]';

  TabBanner.FieldDefs.Clear;
  TabBanner.LoadFromJSON(json);
end;

end.
