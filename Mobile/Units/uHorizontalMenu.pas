unit uHorizontalMenu;

interface

uses FMX.Layouts, FMX.Objects, FMX.Types, FMX.Graphics, System.UITypes,
     System.Classes, System.Types, System.SysUtils, FMX.Forms, FMX.StdCtrls,
     FMX.Ani, System.Actions, FMX.ActnList, System.JSON, System.Net.HttpClient,
     FMX.Dialogs, System.Net.HttpClientComponent, Soap.EncdDecd, Data.DB;

type
  TExecutaClickWin = procedure(Sender: TObject) of Object;
  TExecutaClickMobile = procedure(Sender: TObject; const Point: TPointF) of Object;

  TMyThread = class(TThread)
  private
    url : string;
    rectangle : TRectangle;
  protected
    procedure Execute; override;
    constructor Create;
  end;

  TMyLayout = class(TLayout)
  public
    codInteger : integer;
    codString : string;
  end;

  THorizontalMenu = class
  private
    MyThread : TMyThread;
    FMarginPadrao : integer;

    {$IFDEF MSWINDOWS}
    FACallBack: TExecutaClickWin;
    {$ELSE}
    FACallBack: TExecutaClickMobile;
    {$ENDIF}

    FHorizBox : THorzScrollBox;
    MoverObj : boolean;
    Offset : TPointF;
    ViewPort : Single;
    QtdItem : integer;
    Rect : TRectangle;
    Lyt: TMyLayout;
    lbl: TLabel;
    ContDownload : integer;
    procedure Tap(Sender: TObject; const Point: TPointF);
    procedure ThreadTerminate(Sender: TObject);
    function BitmapFromBase64(const base64: string): TBitmap;

  protected

  public
    constructor Create(Owner : TComponent);

    procedure LoadFromDataSet(ds : TDataset;
                               {$IFDEF MSWINDOWS}
                               ACallBack: TExecutaClickWin = nil
                               {$ELSE}
                               ACallBack: TExecutaClickMobile = nil
                               {$ENDIF});

    procedure AddItem( codStr: string = '';
                       bgImage : TBitmap = nil;
                       urlImage : string = '';
                       itemWidth : Integer = 100;
                       bgColor : cardinal = $FFFFFFFF;
                       borderRadius : integer = 0;
                       fontColor : cardinal = $FFCCCCCC;
                       itemText : string = '';

                       {$IFDEF MSWINDOWS}
                       ACallBack: TExecutaClickWin = nil;
                       {$ELSE}
                       ACallBack: TExecutaClickMobile = nil;
                       {$ENDIF}
                       codInt: integer = 0
                       );
    procedure LoadFromJSON(strJson : string;
                           {$IFDEF MSWINDOWS}
                           ACallBack: TExecutaClickWin = nil
                           {$ELSE}
                           ACallBack: TExecutaClickMobile = nil
                           {$ENDIF});

    procedure DeleteAll();
    procedure DeleteItem(codItem: string);
  published
    property MarginPadrao: integer read FMarginPadrao write FMarginPadrao;
  end;


implementation

