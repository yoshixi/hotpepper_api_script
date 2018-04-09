# # frozen_string_literal: true

require 'net/http'
require 'csv'
require 'json'
require 'uri'
require 'openssl'
require 'pry'
require 'active_record'
require 'pry-byebug'
require './active_record_setup.rb'

KEY = "?key=#{ENV['ACCESS_KEY']}&format=json"
BASE_URL = 'http://webservice.recruit.co.jp/hotpepper/gourmet/v1'

def fetch_search_api(name:, shop_id:, db_address:)
#  binding.pry if db_address == '東京都小金井市東町４-４２-１９'
  params_name = '&name=' + convert_name(name)
  params_address = '&address=' + convert_address(db_address)
  puts '======================================================'
  puts params_name
  puts params_address
  url = BASE_URL + KEY + params_name + params_address
  url = URI.parse URI.encode url
  req = Net::HTTP::Get.new(url.request_uri)

  http = Net::HTTP.new(url.host, url.port)
 # http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  # http.set_debug_output $stderr
  res = ''
  begin
    http.start do |h|
      res = h.request(req)
    end
    res = JSON.parse(res.body)
    results = res['results']
    results_available = results['results_available'].to_i
    if results_available.zero?
      puts '0'
      if ResponseZeroShop.where(params_name: params_name, params_address: params_address).blank?
        ResponseZeroShop.create(shop_id: shop_id, db_name: name, db_address: db_address, params_name: params_name, params_address: params_address)
      else
        puts 'aleady exist'
      end
    elsif results['results_available'] == 1
      puts '1'
      if ResponseZeroShop.where(shop_id: shop_id, db_name: name, db_address: db_address, api_address: results['shop'][0]['address'], api_shop_name: results['shop'][0]['name'], urls: results['shop'][0]['urls']['pc']).blank?
        ResponseOneShop.find_or_create_by(shop_id: shop_id, db_name: name, db_address: db_address, api_address: results['shop'][0]['address'], api_shop_name: results['shop'][0]['name'], urls: results['shop'][0]['urls']['pc'], params_name: params_name, params_address: params_address)
      else
        puts 'aleady exist'
      end
    else
      puts 'over2'
      results['shop'].each do |shop|
        ResponseOverTwoShop.find_or_create_by(shop_id: shop_id, db_name: name, db_address: db_address, api_name: shop[:name],api_address: shop['address'], api_url: shop['urls']['pc'], params_name: params_name, params_address: params_address)
      end
    end
  rescue => e
    puts e
    return nil
  end
end

def convert_name(str)
  str.sub(/\n.*/, '').sub(/\s.*/, '')
end

def convert_address(str)
  str.sub!(/\s.*/, '')
  str.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z').match(/.*(-\d)/).to_s
end

def main
  target_shops_csv_path = 'check_ins_shops.csv'
  CSV.foreach(target_shops_csv_path, headers: true) do |shop|
    puts shop
    fetch_search_api(name: shop['name'], shop_id: shop['shop_id'], db_address: shop['address'])
  end
end

Sqlite::Orm.setup
main
# fetch_search_api(name: '鳥貴族', shop_id: 100, db_address: 'tokyo' )
