package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/**
	Checks if target is an array and of the required length
**/
class ArrayOfLength implements deepequal.CustomCompare {
	var length:Int;
	public function new(length) {
		this.length = length;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!Std.is(other, Array)) return Failure({message: 'Expected array but got $other', path: []});
		return (other:Array<Dynamic>).length == length ? Success(Noise) : Failure({message: 'Expected array of length $length but got $other', path: []});
	}
	@:keep
	public function toString()
		return 'ArrayLength($length)';
}