const
    ImageError = 'iVBORw0KGgoAAAANSUhEUgAAAGQAAABWCAQAAACTWft5AAAACXBIWXMAAAsTAAALEwEAmpwYAAADGGlDQ1'+
                 'BQaG90b3Nob3AgSUNDIHByb2ZpbGUAAHjaY2BgnuDo4uTKJMDAUFBUUuQe5BgZERmlwH6egY2BmYGBgYGB'+
                 'ITG5uMAxIMCHgYGBIS8/L5UBFTAyMHy7xsDIwMDAcFnX0cXJlYE0wJpcUFTCwMBwgIGBwSgltTiZgYHhCwM'+
                 'DQ3p5SUEJAwNjDAMDg0hSdkEJAwNjAQMDg0h2SJAzAwNjCwMDE09JakUJAwMDg3N+QWVRZnpGiYKhpaWlgmN'+
                 'KflKqQnBlcUlqbrGCZ15yflFBflFiSWoKAwMD1A4GBgYGXpf8EgX3xMw8BSMDVQYqg4jIKAUICxE+CDEESC4t'+
                 'KoMHJQODAIMCgwGDA0MAQyJDPcMChqMMbxjFGV0YSxlXMN5jEmMKYprAdIFZmDmSeSHzGxZLlg6WW6x6rK2s99'+
                 'gs2aaxfWMPZ9/NocTRxfGFM5HzApcj1xZuTe4FPFI8U3mFeCfxCfNN45fhXyygI7BD0FXwilCq0A/hXhEVkb2i4'+
                 'aJfxCaJG4lfkaiQlJM8JpUvLS19QqZMVl32llyfvIv8H4WtioVKekpvldeqFKiaqP5UO6jepRGqqaT5QeuA9iSd'+
                 'VF0rPUG9V/pHDBYY1hrFGNuayJsym740u2C+02KJ5QSrOutcmzjbQDtXe2sHY0cdJzVnJRcFV3k3BXdlD3VPXS8'+
                 'Tbxsfd99gvwT//ID6wIlBS4N3hVwMfRnOFCEXaRUVEV0RMzN2T9yDBLZE3aSw5IaUNak30zkyLDIzs+ZmX8xlz'+
                 '7PPryjYVPiuWLskq3RV2ZsK/cqSql01jLVedVPrHzbqNdU0n22VaytsP9op3VXUfbpXta+x/+5Em0mzJ/+dGj/t'+
                 '8AyNmf2zvs9JmHt6vvmCpYtEFrcu+bYsc/m9lSGrTq9xWbtvveWGbZtMNm/ZarJt+w6rnft3u+45uy9s/4ODOYd+'+

                 'Hmk/Jn58xUnrU+fOJJ/9dX7SRe1LR68kXv13fc5Nm1t379TfU75/4mHeY7En+59lvhB5efB1/lv5dxc+NH0y/fzq'+
                 '64Lv4T8Ffp360/rP8f9/AA0ADzT6lvFdAAAABGdBTUEAALGOfPtRkwAAACBjSFJNAAB6JQAAgIMAAPn/AACA6QAAd'+
                 'TAAAOpgAAA6mAAAF2+SX8VGAAAKNElEQVR42uyce3BU1R3HP+c+9+7e3QQhCRUFhSIvjVEB6wOiFkax4LMItg61Tjt'+
                 '1OrV22tqZznS0dsb+ocVxfHQ6U9vRltGxtNRqraPSWgUEQVCMIkoKKCQSCRB2s4+793H6R5aQbG7YTYJk4/DNP5mdu'+
                 '7vnc8/vfc+skHwxpMEbPMlubHV3ZK/+mRg5Sx8r69xx2VODZSQ4Fw0EBs2R/dGUMrL2YB/7tGbzvIyaE4ACko7ITn'+
                 'ukYXQpray1nzAzXSD/Vf8RHcnescJ+WQUF3oyMzN04oqxYa3aB6CM9Yr2lggZtfSKVJr0KXrZCULTiQ13ht7cEV2S'+
                 'M3IsVDDKPwHrV8vvmkd4YSzOLMisr2pAUFqYd1ljFr/aSKifm2slXNMgULKa6HHtHPO4bxiKjmhh1tNDCJGIcJM2h'+
                 'Pob/U+ah0UoJkOFSDadxBnGSTGIDLUxnDG2MopPd/I/ObvP5LpfRQYRcJYLM5WZ20IpGgIuDB7jk8YBaargRyZPs'+
                 'BO7kq6QAGV40DqfbNvBNGvFpJo+Cho6GIkBBkxrg4WExi0tYiWA+WTRAR60kkAu4g2noODhIFAw61R3m2/pBBbFeV'+
                 'vl2PpE3goCADCa34JGlK1RFMSsDRDCHRTSi4OCiADop9T1rl+mIIynukIqxK5iRm5hTAwjIApKgEJKCSgCZxXe4C'+
                 'J8cHgKBikWL8e+4J/rWthuj280ZScv3AUFADgGIkARxgkGm8Q0uQeXTbocV6Lxo/DUEo0tJ9dGElprluYCChgRUl'+
                 'M8bRNB/61zNNVyNRgsBR1dt0qQ9EOcYnWmbutx+tMPCR2Kh'+

                 'IrE+Px/RmEod7ezkHMbxPtv6XNHIddTQGQL6XJQSDXa79rR1YzZLQJzTCDBCln0cQGwu52o+po0cgmqmM'+
                 'weTFbzZbckWC1iAQ3uf9+rs0N4zSn/HamuuEw8kWTIoKLjHG0RhCbdyJq1sxyUAfBwcGpnNR/yOV4FaFlPFB'+
                 '8g+N14S4aVIUFZL+4pxaS6HymgMPPzjCZJgAdfSgEsnTnHXRsAkfsMbrGUco3Cxwz1KtJbZ1rVrOj4KCiYm+v'+
                 'EC0VjAD5hAnjSE5FkAB0Ejk3iwl3P3BvFFssw2e6/yCi46Z2NjHB9nN1nKIqbhkipxpSRFHTbPHivMlTlJa+M'+
                 'zAgy+jUCGhIxBgFzDvSTJlHm1ZAmfYvSz3kBukk5ZKGOpx0VDIY1+PBKi4FpSfXyifzlM5E6a0cNNK9geOGo'+
                 '5n3NGcAM5BHEkSshtGTDIfBrIDugdAWPZSQdhzhBhvNteFki1d5AsGhEsIhhDBbH5UUjoKwUSo57m0JBgMC+3JV'+
                 'L6MyJydl4lgoWNRmToUesyJpZ08b7yqEGQCt2TOu+C/OaSKfGGTEOQIyCKj4eCNzQQwU0hObV7cIGKQAu98wE1'+
                 'GIXatTgG3pDZrB87dp3iL8yqmECcPBJ1qCBfZybpfhANDmktZkZ8EkzI1QUiBCWKFrreud69yfsS+X5Rxvo/T47'+
                 'GRcdiNAKIhqTXAYDEuBUvZCkSHZUN0fVRD2hih7Uk3ZhzCyXLURAFq5+dvNLd3rkq5oSmxir/juS5vo+KRhN7'+
                 'kIDOR3IIINMZ1z3P6F34JXkkuqZ7op8TT9r7uTR3NmNDynofivq7AIcznQXutthOs7fJmPL8zIRclcyiAz4r+b'+
                 'Cw/0OaolyHG+IhCnkejzxb9GDiX3ZOTnFUlKJFC+AApyDwkT3mIS7R4OJUQ7bJdNSD4rCok1agefX5Gj9V8AeJw'+
                 'q8L4SLKf/jxYEFmMB8v5PIoL2orQirCtfacoN7N4RbtScBWqqmiDgOJgVow1gCXaq/eq2Ujm7iYUezF6H63xKK6'+

                 '26xjxMSgd+RmEiGBN8Zz2n2JsOvz4oFER/I8dypGDxSVA6TZRysa9Qiq2EYdFgIV8HELg4Wj/x1JnE3s6NnFDN'+
                 'ZHNE7nkz6GFeEDHrbT/dSvGfFw/LbD0321YEZdhtjBYSw0Okmj0slWakgxlz2hhccR/E7uZn+JFZal2YwpcnRJ'+
                 'lPfE8njrMT5BKn+rmn/4LN/vkQpF4X8FBQWBiYGBwj5OQcUPrRskcFevPv9dHh8MiMotRIvumMBhtfVJiZzcod'+
                 'web0xeH8woLCcghUckNBO5mMyllUzI1KqWr/UyaFMMCuRyGsn2SkKCKL+MPF/GQ9QO7bXEVYcNedRtwxpmozCv'+
                 'amAOKjvJ9Pg2QTWx4p0anI9cQrYoo9us1FfZ5Zllh/aH+PjUaCkQyD5+JtBJqzsUJ6j2JXl0lnE+O2nhY/L4KD'+
                 'jcUzR9UTkwGB+JM4ODPaobQZRV6kPx8p8zvmXcZi9JXUktKVYzsag+2xzbHlktdDkjU5cVBGSYynSyNLGbJEn+ye'+
                 'tlhaOSWsgZdPa4UOdt8Xg8PaBH2m3mS1yR0hA9ehlJhDZ1s92mA7jinVhMLM4oBOQBhVnMJEuKu8qc55RQFbegEu'+
                 '3+sxH80W4bcEP2ofmXqEOmxxfGaNaeSbT1aC3WRVdFRMHVJQ55NMbzvTITRMnh/1hShXglUTC5J/aOOZjJy1PRj'+
                 'WJyWhbc2mCb8VTcLUodj9hbWZC7kOruyNXJHGazceggU2jtHjQo6DxjvmoNdhLWbBFMyEWkQSCaI1tiYde8Hhsj'+
                 'L3a0HqWNxreGDnI6N6GRKOyGwm/1p+NDmUw2x1oiGVfhXT3VX6cu/h6fFcxzXY50W1lmczp7huYjSxiFQEVFx+R9'+
                 '9WWbISqrro+si6TUYw2Q7o7/UF9DtjDB8rFZPDRnt2lgN2200UY7W8VdifImHkOVq2xKtKuR7so4w818eSgg51'+
                 'OLio6ORZ777eQJwQDwxBOJN7VMYRAXkOD6wYMoLKWaOAlGE+PBWLPJCdR+9Sf2r8TbBIAk'+

                 'y1cwBwvSwAU4KBjk+L253uIEK6+tq0oqXQaWZzrLBguyGA2JAqzWV9gMg1LaSnuPSJJHkmEpYwYDEucidGzGs'+
                 'Ft5KM4wnT7dYixNPMZ2MhzCZuZgQBZSQw6DJuVniewwHhXs1N+xXaECeRZhDBQkwnW049DC8ujeYT6vsiPytC1'+
                 'QcZhJ40BB5jEZk8+4J7YhwrDrNfP7sVW0Y7Cs39jVD8hcbKrYZGywqAg1WeujCpJ6pgwEZDyzSPMnfXmcitGW6P'+
                 'OWQOX2gRSNC6nlFeVh262gk/IBf441B5c68zmXreXtyGiWsVncn0irVJjWxzeb0X4arRCQC3F5zG7VqECtsdfpMz'+
                 'k1rPqXiFE9ns1IcegXwZboCxV7Wl6X8w8nvbU6VT1edGTfU/GzZKvxQgUf+nfFy4lp6lmyhGkpMq+vtKloecpLic'+
                 'laCdNSUI/xlLBypPV+iujIlFYc5AJGgryBz7VGik6CnAQ5CXIS5CTISZCTIF0gk4ORDjFeggLn5Ec6SIMPClyRO8'+
                 '0fyRhf8q/KgQKz5dWdjNwfGgiuSV3YZVoemttweKw3EilO9WYmDc+lMA5yqfUmJ3eZu5QDI+qnEsYFEx0ncI90iF'+
                 '8M/X8A9Ctev1UbjM0AAAAASUVORK5CYII=';


