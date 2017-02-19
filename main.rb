require 'sinatra'
require 'json'

set :root, './'
searchInput = ""

def read_groceries_from(filename)
  File.readlines(filename)
end

def parseJson(filename)
	json_file = File.read(filename)
    json_data = JSON.parse(json_file)
end

def getName(filename)
	returnArray = Array.new
	jsonData = parseJson(filename)
	jsonArray = jsonData["Firms"]
	i = 0	
	jsonArray.each do 		
		returnArray.push(jsonArray[i]["Name"])
		i += 1
	end
	return returnArray
end

def getFirmInfo(filename, firmName)
	jsonData = parseJson(filename)
	jsonArray = jsonData["Firms"]
	i = 0	
	jsonArray.each do
		if firmName == jsonArray[i]["Name"]
			return jsonArray[i]
		end
		i += 1
	end
end

def generateFirm(firmName, cvr, adress, city, country, phone, filename)
	if (firmName == "" || cvr == "" || adress == "" || city == "" || country == "")
		return
	end
	json_data = parseJson(filename)
	json_data["Firms"] << {Name: firmName, CVR: cvr, Adress: adress, City: city, Country: country, Phone: phone}
	jjdata = json_data.to_json
	File.open(filename, "w") do |f|
		f.write(jjdata)
	end	
end

get '/' do
  @firms = getName("input.json") 
  if (searchInput != "")
  	@firmInfo = getFirmInfo("input.json", searchInput)
  end  
  erb :index
end

post "/" do
	@firmName = params[:firmName]
	@cvr = params[:cvr]
	@adress = params[:adress]
	@city = params[:city]
	@country = params[:country]
	@phone = params[:phone]
	generateFirm(@firmName, @cvr, @adress, @city, @country, @phone, "input.json")
	redirect "/"
end

post "/search" do
	@search = params[:search]
	searchInput = @search
	redirect "/"
end
