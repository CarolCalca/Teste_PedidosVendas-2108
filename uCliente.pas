unit uCliente;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs;

type
  TCliente = class
  private
    FIdCliente: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;

    procedure SetIdCliente(const Value: Integer);
    function GetIdCliente:Integer;
    procedure SetNome(const Value: string);
    function GetNome:string;
    procedure SetCidade(const Value: string);
    function GetCidade:string;
    procedure SetUF(const Value: string);
    function GetUF:string;
  public  
    function Inserir: Boolean;
    function Carregar: Boolean;

    property IdCliente: Integer read FIdCliente write SetIdCliente;
    property Nome: string read FNome write SetNome;
    property Cidade: string read FCidade write SetCidade;
    property UF: string read FUF write SetUF;
  end;

implementation

uses uDM;

{ TCliente }

function TCliente.Carregar: Boolean;
  var qryCarregar: TFDQuery;
begin
  Result := False;
  
  try
    try
      qryCarregar := TFDQuery.Create(nil);
      qryCarregar.Connection := DM.Conn;

      qryCarregar.Close;
      qryCarregar.SQL.Clear;
      qryCarregar.SQL.Add('SELECT * FROM cliente WHERE idcliente = :idcliente');
      qryCarregar.ParamByName('idcliente').AsInteger := Self.FIdCliente;
      qryCarregar.Open;

      if not qryCarregar.IsEmpty then
      begin
        Result := True;

        if Assigned(qryCarregar.FindField('idcliente')) then
          Self.FIdCliente := qryCarregar.FieldByName('idcliente').AsInteger;
        if Assigned(qryCarregar.FindField('nome')) then
          Self.FNome := qryCarregar.FieldByName('nome').AsString;
        if Assigned(qryCarregar.FindField('cidade')) then
          Self.FCidade := qryCarregar.FieldByName('cidade').AsString;
        if Assigned(qryCarregar.FindField('uf')) then
          Self.FUF := qryCarregar.FieldByName('uf').AsString;
      end;

    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao carregar o Cliente!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryCarregar);
  end;
end;

function TCliente.GetCidade: string;
begin
  Result := fCidade;
end;

function TCliente.GetIdCliente: Integer;
begin
  Result := fIdCliente;
end;

function TCliente.GetNome: string;
begin
  Result := fNome;
end;

function TCliente.GetUF: string;
begin
  Result := fUF;
end;

function TCliente.Inserir: Boolean;
  var qryInserir: TFDQuery;
begin

  try
    try
      qryInserir := TFDQuery.Create(nil);
      qryInserir.Connection := DM.Conn;

      qryInserir.Close;
      qryInserir.SQL.Clear;
      qryInserir.SQL.Add('INSERT INTO cliente (nome, cidade, uf) VALUES (:nome, :cidade, :uf)');
      qryInserir.ParamByName('nome').AsString := Self.FNome;
      qryInserir.ParamByName('cidade').AsString := Self.FCidade;
      qryInserir.ParamByName('uf').AsString := Self.FUF;
      qryInserir.ExecSQL;

      Result := True;
    except on E:Exception do
      begin
        Result := False;
        MessageDlg('Erro ao inserir o Cliente!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  finally
    FreeAndNil(qryInserir);
  end;
end;

procedure TCliente.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TCliente.SetIdCliente(const Value: Integer);
begin
  FIdCliente := Value;
end;

procedure TCliente.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TCliente.SetUF(const Value: string);
begin
  FUF := Value;
end;

end.
