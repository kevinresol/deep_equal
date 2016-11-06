package deepequal;

import haxe.Int64;

typedef Custom = {
	cond: Dynamic->Dynamic->Bool,
	check: Dynamic->Dynamic->Void,
}

class DeepEqual {
	public static function compare(e:Dynamic, a:Dynamic, ?custom:Array<Custom>, ?pos:haxe.PosInfos) {
		
		if(custom != null) for(c in custom) if(c.cond(e, a)) {
			c.check(e, a);
			return;	
		}
		
		if(Std.is(a, String)) {
			
			if(!Std.is(e, String)) fail('$e is not string', pos);
			simple(e, a);
			
		} else if(Std.is(a, Date)) {
			
			if(!Std.is(e, Date)) fail('$e is not date', pos);
			var e:Date = cast e;
			var a:Date = cast a;
			date(e, a, pos);
			
		} else if (Std.is(a, Array)) {
			
			if(!Std.is(e, Array)) fail('$e is not array', pos);
			if(a.length != e.length) fail('not same length', pos);
			for(i in 0...a.length) compare(e[i], a[i], custom);
			
		} else if(Int64.is(a)) {
			
			#if !java
			if(!Int64.is(e)) fail('$e is not int64', pos);
			#end
			var a:Int64 = cast a;
			var e:Int64 = cast e;
			bool(e == a);
			
		} else if(Reflect.isEnumValue(a)) {
		
			if(!Reflect.isEnumValue(e)) fail('$e is not enum', pos);
			var a:EnumValue = cast a;
			var e:EnumValue = cast e;
			if(a.getIndex() != e.getIndex()) fail('not same constructor');
			compare(a.getParameters(), e.getParameters(), custom, pos);
			
		} else if(Reflect.isObject(a)) {
			
			if(!Reflect.isObject(e)) fail('$e is not object', pos);
			var keys = Reflect.fields(a);
			
			if(keys.length != Reflect.fields(e).length) fail('not same number of keys', pos);
			for(key in keys) compare(Reflect.field(e, key), Reflect.field(a, key), custom);
			
		} else {
			
			simple(e, a);
			
		}
	}
	
	static function fail(msg:String, ?pos:haxe.PosInfos)
		throw msg;
	
	static function bool(b:Bool, ?pos:haxe.PosInfos)
		if(!b) fail('Expected true but got false', pos);
		
	static function simple<T>(e:T, a:T, ?pos:haxe.PosInfos)
		if(e != a) fail('Expected $e but got $a', pos);
	
	static function date(e:Date, a:Date, ?pos:haxe.PosInfos) {
		return simple(
			#if (neko || cs)
				Std.int(e.getTime() / 1000), Std.int(a.getTime() / 1000)
			#else
				e.getTime(), a.getTime()
			#end
		);
	}
}