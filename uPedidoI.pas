unit uPedidoI;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs;

type
  TPedidoI = class
  private
    FIdPedidoI: Integer;
    FIdPedidoG: Integer;
    FIdProduto: Integer;
    FQuantidade: Integer;
    FVlrUnitario: Double;
    FVlrTotal: Double;

    procedure SetIdPedidoI(const Value: Integer);
    function GetIdPedidoI:Integer;
    procedure SetIdPedidoG(const Value: Integer);
    function GetIdPedidoG:Integer;
    procedure SetIdProduto(const Value: Integer);
    function GetIdProduto:Integer;
    procedure SetQuantidade(const Value: Integer);
    function GetQuantidade:Integer;
    procedure SetVlrUnitario(const Value: Double);
    function GetVlrUnitario:Double;
    procedure SetVlrTotal(const Value: Double);
    function GetVlrTotal:Double;
  public
    function Inserir: Boolean;
    function Alterar: Boolean;
    function Excluir: Boolean;
    function Carregar: Boolean;

    property IdPedidoI: Integer read FIdPedidoI write SetIdPedidoI;
    property IdPedidoG: Integer read FIdPedidoG write SetIdPedidoG;
    property IdProduto: Integer read FIdProduto write SetIdProduto;
    property Quantidade: Integer read FQuantidade write SetQuantidade;
    property VlrUnitario: Double read FVlrUnitario write SetVlrUnitario;
    property VlrTotal: Double read FVlrTotal write SetVlrTotal;
  end;

implementation

uses uDM;

{ TPedidoI }

function TPedidoI.Alterar: Boolean;
  var qryAlterar: TFDQuery;
begin

  try
    try
      qryAlterar := TFDQuery.Create(nil);
      qryAlterar.Connection := DM.Conn;

      qryAlterar.Close;
      qryAlterar.SQL.Clear;
      qryAlterar.SQL.Add('UPDATE pedidoi SET quantidade, vlrunitario, vlrtotal');
      qryAlterar.SQL.Add('WHERE idpedidoi = :idpedidoi');
      qryAlterar.ParamByName('idpedidoi').AsInteger := Self.FIdPedidoI;
      qryAlterar.ParamByName('quantidade').AsInteger := Self.FQuantidade;
      qryAlterar.ParamByName('vlrunitario').AsFloat := Self.FVlrUnitario;
      qryAlterar.ParamByName('vlrtotal').AsFloat := Self.FVlrTotal;
      qryAlterar.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao alterar o produto do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryAlterar);
  end;
end;

function TPedidoI.Carregar: Boolean;
  var qryCarregar: TFDQuery;
begin
  Result := False;

  try
    try
      qryCarregar := TFDQuery.Create(nil);
      qryCarregar.Connection := DM.Conn;

      qryCarregar.Close;
      qryCarregar.SQL.Clear;
      qryCarregar.SQL.Add('SELECT * FROM pedidoi WHERE idpedidoi = :idpedidoi');
      qryCarregar.ParamByName('idpedidoi').AsInteger := Self.FIdPedidoI;
      qryCarregar.Open;

      if not qryCarregar.IsEmpty then
      begin
        Result := True;

        if Assigned(qryCarregar.FindField('idpedidoi')) then
          Self.FIdPedidoI := qryCarregar.FieldByName('idpedidoi').AsInteger;
        if Assigned(qryCarregar.FindField('idpedidog')) then
          Self.FIdPedidoG := qryCarregar.FieldByName('idpedidog').AsInteger;
        if Assigned(qryCarregar.FindField('idproduto')) then
          Self.FIdProduto := qryCarregar.FieldByName('idproduto').AsInteger;
        if Assigned(qryCarregar.FindField('quantidade')) then
          Self.FQuantidade := qryCarregar.FieldByName('quantidade').AsInteger;
        if Assigned(qryCarregar.FindField('vlrunitario')) then
          Self.FVlrUnitario := qryCarregar.FieldByName('vlrunitario').AsFloat;
        if Assigned(qryCarregar.FindField('vlrtotal')) then
          Self.FVlrTotal := qryCarregar.FieldByName('vlrtotal').AsFloat;
      end;

      except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao carregar o produto do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryCarregar);
  end;
end;

function TPedidoI.Excluir: Boolean;
  var qryExcluir: TFDQuery;
begin

  try
    try
      qryExcluir := TFDQuery.Create(nil);
      qryExcluir.Connection := DM.Conn;

      qryExcluir.Close;
      qryExcluir.SQL.Clear;
      qryExcluir.SQL.Add('DELETE FROM pedidoi WHERE idpedidoi = :idpedidoi');
      qryExcluir.ParamByName('idpedidoi').AsInteger := Self.FIdPedidoI;
      qryExcluir.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao excluir o produto do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryExcluir);
  end;
end;

function TPedidoI.GetIdPedidoG: Integer;
begin
  Result := fIdPedidoG;
end;

function TPedidoI.GetIdPedidoI: Integer;
begin
  Result := fIdPedidoI;
end;

function TPedidoI.GetIdProduto: Integer;
begin
  Result := fIdProduto;
end;

function TPedidoI.GetQuantidade: Integer;
begin
  Result := fQuantidade;
end;

function TPedidoI.GetVlrTotal: Double;
begin
  Result := fVlrTotal;
end;

function TPedidoI.GetVlrUnitario: Double;
begin
  Result := fVlrUnitario;
end;

function TPedidoI.Inserir: Boolean;
  var qryInserir: TFDQuery;
begin

  try
    try
      qryInserir := TFDQuery.Create(nil);
      qryInserir.Connection := DM.Conn;

      qryInserir.Close;
      qryInserir.SQL.Clear;
      qryInserir.SQL.Add('INSERT INTO pedidoi (idpedidog, idproduto, quantidade, vlrunitario, vlrtotal) ');
      qryInserir.SQL.Add('VALUES (:idpedidog, :idproduto, :quantidade, :vlrunitario , :vlrtotal) ');
      qryInserir.ParamByName('idpedidog').AsInteger := Self.FIdPedidoG;
      qryInserir.ParamByName('idproduto').AsInteger := Self.FIdProduto;
      qryInserir.ParamByName('quantidade').AsInteger := Self.FQuantidade;
      qryInserir.ParamByName('vlrunitario').AsFloat := Self.FVlrUnitario;
      qryInserir.ParamByName('vlrtotal').AsFloat := Self.FVlrTotal;
      qryInserir.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao incluir o produto do pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryInserir);
  end;
end;

procedure TPedidoI.SetIdPedidoG(const Value: Integer);
begin
  FIdPedidoG := Value;
end;

procedure TPedidoI.SetIdPedidoI(const Value: Integer);
begin
  FIdPedidoI := Value;
end;

procedure TPedidoI.SetIdProduto(const Value: Integer);
begin
  FIdProduto := Value;
end;

procedure TPedidoI.SetQuantidade(const Value: Integer);
begin
  FQuantidade := Value;
end;

procedure TPedidoI.SetVlrTotal(const Value: Double);
begin
  FVlrTotal := Value;
end;

procedure TPedidoI.SetVlrUnitario(const Value: Double);
begin
  FVlrUnitario := Value;
end;

end.
