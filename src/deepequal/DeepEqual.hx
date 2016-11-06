package deepequal;

import haxe.Int64;

using tink.CoreApi;

class DeepEqual {
	public static function compare(e:Dynamic, a:Dynamic, ?pos:haxe.PosInfos) {
		return switch _compare(e, a, pos) {
			case Failure(f):
				// display a top-level message together with the internal comparison result
				Failure(Error.withData('Expected $e but got $a', f.message, pos));
			case Success(s):
				Success(s);
		}
	}
	static function _compare(e:Dynamic, a:Dynamic, ?pos:haxe.PosInfos) {
		
		if(Std.is(e, CustomCompare)) {
			
			return (e:CustomCompare).check(a, _compare.bind(_, _, pos));
			
		} else if(Std.is(e, String)) {
			
			if(!Std.is(a, String)) return fail('Expected string but got $a', pos);
			return simple(e, a);
			
		} else if(Std.is(e, Date)) {
			
			if(!Std.is(a, Date)) return fail('Expected date but got $a', pos);
			return date(e, a, pos);
			
		} else if (Std.is(e, Array)) {
			
			if(!Std.is(a, Array)) return fail('Expected array but got $e', pos);
			if(a.length != e.length) return fail('Expected array of length ${e.length} but got ${a.length}', pos);
			for(i in 0...a.length) switch _compare(e[i], a[i]) {
				case Success(_):
				case Failure(e): return fail(e.message + ' at index $i');
			}
			return success();
			
		} else if(Int64.is(e)) {
			
			#if !java
			if(!Int64.is(a)) return fail('Expected int64 but got $a', pos);
			#end
			return bool((e:Int64) == (a:Int64));
			
		} else if(Reflect.isEnumValue(e)) {
		
			if(!Reflect.isEnumValue(a)) return fail('Expected enum value but got $a', pos);
			var a:EnumValue = cast a;
			var e:EnumValue = cast e;
			var type = Type.getEnum(e);
			if(!Std.is(a, type)) return fail('Expected ${Type.getEnumName(type)} but got $a', pos);
			
			switch [e.getName(), a.getName()] {
				case [e, a] if(e != a): return fail('Expected $e but got $a');
				default:
			} 
			return _compare(a.getParameters(), e.getParameters(), pos);
			
		} else if(Reflect.isObject(e)) {
			
			if(!Reflect.isObject(a)) return fail('Expected object but got $a', pos);
			var keys = Reflect.fields(a);
			switch Reflect.fields(e).length {
				case len if(len != keys.length): return fail('Expected ${keys.length} field(s) but got $len', pos);
				default:
			} 
			for(key in keys) switch _compare(Reflect.field(e, key), Reflect.field(a, key), pos) {
				case Failure(f): return fail(f.message, pos);
				default:
			}
			return success();
			
		} else {
			
			return simple(e, a);
			
		}
	}
	
	static function success()
		return Success(Noise);
	
	static function fail(msg:String, ?pos:haxe.PosInfos)
		return Failure(new Error(msg, pos));
	
	static function bool(b:Bool, ?pos:haxe.PosInfos)
		return b ? success() : fail('Expected true but got false', pos);
		
	static function simple<T>(e:T, a:T, ?pos:haxe.PosInfos)
		return e == a ? success() : fail('Expected $e but got $a', pos);
	
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