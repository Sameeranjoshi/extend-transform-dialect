//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <utility>

// template <class T1, class T2> struct pair

// template <class T1, class T2> void swap(pair<T1, T2>& x, pair<T1, T2>& y);

#include <utility>
#include <cassert>

#include "test_macros.h"

int main(int, char**)
{
    {
        typedef std::pair<int, short> P1;
        P1 p1(3, static_cast<short>(4));
        P1 p2(5, static_cast<short>(6));
        swap(p1, p2);
        assert(p1.first == 5);
        assert(p1.second == 6);
        assert(p2.first == 3);
        assert(p2.second == 4);
    }

  return 0;
}
