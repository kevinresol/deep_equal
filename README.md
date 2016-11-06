# Deep Equal

Every programmer needs to compare values.



## Basic Usage

```haxe

var expected = // any value, array, objects, etc
var actual = // some other value

switch DeepEqual.compare(expected, actual) {
  case Success(_): // they are value-identical
  case Failure(f): trace(f.message, f.data); // they are different!
}

```

## Advanced Usage

By default, String, Bool, Int, Float, Date, Int64, Array and Objects are recursively compared by value,
anything else will be compared by reference.
In case more advanced comparison is needed, one can implement the `CustomCompare` interface and supply it as the expected value.

Example:

```haxe

var a = [1,2,3,4];
var e = new ArrayContains([1,2,3]);
compare(e, a); // success, because the actual value contains all the required values 1, 2 and 3.

var a = [1,2,3,4];
var e = new ArrayContains([3,5]);
compare(e, a); // fail, because the actual value does not contain the required value 5.

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

```
