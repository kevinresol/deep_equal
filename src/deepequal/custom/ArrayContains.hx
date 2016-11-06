package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/** 
	Checks if targets is an array and contains the required elements
	This is a simple and naive implementation with complexity O(n^2),
	don't use it with really huge arrays 
**/
class ArrayContains implements deepequal.CustomCompare {
	var items:Array<Dynamic>;
	public function new(items) {
		this.items = items;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>) {
		if(!Std.is(other, Array)) return Failure(new Error('Expected array but got $other'));
		for(i in items) {
			var matched = false;
			for(o in (other:Array<Dynamic>)) switch compare(i, o) {
				case Success(_): matched = true; break;
				case Failure(_):
			}
			if(!matched) return Failure(new Error('Cannot find $i in $other'));
		}
		return Success(Noise);
	}
}