procedure THorizontalMenu.ThreadTerminate(Sender: TObject);
var
    bmp : TBitmap;
begin
    if Assigned(TThread(Sender).FatalException) then
    begin
        //showmessage('Erro na thread da imagem: ' + Exception(TThread(Sender).FatalException).Message);
        try
            bmp := BitmapFromBase64(ImageError);
            TMyThread(Sender).rectangle.Align := TAlignLayout.Center;
            TMyThread(Sender).rectangle.Width := 60;
            TMyThread(Sender).rectangle.Height := 58;
            TMyThread(Sender).rectangle.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
            TMyThread(Sender).rectangle.Fill.Bitmap.Bitmap := bmp;
            bmp.DisposeOf;
        except
        end;
    end;
end;

constructor TMyThread.Create;
begin
    inherited Create(True);
end;

procedure TMyThread.Execute;
var
    http : TNetHTTPClient;
    vStream : TMemoryStream;
begin
    inherited;

    try
        http := TNetHTTPClient.Create(nil);
        vStream :=  TMemoryStream.Create;

        if (Pos('https', LowerCase(self.url)) > 0) then
              HTTP.SecureProtocols  := [THTTPSecureProtocol.TLS1,
                                        THTTPSecureProtocol.TLS11,
                                        THTTPSecureProtocol.TLS12];


        http.Get(self.url, vStream);
        vStream.Position  :=  0;

        Synchronize(procedure
        begin
            self.rectangle.Fill.Bitmap.Bitmap.LoadFromStream(vStream);
            self.rectangle.Repaint;
        end);

    finally
        vStream.DisposeOf;
        http.DisposeOf;
    end;

