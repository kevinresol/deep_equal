package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

abstract Anything(Impl) {
	public inline function new()
		this = Impl.instance;
}

private class Impl implements deepequal.CustomCompare {
	public static var instance(default, null) = new Impl();
	function new() {}
	public function check(other:Dynamic, compare) return Success(Noise);
}