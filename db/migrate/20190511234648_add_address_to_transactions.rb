class AddAddressToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :latitude, :double
    add_column :transactions, :longitude, :double
    add_column :transactions, :pais, :string
    add_column :transactions, :uf, :string
    add_column :transactions, :cidade, :string
    add_column :transactions, :bairro, :string
    add_column :transactions, :rua, :string
    add_column :transactions, :numero, :string
    add_column :transactions, :cep, :string
    add_column :transactions, :data, :string
    add_column :transactions, :horario, :string
    add_column :transactions, :endereco, :string
  end
end
