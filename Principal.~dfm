object Form1: TForm1
  Left = 376
  Top = 93
  Width = 893
  Height = 600
  HelpContext = 702
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 0
    Top = 48
    Width = 877
    Height = 514
    Align = alClient
    TabOrder = 0
    object cxGrid1DBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsVersao
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      object cxGrid1DBTableView1nmarquivo: TcxGridDBColumn
        DataBinding.FieldName = 'nmarquivo'
      end
      object cxGrid1DBTableView1NrUltimaVersao: TcxGridDBColumn
        DataBinding.FieldName = 'NrUltimaVersao'
      end
      object cxGrid1DBTableView1ArquivoVersao: TcxGridDBColumn
        DataBinding.FieldName = 'ArquivoVersao'
      end
      object cxGrid1DBTableView1versaoDisponivel: TcxGridDBColumn
        DataBinding.FieldName = 'versaoDisponivel'
      end
      object cxGrid1DBTableView1StAtualizado: TcxGridDBColumn
        DataBinding.FieldName = 'StAtualizado'
      end
      object cxGrid1DBTableView1Selecionar: TcxGridDBColumn
        DataBinding.FieldName = 'Selecionar'
        Width = 53
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object edtDiretorio: TEdit
    Left = 455
    Top = 54
    Width = 416
    Height = 21
    TabOrder = 5
  end
  object dxBarManager1: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = ImagensRepositorio16x16.List
    ImageOptions.LargeImages = ImagensRepositorio24x24.List
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 11
    Top = 517
    DockControlHeights = (
      0
      0
      48
      0)
    object dxbPrincipal: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      Caption = 'Principal'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 510
      FloatTop = 241
      FloatClientWidth = 0
      FloatClientHeight = 0
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnNovo'
        end
        item
          Visible = True
          ItemName = 'btnAbrir'
        end
        item
          Visible = True
          ItemName = 'btnExcluir'
        end
        item
          Visible = True
          ItemName = 'btnLocalizar'
        end>
      MultiLine = True
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 0
      ShowMark = False
      UseOwnFont = False
      UseRestSpace = True
      Visible = True
      WholeRow = True
    end
    object btnSair: TdxBarLargeButton
      Caption = 'Sair'
      Category = 0
      Hint = 'Sair'
      Visible = ivAlways
      LargeImageIndex = 108
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = 108
    end
    object btnNovo: TdxBarLargeButton
      Caption = '&Listar'
      Category = 0
      Hint = 'Listar'
      Visible = ivAlways
      LargeImageIndex = 254
      ShortCut = 32846
      OnClick = btnNovoClick
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = 245
    end
    object btnAbrir: TdxBarLargeButton
      Caption = '&Atualizar'
      Category = 0
      Hint = 'Atualizar aplicativos selecionados'
      Visible = ivAlways
      LargeImageIndex = 84
      ShortCut = 32837
      OnClick = btnAbrirClick
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = 88
    end
    object btnExcluir: TdxBarLargeButton
      Caption = 'Alterar Vers'#227'o'
      Category = 0
      Hint = 'Alterar Valor da '#250'ltima vers'#227'o utilizada'
      Visible = ivAlways
      LargeImageIndex = 194
      ShortCut = 32856
      OnClick = btnExcluirClick
      AutoGrayScale = False
    end
    object btnLocalizar: TdxBarLargeButton
      Caption = 'Diret'#243'rio de atualiza'#231#227'o'
      Category = 0
      Hint = 'Selecionar diret'#243'rio de atualiza'#231#227'o'
      Visible = ivAlways
      LargeImageIndex = 468
      ShortCut = 32844
      OnClick = btnLocalizarClick
      AutoGrayScale = False
    end
    object btnImprimir: TdxBarLargeButton
      Caption = '&Imprimir'
      Category = 0
      Hint = 'Imprimir'
      Visible = ivAlways
      LargeImageIndex = 94
      ShortCut = 32841
      AutoGrayScale = False
    end
    object btnVisualizar: TdxBarLargeButton
      Caption = '&Visualizar'
      Category = 0
      Hint = 'Visualizar'
      Visible = ivAlways
      LargeImageIndex = 113
      ShortCut = 32854
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = 108
    end
    object btnNovidadesHelp: TdxBarLargeButton
      Caption = 'Ajuda'
      Category = 0
      HelpContext = 10
      Hint = 'Ajuda'
      Visible = ivNever
      LargeImageIndex = 75
      AutoGrayScale = False
    end
    object btnAjuda: TdxBarLargeButton
      Caption = 'A&juda'
      Category = 0
      Hint = 'Ajuda'
      Visible = ivAlways
      LargeImageIndex = 75
      SyncImageIndex = False
      ImageIndex = 75
    end
  end
  object dspVersao: TDataSetProvider
    DataSet = qrySistema
    Left = 61
    Top = 109
  end
  object cdsVersao: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'nmArquivo'
    Params = <>
    ProviderName = 'dspVersao'
    Left = 116
    Top = 129
    object cdsVersaonmarquivo: TStringField
      DisplayLabel = 'Nome do arquivo'
      DisplayWidth = 50
      FieldName = 'nmarquivo'
      Origin = 'nmarquivo'
      Size = 100
    end
    object cdsVersaoNrUltimaVersao: TStringField
      Alignment = taCenter
      DisplayLabel = 'Ultima Vers'#227'o'
      DisplayWidth = 20
      FieldName = 'NrUltimaVersao'
      Origin = 'NrUltimaVersao'
      FixedChar = True
      Size = 50
    end
    object cdsVersaoArquivoVersao: TStringField
      Alignment = taCenter
      DisplayLabel = 'Vers'#227'o do Arquivo'
      DisplayWidth = 20
      FieldKind = fkInternalCalc
      FieldName = 'ArquivoVersao'
      Size = 50
    end
    object cdsVersaoversaoDisponivel: TStringField
      Alignment = taCenter
      DisplayLabel = 'Vers'#227'o Dispon'#237'vel'
      DisplayWidth = 25
      FieldKind = fkInternalCalc
      FieldName = 'versaoDisponivel'
    end
    object cdsVersaoStAtualizado: TStringField
      Alignment = taCenter
      DisplayLabel = 'Atualizado'
      DisplayWidth = 15
      FieldKind = fkInternalCalc
      FieldName = 'StAtualizado'
      Size = 1
    end
    object cdsVersaoSelecionar: TBooleanField
      FieldKind = fkInternalCalc
      FieldName = 'Selecionar'
    end
  end
  object qrySistema: TUniQuery
    Connection = dtmConnection.mscConnectionERP
    SQL.Strings = (
      'Select nmSistema, nmArquivo, nrUltimaVersao from Sistema')
    Active = True
    Left = 13
    Top = 107
  end
  object qryConfiguracao: TUniQuery
    SQL.Strings = (
      
        'Select vlConfiguracao from Configuracao where nmSecao = '#39'DataBas' +
        'e'#39' and nmConfiguracao = '#39'DiretorioAtualizacao'#39)
    Left = 69
    Top = 157
  end
  object dsVersao: TUniDataSource
    DataSet = cdsVersao
    Left = 24
    Top = 161
  end
end
