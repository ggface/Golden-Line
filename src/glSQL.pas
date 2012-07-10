unit glSQL;

interface

uses
  System.SysUtils, System.Classes;

type
  TglSQLQuery = class(TCollectionItem)
  private
    fSQL: TStringList;
  protected
    procedure SetSQL(value: TStringList);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property SQL: TStringList read fSQL write SetSQL;
  end;

  TglSQL = class;
  TItemChangeEvent = procedure(Item: TCollectionItem) of object;

  TSQLCollection = class(TCollection)
  private
    fMainSQL: TglSQL;
    fOnItemChange: TItemChangeEvent;
    function GetItem(Index: Integer): TglSQLQuery;
    procedure SetItem(Index: Integer; const value: TglSQLQuery);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    procedure DoItemChange(Item: TCollectionItem); dynamic;
  public
    constructor Create(Owner: TglSQL);
    function Add: TglSQLQuery;
    property Items[Index: Integer]: TglSQLQuery read GetItem
      write SetItem; default;
  published
    property OnItemChange: TItemChangeEvent read fOnItemChange
      write fOnItemChange;
  end;

  TglSQL = class(TComponent)
  private
    fSQLCollection: TSQLCollection;
    procedure SetSQLCollection(const value: TSQLCollection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property QueryBox: TSQLCollection read fSQLCollection
      write SetSQLCollection;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Golden Line', [TglSQL]);
end;

{ TglSQLQuery }

constructor TglSQLQuery.Create(Collection: TCollection);
begin
  inherited;
  fSQL := TStringList.Create;
end;

destructor TglSQLQuery.Destroy;
begin
  fSQL.Free;
  inherited;
end;

procedure TglSQLQuery.SetSQL(value: TStringList);
begin
  if (fSQL <> value) then
  begin
    fSQL := value;
    Changed(False);
  end;
end;

{ TSQLCollection }

function TSQLCollection.Add: TglSQLQuery;
begin
  Result := TglSQLQuery(inherited Add);
end;

constructor TSQLCollection.Create(Owner: TglSQL);
begin
  inherited Create(TglSQLQuery);
  fMainSQL := Owner;
end;

procedure TSQLCollection.DoItemChange(Item: TCollectionItem);
begin
  if Assigned(fOnItemChange) then
    fOnItemChange(Item);
end;

function TSQLCollection.GetItem(Index: Integer): TglSQLQuery;
begin
  Result := TglSQLQuery(inherited GetItem(Index));
end;

function TSQLCollection.GetOwner: TPersistent;
begin
  Result := fMainSQL;
end;

procedure TSQLCollection.SetItem(Index: Integer; const value: TglSQLQuery);
begin
  inherited SetItem(Index, value);
end;

procedure TSQLCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  DoItemChange(Item);
end;

{ TglSQL }

constructor TglSQL.Create(AOwner: TComponent);
begin
  inherited;
  fSQLCollection := TSQLCollection.Create(Self);
end;

destructor TglSQL.Destroy;
begin
  fSQLCollection.Free;
  inherited;
end;

procedure TglSQL.SetSQLCollection(const value: TSQLCollection);
begin
  fSQLCollection.Assign(value);
end;

end.
