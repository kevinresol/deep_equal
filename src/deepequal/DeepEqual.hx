package deepequal;

import haxe.Int64;
import haxe.PosInfos;
import haxe.io.Bytes;
import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Error;
import deepequal.Stringifier.*;

class DeepEqual {
	public static function compare(e:Dynamic, a:Dynamic, ?pos:haxe.PosInfos) {
		return switch new Compare(e, a).compare() {
			case Failure(f):
				// display a top-level message together with the internal comparison result
				Failure(new Error(f.message + ' @ v' + reconstructPath(f.path), pos));
			case Success(s):
				Success(s);
		}
	}
	
	static function reconstructPath(path:Array<Path>) {
		var buf = new StringBuf();
		for(p in path) switch p {
			case EnumParam(i): buf.add('(enumParam:$i)');
			case Index(i): buf.add('[$i]');
			case Field(k): buf.add('.$k');
		}
		return buf.toString();
	}
}



private class Compare {
	var path:Array<Path>;
	var e:Dynamic;
	var a:Dynamic;
	
	public function new(e, a) {
		path = [];
		this.e = e;
		this.a = a;
	}
	
	static function comparer(e:Dynamic, a:Dynamic):Result
		return new Compare(e, a).compare();
	
	public function compare():Result {
		
		if(e == null) {
			
			return simple(e, a);
			
		} else if(Std.is(e, CustomCompare)) {
			
			return (e:CustomCompare).check(a, comparer);
			
		} else if(Std.is(e, String)) {
			
			if(!Std.is(a, String)) return mismatch(e, a);
			return simple(e, a);
			
		} else if(Std.is(e, Float)) {
			
			if(!Std.is(a, Float)) return mismatch(e, a);
			return simple(e, a);
			
		} else if(Std.is(e, Bool)) {
			
			if(!Std.is(a, Bool)) return mismatch(e, a);
			return simple(e, a);
			
		} else if(Std.is(e, Date)) {
			
			if(!Std.is(a, Date)) return mismatch(e, a);
			return date(e, a);
			
		} else if (Std.is(e, Array)) {
			
			if(!Std.is(a, Array)) return fail('Expected array but got $e');
			if(a.length != e.length) return fail('Expected array of length ${e.length} but got ${a.length}');
			for(i in 0...a.length) {
				path.push(Index(i));
				switch comparer(e[i], a[i]) {
					case Success(_): path.pop();
					case Failure({message: m, path: p}):
						path = path.concat(p);
						return fail(m);
				}
			}
			return success();
			
		} else if(Int64.is(e)) {
			
			#if !java
			if(!Int64.is(a)) return mismatch(e, a);
			#end
			return if((e:Int64) == (a:Int64)) Success(Noise) else mismatch(e, a);
			
		} else if(Reflect.isEnumValue(e)) {
		
			var ecls = Type.getEnum(e);
			var acls = Type.getEnum(a);
			if(ecls != acls) return return fail('Expected enum ${Type.getEnumName(ecls)} but got ${Type.getEnumName(acls)}');
			var a:EnumValue = cast a;
			var e:EnumValue = cast e;
			switch [e.getName(), a.getName()] {
				case [en, an] if(en != an): return fail('Expected enum constructor $en but got $an');
				default:
			} 
			return switch comparer(a.getParameters(), e.getParameters()) {
				case Success(_): Success(Noise);
				case Failure(f):
					switch f.path.pop() {
						case Index(i): f.path.push(EnumParam(i));
						default:
					}
					Failure(f);
			}
			
		} else if(Std.is(e, Bytes)) {
			
			var e:Bytes = e;
			var a:Bytes = a;
			if(e.length != a.length) return fail('Expected bytes of length ${e.length} but got ${a.length}');
			for(i in 0...e.length) if(e.get(i) != a.get(i)) return mismatch(e, a);
			return success();
			
		} else if(Type.getClass(e) != null) {
			
			var ecls = Type.getClass(e);
			var acls = Type.getClass(a);
			if(ecls != acls) return fail('Expected class instance of ${Type.getClassName(ecls)} but got ${Type.getClassName(acls)}');
			for(key in Type.getInstanceFields(ecls)) {
				path.push(Field(key));
				switch comparer(Reflect.getProperty(e, key), Reflect.getProperty(a, key)) {
					case Success(_): path.pop();
					case Failure(f):
						path = path.concat(f.path);
						return fail(f.message);
				}
			}
			return success();
			
		} else if(Std.is(e, Class)) {
			
			if(!Std.is(a, Class)) return mismatch(e, a);
			return simple(e, a);
			
		} else if(Std.is(e, Enum)) {
			
			if(!Std.is(a, Enum)) return mismatch(e, a);
			return simple(e, a);
			
		} else if(Reflect.isObject(e)) {
			
			if(!Reflect.isObject(a)) return fail('Expected object but got $a');
			var keys = Reflect.fields(e);
			switch Reflect.fields(a).length {
				case len if(len != keys.length): return fail('Expected ${keys.length} field(s) but got $len');
				default:
			} 
			for(key in keys) {
				path.push(Field(key));
				switch comparer(Reflect.field(e, key), Reflect.field(a, key)) {
					case Success(_): path.pop();
					case Failure({message: m, path: p}):
						path = path.concat(p);
						return fail(m);
				}
			}
			return success();
			
		} else {
			
			throw 'Unhandled case'; // if anyone reaches this block, please file an issue
			
		}
	}
	
	function success()
		return Success(Noise);
	
	function fail(msg:String)
		return Failure({message: msg, path: path});
		
	function mismatch(e:Dynamic, a:Dynamic) 
		return fail('Expected ${stringify(e)} but got ${a == null ? null : stringify(a)}');
	
	function bool(b:Bool)
		return b ? success() : fail('Expected true but got false');
		
	function simple<T>(e:T, a:T)
		return e == a ? success() : mismatch(e, a);
	
	function date(e:Date, a:Date) {
		return switch simple(
			#if (neko || cs)
				Std.int(e.getTime() / 1000), Std.int(a.getTime() / 1000)
			#else
				e.getTime(), a.getTime()
			#end
		) {
			case Success(_): Success(Noise);
			case Failure(_): mismatch(e, a);
		}
	}
	
}