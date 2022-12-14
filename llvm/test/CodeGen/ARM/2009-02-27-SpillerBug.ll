; RUN: llc < %s -mattr=+v6,+vfp2

target triple = "arm-apple-darwin9"
@a = external global double		; <ptr> [#uses=1]
@N = external global double		; <ptr> [#uses=1]

declare double @llvm.exp.f64(double) nounwind readonly

define fastcc void @findratio(ptr nocapture %res1, ptr nocapture %res2) nounwind {
bb.thread:
	br label %bb52

bb32:		; preds = %bb52
	%0 = fadd double 0.000000e+00, 0.000000e+00		; <double> [#uses=1]
	%1 = add i32 %j.1, 1		; <i32> [#uses=1]
	br label %bb52

bb52:		; preds = %bb53, %bb32, %bb.thread
	%i.3494 = phi i32 [ 0, %bb.thread ], [ %3, %bb53 ], [ %i.3494, %bb32 ]		; <i32> [#uses=2]
	%k.4 = phi double [ %0, %bb32 ], [ 0.000000e+00, %bb53 ], [ 0.000000e+00, %bb.thread ]		; <double> [#uses=2]
	%j.1 = phi i32 [ %1, %bb32 ], [ 0, %bb53 ], [ 0, %bb.thread ]		; <i32> [#uses=2]
	%2 = icmp sgt i32 %j.1, 99		; <i1> [#uses=1]
	br i1 %2, label %bb53, label %bb32

bb53:		; preds = %bb52
	%3 = add i32 %i.3494, 1		; <i32> [#uses=2]
	%phitmp = icmp sgt i32 %3, 999999		; <i1> [#uses=1]
	br i1 %phitmp, label %bb55, label %bb52

bb55:		; preds = %bb53
	%4 = load double, ptr @a, align 4		; <double> [#uses=10]
	%5 = fadd double %4, 0.000000e+00		; <double> [#uses=16]
	%6 = fcmp ogt double %k.4, 0.000000e+00		; <i1> [#uses=1]
	%.pn404 = fmul double %4, %4		; <double> [#uses=4]
	%.pn402 = fmul double %5, %5		; <double> [#uses=5]
	%.pn165.in = load double, ptr @N		; <double> [#uses=5]
	%.pn198 = fmul double 0.000000e+00, %5		; <double> [#uses=1]
	%.pn185 = fsub double -0.000000e+00, 0.000000e+00		; <double> [#uses=1]
	%.pn147 = fsub double -0.000000e+00, 0.000000e+00		; <double> [#uses=1]
	%.pn141 = fdiv double 0.000000e+00, %4		; <double> [#uses=1]
	%.pn142 = fdiv double 0.000000e+00, %5		; <double> [#uses=1]
	%.pn136 = fdiv double 0.000000e+00, 0.000000e+00		; <double> [#uses=1]
	%.pn132 = fdiv double 0.000000e+00, %5		; <double> [#uses=1]
	%.pn123 = fdiv double 0.000000e+00, 0.000000e+00		; <double> [#uses=1]
	%.pn124 = fdiv double 0.000000e+00, %.pn198		; <double> [#uses=1]
	%.pn120 = fdiv double 0.000000e+00, 0.000000e+00		; <double> [#uses=1]
	%.pn117 = fdiv double 0.000000e+00, %4		; <double> [#uses=1]
	%.pn118 = fdiv double %.pn185, %5		; <double> [#uses=1]
	%.pn88 = fdiv double %.pn147, %5		; <double> [#uses=1]
	%.pn81 = fsub double %.pn141, %.pn142		; <double> [#uses=1]
	%.pn77 = fsub double 0.000000e+00, %.pn136		; <double> [#uses=1]
	%.pn75 = fsub double 0.000000e+00, %.pn132		; <double> [#uses=1]
	%.pn69 = fsub double %.pn123, %.pn124		; <double> [#uses=1]
	%.pn67 = fsub double 0.000000e+00, %.pn120		; <double> [#uses=1]
	%.pn56 = fsub double %.pn117, %.pn118		; <double> [#uses=1]
	%.pn42 = fsub double 0.000000e+00, %.pn88		; <double> [#uses=1]
	%.pn60 = fmul double %.pn81, 0.000000e+00		; <double> [#uses=1]
	%.pn57 = fadd double %.pn77, 0.000000e+00		; <double> [#uses=1]
	%.pn58 = fmul double %.pn75, %.pn165.in		; <double> [#uses=1]
	%.pn32 = fadd double %.pn69, 0.000000e+00		; <double> [#uses=1]
	%.pn33 = fmul double %.pn67, %.pn165.in		; <double> [#uses=1]
	%.pn17 = fsub double 0.000000e+00, %.pn60		; <double> [#uses=1]
	%.pn9 = fadd double %.pn57, %.pn58		; <double> [#uses=1]
	%.pn30 = fmul double 0.000000e+00, %.pn56		; <double> [#uses=1]
	%.pn24 = fmul double 0.000000e+00, %.pn42		; <double> [#uses=1]
	%.pn1 = fadd double %.pn32, %.pn33		; <double> [#uses=1]
	%.pn28 = fsub double %.pn30, 0.000000e+00		; <double> [#uses=1]
	%.pn26 = fadd double %.pn28, 0.000000e+00		; <double> [#uses=1]
	%.pn22 = fsub double %.pn26, 0.000000e+00		; <double> [#uses=1]
	%.pn20 = fsub double %.pn24, 0.000000e+00		; <double> [#uses=1]
	%.pn18 = fadd double %.pn22, 0.000000e+00		; <double> [#uses=1]
	%.pn16 = fadd double %.pn20, 0.000000e+00		; <double> [#uses=1]
	%.pn14 = fsub double %.pn18, 0.000000e+00		; <double> [#uses=1]
	%.pn12 = fsub double %.pn16, %.pn17		; <double> [#uses=1]
	%.pn10 = fadd double %.pn14, 0.000000e+00		; <double> [#uses=1]
	%.pn8 = fadd double %.pn12, 0.000000e+00		; <double> [#uses=1]
	%.pn6 = fsub double %.pn10, 0.000000e+00		; <double> [#uses=1]
	%.pn4 = fsub double %.pn8, %.pn9		; <double> [#uses=1]
	%.pn2 = fadd double %.pn6, 0.000000e+00		; <double> [#uses=1]
	%.pn = fadd double %.pn4, 0.000000e+00		; <double> [#uses=1]
	%N1.0 = fsub double %.pn2, 0.000000e+00		; <double> [#uses=2]
	%D1.0 = fsub double %.pn, %.pn1		; <double> [#uses=2]
	br i1 %6, label %bb62, label %bb64

bb62:		; preds = %bb55
	%7 = fmul double 0.000000e+00, %4		; <double> [#uses=1]
	%8 = fsub double -0.000000e+00, %7		; <double> [#uses=3]
	%9 = fmul double 0.000000e+00, %5		; <double> [#uses=1]
	%10 = fsub double -0.000000e+00, %9		; <double> [#uses=3]
	%11 = fmul double %.pn404, %4		; <double> [#uses=5]
	%12 = fmul double %.pn402, %5		; <double> [#uses=5]
	%13 = fmul double 0.000000e+00, -2.000000e+00		; <double> [#uses=1]
	%14 = fdiv double 0.000000e+00, %.pn402		; <double> [#uses=1]
	%15 = fsub double 0.000000e+00, %14		; <double> [#uses=1]
	%16 = fmul double 0.000000e+00, %15		; <double> [#uses=1]
	%17 = fadd double %13, %16		; <double> [#uses=1]
	%18 = fmul double %.pn165.in, -2.000000e+00		; <double> [#uses=5]
	%19 = fmul double %18, 0.000000e+00		; <double> [#uses=1]
	%20 = fadd double %17, %19		; <double> [#uses=1]
	%21 = fmul double 0.000000e+00, %20		; <double> [#uses=1]
	%22 = fadd double 0.000000e+00, %21		; <double> [#uses=1]
	%23 = fdiv double 0.000000e+00, %12		; <double> [#uses=1]
	%24 = fsub double 0.000000e+00, %23		; <double> [#uses=0]
	%25 = fmul double %18, 0.000000e+00		; <double> [#uses=1]
	%26 = fadd double 0.000000e+00, %25		; <double> [#uses=1]
	%27 = fmul double 0.000000e+00, %26		; <double> [#uses=1]
	%28 = fsub double %22, %27		; <double> [#uses=1]
	%29 = fmul double %11, %4		; <double> [#uses=1]
	%30 = fmul double %12, %5		; <double> [#uses=3]
	%31 = fmul double %.pn165.in, -4.000000e+00		; <double> [#uses=1]
	%32 = fmul double %.pn165.in, 0x3FF5555555555555		; <double> [#uses=1]
	%33 = fmul double %32, 0.000000e+00		; <double> [#uses=2]
	%34 = fadd double %28, 0.000000e+00		; <double> [#uses=1]
	%35 = fsub double -0.000000e+00, 0.000000e+00		; <double> [#uses=1]
	%36 = fdiv double %35, %11		; <double> [#uses=1]
	%37 = fdiv double 0.000000e+00, %12		; <double> [#uses=1]
	%38 = fsub double %36, %37		; <double> [#uses=1]
	%39 = fmul double 0.000000e+00, %38		; <double> [#uses=1]
	%40 = fadd double 0.000000e+00, %39		; <double> [#uses=1]
	%41 = fadd double %40, 0.000000e+00		; <double> [#uses=1]
	%42 = fadd double %41, 0.000000e+00		; <double> [#uses=1]
	%43 = fmul double %42, 0.000000e+00		; <double> [#uses=1]
	%44 = fsub double %34, %43		; <double> [#uses=1]
	%45 = tail call double @llvm.exp.f64(double %8) nounwind		; <double> [#uses=1]
	%46 = fsub double -0.000000e+00, %45		; <double> [#uses=2]
	%47 = fdiv double %46, 0.000000e+00		; <double> [#uses=1]
	%48 = fmul double %30, %5		; <double> [#uses=1]
	%49 = fdiv double 0.000000e+00, %48		; <double> [#uses=1]
	%50 = fsub double %47, %49		; <double> [#uses=1]
	%51 = fmul double %50, -4.000000e+00		; <double> [#uses=1]
	%52 = fadd double %51, 0.000000e+00		; <double> [#uses=1]
	%53 = fdiv double %46, %11		; <double> [#uses=1]
	%54 = fsub double %53, 0.000000e+00		; <double> [#uses=1]
	%55 = fmul double %31, %54		; <double> [#uses=1]
	%56 = fadd double %52, %55		; <double> [#uses=1]
	%57 = fadd double %56, 0.000000e+00		; <double> [#uses=1]
	%58 = fadd double %44, %57		; <double> [#uses=1]
	%59 = fsub double %58, 0.000000e+00		; <double> [#uses=1]
	%60 = tail call double @llvm.exp.f64(double 0.000000e+00) nounwind		; <double> [#uses=1]
	%61 = fsub double -0.000000e+00, %60		; <double> [#uses=1]
	%62 = fdiv double 0.000000e+00, -6.000000e+00		; <double> [#uses=1]
	%63 = fdiv double %61, %5		; <double> [#uses=1]
	%64 = fsub double 0.000000e+00, %63		; <double> [#uses=1]
	%65 = fmul double %62, %64		; <double> [#uses=1]
	%66 = fsub double 0.000000e+00, %65		; <double> [#uses=1]
	%67 = fsub double -0.000000e+00, 0.000000e+00		; <double> [#uses=2]
	%68 = tail call double @llvm.exp.f64(double %10) nounwind		; <double> [#uses=1]
	%69 = fsub double -0.000000e+00, %68		; <double> [#uses=2]
	%70 = fdiv double %67, %.pn404		; <double> [#uses=1]
	%71 = fdiv double %69, %.pn402		; <double> [#uses=1]
	%72 = fsub double %70, %71		; <double> [#uses=1]
	%73 = fmul double %72, -5.000000e-01		; <double> [#uses=1]
	%74 = fdiv double %67, %4		; <double> [#uses=1]
	%75 = fdiv double %69, %5		; <double> [#uses=1]
	%76 = fsub double %74, %75		; <double> [#uses=1]
	%77 = fmul double %76, 0.000000e+00		; <double> [#uses=1]
	%78 = fadd double %73, %77		; <double> [#uses=1]
	%79 = fmul double 0.000000e+00, %78		; <double> [#uses=1]
	%80 = fadd double %66, %79		; <double> [#uses=1]
	%81 = fdiv double 0.000000e+00, %.pn404		; <double> [#uses=1]
	%82 = fdiv double 0.000000e+00, %.pn402		; <double> [#uses=1]
	%83 = fsub double %81, %82		; <double> [#uses=1]
	%84 = fmul double %83, -5.000000e-01		; <double> [#uses=1]
	%85 = fdiv double 0.000000e+00, %4		; <double> [#uses=1]
	%86 = fdiv double 0.000000e+00, %5		; <double> [#uses=1]
	%87 = fsub double %85, %86		; <double> [#uses=1]
	%88 = fmul double %87, 0.000000e+00		; <double> [#uses=1]
	%89 = fadd double %84, %88		; <double> [#uses=1]
	%90 = fmul double 0.000000e+00, %89		; <double> [#uses=1]
	%91 = fsub double %80, %90		; <double> [#uses=1]
	%92 = tail call double @llvm.exp.f64(double %8) nounwind		; <double> [#uses=1]
	%93 = fsub double -0.000000e+00, %92		; <double> [#uses=1]
	%94 = tail call double @llvm.exp.f64(double %10) nounwind		; <double> [#uses=1]
	%95 = fsub double -0.000000e+00, %94		; <double> [#uses=3]
	%96 = fdiv double %95, %.pn402		; <double> [#uses=1]
	%97 = fsub double 0.000000e+00, %96		; <double> [#uses=1]
	%98 = fmul double 0.000000e+00, %97		; <double> [#uses=1]
	%99 = fdiv double %93, %11		; <double> [#uses=1]
	%100 = fdiv double %95, %12		; <double> [#uses=1]
	%101 = fsub double %99, %100		; <double> [#uses=1]
	%102 = fsub double %98, %101		; <double> [#uses=1]
	%103 = fdiv double %95, %5		; <double> [#uses=1]
	%104 = fsub double 0.000000e+00, %103		; <double> [#uses=1]
	%105 = fmul double %18, %104		; <double> [#uses=1]
	%106 = fadd double %102, %105		; <double> [#uses=1]
	%107 = fmul double %106, %k.4		; <double> [#uses=1]
	%108 = fadd double %91, %107		; <double> [#uses=1]
	%109 = fsub double %108, 0.000000e+00		; <double> [#uses=1]
	%110 = tail call double @llvm.exp.f64(double %8) nounwind		; <double> [#uses=1]
	%111 = fsub double -0.000000e+00, %110		; <double> [#uses=2]
	%112 = tail call double @llvm.exp.f64(double %10) nounwind		; <double> [#uses=1]
	%113 = fsub double -0.000000e+00, %112		; <double> [#uses=2]
	%114 = fdiv double %111, %11		; <double> [#uses=1]
	%115 = fdiv double %113, %12		; <double> [#uses=1]
	%116 = fsub double %114, %115		; <double> [#uses=1]
	%117 = fmul double 0.000000e+00, %116		; <double> [#uses=1]
	%118 = fdiv double %111, %29		; <double> [#uses=1]
	%119 = fdiv double %113, %30		; <double> [#uses=1]
	%120 = fsub double %118, %119		; <double> [#uses=1]
	%121 = fsub double %117, %120		; <double> [#uses=1]
	%122 = fmul double %18, 0.000000e+00		; <double> [#uses=1]
	%123 = fadd double %121, %122		; <double> [#uses=1]
	%124 = fmul double %33, 0.000000e+00		; <double> [#uses=1]
	%125 = fadd double %123, %124		; <double> [#uses=1]
	%126 = fadd double %109, %125		; <double> [#uses=1]
	%127 = tail call double @llvm.exp.f64(double 0.000000e+00) nounwind		; <double> [#uses=1]
	%128 = fsub double -0.000000e+00, %127		; <double> [#uses=2]
	%129 = fdiv double %128, %30		; <double> [#uses=1]
	%130 = fsub double 0.000000e+00, %129		; <double> [#uses=1]
	%131 = fsub double 0.000000e+00, %130		; <double> [#uses=1]
	%132 = fdiv double 0.000000e+00, %.pn404		; <double> [#uses=1]
	%133 = fsub double %132, 0.000000e+00		; <double> [#uses=1]
	%134 = fmul double %18, %133		; <double> [#uses=1]
	%135 = fadd double %131, %134		; <double> [#uses=1]
	%136 = fdiv double %128, %5		; <double> [#uses=1]
	%137 = fsub double 0.000000e+00, %136		; <double> [#uses=1]
	%138 = fmul double %33, %137		; <double> [#uses=1]
	%139 = fadd double %135, %138		; <double> [#uses=1]
	%140 = fsub double %126, %139		; <double> [#uses=1]
	%141 = fadd double %N1.0, %59		; <double> [#uses=1]
	%142 = fadd double %D1.0, %140		; <double> [#uses=1]
	br label %bb64

bb64:		; preds = %bb62, %bb55
	%N1.0.pn = phi double [ %141, %bb62 ], [ %N1.0, %bb55 ]		; <double> [#uses=1]
	%D1.0.pn = phi double [ %142, %bb62 ], [ %D1.0, %bb55 ]		; <double> [#uses=1]
	%x.1 = fdiv double %N1.0.pn, %D1.0.pn		; <double> [#uses=0]
	ret void
}
