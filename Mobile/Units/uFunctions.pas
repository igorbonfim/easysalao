unit uFunctions;

interface

uses
  System.Net.HttpClientComponent, FMX.Graphics, System.Classes,
  System.SysUtils, System.Net.HttpClient, System.JSON, Data.DB,
  FMX.ListView.Types, FMX.TextLayout, System.Types, FMX.StdCtrls;


procedure LoadImageFromURL(img: TBitmap; url: string);
procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
function GetLabelHeight(const L: TLabel; const Width: single): Integer;

implementation

procedure LoadImageFromURL(img: TBitmap; url: string);
var
    http : TNetHTTPClient;
    vStream : TMemoryStream;
begin
    try
        try
            http := TNetHTTPClient.Create(nil);
            vStream :=  TMemoryStream.Create;

            if (Pos('https', LowerCase(url)) > 0) then
                  HTTP.SecureProtocols  := [THTTPSecureProtocol.TLS1,
                                            THTTPSecureProtocol.TLS11,
                                            THTTPSecureProtocol.TLS12];

            http.Get(url, vStream);
            vStream.Position  :=  0;


            img.LoadFromStream(vStream);
        except
        end;

    finally
        vStream.DisposeOf;
        http.DisposeOf;
    end;
end;

procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    Blob.SaveToStream(ms);
    ms.Position := 0;
    Bitmap.LoadFromStream(ms);
  finally
    ms.Free;
  end;
end;

function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

function GetLabelHeight(const L: TLabel; const Width: single): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(L.Font);
      Layout.VerticalAlign := L.TextSettings.VertAlign;
      Layout.HorizontalAlign := L.TextSettings.HorzAlign;
      Layout.WordWrap := L.WordWrap;
      Layout.Trimming := L.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := L.Text;
    finally
      Layout.EndUpdate;
    end;

    // Get layout height
    Result := Round(Layout.Height);

    // Add one em to the height
    //Layout.Text := 'm';
    //Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;



end.
