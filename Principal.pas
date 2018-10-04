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
  cxBarEditItem, DBClient, Provider, MemDS, DBAccess, Uni;

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
    dsVersao: TDataSource;
    qryAtualizaNrUltimaVersao: TUniQuery;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
  private
    qtAtualizados,
    qtDesatualizados: Integer;
    procedure preencherGridVersaoArquivo;
    procedure ListarArquivos(Diretorio: string; Sub: Boolean;
      Lista: TStringList);
    function TemAtributo(Attr, Val: Integer): Boolean;
    function VersaoExe(arquivo: string): String;

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
var
  Connection: TdtmConnection;
begin
  Connection := TdtmConnection.Create(nil);
  //edtDiretorio.Text:= 'C:\Program Files (x86)\Alterdata\ERP';
  FCadastroUsuariosSQL:= TUsuariosERP.create();
  FCadastroUsuariosSQL.Connection:= Connection.mscConnectionERP;

  FLogin := false;

  if (FCadastroUsuariosSQL.ShowLogin(ttlTerminar, cEstCompras, GetVersaoSistema(cEstCompras))) then
  begin
    FLogin := true;

    dtmERP.ConnectERPServer(ttlTerminar);
    cdsVersao.Open();
    PreencherGridVersaoArquivo();
    inherited;
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
  cxGrid1DBTableView1.DataController.datasource.DataSet:= nil;
  listaVersaoArquivo:= TStringList.Create();
  listaVersaoDisponivel:= TStringList.Create();
  //ListarArquivos(edtDiretorio.Text,false,listaVersaoArquivo);
  //ListarArquivos(RetornaDiretorioAtualizacao(),false,listaVersaoDisponivel);
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

end.
