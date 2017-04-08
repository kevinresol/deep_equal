package deepequal;

class Stringifier {
	public static function stringify(v:Dynamic):String {
		return
			if(Std.is(v, Date)) DateTools.format(v, '%F %T');
			else if(Reflect.isEnumValue(v)) Std.string(v);
			else if(Std.is(v, haxe.io.Bytes)) 'bytes(hex):' + (v:haxe.io.Bytes).toHex();
			else if(haxe.Int64.is(v)) haxe.Int64.toStr(v);
			else haxe.Json.stringify(v);
	}
}