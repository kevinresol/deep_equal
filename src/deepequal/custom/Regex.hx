package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Helper.*;

/**
	Checks if target is a string and fulfills the required regex
**/
class Regex implements deepequal.CustomCompare {
	var regex:EReg;
	public function new(regex) {
		this.regex = regex;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!isOfType(other, String)) return Failure({message: 'Expected string but got $other', path: []});
		if(!regex.match(other)) return Failure({message: 'Cannot match $other with the required regex: $regex', path: []});
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'Regex($regex)';
}
