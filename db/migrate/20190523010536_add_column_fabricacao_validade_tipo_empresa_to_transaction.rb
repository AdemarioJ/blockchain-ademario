class AddColumnFabricacaoValidadeTipoEmpresaToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :fabricacao, :string
    add_column :transactions, :validade, :string
    add_column :transactions, :tipo, :string
    add_column :transactions, :empresa, :string
  end
end
