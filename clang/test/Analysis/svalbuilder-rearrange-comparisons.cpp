// RUN: %clang_analyze_cc1 \
// RUN:    -analyzer-checker=debug.ExprInspection,core.builtin \
// RUN:    -analyzer-config aggressive-binary-operation-simplification=true \
// RUN:    -analyzer-config support-symbolic-integer-casts=false \
// RUN:    -analyzer-config eagerly-assume=false \
// RUN:    -verify %s

// RUN: %clang_analyze_cc1 \
// RUN:    -analyzer-checker=debug.ExprInspection,core.builtin \
// RUN:    -analyzer-config aggressive-binary-operation-simplification=true \
// RUN:    -analyzer-config support-symbolic-integer-casts=true \
// RUN:    -DSUPPORT_SYMBOLIC_INTEGER_CASTS \
// RUN:    -analyzer-config eagerly-assume=false \
// RUN:    -verify %s

void clang_analyzer_eval(bool x);
template <typename T>
void clang_analyzer_denote(T x, const char *literal);
template <typename T>
void clang_analyzer_express(T x);

void exit(int);

#define UINT_MAX (~0U)
#define INT_MAX (UINT_MAX & (UINT_MAX >> 1))

extern void __assert_fail (__const char *__assertion, __const char *__file,
    unsigned int __line, __const char *__function)
     __attribute__ ((__noreturn__));
#define assert(expr) \
  ((expr)  ? (void)(0)  : __assert_fail (#expr, __FILE__, __LINE__, __func__))

int g(void);
int f(void) {
  int x = g();
  // Assert that no overflows occur in this test file.
  // Assuming that concrete integers are also within that range.
  assert(x <= ((int)INT_MAX / 4));
  assert(x >= -((int)INT_MAX / 4));
  return x;
}

void compare_different_symbol_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 0}}
}

void compare_different_symbol_plus_left_int_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 1;
  clang_analyzer_express(x == y); // expected-warning {{$y - $x == 1}}
}

void compare_different_symbol_minus_left_int_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 1;
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 1}}
}

void compare_different_symbol_plus_right_int_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  y += 2;
  clang_analyzer_express(y); // expected-warning {{$y + 2}}
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 2}}
}

void compare_different_symbol_minus_right_int_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  y -= 2;
  clang_analyzer_express(y); // expected-warning {{$y - 2}}
  clang_analyzer_express(x == y); // expected-warning {{$y - $x == 2}}
}

void compare_different_symbol_plus_left_plus_right_int_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 2;
  y += 1;
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x == y); // expected-warning {{$y - $x == 1}}
}

void compare_different_symbol_plus_left_minus_right_int_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 2;
  y -= 1;
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x == y); // expected-warning {{$y - $x == 3}}
}

void compare_different_symbol_minus_left_plus_right_int_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 2;
  y += 1;
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 3}}
}

void compare_different_symbol_minus_left_minus_right_int_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 2;
  y -= 1;
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 1}}
}

void compare_same_symbol_equal(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x == y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_left_int_equal(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x == y); // expected-warning {{FALSE}}
}

void compare_same_symbol_minus_left_int_equal(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x == y); // expected-warning {{FALSE}}
}

void compare_same_symbol_plus_right_int_equal(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x == y); // expected-warning {{FALSE}}
}

void compare_same_symbol_minus_right_int_equal(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x == y); // expected-warning {{FALSE}}
}

void compare_same_symbol_plus_left_plus_right_int_equal(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x == y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_left_minus_right_int_equal(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x == y); // expected-warning {{FALSE}}
}

void compare_same_symbol_minus_left_plus_right_int_equal(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x == y); // expected-warning {{FALSE}}
}

void compare_same_symbol_minus_left_minus_right_int_equal(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x == y); // expected-warning {{TRUE}}
}

void compare_different_symbol_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 0}}
}

void compare_different_symbol_plus_left_int_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 1;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$y - $x >= 1}}
}

void compare_different_symbol_minus_left_int_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 1;
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 1}}
}

void compare_different_symbol_plus_right_int_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  y += 2;
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 2}}
}

void compare_different_symbol_minus_right_int_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  y -= 2;
  clang_analyzer_express(y); // expected-warning {{$y - 2}}
  clang_analyzer_express(x <= y); // expected-warning {{$y - $x >= 2}}
}

void compare_different_symbol_plus_left_plus_right_int_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 2;
  y += 1;
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$y - $x >= 1}}
}

void compare_different_symbol_plus_left_minus_right_int_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 2;
  y -= 1;
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$y - $x >= 3}}
}

void compare_different_symbol_minus_left_plus_right_int_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 2;
  y += 1;
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 3}}
}

