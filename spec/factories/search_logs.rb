FactoryBot.define do
    factory :search_log do
      query { 'Example Query' }
      ip_address { '192.168.1.1' }
      country { 'US' }
      operating_system { 'Windows 10' }
      search_count { 1 }
      last_searched { Time.current }
    end
  end