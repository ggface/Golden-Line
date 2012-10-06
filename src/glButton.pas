unit glButton;

interface

uses
{$IFDEF VER230} WinAPI.Windows, WinAPI.Messages {$ELSE} Windows, Messages
{$ENDIF}, SysUtils, Classes, Controls, Graphics, glCustomObject,
  PNGimage, glButtonPattern;

type
  TglButton = class(TglCustomObject)
  private
    fViewState: byte;
    fLeave, fEnter, fDown: TPicture;
    function isEmpty(var value: TPicture): boolean;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseEnter(var Msg: TMessage); message cm_mouseEnter;
    procedure MouseLeave(var Msg: TMessage); message cm_mouseLeave;
    procedure SetLeaveImage(value: TPicture); virtual;
    procedure SetEnterImage(value: TPicture); virtual;
    procedure SetDownImage(value: TPicture); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Assign(value: TglButtonPattern);
  published
    property ImageLeave: TPicture read fLeave write SetLeaveImage;
    property ImageEnter: TPicture read fEnter write SetEnterImage;
    property ImageDown: TPicture read fDown write SetDownImage;
    property OnMouseEnter;
    property OnMouseLeave;
  end;

procedure Register;

implementation

const
  vsLeave = 0;
  vsEnter = 1;
  vsDown = 2;

procedure Register;
begin
  RegisterComponents('Golden Line', [TglButton]);
end;

procedure TglButton.Assign(value: TglButtonPattern);
begin
  fDown.Assign(value.ImageDown);
  fLeave.Assign(value.ImageLeave);
  fEnter.Assign(value.ImageEnter);
  Invalidate;
end;

constructor TglButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fLeave := TPicture.Create;
  fEnter := TPicture.Create;
  fDown := TPicture.Create;
end;

destructor TglButton.Destroy;
begin
  inherited Destroy;
  fDown.Free;
  fEnter.Free;
  fLeave.Free;
end;

function TglButton.isEmpty(var value: TPicture): boolean;
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  value.Graphic.SaveToStream(m);
  if m.Size > 0 then
    result := false
  else
    result := true;
  FreeAndNil(m);
end;

procedure TglButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  fViewState := vsDown;
  repaint;
end;

procedure TglButton.MouseEnter(var Msg: TMessage);
begin
  fViewState := vsEnter;
  repaint;
end;

procedure TglButton.MouseLeave(var Msg: TMessage);
begin
  fViewState := vsLeave;
  repaint;
end;

procedure TglButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  repaint;
end;

procedure TglButton.Paint;
begin
  case fViewState of
    0:
      Canvas.Draw(0, 0, fLeave.Graphic);
    1:
      begin
        if Assigned(fEnter.Graphic) then
          Canvas.Draw(0, 0, fEnter.Graphic)
        else
          Canvas.Draw(0, 0, fLeave.Graphic);
      end;
    2:
      begin
        if Assigned(fDown.Graphic) then
          Canvas.Draw(0, 0, fDown.Graphic)
        else if Assigned(fEnter.Graphic) then
          Canvas.Draw(0, 0, fEnter.Graphic)
        else
          Canvas.Draw(0, 0, fLeave.Graphic);
      end;
  end;
  inherited;
end;

procedure TglButton.SetDownImage(value: TPicture);
begin
  fDown.Assign(value);
  Invalidate;
end;

procedure TglButton.SetEnterImage(value: TPicture);
begin
  fEnter.Assign(value);
  Invalidate;
end;

procedure TglButton.SetLeaveImage(value: TPicture);
begin
  fLeave.Assign(value);
  Invalidate;
end;

end.
