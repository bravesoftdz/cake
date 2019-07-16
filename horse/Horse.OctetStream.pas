unit Horse.OctetStream;

interface

uses
  System.SysUtils, Horse, System.Classes;

type
  TFileReturn = class
  private
    FName: string;
    FStream: TStream;
  public
    property Stream: TStream read FStream write FStream;
    property Name: string read FName write FName;
    constructor Create(AName: string; AStream: TStream);
  End;

procedure OctetStream(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  Web.HTTPApp;

procedure OctetStream(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LWebRequest: TWebRequest;
  LWebResponse: TWebResponse;
  LContent: TObject;
  LWriter: TBinaryWriter;
begin
  LWebRequest := THorseHackRequest(Req).GetWebRequest;

  if (LWebRequest.MethodType in [mtPost, mtPut]) and
    (LWebRequest.ContentType = 'application/octet-stream') then
  begin
    LContent := TMemoryStream.Create;
    LWriter := TBinaryWriter.Create(TStream(LContent));
    LWriter.Write(LWebRequest.RawContent);
    THorseHackRequest(Req).SetBody(LContent);
  end;

  Next;

  LWebResponse := THorseHackResponse(Res).GetWebResponse;
  LContent := THorseHackResponse(Res).GetContent;

  if Assigned(LContent) and LContent.InheritsFrom(TStream) then
    begin
    LWebResponse.ContentType := 'application/octet-stream';
    LWebResponse.SetCustomHeader('Content-Disposition',
      'attachment; filename="pong.xlsx"');
    LWebResponse.ContentStream := TStream(TStream);
    LWebResponse.SendResponse;
    LContent.Free;
  end;

  if Assigned(LContent) and LContent.InheritsFrom(TFileReturn) then
  begin
    LWebResponse.ContentType := 'application/octet-stream';
    LWebResponse.SetCustomHeader('Content-Disposition',
      'attachment; ' + 'filename="' + TFileReturn(LContent).Name + '"');
    LWebResponse.ContentStream := TFileReturn(LContent).Stream;
    LWebResponse.SendResponse;
    LContent.Free;
  end;
end;

{ TFileReturn }

constructor TFileReturn.Create(AName: string; AStream: TStream);
begin
  Name := AName;
  Stream := AStream;
end;

end.
