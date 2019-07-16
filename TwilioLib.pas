unit TwilioLib;

interface

uses System.Net.HttpClient, 
     System.Net.URLClient, 
     System.Classes,
     System.SysUtils;

type
  TTwilio = class
  protected
    FAccountSid: String;
    FAuthToken: String;
    FClient: THttpClient;
    procedure TwilioAuthEvent(const Sender: TObject; AnAuthTarget: TAuthTargetType;
      const ARealm, AURL: string; var AUserName, APassword: string; var AbortAuth: Boolean;
      var Persistence: TAuthPersistenceType);
  public
    constructor Create(const AAccountSid, AAuthToken: string);
    destructor Destroy; override;
    function Send(const FromPhone, ToPhone, Msg: string): string;
  end;

implementation

{ TTwilio }

procedure TTwilio.TwilioAuthEvent(const Sender: TObject; AnAuthTarget: TAuthTargetType;
  const ARealm, AURL: string; var AUserName, APassword: string;
  var AbortAuth: Boolean; var Persistence: TAuthPersistenceType);
begin
  AUserName := FAccountSid;
  APassword := FAuthToken;
end;

constructor TTwilio.Create(const AAccountSid, AAuthToken: string);
begin
  inherited Create;
  FAccountSid  := AAccountSid;
  FAuthToken := AAuthToken;

  FClient := THTTPClient.Create;
  FClient.AuthEvent := TwilioAuthEvent;
end;

destructor TTwilio.Destroy;
begin
  FClient.Free;
  inherited;
end;

function TTwilio.Send(const FromPhone, ToPhone, Msg: string): string;
var
  LURL: string;
  LStringList: TStrings;
  LResponseContent: TStringStream;
begin
  LStringList := TStringList.Create;
  try
    LURL := Format('https://api.twilio.com/2010-04-01/Accounts/%s/Messages', [FAccountSid]);
    LStringList.AddPair('To', ToPhone);
    LStringList.AddPair('From', FromPhone);
    LStringList.AddPair('Body', Msg);
    LResponseContent := TStringStream.Create;
    try
      FClient.Post(LURL, LStringList, LResponseContent);
      Result := LResponseContent.DataString;
    finally
      LResponseContent.Free;
    end;
  finally
    LStringList.Free;
  end;
end;

end.
