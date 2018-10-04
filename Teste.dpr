program Teste;

uses
  ExceptionLog,
  Forms,
  Principal in 'Principal.pas' {Form1},
  uImagensRepositorio16x16 in '..\..\..\unitscompartilhadas\template.crud\uImagensRepositorio16x16.pas' {ImagensRepositorio16x16: TDataModule},
  uImagensRepositorio24x24 in '..\..\..\unitscompartilhadas\template.crud\uImagensRepositorio24x24.pas' {ImagensRepositorio24x24: TDataModule},
  DConnectionERP in '..\..\..\..\trunk\unitscompartilhadas\geral\DConnectionERP.pas' {dtmConnection: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdtmConnection, dtmConnection);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
