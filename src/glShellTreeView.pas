unit glShellTreeView;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ComCtrls, Windows;

type
  TglShellTreeView = class(TCustomTreeView)
  private
    FRemovable, FFixed, FRemote, FCDROM, FUnknown: integer;

    function SrNodeTree(pTreeNode: TTreeNode; var sRuta: string): string;
    function DirectoryName(name: string): Boolean;
    procedure NextLevel(ParentNode: TTreeNode);
  protected
    function CanExpand(Node: TTreeNode): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure MakeTree;
    function GetPath: string;
  published
    property ImageIndexRemovable: integer read FRemovable write FRemovable;
    property ImageIndexFixed: integer read FFixed write FFixed;
    property ImageIndexRemote: integer read FRemote write FRemote;
    property ImageIndexCDROM: integer read FCDROM write FCDROM;
    property ImageIndexUnknown: integer read FUnknown write FUnknown;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Golden Line', [TglShellTreeView]);
end;

{ TglShellTreeView }

function TglShellTreeView.CanExpand(Node: TTreeNode): Boolean;
begin
  result := inherited CanExpand(Node);
  if result then
  begin
    Items.BeginUpdate;
    Node.DeleteChildren;
    NextLevel(Node);
    Items.EndUpdate;
  end;
end;

constructor TglShellTreeView.Create(AOwner: TComponent);
begin
  inherited;
  MakeTree;
end;

function TglShellTreeView.DirectoryName(name: string): Boolean;
begin
  result := (name <> '.') and (name <> '..');
end;

function TglShellTreeView.GetPath: string;
var
  s: string;
begin
  result := SrNodeTree(Selected, s);
end;

procedure TglShellTreeView.MakeTree;
var
  c: Char;
  s: string;
  Node: TTreeNode;
  DriveType: integer;
begin
  inherited;
  Items.BeginUpdate;
  for c := 'A' to 'Z' do
  begin
    s := c + ':';
    DriveType := GetDriveType(PChar(s));
    if DriveType = DRIVE_NO_ROOT_DIR then
      Continue;
    Node := Items.AddChild(nil, s);
    case DriveType of
      DRIVE_REMOVABLE:
        Node.ImageIndex := FRemovable;
      DRIVE_FIXED:
        Node.ImageIndex := FFixed;
      DRIVE_REMOTE:
        Node.ImageIndex := FRemote;
      DRIVE_CDROM:
        Node.ImageIndex := FCDROM;
    else
      Node.ImageIndex := FUnknown;
    end;
    Node.SelectedIndex := Node.ImageIndex;
    Node.HasChildren := true;
  end;
  Items.EndUpdate;
end;

procedure TglShellTreeView.NextLevel(ParentNode: TTreeNode);
var
  sr, srChild: TSearchRec;
  Node: TTreeNode;
  path: string;
begin
  Node := ParentNode;
  path := '';
  repeat
    path := Node.Text + '\' + path;
    Node := Node.Parent;
  until Node = nil;
  if FindFirst(path + '*.*', faDirectory, sr) = 0 then
  begin
    repeat
      if (sr.Attr and faDirectory <> 0) and DirectoryName(sr.name) then
      begin
        Node := Items.AddChild(ParentNode, sr.name);
        Node.ImageIndex := 2;
        Node.SelectedIndex := 1;
        Node.HasChildren := false;
        if FindFirst(path + sr.name + '\*.*', faDirectory, srChild) = 0 then
        begin
          repeat
            if (srChild.Attr and faDirectory <> 0) and
              DirectoryName(srChild.name) then
              Node.HasChildren := true;
          until (FindNext(srChild) <> 0) or Node.HasChildren;
        end;
        System.SysUtils.FindClose(srChild);
      end;
    until FindNext(sr) <> 0;
  end
  else
    ParentNode.HasChildren := false;
  System.SysUtils.FindClose(sr);
end;

function TglShellTreeView.SrNodeTree(pTreeNode: TTreeNode;
  var sRuta: string): string;
begin
  sRuta := pTreeNode.Text + '\' + sRuta;
  if pTreeNode.Level = 0 then
    result := sRuta
  else
    result := SrNodeTree(pTreeNode.Parent, sRuta);
end;

end.
