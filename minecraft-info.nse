local stdnse = require "stdnse"
local shortport = require "shortport"
local json = require "json"
local string = require "string"

description = [[
This script queries information from a minecraft server, using mcstatus.
note: You must have mcstatus installed for the script to work.
]]


author = "3𝖗i4ηG0ld"
license = "Same as Nmap--See http://nmap.org/book/man-legal.html"
categories = {"safe","discovery"}

portrule = shortport.port_or_service(25565, "minecraft")

action = function(host, port)
  
  
  local json_string = io.popen("mcstatus "..tostring(host["ip"])..":".. tostring(port["number"]).." json"):read("*a")

  --print(json_string)

  local output = stdnse.output_table()
  local pos, value = json.parse(json_string)

  -- If server is offline  
  if string.match(json_string,"false}") then
    output["Online"] = value["online"]
  else
    
    output["Online"] = value["online"]
    output["Ping"] = value["ping"].." ms"
    output["Version"] = value["version"]
    output["Protocol"] = value["protocol"]
    output["Motd"] = '"'.. value["motd"]..'"'
    output["Players"] = value["player_count"].."/"..value["player_max"]
    if string.match(json_string,"}]}") then
      output["Online Players"] = value["players"]
    end
  end

  return output
end