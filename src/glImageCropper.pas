unit glImageCropper;

interface

uses
{$IFDEF VER230} System.SysUtils, WinAPI.Windows, WinAPI.Messages
{$ELSE} Windows, Messages, SysUtils {$ENDIF}, Classes, Controls, JPEG, Graphics;

type
  TglImageCropper = class(TCustomControl)
  private
    fMousePress, fEmpty: boolean;
    FPhoto: TPicture;

    // Для перемещения
    FStartDragX, FStartDragY: integer;

    FRect, FStartRect: TRect;
    fBitmap, fMiniBitmap: TBitmap;
    procedure WMMOUSEWHEEL(var msg: TWMMOUSEWHEEL); message WM_MOUSEWHEEL;
    procedure PictureChanged(Sender: TObject);
    procedure SetPhoto(Value: TPicture);
    procedure DrawMiniBitmap(Scale: boolean);
    procedure ScalingRectUp;
    procedure ScalingRectDown;
    procedure UpdateRect(Value: TRect; Scale: boolean);
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
    function GetThumbnail: TJPEGImage;
  published
    property Photo: TPicture read FPhoto write SetPhoto;
    property TabOrder;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property Align;
    property Color;
    property ParentColor;
    property OnClick;
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
  FPhoto := TPicture.Create;
  FPhoto.OnChange := PictureChanged;
  fBitmap := TBitmap.Create;
  fMiniBitmap := TBitmap.Create;
  Width := 64;
  Height := 64;
end;

destructor TglImageCropper.Destroy;
begin
  FPhoto.Free;
  fBitmap.Free;
  fMiniBitmap.Free;
  inherited;
end;

procedure TglImageCropper.DrawMiniBitmap;
begin
  SetStretchBltMode(fMiniBitmap.Canvas.Handle, STRETCH_DELETESCANS);
  fMiniBitmap.Canvas.CopyRect(Bounds(0, 0, fMiniBitmap.Width,
    fMiniBitmap.Height), fBitmap.Canvas, FRect);
end;

procedure TglImageCropper.FreePhoto;
begin
  if FPhoto <> nil then
    FPhoto := nil;
  fEmpty := true;
end;

function TglImageCropper.GetThumbnail;
var
  nanoBMP: TBitmap;
begin
  nanoBMP := TBitmap.Create;
  nanoBMP.SetSize(115, 145);
  SetStretchBltMode(nanoBMP.Canvas.Handle, HALFTONE);
  nanoBMP.Canvas.StretchDraw(Rect(0, 0, 115, 145), fMiniBitmap);
  Result := TJPEGImage.Create;
  Result.Assign(nanoBMP);
end;

function TglImageCropper.isEmpty: boolean;
begin
  Result := fEmpty;
end;

procedure TglImageCropper.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  fMousePress := true;
  FStartDragX := X;
  FStartDragY := Y;
  FStartRect := FRect;
end;

procedure TglImageCropper.MouseMove(Shift: TShiftState; X, Y: integer);
var
  fTemp: integer;
  Rect: TRect;
begin
  inherited;
  if fMousePress then
  begin
    Rect := FRect;
    fTemp := FStartRect.Left + (FStartDragX - X);
    if (fTemp > -1) and (abs(fTemp) < (fBitmap.Width - fMiniBitmap.Width)) then
    begin
      Rect.Left := FStartRect.Left + (FStartDragX - X);
      Rect.Right := FStartRect.Right + (FStartDragX - X);
    end;

    fTemp := FStartRect.Top + (FStartDragY - Y);
    if (fTemp > -1) and
      (abs(fTemp) < (fBitmap.Height - fMiniBitmap.Height)) then
    begin
      Rect.Top := FStartRect.Top + (FStartDragY - Y);
      Rect.Bottom := FStartRect.Bottom + (FStartDragY - Y);
    end;
    UpdateRect(Rect, false);
  end;
end;

procedure TglImageCropper.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  fMousePress := false;
end;

procedure TglImageCropper.Paint;
begin
  inherited Paint;
  if (csDesigning in ComponentState) then
  begin
    Canvas.Pen.Color := clGray;
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, Width, Height);
  end;
  Canvas.Pen.Color := Color;
  Canvas.Brush.Color := Color;
  Canvas.Rectangle(BoundsRect);
  Canvas.Draw(0, 0, fMiniBitmap);
end;

procedure TglImageCropper.PictureChanged(Sender: TObject);
begin
  fBitmap.SetSize(FPhoto.Width, FPhoto.Height);
  fBitmap.Canvas.Draw(0, 0, FPhoto.Graphic);
  fMiniBitmap.SetSize(Self.Width, Self.Height);

  if fBitmap.Empty then
  begin
    fMiniBitmap.Canvas.Pen.Color := Color;
    fMiniBitmap.Canvas.Brush.Color := Color;
    fMiniBitmap.Canvas.Rectangle(BoundsRect);
    fEmpty := true;
  end
  else
  begin
    UpdateRect(Bounds((fBitmap.Width div 2) - (fMiniBitmap.Width div 2),
      (fBitmap.Height div 2) - (fMiniBitmap.Height div 2), fMiniBitmap.Width,
      fMiniBitmap.Height), false);
    fEmpty := false;
  end;
  invalidate;
end;

procedure TglImageCropper.ScalingRectDown;
var
  Rect: TRect;
  differenceX, differenceY: integer;
begin
  Rect := FRect;
  differenceX := (Rect.Right - Rect.Left) * 5 div 100;
  Rect.Left := Rect.Left + differenceX;
  Rect.Right := Rect.Right - differenceX;

  differenceY := (Rect.Bottom - Rect.Top) * 5 div 100;
  Rect.Top := Rect.Top + differenceY;
  Rect.Bottom := Rect.Bottom - differenceY;

  UpdateRect(Rect, true);
end;

procedure TglImageCropper.ScalingRectUp;
var
  Rect: TRect;
  differenceX, differenceY: integer;
begin
  Rect := FRect;
  differenceX := (Rect.Right - Rect.Left) * 5 div 100;
  Rect.Left := Rect.Left - differenceX;
  Rect.Right := Rect.Right + differenceX;

  differenceY := (Rect.Bottom - Rect.Top) * 5 div 100;
  Rect.Top := Rect.Top - differenceY;
  Rect.Bottom := Rect.Bottom + differenceY;

  UpdateRect(Rect, true);
end;

procedure TglImageCropper.SetPhoto(Value: TPicture);
begin
  FPhoto.Assign(Value);
end;

procedure TglImageCropper.UpdateRect;
begin
  // if Value <> FRect then
  // begin
  if (Value.Left >= 0) and (Value.Top >= 0) and (Value.Right <= fBitmap.Width)
    and (Value.Top <= fBitmap.Height) then
  begin
    FRect := Value;
    DrawMiniBitmap(Scale);
    invalidate;
  end;
  // end;
end;

procedure TglImageCropper.WMMOUSEWHEEL(var msg: TWMMOUSEWHEEL);
begin
  inherited;
  if not(csDesigning in ComponentState) then
  begin
    if msg.WheelDelta > 0 then
      ScalingRectDown
    else
      ScalingRectUp;
  end;
end;

end.
