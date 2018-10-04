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
  cxBarEditItem, DBClient, Provider, MemDS, DBAccess, Uni, StdCtrls;

type
  TForm1 = class(TForm)
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    dxBarManager1: TdxBarManager;
    dxbPrincipal: TdxBar;
    btnSair: TdxBarLargeButton;
    btnNovo: TdxBarLargeButton;
    btnAbrir: TdxBarLargeButton;
    btnExcluir: TdxBarLargeButton;
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
    edtDiretorio: TEdit;
    qryConfiguracao: TUniQuery;
    cxGrid1DBTableView1nmarquivo: TcxGridDBColumn;
    cxGrid1DBTableView1NrUltimaVersao: TcxGridDBColumn;
    cxGrid1DBTableView1ArquivoVersao: TcxGridDBColumn;
    cxGrid1DBTableView1versaoDisponivel: TcxGridDBColumn;
    cxGrid1DBTableView1StAtualizado: TcxGridDBColumn;
    cxGrid1DBTableView1Selecionar: TcxGridDBColumn;
    dsVersao: TUniDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
  private
    Connection: TdtmConnection;
    qtAtualizados,
    qtDesatualizados: Integer;
    procedure preencherGridVersaoArquivo;
    procedure ListarArquivos(Diretorio: string; Sub: Boolean;
      Lista: TStringList);
    function TemAtributo(Attr, Val: Integer): Boolean;
    function VersaoExe(arquivo: string): String;
    function RetornaDiretorioAtualizacao: string;
    procedure PreencherVersaoDoArquivo(nomeAplicativo: string;
      lista: Tstringlist; coluna: TStringField);
    function VersaoComMascara(versao: string): string;

    { Private declarations }
  public
    FCadastroUsuariosSQL: TUsuariosErp;
    FLogin: Boolean;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  dtmConnection.mscConnectionERP.LoginPrompt:= False;
  FCadastroUsuariosSQL:= TUsuariosERP.create();
  FCadastroUsuariosSQL.Connection:= dtmConnection.mscConnectionERP;

  FLogin := false;

  if (FCadastroUsuariosSQL.ShowLogin(ttlTerminar, cEstCompras, GetVersaoSistema(cEstCompras))) then
  begin
    FLogin := true;

    dtmERP.ConnectERPServer(ttlTerminar);
    cdsVersao.Open();
    inherited;
    PreencherGridVersaoArquivo();
  end;

end;

procedure TForm1.btnNovoClick(Sender: TObject);
begin
  //preencherGridVersaoArquivo();
end;

procedure TForm1.btnAbrirClick(Sender: TObject);
begin
  (*dmConexao.FDQuery1.Connection:= dmConexao.conexaoSql;
  dmConexao.FDQuery1.Close();
  dmConexao.FDQuery1.open();
  if dmConexao.FDQuery1.FieldByName('vlConfiguracao').text = '' then
    begin
      ShowMessage('O diretório de atualização não foi informado, informe o diretório a ser utilizado '+
        'para extrair os arquivos de atualização');
      AbrirFrmSelecionaDiretorio();
    end;
  atualizarSelecionados();*)
end;

procedure TForm1.btnExcluirClick(Sender: TObject);
begin
  //AtualizarNrUltimaVersao();
end;

procedure TForm1.btnLocalizarClick(Sender: TObject);
begin
  //abrirFrmSelecionaDiretorio();
end;

procedure TForm1.preencherGridVersaoArquivo();
var
  listaVersaoArquivo, listaVersaoDisponivel: TStringList;
  arquivo,nrVersaoSistema,nrVersaoArquivo: string;
  Coluna: TStringField;
begin
  qtAtualizados:= 0;
  qtDesatualizados:= 0;
  cxGrid1DBTableView1.DataController.datasource.DataSet.DisableControls();
  listaVersaoArquivo:= TStringList.Create();
  listaVersaoDisponivel:= TStringList.Create();
  ListarArquivos(edtDiretorio.Text,false,listaVersaoArquivo);
  ListarArquivos(RetornaDiretorioAtualizacao(),false,listaVersaoDisponivel);
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
        //preencherLabelQtAtualizada(nrVersaoSistema,nrVersaoArquivo);
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

procedure TForm1.ListarArquivos(Diretorio: string; Sub:Boolean;Lista: TStringList);
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

function TForm1.TemAtributo(Attr, Val: Integer): Boolean;
begin
  Result := Attr and Val = Val;
end;

function TForm1.VersaoExe(arquivo: string): String;
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

function TForm1.RetornaDiretorioAtualizacao(): string;
begin
  qryConfiguracao.Connection:= dtmConnection.mscConnectionERP;
  qryConfiguracao.Close();
  qryConfiguracao.open();
  result:= qryConfiguracao.FieldByName('vlConfiguracao').text;
end;

procedure TForm1.PreencherVersaoDoArquivo(nomeAplicativo: string; lista: Tstringlist; coluna: TStringField);
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

function TForm1.VersaoComMascara(versao: string): string;
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
end.
