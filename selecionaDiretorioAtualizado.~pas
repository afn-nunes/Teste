unit selecionaDiretorioAtualizado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, StdCtrls, cxButtons,
  dxSkinsCore, altlib_skin_alterdata,
  dxSkinsDefaultPainters, Buttons, AltUsrERP, AltLib, DConnectionERP,AltLibTypes,AltLibSist,udtmERP,Uni,
  DB, MemDS, DBAccess, abcfdir, cxClasses, cxShellBrowserDialog,FileCtrl,
  DASQLMonitor, UniSQLMonitor;

type
  TfrmDiretorio = class(TForm)
    edtDiretorio: TEdit;
    Label1: TLabel;
    btnSelecaoDiretorio: TSpeedButton;
    btnGravar: TcxButton;
    OpenDialog2: TOpenDialog;
    UniQuery1: TUniQuery;
    qryConfiguracao: TUniQuery;
    qryConfiguracao1: TUniQuery;
    qryUltimoCodigo: TUniQuery;
    UniStoredProc1: TUniStoredProc;
    OpenDialog1: TcxShellBrowserDialog;
    UniSQLMonitor1: TUniSQLMonitor;
    procedure btnSelecaoDiretorioClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure ValidarConfiguracaoDiretorio;
    procedure GravarDiretorioAtualizacao();
    { Private declarations }
  public
    { Public declarations }
    function ExisteConfiguracaoDiretorioAtualizacao(): Boolean;
    procedure criarConfiguracaoDiretorioAtualizacao();
    procedure AtualizarVlUltimoCodigo();
    function NumToBase36(Value: DWord): string;
    function StrZero(const strvalor: string;
      const intComprimento: integer): string;
    function getIdConfiguracao: string;
  end;

var
  frmDiretorio: TfrmDiretorio;

implementation

{$R *.dfm}

procedure TfrmDiretorio.btnGravarClick(Sender: TObject);
begin
  validarConfiguracaoDiretorio();
  gravarDiretorioAtualizacao();
  frmDiretorio.Close;
end;

procedure TfrmDiretorio.btnSelecaoDiretorioClick(Sender: TObject);
var
  lDiretorio: string;
