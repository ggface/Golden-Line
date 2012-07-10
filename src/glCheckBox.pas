unit glCheckBox;

interface

uses
{$IFDEF VER230} System.SysUtils, WinAPI.Windows, WinAPI.Messages
{$ELSE} Windows, Messages, SysUtils {$ENDIF} , Classes, Controls, Graphics,
  glCustomObject, PNGImage;

type
  TglCheckBox = class(TglCustomObject)
  private
    FOnChange: TNotifyEvent;
    fViewState: byte;
    fCheck, fFocus: Boolean;
    FOnDown, FOnEnter, FOnLeave, FOffDown, FOffEnter, FOffLeave: TPicture;
    procedure SetChecked(Value: Boolean);
  protected
    procedure Change; dynamic;
    procedure Paint; override;
    procedure MouseEnter(var Msg: TMessage); message cm_mouseEnter;
    procedure MouseLeave(var Msg: TMessage); message cm_mouseLeave;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure SetOnDown(Value: TPicture); virtual;
    procedure SetOnEnter(Value: TPicture); virtual;
    procedure SetOnLeave(Value: TPicture); virtual;
    procedure SetOffDown(Value: TPicture); virtual;
    procedure SetOffEnter(Value: TPicture); virtual;
    procedure SetOffLeave(Value: TPicture); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ImageOnDown: TPicture read FOnDown write SetOnDown;
    property ImageOnEnter: TPicture read FOnEnter write SetOnEnter;
    property ImageOnLeave: TPicture read FOnLeave write SetOnLeave;
    property ImageOffDown: TPicture read FOffDown write SetOffDown;
    property ImageOffEnter: TPicture read FOffEnter write SetOffEnter;
    property ImageOffLeave: TPicture read FOffLeave write SetOffLeave;
    property Checked: Boolean read fCheck write SetChecked;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

procedure Register;

implementation

const
  vsOnLeave = 0;
  vsOnEnter = 1;
  vsOnDown = 2;
  vsOffLeave = 3;
  vsOffEnter = 4;
  vsOffDown = 5;

procedure TglCheckBox.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);

  if fCheck then
    fViewState := vsOnLeave
  else
    fViewState := vsOffLeave;
  repaint;
end;

constructor TglCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOnLeave := TPicture.Create;
  FOnEnter := TPicture.Create;
  FOnDown := TPicture.Create;
  FOffLeave := TPicture.Create;
  FOffEnter := TPicture.Create;
  FOffDown := TPicture.Create;
  fCheck := false;
  fViewState := vsOffLeave;
end;

destructor TglCheckBox.Destroy;
begin
  inherited Destroy;
  FOnLeave.Free;
  FOnEnter.Free;
  FOnDown.Free;
  FOffLeave.Free;
  FOffEnter.Free;
  FOffDown.Free;
end;

procedure TglCheckBox.Paint;
begin
  case fViewState of
    0:
      Canvas.Draw(0, 0, FOnLeave.Graphic);
    1:
      begin
        if Assigned(FOnEnter.Graphic) then
          Canvas.Draw(0, 0, FOnEnter.Graphic)
        else
          Canvas.Draw(0, 0, FOnLeave.Graphic);
      end;
    2:
      begin
        if Assigned(FOnDown.Graphic) then
          Canvas.Draw(0, 0, FOnDown.Graphic)
        else if Assigned(FOnEnter.Graphic) then
          Canvas.Draw(0, 0, FOnEnter.Graphic)
        else
          Canvas.Draw(0, 0, FOnLeave.Graphic);
      end;
    3:
      Canvas.Draw(0, 0, FOffLeave.Graphic);
    4:
      begin
        if Assigned(FOffEnter.Graphic) then
          Canvas.Draw(0, 0, FOffEnter.Graphic)
        else
          Canvas.Draw(0, 0, FOffLeave.Graphic);
      end;
    5:
      begin
        if Assigned(FOffDown.Graphic) then
          Canvas.Draw(0, 0, FOffDown.Graphic)
        else if Assigned(FOffEnter.Graphic) then
          Canvas.Draw(0, 0, FOffEnter.Graphic)
        else
          Canvas.Draw(0, 0, FOffLeave.Graphic);
      end;
  end;
  inherited;
end;

procedure TglCheckBox.SetChecked(Value: Boolean);
begin
  fCheck := Value;
  Change;
end;

procedure TglCheckBox.SetOnLeave(Value: TPicture);
begin
  FOnLeave.Assign(Value);
  Invalidate;
end;

procedure TglCheckBox.SetOnEnter(Value: TPicture);
begin
  FOnEnter.Assign(Value);
  Invalidate;
end;

procedure TglCheckBox.SetOnDown(Value: TPicture);
begin
  FOnDown.Assign(Value);
  Invalidate;
end;

procedure TglCheckBox.SetOffLeave(Value: TPicture);
begin
  FOffLeave.Assign(Value);
  Invalidate;
end;

procedure TglCheckBox.SetOffEnter(Value: TPicture);
begin
  FOffEnter.Assign(Value);
  Invalidate;
end;

procedure TglCheckBox.SetOffDown(Value: TPicture);
begin
  FOffDown.Assign(Value);
  Invalidate;
end;

procedure TglCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if fCheck then
    fViewState := vsOnDown
  else
    fViewState := vsOffDown;
  repaint;
end;

procedure TglCheckBox.MouseEnter(var Msg: TMessage);
begin
  inherited;
  fFocus := true;
  if fCheck then
    fViewState := vsOnEnter
  else
    fViewState := vsOffEnter;
  repaint;
end;

procedure TglCheckBox.MouseLeave(var Msg: TMessage);
begin
  inherited;
  fFocus := false;
  if fCheck then
    fViewState := vsOnLeave
  else
    fViewState := vsOffLeave;
  repaint;
end;

procedure TglCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if fCheck then
  begin
    if fFocus then
      fViewState := vsOffEnter
    else
      fViewState := vsOffLeave;
    fCheck := false;
  end
  else
  begin
    if fFocus then
      fViewState := vsOnEnter
    else
      fViewState := vsOnLeave;
    fCheck := true;
  end;
  repaint;
end;

procedure Register;
begin
  RegisterComponents('Golden Line', [TglCheckBox]);
end;

end.
