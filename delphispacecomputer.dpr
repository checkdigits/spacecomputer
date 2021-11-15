program delphispacecomputer;

uses
  Vcl.Forms,
  forms.maincomputergui in 'forms.maincomputergui.pas' {MainComputerGUI};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainComputerGUI, MainComputerGUI);
  Application.Run;
end.
