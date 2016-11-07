# Deep Equal [![Build Status](https://travis-ci.org/kevinresol/deep_equal.svg?branch=master)](https://travis-ci.org/kevinresol/deep_equal)

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

By default, string, bool, Int, float, date, bytes, int64, array, objects, class instances,
enum values, class/enum objects (`Class<T>/Enum<T>`) are recursively compared by value.
In case more advanced comparison (such as partial equals, regex checks, etc) is needed, 
one can implement the `CustomCompare` interface and put it as the expected value.

The following shows an example on checking if an array contains some required elements,
while not necessarily the same length as the required elements.

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

### Here are some more use case examples:

#### Assert array of certain length without caring about the contents
```haxe
var actual = [1,2,3];
compare(new ArrayOfLength(3), actual)` // or;
compare([for(i in 0...3) new Anything()], actual);
```
  
#### Assert object with certain contents without doing a perfect match
```haxe
var actual = {a:1, b:2}
compare(new ObjectContains({a: 1}), actual);
```

#### Assert an enum value and matches its first parameter as regex
```haxe
var actual = Bar("MyString", 1); // suppose defined `enum Foo {Bar(s:String, i:Int)}`
compare(new EnumByName(Foo, 'Bar', [new Regex(~/MyS.*/), new Anything()]), actual);
```
