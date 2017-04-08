package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Stringifier.*;

/**
	Checks if target is an array and of the required length
**/
class ArrayOfLength implements deepequal.CustomCompare {
	var length:Int;
	public function new(length) {
		this.length = length;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!Std.is(other, Array)) return Failure({message: 'Expected array but got ${stringify(other)}', path: []});
		var len = (other:Array<Dynamic>).length;
		return len == length ? Success(Noise) : Failure({message: 'Expected array of length $length but got $len', path: []});
	}
	@:keep
	public function toString()
		return 'ArrayLength($length)';
}
