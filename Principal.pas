unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AltUsrERP, AltLib, DConnectionERP,AltLibTypes,AltLibSist,udtmERP, CfgEst;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

    { Private declarations }
  public
    FCadastroUsuariosSQL: TUsuariosErp;
    FLogin: Boolean;
    FCfgEstoque: TCfgEst;
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
  FCadastroUsuariosSQL:= TUsuariosERP.create();
  FCadastroUsuariosSQL.Connection:= Connection.mscConnectionERP;

  FLogin := false;

  if (FCadastroUsuariosSQL.ShowLogin(ttlTerminar, cEstCompras, GetVersaoSistema(cEstCompras))) then
  begin
    FCfgEstoque := TCfgEst.Create(Connection.mscConnectionERP);

    FLogin := true;

    dtmERP.ConnectERPServer(ttlTerminar);

    inherited;
  end;
end;

end.