void compare_different_symbol_minus_left_minus_right_int_less_or_equal(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 2;
  y -= 1;
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 1}}
}

void compare_same_symbol_less_or_equal(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_left_int_less_or_equal(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x <= y); // expected-warning {{FALSE}}
}

void compare_same_symbol_minus_left_int_less_or_equal(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_right_int_less_or_equal(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_same_symbol_minus_right_int_less_or_equal(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x <= y); // expected-warning {{FALSE}}
}

void compare_same_symbol_plus_left_plus_right_int_less_or_equal(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_left_minus_right_int_less_or_equal(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x <= y); // expected-warning {{FALSE}}
}

void compare_same_symbol_minus_left_plus_right_int_less_or_equal(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_same_symbol_minus_left_minus_right_int_less_or_equal(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_different_symbol_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 0}}
}

void compare_different_symbol_plus_left_int_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 1;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x < y); // expected-warning {{$y - $x > 1}}
}

void compare_different_symbol_minus_left_int_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 1;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 1}}
}

void compare_different_symbol_plus_right_int_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  y += 2;
  clang_analyzer_express(y); // expected-warning {{$y + 2}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 2}}
}

void compare_different_symbol_minus_right_int_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  y -= 2;
  clang_analyzer_express(y); // expected-warning {{$y - 2}}
  clang_analyzer_express(x < y); // expected-warning {{$y - $x > 2}}
}

void compare_different_symbol_plus_left_plus_right_int_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 2;
  y += 1;
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x < y); // expected-warning {{$y - $x > 1}}
}

void compare_different_symbol_plus_left_minus_right_int_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x += 2;
  y -= 1;
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x < y); // expected-warning {{$y - $x > 3}}
}

void compare_different_symbol_minus_left_plus_right_int_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 2;
  y += 1;
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 3}}
}

void compare_different_symbol_minus_left_minus_right_int_less(void) {
  int x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  x -= 2;
  y -= 1;
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 1}}
}

void compare_same_symbol_less(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

void compare_same_symbol_plus_left_int_less(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

void compare_same_symbol_minus_left_int_less(void) {
  int x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x < y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_right_int_less(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x < y); // expected-warning {{TRUE}}
}

void compare_same_symbol_minus_right_int_less(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

void compare_same_symbol_plus_left_plus_right_int_less(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

void compare_same_symbol_plus_left_minus_right_int_less(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

void compare_same_symbol_minus_left_plus_right_int_less(void) {
  int x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x < y); // expected-warning {{TRUE}}
}

void compare_same_symbol_minus_left_minus_right_int_less(void) {
  int x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

// Rearrange should happen on signed types only (tryRearrange):
//
//  // Rearrange signed symbolic expressions only
//  if (!SingleTy->isSignedIntegerOrEnumerationType())
//    return std::nullopt;
//
// Without the symbolic casts, the SVal for `x` in `unsigned x = f()` will be
// the signed `int`. However, with the symbolic casts it will be `unsigned`.
// Thus, these tests are meaningful only if the cast is not emitted.
#ifndef SUPPORT_SYMBOLIC_INTEGER_CASTS

void compare_different_symbol_equal_unsigned(void) {
  unsigned x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 0}}
}

void compare_different_symbol_plus_left_int_equal_unsigned(void) {
  unsigned x = f() + 1, y = f();
  clang_analyzer_denote(x - 1, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x == y); // expected-warning {{$y - $x == 1}}
}

void compare_different_symbol_minus_left_int_equal_unsigned(void) {
  unsigned x = f() - 1, y = f();
  clang_analyzer_denote(x + 1, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 1}}
}

void compare_different_symbol_plus_right_int_equal_unsigned(void) {
  unsigned x = f(), y = f() + 2;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y - 2, "$y");
  clang_analyzer_express(y); // expected-warning {{$y + 2}}
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 2}}
}

void compare_different_symbol_minus_right_int_equal_unsigned(void) {
  unsigned x = f(), y = f() - 2;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y + 2, "$y");
  clang_analyzer_express(y); // expected-warning {{$y - 2}}
  clang_analyzer_express(x == y); // expected-warning {{$y - $x == 2}}
}

void compare_different_symbol_plus_left_plus_right_int_equal_unsigned(void) {
  unsigned x = f() + 2, y = f() + 1;
  clang_analyzer_denote(x - 2, "$x");
  clang_analyzer_denote(y - 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x == y); // expected-warning {{$y - $x == 1}}
}

