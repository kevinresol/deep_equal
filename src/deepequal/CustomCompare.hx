package deepequal;

interface CustomCompare {
	function check(actual:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>):Outcome<Noise, Error>;
}