program PedidosVenda;

uses
  Vcl.Forms,
  fPedidosVenda in 'fPedidosVenda.pas' {frmPedidosVenda},
  uDM in 'uDM.pas' {DM: TDataModule},
  uCliente in 'uCliente.pas',
  uProduto in 'uProduto.pas',
  uPedidoG in 'uPedidoG.pas',
  uPedidoI in 'uPedidoI.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmPedidosVenda, frmPedidosVenda);
  Application.Run;
end.
