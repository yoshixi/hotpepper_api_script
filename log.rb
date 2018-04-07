
def write_shop0_csv_file(shop_id:, name:, db_address:, api_address:, urls: nil, params_name:, params_address:)
  csv_file_path = 'csvs/shop0.csv'
  CSV.open(csv_file_path, 'a+') do |csv_file|
    row = %W(shop_id name db_address api_address url)
    row = %W(#{shop_id} #{name} #{db_address} #{api_address} #{urls} #{params_name} #{params_address})
    puts 'shop0'
    puts row
    csv_file << row
  end
end

def write_shop1_csv_file(shop_id:, name:, db_address:, api_address:, urls:, api_shop_name:, params_name:, params_address:)
  csv_file_path = 'csvs/shop1.csv'
  CSV.open(csv_file_path, 'a+') do |csv_file|
    row = %W(#{shop_id} #{name} #{db_address} #{api_shop_name} #{api_address} #{urls} #{params_name} #{params_address})
    puts 'shop1'
    puts row
    csv_file << row
  end
end

def write_shop_over_2_csv_file(shop_id:, name:, db_address:, shops:, params_name:, params_address:)
  csv_file_path = 'csvs/shop_over_2.csv'
  CSV.open(csv_file_path, 'a+') do |csv_file|
    shops.each do |shop|
      row = %W(#{shop_id} #{name} #{db_address} #{shop['name']} #{shop['address']} #{params_name} #{params_address})
      puts 'shop2'
      puts row
      csv_file << row
    end
  end
end

