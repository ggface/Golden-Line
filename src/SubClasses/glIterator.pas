unit glIterator;

interface

type
  TglIterator = class
  private
    FValue, FDefault: Integer;
  public
    property DefaultValue: Integer read FDefault write FDefault;
    property Value: Integer read FValue;

    constructor Create; overload;
    constructor Create(StartValue: Integer); overload;
    constructor Create(StartValue, DefaultValue: Integer); overload;

    procedure Up;
    procedure Down;
    procedure New;
  end;

implementation

{ TglIterator }

constructor TglIterator.Create;
begin
  FDefault := 0;
  New;
end;

constructor TglIterator.Create(StartValue: Integer);
begin
  FDefault := 0;
  FValue := StartValue;
end;

constructor TglIterator.Create(StartValue, DefaultValue: Integer);
begin
  FDefault := DefaultValue;
  FValue := StartValue;
end;

procedure TglIterator.Down;
begin
  Dec(FValue);
end;

procedure TglIterator.New;
begin
  FValue := FDefault;
end;

procedure TglIterator.Up;
begin
  Inc(FValue);
end;

end.
