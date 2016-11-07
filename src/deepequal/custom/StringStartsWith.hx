package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/**
	Checks if target is a string and starts with the required characters
**/
class StringStartsWith implements deepequal.CustomCompare {
	var s:String;
	public function new(s) {
		this.s = s;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>) {
		if(!Std.is(other, String)) return Failure(new Error('Expected string but got $other'));
		if(!StringTools.startsWith(other, s)) return Failure(new Error('Expected string starting with $s but got $other'));
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'StringStartsWith($s)';
}
