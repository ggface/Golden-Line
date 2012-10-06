unit glButtonPattern;

interface

uses
{$IFDEF VER230} WinAPI.Windows, WinAPI.Messages {$ELSE} Windows, Messages
{$ENDIF}, SysUtils, Classes, Controls, Graphics, PNGimage;

type
  TglButtonPattern = class(TComponent)
  private
    FImageLeave, FImageEnter, FImageDown: TPicture;

    procedure SetImageLeave(value: TPicture);
    procedure SetImageEnter(value: TPicture);
    procedure SetImageDown(value: TPicture);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ImageLeave: TPicture read FImageLeave write SetImageLeave;
    property ImageEnter: TPicture read FImageEnter write SetImageEnter;
    property ImageDown: TPicture read FImageDown write SetImageDown;
  end;

procedure Register;

implementation

{ TglButtonPattern }

procedure Register;
begin
  RegisterComponents('Golden Line', [TglButtonPattern]);
end;

constructor TglButtonPattern.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageLeave := TPicture.Create;
  FImageEnter := TPicture.Create;
  FImageDown := TPicture.Create;
end;

destructor TglButtonPattern.Destroy;
begin
  FImageLeave.Free;
  FImageEnter.Free;
  FImageDown.Free;
  inherited;
end;

procedure TglButtonPattern.SetImageDown(value: TPicture);
begin
  if value <> FImageDown then
    FImageDown := value;
end;

procedure TglButtonPattern.SetImageEnter(value: TPicture);
begin
  if value <> FImageEnter then
    FImageEnter := value;
end;

procedure TglButtonPattern.SetImageLeave(value: TPicture);
begin
  if value <> FImageLeave then
    FImageLeave := value;
end;

end.
