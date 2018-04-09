require "sqlite3"
require "active_record"

Dir[__dir__ + '/model/*.rb'].each(&method(:require))

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => __dir__ + '/db/sample.sqlite3'
)

def create_test_table(code)
  table_name = "sample" + code.to_s + "s"
  table_sym = table_name.to_sym

  unless  ActiveRecord::Base.connection.table_exists? table_sym
    ActiveRecord::Base.connection.create_table table_sym do |t|
      t.string :name
      t.float :score
    end
    orm(table_name)
  end
end

private

# tableとmodelを関連付ける
def orm(table_name)
  model_name = table_name.singularize.camelcase
  file = __dir__ + '/model/' + model_name  + ".rb"
  create_class = "class #{model_name} < ActiveRecord::Base; end"
  IO.write(file, create_class)
  model_path = __dir__ + "/model/" + model_name
  require_relative model_path
end
