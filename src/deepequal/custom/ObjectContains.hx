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
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>) {
		if(!Reflect.isObject(other)) return Failure(new Error('Expected object but got $other'));
		for(field in Reflect.fields(expected)) {
			if(!Reflect.hasField(other, field)) return Failure(new Error('Cannot find field $field in $other'));
			switch compare(Reflect.field(expected, field), Reflect.field(other, field)) {
				case Success(_):
				case Failure(f): return Failure(f);
			}
		}
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'ObjectContains($expected)';
}
