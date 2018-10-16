unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AltUsrERP, AltLib, DConnectionERP,AltLibTypes,AltLibSist,udtmERP,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  dxSkinsCore, altlib_skin_alterdata, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, cxNavigator, DB, cxDBData, dxSkinsdxBarPainter, dxBar, cxClasses,
  cxGridLevel, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid,cxImage,
  cxBarEditItem, DBClient, Provider, MemDS, DBAccess, Uni, StdCtrls,
  ExtCtrls, AltPanel, cxLabel, cxContainer, cxTextEdit, abcfdir,AltFStatus,
  cxShellBrowserDialog, dxPSGlbl, dxPSUtl, dxPrnPg, dxBkgnd, dxWrap,
  dxPgsDlg, AltLibDialog, ExtDlgs, FileCtrl,ComCtrls;

type
  TfrmAtualizadorDeVersoes = class(TForm)
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    dxBarManager1: TdxBarManager;
    dxbPrincipal: TdxBar;
    btnSair: TdxBarLargeButton;
    btnNovo: TdxBarLargeButton;
    btnAbrir: TdxBarLargeButton;
    btnAtualizarTabelaSistema: TdxBarLargeButton;
    btnLocalizar: TdxBarLargeButton;
    btnImprimir: TdxBarLargeButton;
    btnVisualizar: TdxBarLargeButton;
    btnNovidadesHelp: TdxBarLargeButton;
    btnAjuda: TdxBarLargeButton;
    dspVersao: TDataSetProvider;
    cdsVersao: TClientDataSet;
    cdsVersaonmarquivo: TStringField;
    cdsVersaoNrUltimaVersao: TStringField;
    cdsVersaoArquivoVersao: TStringField;
    cdsVersaoversaoDisponivel: TStringField;
    cdsVersaoStAtualizado: TStringField;
    cdsVersaoSelecionar: TBooleanField;
    qrySistema: TUniQuery;
    qryConfiguracao: TUniQuery;
    cxGrid1DBTableView1nmarquivo: TcxGridDBColumn;
    cxGrid1DBTableView1NrUltimaVersao: TcxGridDBColumn;
    cxGrid1DBTableView1ArquivoVersao: TcxGridDBColumn;
    cxGrid1DBTableView1versaoDisponivel: TcxGridDBColumn;
    cxGrid1DBTableView1StAtualizado: TcxGridDBColumn;
    cxGrid1DBTableView1Selecionar: TcxGridDBColumn;
    dsVersao: TUniDataSource;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarButton3: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    edtDiretorio: TcxTextEdit;
    ckMarcarTodos: TCheckBox;
    lbMarcar: TcxLabel;
    Panel1: TPanel;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    edtDiretorioAtualizacao: TcxTextEdit;
    OpenDialog1: TOpenPictureDialog;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure btnAtualizarTabelaSistemaClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure dxBarLargeButton1Click(Sender: TObject);
    procedure cxGrid1DBTableView1DblClick(Sender: TObject);
    procedure ckMarcarTodosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FqtAtualizados,
    FqtDesatualizados: Integer;
    procedure PreencherGridVersaoArquivo;
    procedure ListarArquivos(Diretorio: string; Sub: Boolean;
      Lista: TStringList);
    function TemAtributo(Attr, Val: Integer): Boolean;
    function VersaoExe(arquivo: string): String;
    procedure PreencherVersaoDoArquivo(nomeAplicativo: string;
      lista: Tstringlist; coluna: TStringField);
    function VersaoComMascara(versao: string): string;
    procedure AbrirFrmSelecionaDiretorio;
    procedure AtualizarSelecionados;
    procedure AtualizarAplicativo(ArquivoOrigem, ArquivoDestino: string);
    procedure AlterarTodos(value: Boolean);
    procedure AtualizarNrUltimaVersao;
    procedure MontarScriptAtualizarUltimaVersao(pAplicativo, pVersao: String);

    { Private declarations }
  public
    FCadastroUsuariosSQL: TUsuariosErp;
    FLogin: Boolean;
    function RetornarDiretorioAtualizacao: string;
    { Public declarations }
  end;

var
  frmAtualizadorDeVersoes: TfrmAtualizadorDeVersoes;

implementation

uses selecionaDiretorioAtualizado;

{$R *.dfm}

