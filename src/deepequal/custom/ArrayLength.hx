package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/**
	Checks if target is an array and of the required length
**/
class ArrayLength implements deepequal.CustomCompare {
	var length:Int;
	public function new(length) {
		this.length = length;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>) {
		if(!Std.is(other, Array)) return Failure(new Error('Expected array but got $other'));
		return (other:Array<Dynamic>).length == length ? Success(Noise) : Failure(new Error('Expected array of length $length but got $other'));
	}
	@:keep
	public function toString()
		return 'ArrayLength($length)';
}
