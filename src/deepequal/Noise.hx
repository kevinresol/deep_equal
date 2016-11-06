package deepequal;

#if tink_core
typedef Noise = tink.core.Noise;
#else
#if cs @:native('deepequal.DeepNoise') #end
enum Noise {
	Noise;
}
#end