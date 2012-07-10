unit glHandle;

interface

uses
  Classes, Controls, Windows, Messages, Graphics;

type
  TglHandle = class(TGraphicControl)
  private
    fEN, fReadOnlyBool: Boolean;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure SetMyEnabled(value: Boolean); virtual;
  public
  published
    property Align;
    property HelpContext: Boolean read fReadOnlyBool;
    property HelpKeyword: Boolean read fReadOnlyBool;
    property HelpType: Boolean read fReadOnlyBool;
    property Tag: Boolean read fReadOnlyBool;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property Enabled: Boolean read fEN write SetMyEnabled;
  end;

procedure Register;

implementation

//{$R glHandle}

procedure Register;
begin
  RegisterComponents('Golden Line', [TglHandle]);
end;

procedure TglHandle.SetMyEnabled(value: Boolean);
begin
  fEN := value;
  invalidate;
end;

procedure TglHandle.Paint;
begin
  if (csDesigning in ComponentState) then
  begin
    Canvas.brush.Style := bsFDiagonal;
    Canvas.Rectangle(0, 0, width, height);
  end;
end;

procedure TglHandle.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
const
  SC_DRAGMOVE: Longint = $F012;
begin
  if fEN then
  begin
    ReleaseCapture;
    SendMessage(TglHandle(self).Parent.Handle, WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
  inherited;
end;

end.
