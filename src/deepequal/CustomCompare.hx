package deepequal;

interface CustomCompare {
	function check(actual:Dynamic, compare:Dynamic->Dynamic->Result):Result;
}