end;

constructor THorizontalMenu.Create(Owner : TComponent);
begin
    FHorizBox := Owner as THorzScrollBox;

    // Margin direita do ultimo item...
    lyt := TMyLayout.Create(FHorizBox);
    lyt.Parent := FHorizBox;
    lyt.Width := 20;
    lyt.Align := TAlignLayout.Left;
    lyt.Tag := -1;


    {$IFNDEF MSWINDOWS}
    FHorizBox.OnTap := Tap;
    {$ENDIF}
end;

function THorizontalMenu.BitmapFromBase64(const base64: string): TBitmap;
var
        Input: TStringStream;
        Output: TBytesStream;
begin
        Input := TStringStream.Create(base64, TEncoding.ASCII);
        try
                Output := TBytesStream.Create;
                try
                        Soap.EncdDecd.DecodeStream(Input, Output);
                        Output.Position := 0;
                        Result := TBitmap.Create;
                        try
                                Result.LoadFromStream(Output);
                        except
                                Result.Free;
                                raise;
                        end;
                finally
                        Output.Free;
                end;
        finally
                Input.Free;
        end;
end;


procedure THorizontalMenu.Tap(Sender: TObject; const Point: TPointF);
var
    x : integer;
    pt : TPointF;
begin
    pt := TPointF.Create(FHorizBox.ViewportPosition.x + point.X, 0);

    for x := 0 to FHorizBox.ComponentCount - 1 do
    begin
        if FHorizBox.Components[x] is TLayout then
        begin
            if (pt.x >= TLayout(FHorizBox.Components[x]).Position.X) and
               (pt.x <= TLayout(FHorizBox.Components[x]).Position.X + TLayout(FHorizBox.Components[x]).Width)then
                TLayout(FHorizBox.Components[x]).OnTap(TLayout(FHorizBox.Components[x]), pt);
        end;
    end;
