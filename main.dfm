object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Billard Game'
  ClientHeight = 500
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object controlPanel: TPanel
    Left = 850
    Top = 0
    Width = 150
    Height = 500
    Align = alRight
    TabOrder = 0
    object xYonLbl: TLabel
      Left = 40
      Top = 103
      Width = 55
      Height = 13
      Caption = 'X y'#246'n'#252'nde:'
    end
    object yYonLbl: TLabel
      Left = 40
      Top = 149
      Width = 55
      Height = 13
      Caption = 'Y y'#246'n'#252'nde:'
    end
    object surtunmeLbl: TLabel
      Left = 40
      Top = 195
      Width = 50
      Height = 13
      Caption = 'S'#252'rt'#252'nme:'
    end
    object Image1: TImage
      Left = 37
      Top = 8
      Width = 76
      Height = 73
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D494844520000004B0000
        004B0806000000384E7AEA000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC6105000000097048597300000EC200000EC20115284A80000001
        5A4944415478DAEDDAB10D82400046E16318A6600217B17600878092451CC109
        8C15BBA056C440882F1C1E77797FA9CDCB77245C4135BE170EB0AAAA66BF1D24
        6D6A140B348A051AC5028D628146B140A358A0512CD0281668140B348A051AC5
        028DE5600DA16BEAF0BC8EA13FEDD4281668140B34E68E35744DA82FF7857FCE
        E136F621A65BF658D3E64FD637E476BCA2B1A2372E612D9D481DF9948AC14A31
        EF5924442C10221608110B84880542C40221628110B140885820442C10221608
        C901EBD3943A2297890526169858606281F936248D628146B140A358A0512CD0
        281668140B348A051AC5028D628146B140A358A0512CD0281668DC8615EF9B28
        B148885820A454AC3DBE102E026BFD8B5F9F2C30B1C0C44A13B2096BEDD0221E
        A8586289356358B9C2B4ED235C625F6F72C69AE693259658C9B1FED428166814
        0B348A051AC5028D628146B140A358A0512CD028166814EBF7BD0072EE934D17
        02FC880000000049454E44AE426082}
    end
    object Label1: TLabel
      Left = 56
      Top = 408
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 72
      Top = 448
      Width = 31
      Height = 13
      Caption = 'Label2'
    end
    object xhizEdt: TEdit
      Left = 40
      Top = 122
      Width = 65
      Height = 21
      TabOrder = 0
      Text = '90'
    end
    object baslatBtn: TButton
      Left = 32
      Top = 249
      Width = 75
      Height = 25
      Caption = 'Ba'#351'lat'
      Default = True
      TabOrder = 1
      OnClick = baslatBtnClick
    end
    object yhizEdt: TEdit
      Left = 40
      Top = 168
      Width = 65
      Height = 21
      TabOrder = 2
      Text = '30'
    end
    object frictionCbox: TComboBox
      Left = 40
      Top = 214
      Width = 65
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5')
    end
    object RestartBtn: TButton
      Left = 17
      Top = 348
      Width = 120
      Height = 25
      Caption = 'Restart Game'
      TabOrder = 4
      OnClick = RestartBtnClick
    end
  end
  object LineBtn: TButton
    Left = 882
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Line '#199'iz'
    TabOrder = 1
    OnClick = LineBtnClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 88
    Top = 384
  end
end
