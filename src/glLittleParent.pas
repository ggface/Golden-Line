unit glLittleParent;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls;

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

  TglLittleParent = class;
  TItemChangeEvent = procedure(Item: TCollectionItem) of object;

  TSQLCollection = class(TCollection)
  private
    fMainSQL: TglLittleParent;
    fOnItemChange: TItemChangeEvent;
    function GetItem(Index: Integer): TglSQLQuery;
    procedure SetItem(Index: Integer; const value: TglSQLQuery);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
    procedure DoItemChange(Item: TCollectionItem); dynamic;
  public
    constructor Create(Owner: TglLittleParent);
    function Add: TglSQLQuery;
    property Items[Index: Integer]: TglSQLQuery read GetItem
      write SetItem; default;
  published
    property OnItemChange: TItemChangeEvent read fOnItemChange
      write fOnItemChange;
  end;
  TglLittleParent = class(TWinControl)
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
  RegisterComponents('Golden Line', [TglLittleParent]);
end;

{ TglLittleParent }

constructor TglLittleParent.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := [csCaptureMouse, csClickEvents, csAcceptsControls];
end;

end.
