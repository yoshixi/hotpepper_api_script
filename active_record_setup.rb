module Sqlite
  class ActiveRecord
    def self.setup
      ActiveRecord::Base.logger = Logger.new(STDERR)
      ActiveRecord::Base.colorize_logging = false
      ActiveRecord::Base.establish_connection(
        adapter: "sqlite3",
        dbfile:  "./hotpepper_data.sqlite"
      )

      ActiveRecord::Schema.define do
        create_table :response_0 do |table|
          table.column :shop_id,     :integer
          table.column :db_name,     :string
          table.column :db_address,  :string
          table.column :params_name,    :string
          table.column :params_address, :string
        end
        create_table :response_1 do |table|
          table.column :shop_id,     :integer
          table.column :db_name,     :string
          table.column :db_address,  :string
          table.column :api_address, :string
          table.column :api_name, :string
          table.column :api_urls,    :string
          table.column :params_name,    :string
          table.column :params_address, :string
        end

        create_table :response_over_2 do |table|
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

class Response0 < ActiveRecord::Base; end
class Response1 < ActiveRecord::Base; end
class ResponseOver2 < ActiveRecord::Base; end

