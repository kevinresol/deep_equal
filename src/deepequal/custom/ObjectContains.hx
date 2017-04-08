package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/** 
	Check if target include the required field and values  
**/
class ObjectContains implements deepequal.CustomCompare {
	var expected:{};
	public function new(expected) {
		this.expected = expected;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!Reflect.isObject(other)) return Failure({message: 'Expected object but got $other', path: []});
		for(field in Reflect.fields(expected)) {
			if(!Reflect.hasField(other, field)) return Failure({message: 'Cannot find field $field in $other', path: []});
			var e = Reflect.field(expected, field);
			var a = Reflect.field(other, field);
			switch compare(e, a) {
				case Failure(f): return Failure({message: 'Expected field $field to be ${Std.string(e)} but got ${Std.string(a)}', path: []});
				default:
			}
		}
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'ObjectContains($expected)';
}