procedure TfrmAtualizadorDeVersoes.FormCreate(Sender: TObject);
begin
  dtmConnection.mscConnectionERP.LoginPrompt:= False;
  FCadastroUsuariosSQL:= TUsuariosERP.create();
  FCadastroUsuariosSQL.Connection:= dtmConnection.mscConnectionERP;
  FLogin := false;

  if (FCadastroUsuariosSQL.ShowLogin(ttlTerminar, '', '')) then
  begin
    FLogin := true;
    dtmERP.ConnectERPServer(ttlTerminar);
    cdsVersao.Open();
  end;
end;

procedure TfrmAtualizadorDeVersoes.btnNovoClick(Sender: TObject);
begin
  PreencherGridVersaoArquivo();
end;

procedure TfrmAtualizadorDeVersoes.btnAbrirClick(Sender: TObject);
begin
  qryConfiguracao.Connection:= dtmConnection.mscConnectionERP;
  qryConfiguracao.Close();
  qryConfiguracao.open();
  if qryConfiguracao.FieldByName('vlConfiguracao').text = '' then
    begin
      ShowMessage('O diretório de atualização não foi informado, informe o diretório a ser utilizado '+
        'para extrair os arquivos de atualização');
      AbrirFrmSelecionaDiretorio();
    end;
  AtualizarSelecionados();
  PreencherGridVersaoArquivo();
end;

procedure TfrmAtualizadorDeVersoes.btnAtualizarTabelaSistemaClick(Sender: TObject);
begin
  AtualizarNrUltimaVersao();
  PreencherGridVersaoArquivo();
end;

procedure TfrmAtualizadorDeVersoes.btnLocalizarClick(Sender: TObject);
begin
  abrirFrmSelecionaDiretorio();
  edtDiretorioAtualizacao.text:= RetornarDiretorioAtualizacao();
  PreencherGridVersaoArquivo();
end;

procedure TfrmAtualizadorDeVersoes.PreencherGridVersaoArquivo();
var
  listaVersaoArquivo, listaVersaoDisponivel: TStringList;
  arquivo,nrVersaoSistema,nrVersaoArquivo: string;
  Coluna: TStringField;
begin
  FqtAtualizados:= 0;
  FqtDesatualizados:= 0;
  ckMarcarTodos.Checked:= False;
  cxGrid1DBTableView1.DataController.datasource.DataSet.DisableControls();
  listaVersaoArquivo:= TStringList.Create();
  listaVersaoDisponivel:= TStringList.Create();
  ListarArquivos(edtDiretorio.Text,false,listaVersaoArquivo);
  ListarArquivos(RetornarDiretorioAtualizacao(),false,listaVersaoDisponivel);
  cdsVersao.Refresh();
  cdsVersao.First();
  try
    while not cdsVersao.Eof do
      begin
        cdsVersao.Edit();
        arquivo:= cdsVersaonmarquivo.AsString;
        coluna:= cdsVersaoArquivoVersao;
        PreencherVersaoDoArquivo(arquivo,listaVersaoArquivo,coluna);
        coluna:= cdsVersaoversaoDisponivel;
        PreencherVersaoDoArquivo(arquivo,listaVersaoDisponivel,coluna);
        nrVersaoSistema:= cdsVersaoNrUltimaVersao.AsString;
        nrVersaoArquivo:= cdsVersaoArquivoVersao.AsString;
        cdsVersao.Post();
        cdsVersao.Next;
      end;
  finally
    listaVersaoArquivo.Free();
    listaVersaoDisponivel.Free;
    cdsVersao.First();
    cxGrid1DBTableView1.DataController.datasource.DataSet.EnableControls();
  end;
end;

procedure TfrmAtualizadorDeVersoes.ListarArquivos(Diretorio: string; Sub:Boolean;Lista: TStringList);
var
  F: TSearchRec;
  Ret: Integer;
  TempNome: string;
