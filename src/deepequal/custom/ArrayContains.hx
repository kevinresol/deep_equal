package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Helper.*;

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
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!Std.is(other, Array)) return Failure({message: 'Expected array but got ${stringify(other)}', path: []});
		for(i in items) {
			var matched = false;
			for(o in (other:Array<Dynamic>)) switch compare(i, o) {
				case Success(_): matched = true; break;
				case Failure(_):
			}
			if(!matched) return Failure({message: 'Cannot find $i in ${stringify(other)}', path:[]});
		}
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'ArrayContains($items)';
}
