require 'rails_helper'

describe 'Items API' do
  it "default sends a list of first 20 items" do
    create_list(:item, 25)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)
    expect(items[:data]).to be_an(Array)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_an(String)
      expect(item[:type]).to eq("item")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_an(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_an(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_an(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_an(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it "sends a list of 20 items depending on page" do
    create_list(:item, 50)

    get '/api/v1/items?page=2'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)
    expect(items[:data].first[:id]).to_not eq("#{Item.first.id}")
    expect(items[:data].last[:id]).to_not eq("#{Item.last.id}")
  end

  it "sends first 20 items if page is 0 or lower" do
    create_list(:item, 50)

    get '/api/v1/items?page=0'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)
    expect(items[:data].first[:id]).to eq("#{Item.first.id}")
    expect(items[:data].last[:id]).to_not eq("#{Item.last.id}")
  end

  it "sends a list of items depending on per_page number" do
    create_list(:item, 50)

    get '/api/v1/items?per_page=30'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(30)
    expect(items[:data].first[:id]).to eq("#{Item.first.id}")
    expect(items[:data].last[:id]).to_not eq("#{Item.last.id}")
  end

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item[:data]).to be_an(Hash)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to eq("#{id}")

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_a(String)
    expect(item[:data][:type]).to eq("item")

    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to be_a(Hash)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
  end

  it "can create a new book" do
    merchant = create(:merchant)
    item_params = ({
                    name: 'Slap Bracelet',
                    description: 'A slap bracelet was a bracelet invented by Wisconsin teacher Stuart Anders in 1990, sold originally under the brand name of "Slap Wrap".',
                    unit_price: 2.50,
                    merchant_id: merchant.id,
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "returns error if any attributes are missing" do
    merchant = create(:merchant)
    item_params = ({
                    name: 'Slap Bracelet',
                    description: 'A slap bracelet was a bracelet invented by Wisconsin teacher Stuart Anders in 1990, sold originally under the brand name of "Slap Wrap".',
                    merchant_id: merchant.id,
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(400)
  end

  it "can update an existing items" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "New Name" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("New Name")
  end

  it "gives a 404 error if merchant_id does not exist" do
    id = create(:item).id
    item_params = { merchant_id: 78313219879131544 }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response).to have_http_status(404)
  end

  it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  xit "finds the merchant info for a specific item" do

  end
end
