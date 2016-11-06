package deepequal;

using tink.CoreApi;

interface CustomCompare {
	function check(actual:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>):Outcome<Noise, Error>;
}