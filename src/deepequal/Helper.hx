package deepequal;


class Helper {
	public static function stringify(v:Dynamic):String {
		return
			if(isInt64(v)) haxe.Int64.toStr(v);
			else if(Std.is(v, String) || Std.is(v, Float) || Std.is(v, Bool)) haxe.Json.stringify(v);
			else if(Std.is(v, Date)) DateTools.format(v, '%F %T');
			else if(Std.is(v, haxe.io.Bytes)) 'bytes(hex):' + (v:haxe.io.Bytes).toHex();
			else if(Std.is(v, Class)) Type.getClassName(v);
			else if(Std.is(v, Enum)) Helper.getEnumName(v);
			else Std.string(v);
	}
	
	public static inline function isInt64(v:Dynamic):Bool {
		return
			#if (haxe_ver >= 4.1)
			haxe.Int64.isInt64(v);
			#else
			haxe.Int64.is(v);
			#end
	}
	
	// WORKAROUND: https://github.com/HaxeFoundation/haxe/issues/9759
	public static inline function getEnumName(e:Dynamic) {
		var v = Type.getEnumName(e);
		#if jvm
		if(StringTools.startsWith(v, 'haxe.root.')) v = v.substr(10);
		#end
		return v;
	}
}