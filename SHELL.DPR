program shell;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Shell Universal';
  Application.CreateForm(Tfrm, frm);
  Application.Run;
end.
