package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/**
	Checks if target is an object (as defined by Reflect.isObject) and contains the required fields
**/
class ObjectContainsKeys implements deepequal.CustomCompare {
	var keys:Array<String>;
	public function new(keys) {
		this.keys = keys;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>) {
		if(!Reflect.isObject(other)) return Failure(new Error('Expected object but got $other'));
		for(key in keys) if(!Reflect.hasField(other, key)) return Failure(new Error('Cannot find key $key in $other'));
		return Success(Noise);
	}
}
