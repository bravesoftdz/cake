program cake;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Horse in './modules/horse/src/Horse.pas',
  Horse.Constants in './modules/horse/src/Horse.Constants.pas',
  Horse.WebModule in './modules/horse/src/Horse.WebModule.pas',
  Horse.HTTP in './modules/horse/src/Horse.HTTP.pas',
  Horse.Router in './modules/horse/src/Horse.Router.pas',
  Horse.CORS in './modules/horse-cors/src/Horse.CORS.pas',
  TwilioLib,
  CakeConfig;

var
  TwilioClient: TTwilio;
  CakeConfig: TCakeConfig;
  App: THorse;

begin

  CakeConfig := TCakeConfig.Create();

  App := THorse.Create(StrToIntDef(CakeConfig.ServerPort, 5000));

  App.Use(CORS);

  App.Get('/',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      try
   	    Res.Send('cake -- Backend para envio de WhatsApp e SMS pelo Twilio');
      except
        on E: Exception do
		      Res.Send('Error: ' + E.Message);
      end;
    end);

  App.Post('/sendsms',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LBody: TJSONObject;
      toPhone, smsMessage: String;
    begin
      try
        LBody := TJSONObject.ParseJSONValue(TEncoding.ANSI.GetBytes(Req.Body),0) as TJSONObject;

        if Assigned(LBody) then
        begin
          toPhone := LBody.Get('phone').JsonValue.Value;
          smsMessage := LBody.Get('msg').JsonValue.Value;

          TwilioClient := TTwilio.Create(CakeConfig.AccountSid, CakeConfig.AuthToken);
          TwilioClient.Send(CakeConfig.phoneSMS, toPhone, smsMessage);

          Res.Send('Ok');
        end;

      except
        on E: Exception do
		      Res.Send('Error: ' + E.Message);
      end;
    end);

  App.Post('/sendwhats',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LBody: TJSONObject;
      toPhone, smsMessage: String;
    begin
      try
        LBody := TJSONObject.ParseJSONValue(TEncoding.ANSI.GetBytes(Req.Body),0) as TJSONObject;

        if Assigned(LBody) then
        begin
          toPhone := Format('%s%s', ['whatsapp:', LBody.Get('phone').JsonValue.Value]);
          smsMessage := LBody.Get('msg').JsonValue.Value;

          TwilioClient := TTwilio.Create(CakeConfig.AccountSid, CakeConfig.AuthToken);
          TwilioClient.Send(CakeConfig.phoneWhatsApp, toPhone, smsMessage);

          Res.Send('Ok');
        end;

      except
        on E: Exception do
		      Res.Send('Error: ' + E.Message);
      end;
    end);

  App.Start;
end.
