require 'active_record'
require 'sqlite3'
module Sqlite
  class Orm
    def self.setup
      ActiveRecord::Base.logger = Logger.new(STDERR)

      ActiveRecord::Base.establish_connection(
        adapter: 'sqlite3',
        database: __dir__ + '/db/sample.sqlite3'
      )
      ActiveRecord::Schema.define do
        unless ActiveRecord::Base.connection.table_exists?(:response_zero_shops)
          create_table :response_zero_shops do |table|
            table.column :shop_id,     :integer
            table.column :db_name,     :string
            table.column :db_address,  :string
            table.column :params_name,    :string
            table.column :params_address, :string
          end
        end
        unless ActiveRecord::Base.connection.table_exists?(:response_one_shops)
          create_table :response_one_shops do |table|
            table.column :shop_id,     :integer
            table.column :db_name,     :string
            table.column :db_address,  :string
            table.column :api_address, :string
            table.column :api_name, :string
            table.column :api_urls,    :string
            table.column :params_name,    :string
            table.column :params_address, :string
          end
        end

        unless ActiveRecord::Base.connection.table_exists?(:response_zero_shops)
          create_table :response_over_two_shops do |table|
            table.column :shop_id,     :integer
            table.column :db_name,     :string
            table.column :db_address,  :string
            table.column :api_address, :string
            table.column :api_name, :string
            table.column :api_urls,    :string
            table.column :params_name,    :string
            table.column :params_address, :string
          end
        end
      end
    end
  end
end

class ResponseZeroShop < ActiveRecord::Base; end
class ResponseOneShop < ActiveRecord::Base; end
class ResponseOverTwoShop < ActiveRecord::Base; end

