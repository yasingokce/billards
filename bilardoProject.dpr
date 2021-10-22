program bilardoProject;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  MyTypes in 'MyTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
