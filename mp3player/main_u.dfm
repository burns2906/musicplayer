object Form1: TForm1
  Left = 199
  Top = 123
  Width = 1002
  Height = 572
  Caption = 'Musicplayer (C) Burns Club Lerchenfelderheim'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbltitel: TLabel
    Left = 643
    Top = 8
    Width = 3
    Height = 13
  end
  object lbltime: TLabel
    Left = 608
    Top = 40
    Width = 3
    Height = 13
  end
  object mainScrollBar: TScrollBar
    Left = 632
    Top = 72
    Width = 281
    Height = 25
    PageSize = 0
    TabOrder = 0
    OnScroll = mainScrollBarScroll
  end
  object volumeScrollBar: TScrollBar
    Left = 928
    Top = 8
    Width = 33
    Height = 89
    Kind = sbVertical
    PageSize = 0
    TabOrder = 1
    OnScroll = volumeScrollBarScroll
  end
  object ListBox1: TListBox
    Left = 192
    Top = 496
    Width = 33
    Height = 25
    ItemHeight = 13
    TabOrder = 2
    Visible = False
  end
  object ListBox2: TListBox
    Left = 632
    Top = 136
    Width = 329
    Height = 337
    DragMode = dmAutomatic
    ItemHeight = 13
    TabOrder = 3
    OnDblClick = ListBox2DblClick
    OnDragDrop = ListBox2DragDrop
    OnDragOver = ListBox2DragOver
    OnKeyDown = ListBox2KeyDown
    OnMouseDown = ListBox2MouseDown
  end
  object ListBox3: TListBox
    Left = 8
    Top = 88
    Width = 393
    Height = 393
    DragMode = dmAutomatic
    ItemHeight = 13
    TabOrder = 4
    OnDblClick = ListBox3DblClick
    OnKeyDown = ListBox3KeyDown
    OnMouseDown = ListBox3MouseDown
  end
  object Edit2: TEdit
    Left = 104
    Top = 24
    Width = 153
    Height = 21
    TabOrder = 5
    OnKeyUp = Edit2KeyUp
  end
  object btn_up: TButton
    Left = 368
    Top = 504
    Width = 41
    Height = 25
    Caption = 'up'
    TabOrder = 6
    Visible = False
    OnClick = btn_upClick
  end
  object btn_down: TButton
    Left = 416
    Top = 504
    Width = 33
    Height = 25
    Caption = 'down'
    TabOrder = 7
    Visible = False
    OnClick = btn_downClick
  end
  object ListBox4: TListBox
    Left = 8
    Top = 496
    Width = 33
    Height = 25
    ItemHeight = 13
    TabOrder = 8
    Visible = False
  end
  object Button11: TButton
    Left = 456
    Top = 336
    Width = 121
    Height = 33
    Caption = 'Adminmodus'
    TabOrder = 9
    OnClick = Button11Click
  end
  object btn_dbupdate: TButton
    Left = 424
    Top = 384
    Width = 81
    Height = 41
    Caption = 'dbupdate'
    TabOrder = 10
    Visible = False
    OnClick = btn_dbupdateClick
  end
  object btn_options: TButton
    Left = 520
    Top = 384
    Width = 81
    Height = 41
    Caption = 'einstellungen'
    TabOrder = 11
    Visible = False
    OnClick = btn_optionsClick
  end
  object btn_rpopen: TButton
    Left = 424
    Top = 432
    Width = 81
    Height = 41
    Caption = 'Randompool'
    Enabled = False
    TabOrder = 12
    Visible = False
    OnClick = btn_rpopenClick
  end
  object Button15: TButton
    Left = 736
    Top = 32
    Width = 73
    Height = 33
    Caption = 'Randompool'
    Enabled = False
    TabOrder = 13
    Visible = False
    OnClick = Button15Click
  end
  object Panel1: TPanel
    Left = 184
    Top = 64
    Width = 217
    Height = 25
    Caption = 'Musiksammlung'
    TabOrder = 14
  end
  object Panel2: TPanel
    Left = 776
    Top = 104
    Width = 185
    Height = 25
    Caption = 'Playlist'
    TabOrder = 15
  end
  object ListBox5: TListBox
    Left = 240
    Top = 496
    Width = 41
    Height = 25
    ItemHeight = 13
    TabOrder = 16
    Visible = False
  end
  object btn_autosave: TBitBtn
    Left = 632
    Top = 104
    Width = 75
    Height = 25
    Caption = 'autosave'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 17
    OnClick = btn_autosaveClick
  end
  object btn_remove: TBitBtn
    Left = 528
    Top = 144
    Width = 75
    Height = 41
    Caption = 'remove'
    TabOrder = 18
    OnClick = btn_removeClick
  end
  object btn_import: TBitBtn
    Left = 480
    Top = 96
    Width = 75
    Height = 33
    Caption = 'import'
    TabOrder = 19
    OnClick = btn_importClick
  end
  object btn_add: TBitBtn
    Left = 432
    Top = 144
    Width = 75
    Height = 41
    Caption = 'add'
    TabOrder = 20
    OnClick = btn_addClick
  end
  object btn_plsave: TBitBtn
    Left = 528
    Top = 192
    Width = 89
    Height = 33
    Caption = 'Playlist speichern'
    TabOrder = 21
    OnClick = btn_plsaveClick
  end
  object btn_plopen: TBitBtn
    Left = 416
    Top = 192
    Width = 91
    Height = 33
    Caption = 'Playlist '#246'ffnen'
    TabOrder = 22
    OnClick = btn_plopenClick
  end
  object btn_birthday: TBitBtn
    Left = 432
    Top = 240
    Width = 75
    Height = 25
    Caption = 'birthday'
    TabOrder = 23
    OnClick = btn_birthdayClick
  end
  object btn_suederhof: TBitBtn
    Left = 528
    Top = 240
    Width = 75
    Height = 25
    Caption = 's'#252'derhof'
    TabOrder = 24
    OnClick = btn_suederhofClick
  end
  object Button8: TBitBtn
    Left = 712
    Top = 104
    Width = 57
    Height = 25
    Caption = 'shuffle'
    TabOrder = 25
    OnClick = Button8Click
  end
  object btnplaypause: TBitBtn
    Left = 640
    Top = 32
    Width = 83
    Height = 33
    Caption = 'play/pause'
    TabOrder = 26
    OnClick = btnplaypauseClick
  end
  object btn_next: TBitBtn
    Left = 824
    Top = 32
    Width = 81
    Height = 33
    Caption = 'next'
    TabOrder = 27
    OnClick = btn_nextClick
  end
  object Button2: TBitBtn
    Left = 272
    Top = 24
    Width = 75
    Height = 25
    Caption = 'suchen'
    TabOrder = 28
    OnClick = Button2Click
  end
  object auswahlOpenDialog: TOpenDialog
    Left = 72
    Top = 8
  end
  object maintimer: TTimer
    OnTimer = maintimerTimer
    Left = 32
    Top = 8
  end
  object playlistsavedlg: TSaveDialog
    DefaultExt = '*.plst'
    Filter = 'playlist|*.plst'
    Left = 88
    Top = 496
  end
  object playlistopendlg: TOpenDialog
    DefaultExt = '*,plst'
    Filter = 'playlist|*.plst'
    Left = 144
    Top = 496
  end
  object dlg_autosave: TSaveDialog
    DefaultExt = '*.plst'
    Filter = 'playlist|*.plst'
    Left = 288
    Top = 496
  end
  object XPManifest1: TXPManifest
    Left = 488
    Top = 504
  end
end
