package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/**
	Checks if target is an enum specified by a string name
**/
class EnumByName implements deepequal.CustomCompare {
	
	var enm:Enum<Dynamic>; 
	var name:String;
	var params:Dynamic;
	public function new(enm:Enum<Dynamic>, name:String, ?params:Dynamic) {
		this.enm = enm;
		this.name = name;
		this.params = params;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>) {
		var oenm = Type.getEnum(other);
		if(enm != oenm) return Failure(new Error('Expected enum of ${Type.getEnumName(enm)} but got $other'));
		if(name != (other:EnumValue).getName()) return Failure(new Error('Expected enum named $name but got $other'));
		if(params != null) return compare(params, (other:EnumValue).getParameters());
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'EnumByName($enm, $name, $params)';
}
