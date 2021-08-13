unit uPedidoG;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs;

type
  TPedidoG = class
  private
    FIdPedidoG: Integer;
    FData: TDateTime;
    FIdCliente: Integer;
    FVlrTotal: Double;

    procedure SetIdPedidoG(const Value: Integer);
    function GetIdPedidoG:Integer;
    procedure SetData(const Value: TDateTime);
    function GetData:TDateTime;
    procedure SetIdCliente(const Value: Integer);
    function GetIdCliente:Integer;
    procedure SetVlrTotal(const Value: Double);
    function GetVlrTotal:Double;
  public
    function Inserir: Boolean;
    function Alterar: Boolean;
    function Excluir: Boolean;
    function Carregar: Boolean;

    property IdPedidoG: Integer read FIdPedidoG write SetIdPedidoG;
    property Data: TDateTime read FData write SetData;
    property IdCliente: Integer read FIdCliente write SetIdCliente;
    property VlrTotal: Double read FVlrTotal write SetVlrTotal;
  end;

implementation

uses uDM;

{ TPedidoG }

function TPedidoG.Alterar: Boolean;
  var qryAlterar: TFDQuery;
begin

  try
    try
      qryAlterar := TFDQuery.Create(nil);
      qryAlterar.Connection := DM.Conn;

      qryAlterar.Close;
      qryAlterar.SQL.Clear;
      qryAlterar.SQL.Add('UPDATE pedidog SET vlrtotal = :vlrtotal');
      qryAlterar.SQL.Add('WHERE idpedidog = :idpedidog');
      qryAlterar.ParamByName('idpedidog').AsInteger := Self.FIdPedidoG;
      qryAlterar.ParamByName('vlrtotal').AsFloat := Self.FVlrTotal;
      qryAlterar.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao alterar o Pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryAlterar);
  end;
end;

function TPedidoG.Carregar: Boolean;
  var qryCarregar: TFDQuery;
begin
  Result := False;

  try
    try
      qryCarregar := TFDQuery.Create(nil);
      qryCarregar.Connection := DM.Conn;

      qryCarregar.Close;
      qryCarregar.SQL.Clear;
      qryCarregar.SQL.Add('SELECT * FROM pedidog WHERE idpedidog = :idpedidog');
      qryCarregar.ParamByName('idpedidog').AsInteger := Self.FIdPedidoG;
      qryCarregar.Open;

      if not qryCarregar.IsEmpty then
      begin
        Result := True;

        if Assigned(qryCarregar.FindField('idpedidog')) then
          Self.FIdPedidoG := qryCarregar.FieldByName('idpedidog').AsInteger;
        if Assigned(qryCarregar.FindField('data')) then
          Self.FData := qryCarregar.FieldByName('data').AsDateTime;
        if Assigned(qryCarregar.FindField('idcliente')) then
          Self.FIdCliente := qryCarregar.FieldByName('idcliente').AsInteger;
        if Assigned(qryCarregar.FindField('vlrtotal')) then
          Self.FVlrTotal := qryCarregar.FieldByName('vlrtotal').AsFloat;
      end;

      except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao carregar o Pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryCarregar);
  end;
end;

function TPedidoG.Excluir: Boolean;
  var qryExcluir: TFDQuery;
begin

  try
    try
      qryExcluir := TFDQuery.Create(nil);
      qryExcluir.Connection := DM.Conn;

      qryExcluir.Close;
      qryExcluir.SQL.Clear;
      qryExcluir.SQL.Add('DELETE FROM pedidoi WHERE idpedidog = :idpedidog');
      qryExcluir.ParamByName('idpedidog').AsInteger := Self.FIdPedidoG;
      qryExcluir.ExecSQL;

      qryExcluir.Close;
      qryExcluir.SQL.Clear;
      qryExcluir.SQL.Add('DELETE FROM pedidog WHERE idpedidog = :idpedidog');
      qryExcluir.ParamByName('idpedidog').AsInteger := Self.FIdPedidoG;
      qryExcluir.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao excluir o Pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryExcluir);
  end;
end;

function TPedidoG.GetData: TDateTime;
begin
  Result := fData;
end;

function TPedidoG.GetIdCliente: Integer;
begin
  Result := fIdCliente;
end;

function TPedidoG.GetIdPedidoG: Integer;
begin
  Result := fIdPedidoG;
end;

function TPedidoG.GetVlrTotal: Double;
begin
  Result := fVlrTotal;
end;

function TPedidoG.Inserir: Boolean;
  var qryInserir: TFDQuery;
begin

  try
    try
      qryInserir := TFDQuery.Create(nil);
      qryInserir.Connection := DM.Conn;

      qryInserir.Close;
      qryInserir.SQL.Clear;
      qryInserir.SQL.Add('INSERT INTO pedidog (data, idcliente, vlrtotal) VALUES (:data, :idcliente, :vlrtotal)');
      qryInserir.ParamByName('data').AsDateTime := Self.FData;
      qryInserir.ParamByName('idcliente').AsInteger := Self.FIdCliente;
      qryInserir.ParamByName('vlrtotal').AsFloat := Self.FVlrTotal;
      qryInserir.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao incluir o Pedido!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryInserir);
  end;
end;

procedure TPedidoG.SetData(const Value: TDateTime);
begin
  FData := Value;
end;

procedure TPedidoG.SetIdCliente(const Value: Integer);
begin
  FIdCliente := Value;
end;

procedure TPedidoG.SetIdPedidoG(const Value: Integer);
begin
  FIdPedidoG := Value;
end;

procedure TPedidoG.SetVlrTotal(const Value: Double);
begin
  FVlrTotal := Value;
end;

end.
