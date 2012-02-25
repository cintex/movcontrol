object CtrlTypeFrm: TCtrlTypeFrm
  Left = 322
  Top = 178
  BorderStyle = bsDialog
  Caption = 'Controls types selection'
  ClientHeight = 383
  ClientWidth = 497
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblUnselected: TLabel
    Left = 16
    Top = 8
    Width = 54
    Height = 13
    Caption = 'Unselected'
  end
  object lblSelected: TLabel
    Left = 280
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Selected'
  end
  object lstBoxUnselected: TListBox
    Left = 16
    Top = 30
    Width = 200
    Height = 305
    ItemHeight = 13
    TabOrder = 0
  end
  object lstBoxSelected: TListBox
    Left = 280
    Top = 30
    Width = 200
    Height = 305
    ItemHeight = 13
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 409
    Top = 350
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 321
    Top = 350
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnSelect: TButton
    Left = 230
    Top = 32
    Width = 35
    Height = 25
    Caption = '>'
    TabOrder = 4
    OnClick = btnSelectClick
  end
  object btnSelectAll: TButton
    Left = 230
    Top = 64
    Width = 35
    Height = 25
    Caption = '>>'
    TabOrder = 5
    OnClick = btnSelectAllClick
  end
  object btnUnselect: TButton
    Left = 230
    Top = 104
    Width = 35
    Height = 25
    Caption = '<'
    TabOrder = 6
    OnClick = btnUnselectClick
  end
  object btnUnselectAll: TButton
    Left = 230
    Top = 136
    Width = 35
    Height = 25
    Caption = '<<'
    TabOrder = 7
    OnClick = btnUnselectAllClick
  end
end
