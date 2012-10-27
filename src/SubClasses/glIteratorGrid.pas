unit glIteratorGrid;

interface

type
  TglIteratorGrid = class
  private
    FWidth, FFirstX, fFirstY, FCurrentX, FCurrentY: Integer;
  public
    constructor Create(Width, FirstX, FirstY: Integer);

    procedure New(Width, FirstX, FirstY: Integer);
    procedure Up;

    property Width: Integer read FWidth;
    property CurrentX: Integer read FCurrentX;
    property CurrentY: Integer read FCurrentY;
  end;

implementation

{ TglIteratorGrid }

constructor TglIteratorGrid.Create;
begin
  New(Width, FirstX, FirstY);
end;

procedure TglIteratorGrid.New(Width, FirstX, FirstY: Integer);
begin
  FWidth := Width;
  FFirstX := FirstX;
  fFirstY := FirstY;

  FCurrentX := FFirstX;
  FCurrentY := FirstY;
end;

procedure TglIteratorGrid.Up;
begin
  if FCurrentX <> FWidth then
  begin
    inc(FCurrentX);
  end
  else
  begin
    inc(FCurrentY);
    FCurrentX := FFirstX;
  end;
end;

end.
