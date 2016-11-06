package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

class Anything implements deepequal.CustomCompare {
	public static var instance(default, null) = new Anything();
	function new() {}
	public function check(other:Dynamic, compare) return Success(Noise);
}