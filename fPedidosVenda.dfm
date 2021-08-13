object frmPedidosVenda: TfrmPedidosVenda
  Left = 0
  Top = 0
  Hint = 'Preencha apenas com n'#250'meros.'
  Caption = 'frmPedidosVenda'
  ClientHeight = 510
  ClientWidth = 584
  Color = cl3DLight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 360
    ExplicitTop = 16
    ExplicitWidth = 185
    DesignSize = (
      584
      41)
    object Label1: TLabel
      Left = 19
      Top = 3
      Width = 202
      Height = 35
      Caption = 'Pedidos de Venda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -28
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object btnCarregar: TButton
      Left = 358
      Top = 10
      Width = 100
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Carregar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnCarregarClick
      ExplicitLeft = 534
    end
    object btnCancelar: TButton
      Left = 464
      Top = 10
      Width = 100
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancelar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelarClick
      ExplicitLeft = 640
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 584
    Height = 428
    Align = alClient
    TabOrder = 1
    ExplicitTop = 43
    ExplicitWidth = 760
    DesignSize = (
      584
      428)
    object Label2: TLabel
      Left = 41
      Top = 20
      Width = 39
      Height = 15
      Caption = 'Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 34
      Top = 56
      Width = 46
      Height = 15
      Caption = 'Produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 15
      Top = 91
      Width = 65
      Height = 15
      Caption = 'Quantidade:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 215
      Top = 91
      Width = 73
      Height = 15
      Caption = 'Valor unit'#225'rio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object btnAdicionar: TButton
      Left = 425
      Top = 83
      Width = 135
      Height = 25
      Caption = 'Adicionar Produto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnAdicionarClick
    end
    object dbgProdutos: TDBGrid
      Left = 5
      Top = 120
      Width = 571
      Height = 303
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = dsProdutos
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick]
      TabOrder = 5
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = dbgProdutosKeyDown
    end
    object edtIdCliente: TEdit
      Left = 86
      Top = 14
      Width = 61
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 0
      OnChange = edtIdClienteChange
      OnEnter = edtIdClienteEnter
      OnExit = edtIdClienteExit
    end
    object edtIdProduto: TEdit
      Left = 86
      Top = 50
      Width = 61
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 1
      OnEnter = edtIdProdutoEnter
      OnExit = edtIdProdutoExit
    end
    object edtQtd: TEdit
      Left = 86
      Top = 85
      Width = 110
      Height = 21
      Alignment = taRightJustify
      NumbersOnly = True
      TabOrder = 2
      Text = '0'
      OnEnter = edtQtdEnter
    end
    object edtValor: TEdit
      Left = 294
      Top = 85
      Width = 110
      Height = 21
      Hint = 'Preencha apenas com n'#250'meros.'
      Alignment = taRightJustify
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '0,00'
      OnEnter = edtValorEnter
      OnExit = edtValorExit
    end
    object edtNomeCliente: TEdit
      Left = 153
      Top = 14
      Width = 407
      Height = 21
      Color = cl3DLight
      Enabled = False
      TabOrder = 6
    end
    object edtDescProduto: TEdit
      Left = 153
      Top = 50
      Width = 407
      Height = 21
      Color = cl3DLight
      Enabled = False
      TabOrder = 7
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 469
    Width = 584
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 464
    ExplicitTop = 424
    ExplicitWidth = 185
    DesignSize = (
      584
      41)
    object Label6: TLabel
      Left = 19
      Top = 12
      Width = 104
      Height = 19
      Caption = 'Total do Pedido:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object lblTotal: TLabel
      Left = 129
      Top = 12
      Width = 49
      Height = 19
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
    end
    object btnGravar: TButton
      Left = 464
      Top = 8
      Width = 100
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Gravar Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri Light'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnGravarClick
      ExplicitLeft = 640
    end
  end
  object cdsProdutos: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterPost = cdsProdutosAfterPost
    Left = 112
    Top = 217
    object cdsProdutosidpedidoi: TIntegerField
      FieldName = 'idpedidoi'
      ReadOnly = True
      Visible = False
    end
    object cdsProdutosidpedidog: TIntegerField
      FieldName = 'idpedidog'
      ReadOnly = True
      Visible = False
    end
    object cdsProdutosidproduto: TIntegerField
      DisplayLabel = 'Id'
      FieldName = 'idproduto'
      ReadOnly = True
      Visible = False
    end
    object cdsProdutosdescricao: TStringField
      DisplayLabel = 'Produto'
      DisplayWidth = 55
      FieldName = 'descricao'
      ReadOnly = True
      Size = 150
    end
    object cdsProdutosquantidade: TIntegerField
      DisplayLabel = 'Quantidade'
      FieldName = 'quantidade'
    end
    object cdsProdutosvlrunitario: TFloatField
      DisplayLabel = 'Valor Unit.'
      FieldName = 'vlrunitario'
    end
    object cdsProdutosvlrtotal: TFloatField
      DisplayLabel = 'Total'
      FieldName = 'vlrtotal'
      ReadOnly = True
    end
  end
  object dsProdutos: TDataSource
    DataSet = cdsProdutos
    Left = 40
    Top = 217
  end
end