void compare_different_symbol_plus_left_minus_right_int_equal_unsigned(void) {
  unsigned x = f() + 2, y = f() - 1;
  clang_analyzer_denote(x - 2, "$x");
  clang_analyzer_denote(y + 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x == y); // expected-warning {{$y - $x == 3}}
}

void compare_different_symbol_minus_left_plus_right_int_equal_unsigned(void) {
  unsigned x = f() - 2, y = f() + 1;
  clang_analyzer_denote(x + 2, "$x");
  clang_analyzer_denote(y - 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 3}}
}

void compare_different_symbol_minus_left_minus_right_int_equal_unsigned(void) {
  unsigned x = f() - 2, y = f() - 1;
  clang_analyzer_denote(x + 2, "$x");
  clang_analyzer_denote(y + 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x == y); // expected-warning {{$x - $y == 1}}
}

void compare_same_symbol_equal_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x == y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_left_int_equal_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_express(x == y); // expected-warning {{$x + 1U == $x}}
}

void compare_same_symbol_minus_left_int_equal_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_express(x == y); // expected-warning {{$x - 1U == $x}}
}

void compare_same_symbol_plus_right_int_equal_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_express(x == y); // expected-warning {{$x == $x + 1U}}
}

void compare_same_symbol_minus_right_int_equal_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_express(x == y); // expected-warning {{$x == $x - 1U}}
}

void compare_same_symbol_plus_left_plus_right_int_equal_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x == y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_left_minus_right_int_equal_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_express(x == y); // expected-warning {{$x + 1U == $x - 1U}}
}

void compare_same_symbol_minus_left_plus_right_int_equal_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_express(x == y); // expected-warning {{$x - 1U == $x + 1U}}
}

void compare_same_symbol_minus_left_minus_right_int_equal_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x == y); // expected-warning {{TRUE}}
}

void compare_different_symbol_less_or_equal_unsigned(void) {
  unsigned x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 0}}
}

void compare_different_symbol_plus_left_int_less_or_equal_unsigned(void) {
  unsigned x = f() + 1, y = f();
  clang_analyzer_denote(x - 1, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x <= y); // expected-warning {{$y - $x >= 1}}
}

void compare_different_symbol_minus_left_int_less_or_equal_unsigned(void) {
  unsigned x = f() - 1, y = f();
  clang_analyzer_denote(x + 1, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 1}}
}

void compare_different_symbol_plus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = f() + 2;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y - 2, "$y");
  clang_analyzer_express(y); // expected-warning {{$y + 2}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 2}}
}

void compare_different_symbol_minus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = f() - 2;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y + 2, "$y");
  clang_analyzer_express(y); // expected-warning {{$y - 2}}
  clang_analyzer_express(x <= y); // expected-warning {{$y - $x >= 2}}
}

void compare_different_symbol_plus_left_plus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f() + 2, y = f() + 1;
  clang_analyzer_denote(x - 2, "$x");
  clang_analyzer_denote(y - 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$y - $x >= 1}}
}

void compare_different_symbol_plus_left_minus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f() + 2, y = f() - 1;
  clang_analyzer_denote(x - 2, "$x");
  clang_analyzer_denote(y + 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$y - $x >= 3}}
}

void compare_different_symbol_minus_left_plus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f() - 2, y = f() + 1;
  clang_analyzer_denote(x + 2, "$x");
  clang_analyzer_denote(y - 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 3}}
}

void compare_different_symbol_minus_left_minus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f() - 2, y = f() - 1;
  clang_analyzer_denote(x + 2, "$x");
  clang_analyzer_denote(y + 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - $y <= 1}}
}

void compare_same_symbol_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_left_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_express(x <= y); // expected-warning {{$x + 1U <= $x}}
}

void compare_same_symbol_minus_left_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - 1U <= $x}}
}

void compare_same_symbol_plus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$x <= $x + 1U}}
}

void compare_same_symbol_minus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$x <= $x - 1U}}
}

void compare_same_symbol_plus_left_plus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_same_symbol_plus_left_minus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$x + 1U <= $x - 1U}}
}

void compare_same_symbol_minus_left_plus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_express(x <= y); // expected-warning {{$x - 1U <= $x + 1U}}
}

void compare_same_symbol_minus_left_minus_right_int_less_or_equal_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x <= y); // expected-warning {{TRUE}}
}

void compare_different_symbol_less_unsigned(void) {
  unsigned x = f(), y = f();
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 0}}
}

void compare_different_symbol_plus_left_int_less_unsigned(void) {
  unsigned x = f() + 1, y = f();
  clang_analyzer_denote(x - 1, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x < y); // expected-warning {{$y - $x > 1}}
}

