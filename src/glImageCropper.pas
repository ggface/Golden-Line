unit glImageCropper;

interface

uses
{$IFDEF VER230} System.SysUtils, WinAPI.Windows, WinAPI.Messages
{$ELSE} Windows, Messages, SysUtils {$ENDIF}, Classes, Controls, JPEG, Graphics;

type
  TglImageCropper = class(TCustomControl)
  private
    fMousePress, fEmpty: boolean;
    fDebug: string;
    fPhoto: TPicture;
    fDrawLeft, fDrawTop, fDragX, fDragY, fX, fY: integer;
    fBitmap, fWorkBitmap, fMiniBitmap: TBitmap;
    procedure WMMOUSEWHEEL(var msg: TWMMOUSEWHEEL); message WM_MOUSEWHEEL;
    procedure PictureChanged(Sender: TObject);
    procedure SetPhoto(Value: TPicture);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure FreePhoto;
    function isEmpty: boolean;
  published
    property Photo: TPicture read fPhoto write SetPhoto;
    property TabOrder;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property Align;
    property Color;
    property ParentColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Golden Line', [TglImageCropper]);
end;

{ TglImageCropper }

constructor TglImageCropper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csAcceptsControls];
  fPhoto := TPicture.Create;
  fPhoto.OnChange := PictureChanged;
  fBitmap := TBitmap.Create;
  fMiniBitmap := TBitmap.Create;
  fWorkBitmap := TBitmap.Create;
  Width := 64;
  Height := 64;
end;

destructor TglImageCropper.Destroy;
begin
  fWorkBitmap.Free;
  fPhoto.Free;
  fBitmap.Free;
  fMiniBitmap.Free;
  inherited;
end;

procedure TglImageCropper.FreePhoto;
begin
  if fPhoto <> nil then
    fPhoto := nil;
  fEmpty := true;
end;

function TglImageCropper.isEmpty: boolean;
begin
  result := fEmpty;
end;

procedure TglImageCropper.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  fMousePress := true;
  fDragX := X;
  fDragY := Y;
end;

procedure TglImageCropper.MouseMove(Shift: TShiftState; X, Y: integer);
var
  fTemp: integer;
begin
  inherited;
  if fMousePress then
  begin
    fTemp := (fDrawLeft - (X - fDragX));
    if (fTemp > -1) and (abs(fTemp) < (fBitmap.Width - fMiniBitmap.Width)) then
      fX := (fDrawLeft - (X - fDragX));

    fTemp := (fDrawTop - (Y - fDragY));
    if (fTemp > -1) and
      (abs(fTemp) < (fBitmap.Height - fMiniBitmap.Height)) then
      fY := (fDrawTop - (Y - fDragY));

    begin
      fMiniBitmap.Canvas.CopyRect(Bounds(0, 0, fMiniBitmap.Width,
        fMiniBitmap.Height), fBitmap.Canvas, Bounds(fX, fY, fMiniBitmap.Width,
        fMiniBitmap.Height));

      invalidate;
    end;
  end;
end;

procedure TglImageCropper.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  fMousePress := False;
  fDrawLeft := fX;
  fDrawTop := fY;
end;

procedure TglImageCropper.Paint;
begin
  if (csDesigning in ComponentState) then
  begin
    Canvas.Pen.Color := clGray;
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, Width, Height);
  end;
  Canvas.Draw(0, 0, fMiniBitmap);
  inherited;
end;

procedure TglImageCropper.PictureChanged(Sender: TObject);
begin

  fBitmap.SetSize(fPhoto.Width, fPhoto.Height);
  fBitmap.Canvas.Draw(0, 0, fPhoto.Graphic);
  fMiniBitmap.SetSize(Self.Width, Self.Height);

  fDrawLeft := (fBitmap.Width div 2) - (fMiniBitmap.Width div 2);
  fDrawTop := (fBitmap.Height div 2) - (fMiniBitmap.Height div 2);
  if fBitmap.Empty then
  begin
    fMiniBitmap.Canvas.Pen.Color := Color;
    fMiniBitmap.Canvas.Brush.Color := Color;
    fMiniBitmap.Canvas.Rectangle(BoundsRect);
    fEmpty := true;
  end
  else
  begin
    fMiniBitmap.Canvas.CopyRect(Bounds(0, 0, fMiniBitmap.Width,
      fMiniBitmap.Height), fBitmap.Canvas, Bounds(fDrawLeft, fDrawTop,
      fMiniBitmap.Width, fMiniBitmap.Height));
    fEmpty := False;
  end;
  invalidate;
end;

procedure TglImageCropper.SetPhoto(Value: TPicture);
begin
  fPhoto.Assign(Value);
end;

procedure TglImageCropper.WMMOUSEWHEEL(var msg: TWMMOUSEWHEEL);
begin
  inherited;
  if not(csDesigning in ComponentState) then
  begin
    if msg.WheelDelta > 0 then
      fDebug := 'up'
    else
      fDebug := 'down';
    invalidate;
  end;
end;

end.