begin
  if SelectDirectory(lDiretorio, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
  begin
    FocaControle(edtDiretorio);
    edtDiretorio.Text := lDiretorio;
  end;
end;

procedure TfrmDiretorio.Button1Click(Sender: TObject);
begin
  AtualizarVlUltimoCodigo();
end;

procedure TfrmDiretorio.criarConfiguracaoDiretorioAtualizacao();
begin
  atualizarVlUltimoCodigo();
  UniQuery1.Connection:= dtmConnection.mscConnectionERP;
  UniQuery1.Close;
  UniQuery1.SQL.Clear;
  UniQuery1.SQL.Add('INSERT INTO Configuracao '+
    'VALUES(:idConfiguracao, :nmSecao, :nmConfiguracao,:vlConfiguracao)');
  UniQuery1.ParamByName('idConfiguracao').asstring:= getIdConfiguracao();
  UniQuery1.ParamByName('nmSecao').asstring:= 'DataBase';
  UniQuery1.ParamByName('nmConfiguracao').asstring:= 'DiretorioAtualizacao';
  UniQuery1.ParamByName('vlConfiguracao').asstring:= '';
  UniQuery1.ExecSQL();

end;

function TfrmDiretorio.ExisteConfiguracaoDiretorioAtualizacao: Boolean;
begin
  result:= False;
  qryConfiguracao1.Connection:= dtmConnection.mscConnectionERP;
  qryConfiguracao1.Close();
  qryConfiguracao1.open();
  if (qryConfiguracao1.FieldByName('vlConfiguracao').text) <> '' then
    result:= true;
end;

function TfrmDiretorio.NumToBase36(Value : DWord) : string;
const
  BaseType = 36;
  Base36Table = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Var
  BaseIdx : Word;
begin
  result := '';
  repeat
    BaseIdx := Value mod BaseType;
    Value := Value div BaseType;
    result := Base36Table[BaseIdx+1] + result;
  until value = 0;
end;

function TfrmDiretorio.StrZero(const strvalor: string;const intComprimento: integer): string;
var
  strZeros: string;
  intTamanho,i: integer;
begin
  inttamanho:= Length(Trim(strValor));
  strZeros:= strvalor;
  for i:= 0 to intComprimento - inttamanho do
    strZeros:= '0' + strZeros;
  Result:= strZeros;
end;

function TfrmDiretorio.getIdConfiguracao: string;
var
  ultimoCodigo,
  base36: string;
begin
  qryUltimoCodigo.Connection:= dtmConnection.mscConnectionERP;
  qryUltimoCodigo.Close();
  qryUltimoCodigo.SQL.Text:= ('Select VlUltimoCodigo from Codigo where '+
    'nmtabela = :nmTabela and nmCampo = :nmCampo');
  qryUltimoCodigo.ParamByName('nmTabela').asstring:= 'Configuracao';
  qryUltimoCodigo.ParamByName('nmCampo').asstring:= 'IDConfiguracao';
  qryUltimoCodigo.open();
  UltimoCodigo:= qryUltimoCodigo.FieldByName('vlUltimoCodigo').Text;
  base36:= NumToBase36(StrToInt(ultimoCodigo));
  result:= ('00A' + StrZero(base36,6));
end;

procedure TfrmDiretorio.AtualizarVlUltimoCodigo();
var
  sp_GetNextCode: TUniSQL;
begin
  sp_GetNextCode:= TUniSQL.Create(nil);
  UniSQLMonitor1.Active:= True;
  sp_GetNextCode.Connection:= dtmConnection.mscConnectionERP;
  sp_GetNextCode.SQL.Add('EXECUTE [dbo].[sp_GetNextCode]');
  sp_GetNextCode.SQL.Add(' :TableName,');
  sp_GetNextCode.SQL.Add(' :FieldName,');
  sp_GetNextCode.SQL.Add(' :GravaCodigo');

  sp_GetNextCode.ParamByName('TableName').Value := 'Configuracao';
  sp_GetNextCode.ParamByName('FieldName').Value := 'IdConfiguracao';
  sp_GetNextCode.ParamByName('GravaCodigo').Value := 'S';
  try
    sp_GetNextCode.Execute();
  finally
    sp_GetNextCode.Free;
  end;
end;

procedure TfrmDiretorio.ValidarConfiguracaoDiretorio();
begin
  if not (ExisteConfiguracaoDiretorioAtualizacao()) then
    begin
      criarConfiguracaoDiretorioAtualizacao();
    end;

  if not( DirectoryExists(edtDiretorio.Text)) then
    begin
      ShowMessage('Diretório inválido ou não encontrado, Verifique o diretório selecionado!');
      edtDiretorio.SetFocus();
      Abort();
    end;
end;

procedure TfrmDiretorio.GravarDiretorioAtualizacao();
begin
  qryConfiguracao.Connection:= dtmConnection.mscConnectionERP;
  qryConfiguracao.Close();
  qryConfiguracao.SQL.Text := ('Update configuracao set '+
                              'vlconfiguracao = :vlconfiguracao where '+
                  'nmsecao = :nmsecao and nmConfiguracao = :nmConfiguracao');
  qryConfiguracao.ParamByName('vlconfiguracao').AsString :=  edtDiretorio.Text;
  qryConfiguracao.ParamByName('nmsecao').asstring := 'DataBase';
  qryConfiguracao.ParamByName('nmConfiguracao').asstring := 'DiretorioAtualizacao';
  try
    qryConfiguracao.ExecSQL;
    ShowMessage('Diretório alterado com sucesso');
  except on e: Exception do
    ShowMessage('Não foi possível atualizar o Diretório :'+ #13
                + e.Message);
  end;
end;
end.
