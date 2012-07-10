unit glCustomObject;

interface

uses
  SysUtils, Classes, Controls, Graphics, {$IFDEF VER230} WinAPI.Messages
{$ELSE} Messages {$ENDIF};

type
  TglCustomObject = class(TGraphicControl)
  private
    fCaption: TCaption;
    fReadOnlyBool, fEnabled: Boolean;
    FOnMouseLeave, FOnMouseEnter: TNotifyEvent;
    procedure CMMouseEnter(var msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage); message CM_MOUSELEAVE;
    procedure SetCaption(value: TCaption); virtual;
    procedure SetMyEnabled(value: Boolean);
  protected
    procedure Paint; override;
    procedure DoMouseEnter; dynamic;
    procedure DoMouseLeave; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property Font;
    property Visible;
    property Align;
    property Anchors;
    property Enabled: Boolean read fEnabled write SetMyEnabled default true;
    property Caption: TCaption read fCaption write SetCaption;
    property HelpContext: Boolean read fReadOnlyBool;
    property HelpKeyword: Boolean read fReadOnlyBool;
    property HelpType: Boolean read fReadOnlyBool;
  end;

implementation

procedure TglCustomObject.CMMouseEnter(var msg: TMessage);
begin
  DoMouseEnter;
end;

procedure TglCustomObject.CMMouseLeave(var msg: TMessage);
begin
  DoMouseLeave;
end;

constructor TglCustomObject.Create(AOwner: TComponent);
begin
  inherited;
  Width := 64;
  Height := 64;
  Canvas.Font := Font;
  Canvas.Brush.Style := bsClear;
end;

procedure TglCustomObject.DoMouseEnter;
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;

procedure TglCustomObject.DoMouseLeave;
begin
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

procedure TglCustomObject.Paint;
begin
  inherited;
  if (csDesigning in ComponentState) then
  begin
    Canvas.Pen.Color := clGray;
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, Width, Height);
  end;
  Canvas.TextOut((Width - Canvas.TextWidth(fCaption)) div 2,
    (Height - Canvas.TextHeight(fCaption)) div 2, fCaption);
end;

procedure TglCustomObject.SetCaption(value: TCaption);
begin
  fCaption := value;
  Invalidate;
end;

procedure TglCustomObject.SetMyEnabled(value: Boolean);
begin
  fEnabled := value;
  Invalidate;
end;

end.
