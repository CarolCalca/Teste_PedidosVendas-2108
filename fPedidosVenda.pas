unit fPedidosVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, uDM, uProduto, uCliente, uPedidoG, uPedidoI;

type
  TfrmPedidosVenda = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblTotal: TLabel;
    btnAdicionar: TButton;
    btnGravar: TButton;
    dbgProdutos: TDBGrid;
    cdsProdutos: TClientDataSet;
    dsProdutos: TDataSource;
    edtIdCliente: TEdit;
    edtIdProduto: TEdit;
    edtQtd: TEdit;
    edtValor: TEdit;
    btnCarregar: TButton;
    btnCancelar: TButton;
    edtNomeCliente: TEdit;
    edtDescProduto: TEdit;
    cdsProdutosidpedidoi: TIntegerField;
    cdsProdutosidpedidog: TIntegerField;
    cdsProdutosidproduto: TIntegerField;
    cdsProdutosdescricao: TStringField;
    cdsProdutosquantidade: TIntegerField;
    cdsProdutosvlrunitario: TFloatField;
    cdsProdutosvlrtotal: TFloatField;
    procedure edtIdClienteChange(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure cdsProdutosAfterPost(DataSet: TDataSet);
    procedure btnGravarClick(Sender: TObject);
    procedure edtIdClienteExit(Sender: TObject);
    procedure edtValorExit(Sender: TObject);
    procedure edtValorEnter(Sender: TObject);
    procedure edtQtdEnter(Sender: TObject);
    procedure edtIdClienteEnter(Sender: TObject);
    procedure edtIdProdutoEnter(Sender: TObject);
    procedure edtIdProdutoExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbgProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
  private
    const cstVlrMask: String = '#,###,###,##0.00';

    var TProd: TProduto;
        TCli:  TCliente;
        TPedG: TPedidoG;
        TPedI: TPedidoI;
  public
    { Public declarations }
  end;

var
  frmPedidosVenda: TfrmPedidosVenda;

implementation

{$R *.dfm}

procedure TfrmPedidosVenda.btnAdicionarClick(Sender: TObject);
begin
  if (edtIdProduto.Text = EmptyStr) then
  begin
    MessageDlg('Por favor, preencha o produto.', mtWarning, [mbOk], 0, mbOk);
    edtIdProduto.SetFocus;
  end
  else if (StrToIntDef(edtQtd.Text, 0) = 0) then
  begin
    MessageDlg('Por favor, preencha a quantidade.', mtWarning, [mbOk], 0, mbOk);
    edtQtd.SetFocus;
  end
  else if (StrToFloatDef(edtValor.Text, 0) = 0) then
  begin
    MessageDlg('Por favor, preencha o valor unitário.', mtWarning, [mbOk], 0, mbOk);
    edtValor.SetFocus;
  end
  else
  begin

    // verificar se foi inclusão ou alteração
    
    cdsProdutos.DisableControls;
    
    try
      try     
        cdsProdutos.Append;
        cdsProdutos.FieldByName('idpedidoi').AsInteger := 0;
        cdsProdutos.FieldByName('idpedidog').AsInteger := 0;
        cdsProdutos.FieldByName('idproduto').AsInteger := StrToInt(edtIdProduto.Text);
        cdsProdutos.FieldByName('descricao').AsString := edtDescProduto.Text;
        cdsProdutos.FieldByName('quantidade').AsInteger := StrToInt(edtQtd.Text);
        cdsProdutos.FieldByName('vlrunitario').AsFloat := StrToFloat(edtValor.Text);
        cdsProdutos.FieldByName('vlrtotal').AsFloat := (StrToFloat(edtValor.Text) * StrToInt(edtQtd.Text));
        cdsProdutos.Post;
      
      except on E:Exception do
        begin
          MessageDlg('Erro ao incluir o produto!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
          edtIdProduto.SetFocus;
        end;   
      end;
    finally
      cdsProdutos.EnableControls;
    end;
  end;

end;

procedure TfrmPedidosVenda.btnCancelarClick(Sender: TObject);
begin
  // abre para digitar o numero do pedido
  // confirma se quer cancelar
  // exclui (itens e) pedido
end;

procedure TfrmPedidosVenda.btnCarregarClick(Sender: TObject);
begin
  // carrega edits (cliente)
  // carrega dataset
end;

procedure TfrmPedidosVenda.btnGravarClick(Sender: TObject);
begin
  if (edtIdCliente.Text = EmptyStr) then
  begin
    MessageDlg('Por favor, preencha o cliente.', mtWarning, [mbOk], 0, mbOk);
    edtIdCliente.SetFocus;
  end
  else if (cdsProdutos.IsEmpty) then
  begin
    MessageDlg('Por favor, adicione produtos ao pedido.', mtWarning, [mbOk], 0, mbOk);
    edtIdProduto.SetFocus;
  end
  else
  begin
    // abre transacao

    //exclui itens, se houver
    
    // grava pedido (verificar inclusão ou alteração)
    // grava itens (verificar inclusão ou alteração)
    // commit

    // rollback caso except
  end;
end;

procedure TfrmPedidosVenda.cdsProdutosAfterPost(DataSet: TDataSet);
var dblValorTotal: Double;
begin
  dblValorTotal := 0;

  cdsProdutos.DisableControls;

  try
    cdsProdutos.First;
    while not cdsProdutos.Eof do
    begin
      dblValorTotal := dblValorTotal + cdsProdutos.FieldByName('vlrtotal').AsFloat;
      cdsProdutos.Next;
    end;
  finally
    lblTotal.Caption := 'R$ ' + FormatFloat(cstVlrMask, dblValorTotal);
    cdsProdutos.EnableControls;
  end;
end;

procedure TfrmPedidosVenda.dbgProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // se key = setas, navegar grid

  // verifica se clicou em um registro
    // se del
    // pergunta exclusão
    // exclui (e adiciona em outro dataset, para excluir apenas ao gravar, na transação)

    // se enter
    // habilita alteração
  //
end;

procedure TfrmPedidosVenda.edtIdClienteChange(Sender: TObject);
begin
  btnCarregar.Enabled := (edtIdCliente.Text = EmptyStr);
  btnCancelar.Enabled := (edtIdCliente.Text = EmptyStr);
end;

procedure TfrmPedidosVenda.edtIdClienteEnter(Sender: TObject);
begin
  edtIdCliente.SetFocus;
end;

procedure TfrmPedidosVenda.edtIdClienteExit(Sender: TObject);
begin
  if (edtIdCliente.Text <> EmptyStr) then
  begin
    TCli.IdCliente := StrToInt(edtIdCliente.Text);

    if TCli.Carregar then
    begin
      edtIdCliente.Text := IntToStr(TCli.IdCliente);
      edtNomeCliente.Text := TCli.Nome;
    end
    else
    begin
      MessageDlg('Cliente não encontrado. Por favor, verifique.', mtWarning, [mbOk], 0, mbOk);
      edtIdCliente.SetFocus;
    end;
  end;
end;

procedure TfrmPedidosVenda.edtIdProdutoEnter(Sender: TObject);
begin
  edtIdProduto.SetFocus;
end;

procedure TfrmPedidosVenda.edtIdProdutoExit(Sender: TObject);
begin
  if (edtIdProduto.Text <> EmptyStr) then
  begin
    TProd.IdProduto := StrToInt(edtIdProduto.Text);

    if TProd.Carregar then
    begin
      edtIdProduto.Text := IntToStr(TProd.IdProduto);
      edtDescProduto.Text := TProd.Descricao;
      edtValor.Text := FormatFloat(cstVlrMask, TProd.PrecoVenda);
    end
    else
    begin
      MessageDlg('Produto não encontrado. Por favor, verifique.', mtWarning, [mbOk], 0, mbOk);
      edtIdCliente.SetFocus;
    end;
  end;
end;

procedure TfrmPedidosVenda.edtQtdEnter(Sender: TObject);
begin
  edtQtd.SetFocus;
end;

procedure TfrmPedidosVenda.edtValorEnter(Sender: TObject);
begin
  edtValor.SetFocus;
end;

procedure TfrmPedidosVenda.edtValorExit(Sender: TObject);
  var strTexto: String;
begin
  strTexto := edtValor.Text;
  strTexto := StringReplace(strTexto, '.', '', [rfReplaceAll]);
  strTexto := StringReplace(strTexto, ',', '', [rfReplaceAll]);
  strTexto := Copy(strTexto, 1, Length(strTexto)-2) + ',' + Copy(strTexto, Length(strTexto)-1, 2);
  strTexto := FormatFloat(cstVlrMask, StrToFloat(strTexto));

  edtValor.Text := strTexto;
end;

procedure TfrmPedidosVenda.FormCreate(Sender: TObject);
begin
  TProd := TProduto.Create;
  TCli  := TCliente.Create;
  TPedG := TPedidoG.Create;
  TPedI := TPedidoI.Create;

  cdsProdutos.CreateDataSet;
  cdsProdutos.Open;
end;

end.
