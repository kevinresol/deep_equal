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
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!Std.is(other, String)) return Failure({message: 'Expected string but got $other', path: []});
		if(!StringTools.startsWith(other, s)) return Failure({message: 'Expected string starting with $s but got $other', path: []});
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'StringStartsWith($s)';
}