end;


procedure THorizontalMenu.AddItem( codStr: string = '';
                                   bgImage : TBitmap = nil;
                                   urlImage : string = '';
                                   itemWidth : Integer = 100;
                                   bgColor : cardinal = $FFFFFFFF;
                                   borderRadius : integer = 0;
                                   fontColor : cardinal = $FFCCCCCC;
                                   itemText : string = '';
                                   {$IFDEF MSWINDOWS}
                                   ACallBack: TExecutaClickWin = nil;
                                   {$ELSE}
                                   ACallBack: TExecutaClickMobile = nil;
                                   {$ENDIF}
                                   codInt: integer = 0
                                   );
var
    rect : TRectangle;
    stream : TMemoryStream;
    bmp : TBitmap;
begin
    Inc(QtdItem);

    //lyt := TLayout.Create(FHorizBox);
    lyt := TMyLayout.Create(FHorizBox);
    lyt.Margins.Left := FMarginPadrao;
    lyt.Align := TAlignLayout.MostLeft;
    lyt.Width := itemWidth;
    lyt.Parent := FHorizBox;
    lyt.Opacity := 0;
    lyt.TagString := codStr;
    lyt.Tag := QtdItem;
    lyt.codInteger := codInt;
    lyt.codString := codStr;
    lyt.Position.X := 99999;


    {$IFDEF MSWINDOWS}
    lyt.HitTest := true;
    lyt.OnClick := ACallBack;
    {$ELSE}
    lyt.HitTest := false;
    lyt.OnTap := ACallBack;
    {$ENDIF}


    // Adiciona texto...
    lbl := TLabel.Create(lyt);
    lbl.Text := itemText;
    lbl.Align := TAlignLayout.Bottom;
    lbl.TextAlign := TTextAlign.Center;
    lbl.VertTextAlign := TTextAlign.Center;
    lbl.FontColor := fontColor;
    lbl.Height := 20;
    lbl.Margins.Top := 5;
    lbl.Visible := true;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size];
    lbl.Font.Size := 13;
    lbl.HitTest := false;
    Lyt.AddObject(lbl);

    // Adiciona rect...
    rect := TRectangle.Create(lyt);
    rect.Align := TAlignLayout.Client;
    rect.Fill.Color := bgColor;
    rect.Fill.Kind := TBrushKind.Solid;
    rect.Stroke.Kind := TBrushKind.None;
    rect.XRadius := borderRadius;
    rect.YRadius := borderRadius;
    rect.Visible := true;
    rect.Tag := QtdItem - 1;
    rect.Width := itemWidth;
    rect.HitTest := false;

    if bgImage <> nil then
    begin
        rect.Fill.Kind := TBrushKind.Bitmap;
        rect.Fill.Bitmap.Bitmap := bgImage;
        rect.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    end
    else
    if urlImage <> '' then
    begin
        rect.Fill.Color := $FFF6F6F6;
        rect.Fill.Kind := TBrushKind.Bitmap;
        rect.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;

        // Criar Thread para busca da foto...
        MyThread := TMyThread.Create;
        MyThread.url := urlImage;
        MyThread.rectangle := rect;
        MyThread.OnTerminate := ThreadTerminate;
        MyThread.FreeOnTerminate := true;
        MyThread.Start;
    end;

    lyt.AddObject(rect);


    // Exibe o item...
    TAnimator.AnimateFloat(lyt, 'Opacity', 1, 0.3);
