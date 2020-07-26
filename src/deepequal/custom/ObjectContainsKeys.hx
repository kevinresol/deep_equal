package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Helper.*;

/**
	Checks if target is an object (as defined by Reflect.isObject) and contains the required fields
**/
class ObjectContainsKeys implements deepequal.CustomCompare {
	var keys:Array<String>;
	public function new(keys) {
		this.keys = keys;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!Reflect.isObject(other)) return Failure({message: 'Expected object but got ${stringify(other)}', path: []});
		for(key in keys) if(!Reflect.hasField(other, key)) return Failure({message: 'Cannot find key $key', path: []});
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'ObjectContainsKeys($keys)';
}
