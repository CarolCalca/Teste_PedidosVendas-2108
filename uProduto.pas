unit uProduto;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs;

type
  TProduto = class
  private
    FIdProduto: Integer;
    FDescricao: string;
    FPrecoVenda: Double;

    procedure SetIdProduto(const Value: Integer);
    function GetIdProduto:Integer;
    procedure SetDescricao(const Value: string);
    function GetDescricao:string;
    procedure SetPrecoVenda(const Value: Double);
    function GetPrecoVenda:Double;
  public
    function Inserir: Boolean;
    function Carregar: Boolean;

    property IdProduto: Integer read FIdProduto write SetIdProduto;
    property Descricao: string read FDescricao write SetDescricao;
    property PrecoVenda: Double read FPrecoVenda write SetPrecoVenda;
  end;

implementation

uses uDM;

{ TProduto }

function TProduto.Carregar: Boolean;
  var qryCarregar: TFDQuery;
begin
  Result := False;

  try
    try
      qryCarregar := TFDQuery.Create(nil);
      qryCarregar.Connection := DM.Conn;

      qryCarregar.Close;
      qryCarregar.SQL.Clear;
      qryCarregar.SQL.Add('SELECT * FROM produto WHERE idproduto = :idproduto');
      qryCarregar.ParamByName('idproduto').AsInteger := Self.FIdProduto;
      qryCarregar.Open;

      if not qryCarregar.IsEmpty then
      begin
        Result := True;

        if Assigned(qryCarregar.FindField('idproduto')) then
          Self.FIdProduto := qryCarregar.FieldByName('idproduto').AsInteger;
        if Assigned(qryCarregar.FindField('descricao')) then
          Self.FDescricao := qryCarregar.FieldByName('descricao').AsString;
        if Assigned(qryCarregar.FindField('precovenda')) then
          Self.FPrecoVenda := qryCarregar.FieldByName('precovenda').AsFloat;
      end;

    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao carregar o Produto!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryCarregar);
  end;
end;

function TProduto.GetDescricao: string;
begin
  Result := fDescricao;
end;

function TProduto.GetIdProduto: Integer;
begin
  Result := fIdProduto;
end;

function TProduto.GetPrecoVenda: Double;
begin
  Result := fPrecoVenda;
end;

function TProduto.Inserir: Boolean;
  var qryInserir: TFDQuery;
begin

  try
    try
      qryInserir := TFDQuery.Create(nil);
      qryInserir.Connection := DM.Conn;

      qryInserir.Close;
      qryInserir.SQL.Clear;
      qryInserir.SQL.Add('INSERT INTO produto (descricao, precovenda) VALUES (:descricao, :precovenda)');
      qryInserir.ParamByName('descricao').AsString := Self.FDescricao;
      qryInserir.ParamByName('precovenda').AsFloat := Self.FPrecoVenda;
      qryInserir.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao inserir o Produto!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryInserir);
  end;
end;

procedure TProduto.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TProduto.SetIdProduto(const Value: Integer);
begin
  FIdProduto := Value;
end;

procedure TProduto.SetPrecoVenda(const Value: Double);
begin
  FPrecoVenda := Value;
end;

end.
