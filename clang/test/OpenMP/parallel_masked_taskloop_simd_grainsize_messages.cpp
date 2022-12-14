// RUN: %clang_cc1 -verify -fopenmp -ferror-limit 100 %s -Wuninitialized
// RUN: %clang_cc1 -verify -fopenmp -fopenmp-version=51 -ferror-limit 100 %s -Wuninitialized

// RUN: %clang_cc1 -verify -fopenmp-simd -ferror-limit 100 %s -Wuninitialized
// RUN: %clang_cc1 -verify -fopenmp-version=51 -fopenmp-simd -ferror-limit 100 %s -Wuninitialized

void foo() {
}

bool foobool(int argc) {
  return argc;
}

struct S1; // expected-note {{declared here}}

template <class T, class S> // expected-note {{declared here}}
int tmain(T argc, S **argv) {
  T z;
  #pragma omp parallel masked taskloop simd grainsize // expected-error {{expected '(' after 'grainsize'}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize ( // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize () // expected-error {{expected expression}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (argc // expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (argc)) // expected-warning {{extra tokens at the end of '#pragma omp parallel masked taskloop simd' are ignored}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (argc > 0 ? argv[1][0] : argv[2][argc] + z)
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (foobool(argc)), grainsize (true) // expected-error {{directive '#pragma omp parallel masked taskloop simd' cannot contain more than one 'grainsize' clause}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (S) // expected-error {{'S' does not refer to a value}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (argc argc) // expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize(0) // expected-error {{argument to 'grainsize' clause must be a strictly positive integer value}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize(-1) // expected-error {{argument to 'grainsize' clause must be a strictly positive integer value}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize(argc) num_tasks(argc) // expected-error {{'num_tasks' and 'grainsize' clause are mutually exclusive and may not appear on the same directive}} expected-note {{'grainsize' clause is specified here}}
  for (int i = 0; i < 10; ++i)
    foo();

  return 0;
}

int main(int argc, char **argv) {
  int z;
  #pragma omp parallel masked taskloop simd grainsize // expected-error {{expected '(' after 'grainsize'}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize ( // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize () // expected-error {{expected expression}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (argc // expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (argc)) // expected-warning {{extra tokens at the end of '#pragma omp parallel masked taskloop simd' are ignored}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (argc > 0 ? argv[1][0] : argv[2][argc] + z)
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (foobool(argc)), grainsize (true) // expected-error {{directive '#pragma omp parallel masked taskloop simd' cannot contain more than one 'grainsize' clause}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (S1) // expected-error {{'S1' does not refer to a value}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (argc argc) // expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize (1 0) // expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize(if(tmain(argc, argv) // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize(0)  // expected-error {{argument to 'grainsize' clause must be a strictly positive integer value}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize(-1) // expected-error {{argument to 'grainsize' clause must be a strictly positive integer value}}
  for (int i = 0; i < 10; ++i)
    foo();
  #pragma omp parallel masked taskloop simd grainsize(argc) num_tasks(argc) // expected-error {{'num_tasks' and 'grainsize' clause are mutually exclusive and may not appear on the same directive}} expected-note {{'grainsize' clause is specified here}}
  for (int i = 0; i < 10; ++i)
    foo();

  return tmain(argc, argv);
}
