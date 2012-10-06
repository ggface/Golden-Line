unit glConnect;

interface

uses
  SysUtils, Classes, {$IFDEF VER230} Data.Win.ADODB, System.Win.ComObj
{$ELSE} ADODB, ComObj {$ENDIF}, Variants;

type
  TglConnect = class(TComponent)
  public
    procedure ADOConnectionExecute(Item: TADOConnection;
      FileName, Password: string);
    procedure ADOCE(Item: TADOConnection; FileName, Password: string);
    procedure ADOTableExecute(Item: TADOTable;
      TableName, FileName, Password: string);
    procedure ADOTE(Item: TADOTable; TableName, FileName, Password: string);
    function CreateAccessDatabase(FileName, Password: string): string;
    procedure ADOQueryExecute(Item: TADOQuery; FileName, Password: string);
    procedure ADOQE(Item: TADOQuery; FileName, Password: string);
    procedure ADOQueryOpen(Item: TADOQuery; FileName, Password: string);
    procedure ADOQO(Item: TADOQuery; FileName, Password: string);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Golden Line', [TglConnect]);
end;

{ TglConnect }

procedure TglConnect.ADOCE(Item: TADOConnection; FileName, Password: string);
begin
  ADOConnectionExecute(Item, FileName, Password);
end;

procedure TglConnect.ADOConnectionExecute(Item: TADOConnection;
  FileName, Password: string);
begin
  Item.Close;
  Item.LoginPrompt := false;
  Item.ConnectionString := #80#114#111#118#105#100#101#114#61#77#105#99 +
    #114#111#115#111#102#116#46#74#101#116#46#79#76#69#68#66#46#52#46#48 +
    #59#68#97#116#97#32#83#111#117#114#99#101#61 + FileName + #59#74#101 +
    #116#32#79#76#69#68#66#58#68#97#116#97#98#97#115#101#32#80#97#115#115 +
    #119#111#114#100#61 + Password + ';';
  Item.Open;
end;

procedure TglConnect.ADOQE(Item: TADOQuery; FileName, Password: string);
begin
  ADOQueryExecute(Item, FileName, Password);
end;

procedure TglConnect.ADOQO(Item: TADOQuery; FileName, Password: string);
begin
  ADOQueryOpen(Item, FileName, Password);
end;

procedure TglConnect.ADOQueryExecute(Item: TADOQuery;
  FileName, Password: string);
begin
  Item.ConnectionString := #80#114#111#118#105#100#101#114#61#77#105#99 +
    #114#111#115#111#102#116#46#74#101#116#46#79#76#69#68#66#46#52#46#48 +
    #59#68#97#116#97#32#83#111#117#114#99#101#61 + FileName + #59#74#101 +
    #116#32#79#76#69#68#66#58#68#97#116#97#98#97#115#101#32#80#97#115#115 +
    #119#111#114#100#61 + Password + ';';
  Item.ExecSQL;
end;

procedure TglConnect.ADOQueryOpen(Item: TADOQuery; FileName, Password: string);
begin
  Item.ConnectionString := #80#114#111#118#105#100#101#114#61#77#105#99 +
    #114#111#115#111#102#116#46#74#101#116#46#79#76#69#68#66#46#52#46#48 +
    #59#68#97#116#97#32#83#111#117#114#99#101#61 + FileName + #59#74#101 +
    #116#32#79#76#69#68#66#58#68#97#116#97#98#97#115#101#32#80#97#115#115 +
    #119#111#114#100#61 + Password + ';';
  Item.Open;
end;

procedure TglConnect.ADOTableExecute(Item: TADOTable;
  TableName, FileName, Password: string);
begin
  Item.Close;
  Item.ConnectionString := #80#114#111#118#105#100#101#114#61#77#105#99 +
    #114#111#115#111#102#116#46#74#101#116#46#79#76#69#68#66#46#52#46#48 +
    #59#68#97#116#97#32#83#111#117#114#99#101#61 + FileName + #59#74#101 +
    #116#32#79#76#69#68#66#58#68#97#116#97#98#97#115#101#32#80#97#115#115 +
    #119#111#114#100#61 + Password + ';';
  Item.TableName := TableName;
  Item.Open;
end;

procedure TglConnect.ADOTE(Item: TADOTable;
  TableName, FileName, Password: string);
begin
  ADOTableExecute(Item, TableName, FileName, Password);
end;

function TglConnect.CreateAccessDatabase(FileName, Password: string): string;
var
  cat: OLEVariant;
begin
  Result := '';
  try
    cat := CreateOleObject(#65#68#79#88#46#67#97#116#97#108#111#103);
    cat.Create(#80#114#111#118#105#100#101#114#61#77#105#99#114#111 +
      #115#111#102#116#46#74#101#116#46#79#76#69#68#66#46#52#46#48#59 +
      #68#97#116#97#32#83#111#117#114#99#101#61 + FileName +
      #59#74#101#116#32#79#76#69#68#66#58#68#97#116#97#98#97#115#101 +
      #32#80#97#115#115#119#111#114#100#61 + Password);
    cat := NULL;
  except
    on e: Exception do
      Result := e.message;
  end;
end;

end.
