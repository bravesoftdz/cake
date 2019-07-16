unit CakeConfig;

interface

uses System.Classes,
     System.SysUtils,
     System.Inifiles;

type
  TCakeConfig = class
  private
    FAccountSid: String;
    FAuthToken: String;
    FphoneSMS: String;
    FphoneWhatsApp: String;
    FServerPort: String;
  protected
    iniFile: TIniFile;
  public
    constructor Create();
    destructor Destroy; override;
  published
    property AccountSid: String read FAccountSid write FAccountSid;
    property AuthToken: String read FAuthToken write FAuthToken;
    property phoneSMS: String read FphoneSMS write FphoneSMS;
    property phoneWhatsApp: String read FphoneWhatsApp write FphoneWhatsApp;
    property ServerPort: String read FServerPort write FServerPort;
  end;

implementation

constructor TCakeConfig.Create();
begin

  try
     iniFile := TIniFile.Create('config.ini');
     FAccountSid := IniFile.ReadString('TWILIO', 'SID', 'Twilio SID');
     FAuthToken := IniFile.ReadString('TWILIO', 'TOKEN', 'Twilio Token');
     phoneSMS := IniFile.ReadString('SMS', 'PHONE', 'Twilio SMS phone number');
     phoneWhatsApp := Format('%s%s', ['whatsapp:', IniFile.ReadString('WHATSAPP', 'PHONE', 'Twilio WhatsApp phone number')]);
     ServerPort := IniFile.ReadString('CAKE', 'PORT', 'Server Port running');
  finally
     IniFile.Free;
  end;

end;

destructor TCakeConfig.Destroy;
begin
  inherited;
end;

end.
