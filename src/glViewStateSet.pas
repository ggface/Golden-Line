unit glViewStateSet;

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TNotifyEvent = procedure(Sender: TObject) of object;

  TglViewState = class(TCollectionItem)
  private
    fName: string;
    fOnSetViewState: TNotifyEvent;
    procedure SetName(const Value: string);
  protected
    procedure SetViewState; dynamic;
  published
    property Name: string read fName write SetName;
    property OnSetViewState: TNotifyEvent read fOnSetViewState
      write fOnSetViewState;
  end;

  TglViewStateSet = class;
  TItemChangeEvent = procedure(Item: TCollectionItem) of object;

  TglViewStates = class(TCollection)
  private
    fViewStates: TglViewStateSet;
    FOnItemChange: TItemChangeEvent;
    function GetItem(Index: Integer): TglViewState;
    procedure SetItem(Index: Integer; const Value: TglViewState);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    procedure DoItemChange(Item: TCollectionItem); dynamic;
  public
    constructor Create(DappledShape: TglViewStateSet);
    function Add: TglViewState;
    property Items[Index: Integer]: TglViewState read GetItem
      write SetItem; default;
  published
    property Count;
    property OnItemChange: TItemChangeEvent read FOnItemChange
      write FOnItemChange;
  end;

  TglViewStateSet = class(TComponent)
  private
    fViewStates: TglViewStates;
    fOnAfterSetViewState, fOnBeforeSetViewState: TNotifyEvent;
    procedure SetViewStates(const Value: TglViewStates);
  protected
    procedure AfterSetViewState; dynamic;
    procedure BeforeSetViewState; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ViewStateByName(Name: string): TglViewState;
    procedure ActiveByName(Name: string);
  published
    property ViewStates: TglViewStates read fViewStates write SetViewStates;
    property OnAfterSetViewState: TNotifyEvent read fOnAfterSetViewState
      write fOnAfterSetViewState;
    property OnBeforeSetViewState: TNotifyEvent read fOnBeforeSetViewState
      write fOnBeforeSetViewState;
  end;

procedure Register;

implementation

//{$R glViewStateSet}

procedure Register;
begin
  RegisterComponents('Golden Line', [TglViewStateSet]);
end;

{ TglViewState }

procedure TglViewState.SetName(const Value: string);
begin
  if fName <> Value then
  begin
    fName := Value;
    Changed(False)
  end;
end;

procedure TglViewState.SetViewState;
begin
  if Assigned(fOnSetViewState) then
    fOnSetViewState(Self);
end;

{ TglViewStates }

function TglViewStates.Add: TglViewState;
begin
  Result := TglViewState( inherited Add)
end;

constructor TglViewStates.Create(DappledShape: TglViewStateSet);
begin
  inherited Create(TglViewState);
  fViewStates := DappledShape
end;

procedure TglViewStates.DoItemChange(Item: TCollectionItem);
begin
  if Assigned(FOnItemChange) then
    FOnItemChange(Item)
end;

function TglViewStates.GetItem(Index: Integer): TglViewState;
begin
  Result := TglViewState( inherited GetItem(Index))
end;

function TglViewStates.GetOwner: TPersistent;
begin
  Result := fViewStates
end;

procedure TglViewStates.SetItem(Index: Integer; const Value: TglViewState);
begin
  inherited SetItem(Index, Value)
end;

procedure TglViewStates.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  DoItemChange(Item)
end;

{ TglViewStateSet }

procedure TglViewStateSet.ActiveByName(Name: string);
var
  a: Integer;
begin
  for a := 0 to fViewStates.Count - 1 do
    if fViewStates.Items[a].fName = Name then
    begin
      BeforeSetViewState;
      fViewStates.Items[a].SetViewState;
      AfterSetViewState;
      exit;
    end;
end;

procedure TglViewStateSet.AfterSetViewState;
begin
  if Assigned(fOnAfterSetViewState) then
    fOnAfterSetViewState(Self);
end;

procedure TglViewStateSet.BeforeSetViewState;
begin
  if Assigned(fOnBeforeSetViewState) then
    fOnBeforeSetViewState(Self);
end;

constructor TglViewStateSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fViewStates := TglViewStates.Create(Self)
end;

destructor TglViewStateSet.Destroy;
begin
  fViewStates.Free;
  inherited Destroy
end;

procedure TglViewStateSet.SetViewStates(const Value: TglViewStates);
begin
  fViewStates.Assign(Value)
end;

function TglViewStateSet.ViewStateByName(Name: string): TglViewState;
var
  a: Integer;
begin
  Result := nil;
  for a := 0 to fViewStates.Count - 1 do
    if fViewStates.Items[a].fName = Name then
      Result := fViewStates.Items[a];
end;

end.
