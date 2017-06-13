package.path = package.path .. ';../protobuf/?.lua'
package.cpath = package.cpath .. ';../protobuf/?.so'

local pb = require 'person_pb'

local person= pb.Person()
person.id = 1000
person.name = "Alice"
person.email = "Alice@example.com"

local home = person.Extensions[pb.Phone.phones]:add()
home.num = "2147483647"
home.type = pb.Phone.HOME

local data = person:SerializeToString()

local msg = pb.Person()

msg:ParseFromString(data)
print(msg)
