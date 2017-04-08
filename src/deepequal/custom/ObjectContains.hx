package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Path;
import deepequal.Stringifier.*;

/** 
	Check if target include the required field and values  
**/
class ObjectContains implements deepequal.CustomCompare {
	var expected:{};
	public function new(expected) {
		this.expected = expected;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!Reflect.isObject(other)) return Failure({message: 'Expected object but got ${stringify(other)}', path: []});
		var path = [];
		for(field in Reflect.fields(expected)) {
			if(!Reflect.hasField(other, field)) return Failure({message: 'Cannot find field $field', path: path});
			var e = Reflect.field(expected, field);
			var a = Reflect.field(other, field);
			path.push(Field(field));
			switch compare(e, a) {
				case Success(_):
					path.pop();
				case Failure(f):
					path = path.concat(f.path);
					return Failure({message: f.message, path: path});
			}
		}
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'ObjectContains($expected)';
}
