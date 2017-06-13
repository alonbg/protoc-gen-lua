--
--------------------------------------------------------------------------------
--  FILE:  wire_format.lua
--  DESCRIPTION:  protoc-gen-lua
--      Google's Protocol Buffers project, ported to lua.
--      https://code.google.com/p/protoc-gen-lua/
--
--      Copyright (c) 2010 , 林卓毅 (Zhuoyi Lin) netsnail@gmail.com
--      All rights reserved.
--
--      Use, modification and distribution are subject to the "New BSD License"
--      as listed at <url: http://www.opensource.org/licenses/bsd-license.php >.
--  COMPANY:  NetEase
--  CREATED:  2010年07月30日 15时59分53秒 CST
--------------------------------------------------------------------------------
--

local pb = require "pb"

local _M = {}

_M.WIRETYPE_VARINT = 0
_M.WIRETYPE_FIXED64 = 1
_M.WIRETYPE_LENGTH_DELIMITED = 2
_M.WIRETYPE_START_GROUP = 3
_M.WIRETYPE_END_GROUP = 4
_M.WIRETYPE_FIXED32 = 5


-- yeah, we don't need uint64
-- add uint64 support
local function _VarUInt64ByteSizeNoTag(uint64)
	if uint64 <= 0x7f then return 1 end
	if uint64 <= 0x3fff then return 2 end
	if uint64 <= 0x1fffff then return 3 end
	if uint64 <= 0xfffffff then return 4 end
	if uint64 <= 0x7ffffffff then return 5 end
	if uint64 <= 0x3ffffffffff then return 6 end
	if uint64 <= 0x1ffffffffffff then return 7 end
	if uint64 <= 0xffffffffffffff then return 8 end
	if uint64 <= 0x7fffffffffffffff then return 9 end
	return 10 
end

function _M.PackTag(field_number, wire_type)
    return field_number * 8 + wire_type
end

function _M.UnpackTag(tag)
    local wire_type = tag % 8
    return (tag - wire_type) / 8, wire_type
end

_M.ZigZagEncode32 = pb.zig_zag_encode32
_M.ZigZagDecode32 = pb.zig_zag_decode32
_M.ZigZagEncode64 = pb.zig_zag_encode64
_M.ZigZagDecode64 = pb.zig_zag_decode64

function _M.Int32ByteSize(field_number, int32)
  return _M.Int64ByteSize(field_number, int32)
end

function _M.Int32ByteSizeNoTag(int32)
  return _VarUInt64ByteSizeNoTag(int32)
end

function _M.Int64ByteSize(field_number, int64)
  return _M.UInt64ByteSize(field_number, int64)
end

function _M.UInt32ByteSize(field_number, uint32)
  return _M.UInt64ByteSize(field_number, uint32)
end

function _M.UInt64ByteSize(field_number, uint64)
  return _M.TagByteSize(field_number) + _VarUInt64ByteSizeNoTag(uint64)
end

function _M.SInt32ByteSize(field_number, int32)
  return _M.UInt32ByteSize(field_number, ZigZagEncode(int32))
end

function _M.SInt64ByteSize(field_number, int64)
  return _M.UInt64ByteSize(field_number, ZigZagEncode(int64))
end

function _M.Fixed32ByteSize(field_number, fixed32)
  return _M.TagByteSize(field_number) + 4
end

function _M.Fixed64ByteSize(field_number, fixed64)
  return _M.TagByteSize(field_number) + 8
end

function _M.SFixed32ByteSize(field_number, sfixed32)
  return _M.TagByteSize(field_number) + 4
end

function _M.SFixed64ByteSize(field_number, sfixed64)
  return _M.TagByteSize(field_number) + 8
end

function _M.FloatByteSize(field_number, flt)
  return _M.TagByteSize(field_number) + 4
end

function _M.DoubleByteSize(field_number, double)
  return _M.TagByteSize(field_number) + 8
end

function _M.BoolByteSize(field_number, b)
  return _M.TagByteSize(field_number) + 1
end

function _M.EnumByteSize(field_number, enum)
  return _M.UInt32ByteSize(field_number, enum)
end

function _M.StringByteSize(field_number, string)
  return _M.BytesByteSize(field_number, string)
end

function _M.BytesByteSize(field_number, b)
    return _M.TagByteSize(field_number) + _VarUInt64ByteSizeNoTag(#b) + #b
end

function _M.MessageByteSize(field_number, message)
    return _M.TagByteSize(field_number) + _VarUInt64ByteSizeNoTag(message.ByteSize()) + message.ByteSize()
end

function _M.MessageSetItemByteSize(field_number, msg)
    local total_size = 2 * _M.TagByteSize(1) + _M.TagByteSize(2) + _M.TagByteSize(3) 
    total_size = total_size + _VarUInt64ByteSizeNoTag(field_number)
    local message_size = msg.ByteSize()
    total_size = total_size + _VarUInt64ByteSizeNoTag(message_size)
    total_size = total_size + message_size
    return total_size
end

function _M.TagByteSize(field_number)
    return _VarUInt64ByteSizeNoTag(PackTag(field_number, 0))
end

return setmetatable({}, { __index = _M, })
