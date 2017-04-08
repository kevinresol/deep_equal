package deepequal;

class Stringifier {
	public static function stringify(v:Dynamic):String {
		return
			if(haxe.Int64.is(v)) haxe.Int64.toStr(v);
			else if(Std.is(v, String) || Std.is(v, Float) || Std.is(v, Bool)) haxe.Json.stringify(v);
			else if(Std.is(v, Date)) DateTools.format(v, '%F %T');
			else if(Std.is(v, haxe.io.Bytes)) 'bytes(hex):' + (v:haxe.io.Bytes).toHex();
			else Std.string(v);
	}
}