void compare_different_symbol_minus_left_int_less_unsigned(void) {
  unsigned x = f() - 1, y = f();
  clang_analyzer_denote(x + 1, "$x");
  clang_analyzer_denote(y, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 1}}
}

void compare_different_symbol_plus_right_int_less_unsigned(void) {
  unsigned x = f(), y = f() + 2;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y - 2, "$y");
  clang_analyzer_express(y); // expected-warning {{$y + 2}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 2}}
}

void compare_different_symbol_minus_right_int_less_unsigned(void) {
  unsigned x = f(), y = f() - 2;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_denote(y + 2, "$y");
  clang_analyzer_express(y); // expected-warning {{$y - 2}}
  clang_analyzer_express(x < y); // expected-warning {{$y - $x > 2}}
}

void compare_different_symbol_plus_left_plus_right_int_less_unsigned(void) {
  unsigned x = f() + 2, y = f() + 1;
  clang_analyzer_denote(x - 2, "$x");
  clang_analyzer_denote(y - 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x < y); // expected-warning {{$y - $x > 1}}
}

void compare_different_symbol_plus_left_minus_right_int_less_unsigned(void) {
  unsigned x = f() + 2, y = f() - 1;
  clang_analyzer_denote(x - 2, "$x");
  clang_analyzer_denote(y + 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x + 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x < y); // expected-warning {{$y - $x > 3}}
}

void compare_different_symbol_minus_left_plus_right_int_less_unsigned(void) {
  unsigned x = f() - 2, y = f() + 1;
  clang_analyzer_denote(x + 2, "$x");
  clang_analyzer_denote(y - 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y + 1}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 3}}
}

void compare_different_symbol_minus_left_minus_right_int_less_unsigned(void) {
  unsigned x = f() - 2, y = f() - 1;
  clang_analyzer_denote(x + 2, "$x");
  clang_analyzer_denote(y + 1, "$y");
  clang_analyzer_express(x); // expected-warning {{$x - 2}}
  clang_analyzer_express(y); // expected-warning {{$y - 1}}
  clang_analyzer_express(x < y); // expected-warning {{$x - $y < 1}}
}

#endif

// These pass even with aggressive-binary-operation-simplification=false

void compare_same_symbol_less_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

void compare_same_symbol_plus_left_int_less_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_express(x < y); // expected-warning {{$x + 1U < $x}}
}

void compare_same_symbol_minus_left_int_less_unsigned(void) {
  unsigned x = f(), y = x;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x}}
  clang_analyzer_express(x < y); // expected-warning {{$x - 1U < $x}}
}

void compare_same_symbol_plus_right_int_less_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_express(x < y); // expected-warning {{$x < $x + 1U}}
}

void compare_same_symbol_minus_right_int_less_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_express(x < y); // expected-warning {{$x < $x - 1U}}
}

void compare_same_symbol_plus_left_plus_right_int_less_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

void compare_same_symbol_plus_left_minus_right_int_less_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  ++x;
  clang_analyzer_express(x); // expected-warning {{$x + 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_express(x < y); // expected-warning {{$x + 1U < $x - 1U}}
}

void compare_same_symbol_minus_left_plus_right_int_less_unsigned(void) {
  unsigned x = f(), y = x + 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x + 1}}
  clang_analyzer_express(x < y); // expected-warning {{$x - 1U < $x + 1U}}
}

void compare_same_symbol_minus_left_minus_right_int_less_unsigned(void) {
  unsigned x = f(), y = x - 1;
  clang_analyzer_denote(x, "$x");
  --x;
  clang_analyzer_express(x); // expected-warning {{$x - 1}}
  clang_analyzer_express(y); // expected-warning {{$x - 1}}
  clang_analyzer_eval(x < y); // expected-warning {{FALSE}}
}

void overflow(signed char n, signed char m) {
  if (n + 0 > m + 0) {
    clang_analyzer_eval(n - 126 == m + 3); // expected-warning {{UNKNOWN}}
  }
}

int mixed_integer_types(int x, int y) {
  short a = x - 1U;
  return a - y;
}

unsigned gu(void);
unsigned fu(void) {
  unsigned x = gu();
  // Assert that no overflows occur in this test file.
  // Assuming that concrete integers are also within that range.
  assert(x <= ((unsigned)UINT_MAX / 4));
  return x;
}

void unsigned_concrete_int_no_crash(void) {
  unsigned x = fu() + 1U, y = fu() + 1U;
  clang_analyzer_denote(x - 1U, "$x");
  clang_analyzer_denote(y - 1U, "$y");
  clang_analyzer_express(y); // expected-warning {{$y}}
  clang_analyzer_express(x == y); // expected-warning {{$x + 1U == $y + 1U}}
}
