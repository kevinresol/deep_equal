package deepequal;

#if tink_core
typedef Outcome<S, F> = tink.core.Outcome<S, F>;
#else
enum Outcome<S, F> {
	Success(s:S);
	Failure(f:F);
}
#end