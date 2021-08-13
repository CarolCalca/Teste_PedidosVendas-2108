object DM: TDM
  OldCreateOrder = False
  Height = 222
  Width = 340
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 64
    Top = 24
  end
  object Conn: TFDConnection
    Left = 176
    Top = 24
  end
  object ConnT: TFDConnection
    TxOptions.AutoStart = False
    TxOptions.AutoStop = False
    Left = 176
    Top = 80
  end
  object qryDB: TFDQuery
    Connection = Conn
    Left = 240
    Top = 24
  end
end
