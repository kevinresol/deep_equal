package deepequal;

import haxe.PosInfos;

#if tink_core
typedef Error = tink.core.Error;
#else
class Error {
	public var message:String;
	public var data:Dynamic;
	public var pos:PosInfos;
	public function new(message:String, ?pos:PosInfos) {
		this.message = message;
		this.pos = pos;
	}
	public static function withData(message:String, data:Dynamic, ?pos:PosInfos) {
		var e = new Error(message, pos);
		e.data = data;
		return e;
	}
}
#end