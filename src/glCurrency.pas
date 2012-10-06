unit glCurrency;

interface

uses
  SysUtils, Classes, IdHTTP;

type
  TglCurrency = class(TComponent)
  private
    fAuthentication: boolean;
    fLogin: string;
    fPassword: string;
    fPort: integer;
    fHost: string;
    fHTTP: TidHTTP;
    fImportList: TStringList;
    function ParseValRBC(instr: string): Currency;
  protected
    { Protected declarations }
  public
    function GetCBRFRates(var USD, EUR, GBP, AUD, UAH: Currency): boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Authentication: boolean read fAuthentication write fAuthentication;
    property Login: string read fLogin write fLogin;
    property Password: string read fPassword write fPassword;
    property Port: integer read fPort write fPort;
    property Host: string read fHost write fHost;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Golden Line', [TglCurrency]);
end;

{ TglCurrency }

constructor TglCurrency.Create(AOwner: TComponent);
begin
  inherited;
  fHTTP := TidHTTP.Create(self);
  fImportList := TStringList.Create;
end;

destructor TglCurrency.Destroy;
begin
  fHTTP.Free;
  fImportList.Free;
  inherited;
end;

function TglCurrency.GetCBRFRates(var USD, EUR, GBP, AUD,
  UAH: Currency): boolean;
var
  i: integer;
  SubStr: string[10];
begin
  // настраиваем блин прокси
  with fHTTP.ProxyParams do
  begin
    BasicAuthentication := fAuthentication;
    ProxyUsername := fLogin;
    ProxyPassword := fPassword;
    ProxyPort := fPort;
    ProxyServer := fHost;
  end;
  // скачиваем файло
  fImportList.Text := fHTTP.Get('http://www.rbc.ru/out/802.csv');
  if Trim(fImportList.Text) = '' then
  begin
    result := false;
    exit;
  end;
  fHTTP.Disconnect;
  // ищем нужные строки
  for i := 0 to fImportList.Count - 1 do
  begin
    SubStr := fImportList[i];
    if SubStr = 'USD ЦБ РФ,' then
      USD := ParseValRBC(fImportList[i]);
    if SubStr = 'EUR ЦБ РФ,' then
      EUR := ParseValRBC(fImportList[i]);
    if SubStr = 'AUD ЦБ РФ,' then
      AUD := ParseValRBC(fImportList[i]);
    if SubStr = 'GBP ЦБ РФ,' then
      GBP := ParseValRBC(fImportList[i]);
    if SubStr = 'UAH ЦБ РФ,' then
      UAH := ParseValRBC(fImportList[i]);
  end;
  result := true;
end;

function TglCurrency.ParseValRBC(instr: string): Currency;
var
  s: string;
  m, p: integer;
begin
  // [USD ЦБ РФ,1 Доллар США,22/12,30.5529,-0.1658]
  s := instr;
  // [1 Доллар США,22/12,30.5529,-0.1658]
  Delete(s, 1, pos(',', s));
  // [1]
  m := StrToInt(Copy(s, 1, pos(' ', s) - 1));
  // [12,30.5529,-0.1658]
  Delete(s, 1, pos('/', s));
  // [30.5529,-0.1658]
  Delete(s, 1, pos(',', s));
  // [30.5529]
  Delete(s, pos(',', s), 20);
  // [30,5529]
  p := pos('.', s);
  Delete(s, p, 1);
  Insert(',', s, p);
  // результат делим на "M"
  result := StrToCurr(s) / m;
end;

end.