begin
  Ret := FindFirst(Diretorio + '\*.*', faAnyFile, F);
  try
    while Ret = 0 do
    begin
      if TemAtributo(F.Attr, faDirectory) then
      begin
        if (F.Name <> '.') And (F.Name <> '..') then
          if Sub = True then
          begin
            TempNome := Diretorio+'\' + F.Name;
            ListarArquivos(TempNome, True,Lista);
          end;
      end
      else
      begin
       if POS('.exe',F.Name) <> 0 then
         Lista.Add(f.Name+'|'+VersaoExe(Diretorio+'\' + F.Name));
      end;
      Ret := FindNext(F);
    end;
  finally
    FindClose(F);
  end;
end;

function TfrmAtualizadorDeVersoes.TemAtributo(Attr, Val: Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

function TfrmAtualizadorDeVersoes.VersaoExe(arquivo: string): String;
type
  PFFI = ^vs_FixedFileInfo;
var
  F : PFFI;
  Handle : Dword;
  Len : Longint;
  Data : Pchar;
  Buffer : Pointer;
  Tamanho : Dword;
  Parquivo: Pchar;
  caminho : String;
begin
  caminho := ('C:\Program Files (x86)\Alterdata\ERP\'+arquivo);
  Parquivo := StrAlloc(Length(Arquivo) + 1);
  StrPcopy(Parquivo, Arquivo);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  Result := '';
  if Len > 0 then
  begin
    Data:=StrAlloc(Len+1);
    if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
    begin
      VerQueryValue(Data, '\',Buffer,Tamanho);
      F := PFFI(Buffer);
      Result := Format('%d.%d.%d.%d',
      [HiWord(F^.dwFileVersionMs),
      LoWord(F^.dwFileVersionMs),
      HiWord(F^.dwFileVersionLs),
      Loword(F^.dwFileVersionLs)]
      );
    end;
    StrDispose(Data);
  end;
  StrDispose(Parquivo);
end;

function TfrmAtualizadorDeVersoes.RetornarDiretorioAtualizacao(): string;
begin
  qryConfiguracao.Connection:= dtmConnection.mscConnectionERP;
  qryConfiguracao.Close();
  qryConfiguracao.open();
  result:= qryConfiguracao.FieldByName('vlConfiguracao').text;
end;

procedure TfrmAtualizadorDeVersoes.PreencherVersaoDoArquivo(nomeAplicativo: string; lista: Tstringlist; coluna: TStringField);
var
  horizontal: TStringList;
  i:Integer;
begin
  horizontal:= TStringList.Create;
  horizontal.Delimiter:= '|';
  try
   for I := 0 to Lista.Count - 1 do
      begin
        horizontal.DelimitedText:= lista[i];
          if (nomeAplicativo = horizontal.Strings[0]) then
             begin
               coluna.AsString := VersaoComMascara(horizontal.Strings[1]);
             end;
      end;
  finally
    horizontal.Free();
  end;
end;

function TfrmAtualizadorDeVersoes.VersaoComMascara(versao: string): string;
var
  lista: TStringList;
  a,b,c,d: string;
begin
  lista:= TStringList.Create;
  lista.Delimiter:= '.';
  try
    if ( not(versao = null) ) or (not(versao = ''))  then
      begin
        lista.DelimitedText:= versao;
        if lista.Count > 3 then
          begin
            a:= lista[0];
            b:= FormatFloat('00',StrToInt(lista[1]));
            c:= FormatFloat('00',StrToInt(lista[2]));
            d:= FormatFloat('00',StrToInt(lista[3]));
          end;
        result:= (a +'.'+ b +'.'+ c +'.'+ d);
      end
    else
      result:= '-';
  finally
    lista.Free;
  end;
end;

procedure TfrmAtualizadorDeVersoes.AbrirFrmSelecionaDiretorio();
begin
  try
    frmDiretorio:= tfrmDiretorio.Create(self);
    frmdiretorio.ShowModal();
  finally
    frmDiretorio.Free;
    PreencherGridVersaoArquivo();
  end;
end;

procedure TfrmAtualizadorDeVersoes.dxBarLargeButton1Click(Sender: TObject);
var
  lDiretorio: string;
begin
  if SelectDirectory(lDiretorio, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    FocaControle(edtDiretorio);
    edtDiretorio.Text := lDiretorio;
    PreencherGridVersaoArquivo();
  end;
end;

procedure TfrmAtualizadorDeVersoes.AtualizarSelecionados();
var
  ArquivoOrigem,ArquivoDestino,diretorioDestino: string;
  lStatus : TStatus;
begin;
  diretorioDestino:= edtDiretorio.Text;
  lStatus := TStatus.create();
  cdsVersao.disableControls;
  cdsVersao.First;
  try
    lStatus := TStatus.Animate(Screen.ActiveForm, 'Aguarde, atualizando os aplicativos selecionados... ', aviCopyFile);
    while not cdsVersao.eof do
      begin
        if (cdsVersaoSelecionar.AsBoolean) and (cdsVersaoversaoDisponivel.AsString <> '') then
          begin
            lStatus.Text:= 'Aguarde, atualizando os aplicativos selecionados...  ' + #13 + #13 + cdsVersaonmarquivo.AsString;
            ArquivoOrigem:= RetornarDiretorioAtualizacao() + '\' + cdsVersaonmarquivo.AsString;
            ArquivoDestino:= diretorioDestino + '\' + cdsVersaonmarquivo.AsString;
            AtualizarAplicativo(ArquivoOrigem,ArquivoDestino);
          end;
        cdsVersao.Next;
      end;
  finally
    cdsVersao.First;
    cdsVersao.enableControls;
    lStatus.Free();
  end;
end;

procedure TfrmAtualizadorDeVersoes.AtualizarAplicativo(ArquivoOrigem, ArquivoDestino: string);
begin
  if (cdsVersaoversaoDisponivel.AsString > cdsVersaoArquivoVersao.AsString) then
    CopyFile(pchar(ArquivoOrigem),pchar(ArquivoDestino),False);
end;

procedure TfrmAtualizadorDeVersoes.cxGrid1DBTableView1DblClick(
  Sender: TObject);
begin
  cdsVersao.Edit();
  cdsVersaoSelecionar.AsBoolean:= not (cdsVersaoSelecionar.AsBoolean);
  cdsVersao.Post();
end;

procedure TfrmAtualizadorDeVersoes.ckMarcarTodosClick(Sender: TObject);
begin
  if ckMarcarTodos.Checked then
    begin
      AlterarTodos(true);
      lbMarcar.Caption:= 'Desmarcar Todos';
    end
  else
    begin
      AlterarTodos(false);
      lbMarcar.Caption:= 'Marcar Todos';
    end;
end;

procedure TfrmAtualizadorDeVersoes.AlterarTodos(value: Boolean);
begin
  cdsVersao.disableControls;
  cdsVersao.First();
  while not cdsVersao.eof do
    begin
      cdsVersao.Edit();
      if cdsVersaoversaoDisponivel.AsString <> '' then
        cdsVersaoSelecionar.AsBoolean := value; // true marca, false desmarca
      cdsVersao.Post();
      cdsVersao.Next();
    end;
  cdsVersao.First();
  cdsVersao.enableControls;
end;

procedure TfrmAtualizadorDeVersoes.AtualizarNrUltimaVersao();
var
  lista,Coluna: TStringList;
  i: Integer;
begin
  lista:= TStringList.Create();
  try
    ListarArquivos(RetornarDiretorioAtualizacao(),false,lista);
    for I := 0 to lista.Count - 1 do
      begin
        coluna:= TStringList.Create();
        Coluna.Delimiter:= '|';
        try
          Coluna.DelimitedText:= lista.Strings[i];
          MontarScriptAtualizarUltimaVersao(Coluna.Strings[0],Coluna.Strings[1]);
        finally
          Coluna.Free();
        end;
      end;
  finally
    lista.Free();
  end;
end;

procedure TfrmAtualizadorDeVersoes.FormShow(Sender: TObject);
begin
  edtDiretorioAtualizacao.Text:= RetornarDiretorioAtualizacao();
  edtDiretorio.Text:= 'C:\Program Files (x86)\Alterdata\ERP';
  PreencherGridVersaoArquivo();
end;

procedure TfrmAtualizadorDeVersoes.MontarScriptAtualizarUltimaVersao(pAplicativo, pVersao: String);
var
  qryAtualizaNrUltimaVersao: TUniQuery;
begin
  qryAtualizaNrUltimaVersao:= TUniQuery.Create(nil);
  qryAtualizaNrUltimaVersao.Connection:= dtmConnection.mscConnectionERP;

  try
    qryAtualizaNrUltimaVersao.SQL.Text := ('Update sistema set '+
                                'nrUltimaVersao = :nrUltimaVersao where '+
                                'nmArquivo = :nmArquivo');
    qryAtualizaNrUltimaVersao.ParamByName('nmArquivo').AsString := pAplicativo;
    qryAtualizaNrUltimaVersao.ParamByName('nrUltimaVersao').AsString := versaocomMascara(pVersao);
    try
      qryAtualizaNrUltimaVersao.ExecSQL;
    except on e: Exception do
      ShowMessage('Não foi possível alterar o registro : '+ #13
                  + e.Message);
    end;
  finally
    qryAtualizaNrUltimaVersao.Free();
  end;
end;
end.
