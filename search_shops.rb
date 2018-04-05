# # frozen_string_literal: true

require 'net/http'
require 'csv'
require 'json'
require 'uri'
require 'openssl'
require 'pry'
KEY = "?key=#{ENV['ACCESS_KEY']}&format=json"
BASE_URL = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1'
def fetch_search_api(name:, shop_id:, db_address: )
#  binding.pry if db_address == '東京都小金井市東町４-４２-１９'
  params_name = '&name=' + convert_name(name)
  params_address = '&address=' + convert_address(db_address)
  puts '======================================================'
  puts params_address
  url = BASE_URL + KEY + params_name + params_address
  url = URI.parse URI.encode url
  puts url
  req = Net::HTTP::Get.new(url.request_uri)

  http = Net::HTTP.new(url.host, url.port)
 # http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  http.set_debug_output $stderr
  res = ''
  begin
    http.start do |h|
      res = h.request(req)
    end
    res = JSON.parse(res.body)
    results = res['results']
    results_available = results['results_available'].to_i
    if results_available.zero?
      write_shop0_csv_file(shop_id: shop_id, name: name, db_address: db_address, api_address: nil, params_name: params_name, params_address: params_address)
    elsif results['results_available'] == 1
      write_shop1_csv_file(shop_id: shop_id, name: name, db_address: db_address, api_address: results['shop'][0]['address'],api_shop_name: results['shop'][0]['name'], urls: results['shop'][0]['urls']['pc'], params_name: params_name, params_address: params_address)
    else
      puts "aa"
      write_shop_over_2_csv_file(shop_id: shop_id, name: name, db_address: db_address, shops: results['shop'], params_name: params_name, params_address: params_address)
    end
  rescue => e
    puts e
    return nil
  end
end

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

def convert_name(str)
  str.sub(/\n.*/, '').sub(/\s.*/, '')
end

def convert_address(str)
  str.sub!(/\s.*/, '')
  str.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
end

def main
  target_shops_csv_path = 'check_ins_shops.csv'
  CSV.foreach(target_shops_csv_path, headers: true) do |shop|
    puts shop
    fetch_search_api(name: shop['name'], shop_id: shop['shop_id'], db_address: shop['address'])
  end
end

main
# fetch_search_api(name: '鳥貴族', shop_id: 100, db_address: 'tokyo' )
