object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'glIteratorGrid Example'
  ClientHeight = 377
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 303
    Top = 8
    Width = 29
    Height = 13
    Caption = 'Count'
  end
  object lbl2: TLabel
    Left = 303
    Top = 49
    Width = 40
    Height = 13
    Caption = 'Columns'
  end
  object mmo1: TMemo
    Left = 8
    Top = 8
    Width = 289
    Height = 360
    Lines.Strings = (
      'mmo1')
    TabOrder = 0
  end
  object btn1: TButton
    Left = 303
    Top = 89
    Width = 138
    Height = 25
    Caption = 'Fill'
    TabOrder = 1
    OnClick = btn1Click
  end
  object ud1: TUpDown
    Left = 425
    Top = 22
    Width = 16
    Height = 21
    Associate = edt1
    Position = 8
    TabOrder = 2
  end
  object ud2: TUpDown
    Left = 425
    Top = 62
    Width = 16
    Height = 21
    Associate = edt2
    Position = 3
    TabOrder = 3
  end
  object edt1: TEdit
    Left = 303
    Top = 22
    Width = 122
    Height = 21
    TabOrder = 4
    Text = '8'
  end
  object edt2: TEdit
    Left = 303
    Top = 62
    Width = 122
    Height = 21
    TabOrder = 5
    Text = '3'
  end
end
