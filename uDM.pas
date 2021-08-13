unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQL, Vcl.Dialogs,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, uCliente, uProduto;

type
  TDM = class(TDataModule)
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    Conn: TFDConnection;
    ConnT: TFDConnection;
    qryDB: TFDQuery;
  private
    function GetConn(strDBName: String = ''): Boolean;
    function GetConnT: Boolean;

    procedure ConectaDB;
    procedure CriaDB;

    procedure InsereCliente;
    procedure InsereProduto;
  public
    constructor Create;
  end;

var
  DM: TDM;

const
  cstDB_Driver: string = 'MySQL';
  cstDB_User: string = 'root';
  cstDB_Pass: string = 'root';
  cstDB_Name: string = 'dbcarol';

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }

constructor TDM.Create;
begin
  ConectaDB;
end;

procedure TDM.CriaDB;
begin

  try
    qryDB.Close;
    qryDB.SQL.Clear;
    qryDB.SQL.Add('CREATE DATABASE IF NOT EXISTS :SCHEMA_NAME');
    qryDB.ParamByName('SCHEMA_NAME').AsString := cstDB_Name;
    qryDB.ExecSQL;
  except on E:Exception do
    begin
      MessageDlg('Erro ao criar o banco de dados!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  end;

  if GetConn(cstDB_Name) then
  begin
    try
      // Clientes
      qryDB.Close;
      qryDB.SQL.Clear;
      qryDB.SQL.Add('CREATE TABLE IF NOT EXISTS `'+cstDB_Name+'`.`cliente` ( ');
      qryDB.SQL.Add('  `idcliente` INT NOT NULL AUTO_INCREMENT,   ');
      qryDB.SQL.Add('  `nome` VARCHAR(150) NOT NULL,              ');
      qryDB.SQL.Add('  `cidade` VARCHAR(150) NULL,                ');
      qryDB.SQL.Add('  `uf` VARCHAR(2) NULL,                      ');
      qryDB.SQL.Add('  PRIMARY KEY (`idcliente`),                 ');
      qryDB.SQL.Add('  INDEX `idx_cidade` (`cidade` ASC) VISIBLE, ');
      qryDB.SQL.Add('  INDEX `idx_uf` (`uf` ASC) VISIBLE)         ');
      qryDB.ExecSQL;

      InsereCliente;

      // Produtos
      qryDB.Close;
      qryDB.SQL.Clear;
      qryDB.SQL.Add('CREATE TABLE IF NOT EXISTS `'+cstDB_Name+'`.`produto` ( ');
      qryDB.SQL.Add('  `idproduto` INT NOT NULL AUTO_INCREMENT,         ');
      qryDB.SQL.Add('  `descricao` VARCHAR(150) NOT NULL,               ');
      qryDB.SQL.Add('  `precovenda` DECIMAL(10,2) NOT NULL,             ');
      qryDB.SQL.Add('  PRIMARY KEY (`idproduto`),                       ');
      qryDB.SQL.Add('  INDEX `idx_descricao` (`descricao` ASC) VISIBLE) ');
      qryDB.ExecSQL;

      InsereProduto;

      // Pedidos Geral
      qryDB.Close;
      qryDB.SQL.Clear;
      qryDB.SQL.Add('CREATE TABLE IF NOT EXISTS `'+cstDB_Name+'`.`pedidog` ( ');
      qryDB.SQL.Add('  `idpedido` INT NOT NULL AUTO_INCREMENT,               ');
      qryDB.SQL.Add('  `data` DATETIME NOT NULL,                             ');
      qryDB.SQL.Add('  `idcliente` INT NOT NULL,                             ');
      qryDB.SQL.Add('  `vlrtotal` DECIMAL(10,2) NOT NULL,                    ');
      qryDB.SQL.Add('  PRIMARY KEY (`idpedido`),                             ');
      qryDB.SQL.Add('  INDEX `idx_data` (`data` ASC) INVISIBLE,              ');
      qryDB.SQL.Add('  INDEX `idx_idcliente` (`idcliente` ASC) VISIBLE,      ');
      qryDB.SQL.Add('  CONSTRAINT `fk_idcliente`                             ');
      qryDB.SQL.Add('  FOREIGN KEY (`idcliente`)                             ');
      qryDB.SQL.Add('  REFERENCES `'+cstDB_Name+'`.`cliente` (`idcliente`)   ');
      qryDB.SQL.Add('  ON DELETE NO ACTION                                   ');
      qryDB.SQL.Add('  ON UPDATE NO ACTION)                                  ');
      qryDB.ExecSQL;

      // Pedidos Itens
      qryDB.Close;
      qryDB.SQL.Clear;
      qryDB.SQL.Add('CREATE TABLE IF NOT EXISTS `'+cstDB_Name+'`.`pedidoi` ( ');
      qryDB.SQL.Add('  `idpedidoi` INT NOT NULL AUTO_INCREMENT,              ');
      qryDB.SQL.Add('  `idpedidog` INT NOT NULL,                             ');
      qryDB.SQL.Add('  `idproduto` INT NOT NULL,                             ');
      qryDB.SQL.Add('  `quantidade` INT NOT NULL,                            ');
      qryDB.SQL.Add('  `vlrunitario` DECIMAL(10,2) NOT NULL,                 ');
      qryDB.SQL.Add('  `vlrtotal` DECIMAL(10,2) NOT NULL,                    ');
      qryDB.SQL.Add('  PRIMARY KEY (`idpedidoi`),                            ');
      qryDB.SQL.Add('  INDEX `idx_idpedidog` (`idpedidog` ASC) INVISIBLE,    ');
      qryDB.SQL.Add('  INDEX `idx_idproduto` (`idproduto` ASC) VISIBLE,      ');
      qryDB.SQL.Add('  CONSTRAINT `fk_idproduto`                             ');
      qryDB.SQL.Add('  FOREIGN KEY (`idproduto`)                             ');
      qryDB.SQL.Add('  REFERENCES `'+cstDB_Name+'`.`produto` (`idproduto`)   ');
      qryDB.SQL.Add('  ON DELETE NO ACTION                                   ');
      qryDB.SQL.Add('  ON UPDATE NO ACTION,                                  ');
      qryDB.SQL.Add('  CONSTRAINT `fk_idpedidog`                             ');
      qryDB.SQL.Add('  FOREIGN KEY (`idpedidog`)                             ');
      qryDB.SQL.Add('  REFERENCES `'+cstDB_Name+'`.`pedidog` (`idpedidog`)   ');
      qryDB.SQL.Add('  ON DELETE NO ACTION                                   ');
      qryDB.SQL.Add('  ON UPDATE NO ACTION)                                  ');
      qryDB.ExecSQL;

    except on E:Exception do
      begin
        MessageDlg('Erro ao criar o banco de dados!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
      end;
    end;
  end;
end;

procedure TDM.ConectaDB;
begin
  GetConn;

  qryDB.Close;
  qryDB.SQL.Clear;
  qryDB.SQL.Add('SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = :SCHEMA_NAME');
  qryDB.ParamByName('SCHEMA_NAME').AsString := cstDB_Name;
  qryDB.Open;

  if not qryDB.IsEmpty then
    GetConn(cstDB_Name)
  else
    CriaDB;
end;

function TDM.GetConn(strDBName: String = ''): Boolean;
begin
  Result := False;

  try
    Conn.Params.DriverID := cstDB_Driver;
    Conn.Params.UserName := cstDB_User;
    Conn.Params.Password := cstDB_Pass;

    if strDBName <> EmptyStr then
      Conn.Params.Database := strDBName;

    Conn.Open;

    Result := True;
  except on E:Exception do
    begin
      Result := False;
      MessageDlg('Erro ao conectar!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  end;
end;

function TDM.GetConnT: Boolean;
begin
  Result := False;

  try
    ConnT.Params.DriverID := cstDB_Driver;
    ConnT.Params.UserName := cstDB_User;
    ConnT.Params.Password := cstDB_Pass;
    ConnT.Params.Database := cstDB_Name;

    ConnT.TxOptions.AutoCommit := False;
    ConnT.TxOptions.AutoStart  := False;
    ConnT.TxOptions.AutoStop   := False;

    ConnT.Open;

    Result := True;
  except on E:Exception do
    begin
      Result := False;
      MessageDlg('Erro ao conectar!' + #13 + #13 + E.Message, mtError, [mbOk], 0, mbOk);
    end;
  end;
end;

procedure TDM.InsereCliente;
 var TCli: TCliente;
begin
  TCli := TCliente.Create;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;

  TCli.Nome   := '';
  TCli.Cidade := '';
  TCli.UF     := '';
  TCli.Inserir;
end;

procedure TDM.InsereProduto;
  var TProd: TProduto;
begin
  TProd := TProduto.Create;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;

  TProd.Descricao  := '';
  TProd.PrecoVenda := 0;
  TProd.Inserir;
end;

end.
