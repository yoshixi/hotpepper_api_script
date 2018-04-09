require_relative 'model_controller.rb'

create_test_table(7500)
puts Sample7500.count  #=> 0
Sample7500.create(name:"quita",score:56.3)
puts Sample7500.count  #=> 1
