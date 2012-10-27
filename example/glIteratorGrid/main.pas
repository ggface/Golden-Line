unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TMainForm = class(TForm)
    mmo1: TMemo;
    btn1: TButton;
    ud1: TUpDown;
    ud2: TUpDown;
    edt1: TEdit;
    edt2: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses glIteratorGrid;

{$R *.dfm}

procedure TMainForm.btn1Click(Sender: TObject);
var
  // glI: TglIterator;
  i: Integer;
  glIG: TglIteratorGrid;
begin
  LockWindowUpdate(MainForm.Handle);
  mmo1.Clear;
  glIG := TglIteratorGrid.Create(ud2.Position, 1, 1);
  try
    try
      for i := 0 to ud1.Position - 1 do
      begin
        mmo1.Lines.Add('(' + IntToStr(glIG.CurrentX) + ',' +
          IntToStr(glIG.CurrentY) + ')');
        glIG.Up;
      end;
    except
      on E: Exception do
        ShowMessage(E.ClassName + ' поднята ошибка, с сообщением : ' +
          E.Message);
    end
  finally
    glIG.Free;
  end;
  LockWindowUpdate(0);
end;

end.
