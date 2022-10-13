unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DataSet.Serialize, DataSet.Serialize.Config, FireDAC.Stan.StorageBin;

type
  TDmGlobal = class(TDataModule)
    TabBanner: TFDMemTable;
    TabCategoria: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ListarBanners;
    procedure ListarCategorias;
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

procedure TDmGlobal.ListarCategorias;
var
  json: string;
begin
  json :=  '[{"cod_categoria": "0001", "categoria": "Cabelo",' +
           '"icone": "https://easysalao.s3.amazonaws.com/tesoura.png"},' +
           '{"cod_categoria": "0002", "categoria": "Unha",' +
           '"icone": "https://easysalao.s3.amazonaws.com/unha.png"},' +
           '{"cod_categoria": "0003", "categoria": "Massagem",' +
           '"icone": "https://easysalao.s3.amazonaws.com/massagem.png"},' +
           '{"cod_categoria": "0004", "categoria": "Maquiagem",' +
           '"icone": "https://easysalao.s3.amazonaws.com/maquiagem.png"},' +
           '{"cod_categoria": "0005", "categoria": "Depilação",' +
           '"icone": "https://easysalao.s3.amazonaws.com/depilacao.png"},' +
           '{"cod_categoria": "0006", "categoria": "Estética",' +
           '"icone": "https://easysalao.s3.amazonaws.com/estetica.png"}]';

  TabCategoria.FieldDefs.Clear;
  TabCategoria.LoadFromJSON(json);
end;

end.
