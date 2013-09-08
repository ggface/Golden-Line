unit glTools;

interface

uses
  SysUtils, Classes, Windows, WinSvc;

type
  TglTools = class(TComponent)
  private
    { Private declarations }
  protected
    procedure SrvRegTool(FileName, Path: string; Start: boolean);
  public
    function Stop(ServiceName: string): boolean;
    function Start(ServiceName: string): boolean;
    function Restart(ServiceName: string): boolean;
    procedure Install(FileName, Path: string);
    procedure Uninstall(FileName, Path: string);
    procedure FullRestart(ServiceName, FileName, Path: string);
    function Working(ServiceName: string): DWord;
  published
    function GetStartParam: string;
  end;

procedure Register;

implementation

//{$R glTools}

procedure Register;
begin
  RegisterComponents('Golden Line', [TglTools]);
end;

function ServiceGetStatus(sMachine, sService: string): DWord;
var
  h_manager, h_service: SC_Handle;
  service_status: TServiceStatus;
  hStat: DWord;
begin
  hStat := 1;
  h_manager := OpenSCManager(PChar(sMachine), nil, SC_MANAGER_CONNECT);

  if h_manager > 0 then
  begin
    h_service := OpenService(h_manager, PChar(sService), SERVICE_QUERY_STATUS);

    if h_service > 0 then
    begin
      if (QueryServiceStatus(h_service, service_status)) then
        hStat := service_status.dwCurrentState;

      CloseServiceHandle(h_service);
    end;
    CloseServiceHandle(h_manager);
  end;

  Result := hStat;
end;

function ServiceStart(aMachine, aServiceName: string): boolean;
// aMachine это UNC путь, либо локальный компьютер если пусто
var
  h_manager, h_svc: SC_Handle;
  svc_status: TServiceStatus;
  Temp: PChar;
  dwCheckPoint: DWord;
begin
  svc_status.dwCurrentState := 1;
  h_manager := OpenSCManager(PChar(aMachine), nil, SC_MANAGER_CONNECT);
  if h_manager > 0 then
  begin
    h_svc := OpenService(h_manager, PChar(aServiceName), SERVICE_START or
      SERVICE_QUERY_STATUS);
    if h_svc > 0 then
    begin
      Temp := nil;
      if (StartService(h_svc, 0, Temp)) then
        if (QueryServiceStatus(h_svc, svc_status)) then
        begin
          while (SERVICE_RUNNING <> svc_status.dwCurrentState) do
          begin
            dwCheckPoint := svc_status.dwCheckPoint;

            Sleep(svc_status.dwWaitHint);

            if (not QueryServiceStatus(h_svc, svc_status)) then
              break;

            if (svc_status.dwCheckPoint < dwCheckPoint) then
            begin
              // QueryServiceStatus не увеличивает dwCheckPoint
              break;
            end;
          end;
        end;
      CloseServiceHandle(h_svc);
    end;
    CloseServiceHandle(h_manager);
  end;
  Result := SERVICE_RUNNING = svc_status.dwCurrentState;
end;

function ServiceStop(aMachine, aServiceName: string): boolean;
// aMachine это UNC путь, либо локальный компьютер если пусто
var
  h_manager, h_svc: SC_Handle;
  svc_status: TServiceStatus;
  dwCheckPoint: DWord;
begin
  h_manager := OpenSCManager(PChar(aMachine), nil, SC_MANAGER_CONNECT);
  if h_manager > 0 then
  begin
    h_svc := OpenService(h_manager, PChar(aServiceName), SERVICE_STOP or
      SERVICE_QUERY_STATUS);

    if h_svc > 0 then
    begin
      if (ControlService(h_svc, SERVICE_CONTROL_STOP, svc_status)) then
      begin
        if (QueryServiceStatus(h_svc, svc_status)) then
        begin
          while (SERVICE_STOPPED <> svc_status.dwCurrentState) do
          begin
            dwCheckPoint := svc_status.dwCheckPoint;
            Sleep(svc_status.dwWaitHint);

            if (not QueryServiceStatus(h_svc, svc_status)) then
            begin
              // couldn't check status
              break;
            end;

            if (svc_status.dwCheckPoint < dwCheckPoint) then
              break;

          end;
        end;
      end;
      CloseServiceHandle(h_svc);
    end;
    CloseServiceHandle(h_manager);
  end;

  Result := SERVICE_STOPPED = svc_status.dwCurrentState;
end;

{ TglTools }

procedure TglTools.FullRestart(ServiceName, FileName, Path: string);
begin
  Stop(ServiceName);
  Uninstall(FileName, Path);
  Install(FileName, Path);
  Start(ServiceName);
end;

function TglTools.GetStartParam: string;
begin
  Result := trim(paramstr(1));
end;

procedure TglTools.Install(FileName, Path: string);
begin
  SrvRegTool(FileName, Path, true);
end;

function TglTools.Restart(ServiceName: string): boolean;
begin
  Result := false;
  if ServiceStop('', ServiceName) then
    if ServiceStart('', ServiceName) then
      Result := true;
end;

procedure TglTools.SrvRegTool(FileName, Path: string; Start: boolean);
var
  Action: string;
begin
  if Start then
    Action := ' /silent /install'
  else
    Action := ' /silent /uninstall';
  if trim(Path) = '' then
    WinExec(PAnsiChar(FileName + Action), SW_HIDE)
  else
    WinExec(PAnsiChar(Path + FileName + Action), SW_HIDE);
end;

function TglTools.Start(ServiceName: string): boolean;
begin
  if ServiceStart('', ServiceName) then
    Result := true
  else
    Result := false;
end;

function TglTools.Stop(ServiceName: string): boolean;
begin
  if ServiceStop('', ServiceName) then
    Result := true
  else
    Result := false;
end;

procedure TglTools.Uninstall(FileName, Path: string);
begin
  SrvRegTool(FileName, Path, false);
end;

function TglTools.Working(ServiceName: string): DWord;
begin
  Result := ServiceGetStatus('', ServiceName);
end;

end.