end;


procedure THorizontalMenu.LoadFromJSON(strJson : string;
                                       {$IFDEF MSWINDOWS}
                                       ACallBack: TExecutaClickWin = nil
                                       {$ELSE}
                                       ACallBack: TExecutaClickMobile = nil
                                       {$ENDIF});
var
    JsonArray : TJSONArray;
    JsonObj : TJSONObject;
    i : integer;
begin
    try
        JsonArray := TJSONObject.ParseJSONValue(strJson) as TJSONArray;

        try
            if Assigned(JsonArray) then
            begin
                for i := 0 to JsonArray.Size - 1 do
                begin
                    JsonObj := JsonArray.Get(i) as TJSONObject;

                    AddItem(JsonObj.Get('codItem').JsonValue.Value,
                            nil, // bitmap...
                            JsonObj.Get('urlImage').JsonValue.Value,
                            JsonObj.Get('itemWidth').JsonValue.Value.ToInteger,
                            JsonObj.Get('bgColor').JsonValue.Value.ToInteger,
                            JsonObj.Get('borderRadius').JsonValue.Value.ToInteger,
                            JsonObj.Get('fontColor').JsonValue.Value.ToInteger,
                            JsonObj.Get('itemText').JsonValue.Value,
                            ACallBack
                            );

                end;
            end;
        finally
            JsonArray.DisposeOf;
        end;

    except
        showmessage('Json array inválido');
    end;

end;


procedure THorizontalMenu.LoadFromDataSet(ds : TDataset;
                                       {$IFDEF MSWINDOWS}
                                       ACallBack: TExecutaClickWin = nil
                                       {$ELSE}
                                       ACallBack: TExecutaClickMobile = nil
                                       {$ENDIF});
var
    bmp : TBitmap;
    img_stream : TStream;
    url : string;
begin
    try
        try
            ds.First;
            while NOT ds.Eof do
            begin
                if ds.FieldByName('blobImage').AsString <> '' then
                begin
                    url := '';
                    img_stream := ds.CreateBlobStream(ds.FieldByName('blobImage'), TBlobStreamMode.bmRead);
                    bmp := TBitmap.Create;
                    bmp.LoadFromStream(img_stream);
                end
                else
                begin
                    bmp := nil;
                    url := ds.fieldbyname('urlImage').AsString;
                end;

                AddItem(ds.fieldbyname('codItem').AsString,
                        bmp,
                        url,
                        ds.fieldbyname('itemWidth').AsInteger,
                        ds.fieldbyname('bgColor').AsInteger,
                        ds.fieldbyname('borderRadius').AsInteger,
                        ds.fieldbyname('fontColor').AsInteger,
                        ds.fieldbyname('itemText').AsString,
                        ACallBack
                        );


                if ds.FieldByName('blobImage').AsString <> '' then
                begin
                    img_stream.DisposeOf;
                    bmp.DisposeOf;
                end;

                ds.next;
            end;

        finally
        end;

    except
    end;

end;



procedure THorizontalMenu.DeleteAll();
var
        i : integer;
        layout : TLayout;
begin
    try
        for i := FHorizBox.ComponentCount - 1 downto 0 do
        begin
            if (UpperCase(FHorizBox.Components[i].ClassName) = 'TMYLAYOUT') and
               (FHorizBox.Components[i].tag >= 0) then
            begin
                layout := TLayout(FHorizBox.Components[i]);
                layout.DisposeOf;
            end;
        end;
    finally
    end;
end;

procedure THorizontalMenu.DeleteItem(codItem: string);
var
    i : integer;
    layout : TLayout;
begin
    try
        for i := FHorizBox.ComponentCount - 1 downto 0 do
        begin
            if FHorizBox.Components[i] is TLayout then
            begin
                layout := TLayout(FHorizBox.Components[i]);

                if layout.TagString = codItem then
                    layout.DisposeOf;
            end;
        end;

    finally
    end;
end;

end.
