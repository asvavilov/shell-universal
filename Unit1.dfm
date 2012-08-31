object frm: Tfrm
  Left = 195
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1054#1073#1086#1083#1086#1095#1082#1072' '#1076#1080#1089#1082#1072
  ClientHeight = 388
  ClientWidth = 465
  Color = 16776176
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 14
  object Bevel2: TBevel
    Left = 344
    Top = 32
    Width = 105
    Height = 25
    Shape = bsLeftLine
  end
  object Bevel1: TBevel
    Left = 344
    Top = 32
    Width = 105
    Height = 25
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 192
    Top = 120
    Width = 265
    Height = 17
    AutoSize = False
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
    Color = clLime
    ParentColor = False
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 69
    Height = 25
    AutoSize = False
    Caption = #1043#1088#1091#1087#1087#1072':'
    Color = clLime
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label3: TLabel
    Left = 192
    Top = 64
    Width = 265
    Height = 16
    AutoSize = False
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
    Color = clLime
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object cdBrowse: TSpeedButton
    Left = 344
    Top = 32
    Width = 105
    Height = 25
    Caption = #1054#1073#1079#1086#1088' '#1076#1080#1089#1082#1072
    Flat = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = cdBrowseClick
  end
  object Label4: TLabel
    Left = 8
    Top = 64
    Width = 169
    Height = 17
    AutoSize = False
    Caption = #1056#1077#1089#1091#1088#1089#1099' '#1076#1080#1089#1082#1072':'
    Color = clLime
    ParentColor = False
  end
  object group: TComboBox
    Left = 8
    Top = 32
    Width = 265
    Height = 24
    Style = csDropDownList
    Enabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 2
    OnClick = groupClick
    Items.Strings = (
      '< '#1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' >')
  end
  object comment: TMemo
    Left = 192
    Top = 136
    Width = 265
    Height = 89
    TabStop = False
    BevelKind = bkTile
    BevelOuter = bvRaised
    Color = clInfoBk
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object name: TEdit
    Left = 192
    Top = 80
    Width = 265
    Height = 24
    TabStop = False
    BevelKind = bkFlat
    Color = clInfoBk
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 3
  end
  object actions: TGroupBox
    Left = 192
    Top = 240
    Width = 265
    Height = 137
    Caption = #1044#1077#1081#1089#1090#1074#1080#1103
    Color = 16776176
    ParentColor = False
    TabOrder = 5
  end
  object visibleAll: TCheckBox
    Left = 88
    Top = 8
    Width = 137
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1077
    Checked = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    State = cbChecked
    TabOrder = 1
    OnClick = visibleAllClick
  end
  object resList: TListBox
    Left = 8
    Top = 80
    Width = 169
    Height = 297
    BevelKind = bkFlat
    ItemHeight = 14
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = resListClick
  end
end
