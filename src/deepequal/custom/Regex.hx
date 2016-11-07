package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/**
	Checks if target is a string and fulfills the required regex
**/
class Regex implements deepequal.CustomCompare {
	var regex:EReg;
	public function new(regex) {
		this.regex = regex;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>) {
		if(!Std.is(other, String)) return Failure(new Error('Expected string but got $other'));
		if(!regex.match(other)) return Failure(new Error('Cannot match $other with the required regex: $regex'));
		return Success(Noise);
	}
}
