; RUN: llc < %s -mtriple=x86_64-darwin -mattr=+mmx,+sse2 | FileCheck %s

define i64 @t0(x86_mmx* %p) {
; CHECK-LABEL: t0:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movq
; CHECK-NEXT:    paddq %mm0, %mm0
; CHECK-NEXT:    movd %mm0, %rax
; CHECK-NEXT:    retq
  %t = load x86_mmx, x86_mmx* %p
  %u = tail call x86_mmx @llvm.x86.mmx.padd.q(x86_mmx %t, x86_mmx %t)
  %s = bitcast x86_mmx %u to i64
  ret i64 %s
}

define i64 @t1(x86_mmx* %p) {
; CHECK-LABEL: t1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movq
; CHECK-NEXT:    paddd %mm0, %mm0
; CHECK-NEXT:    movd %mm0, %rax
; CHECK-NEXT:    retq
  %t = load x86_mmx, x86_mmx* %p
  %u = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %t, x86_mmx %t)
  %s = bitcast x86_mmx %u to i64
  ret i64 %s
}

define i64 @t2(x86_mmx* %p) {
; CHECK-LABEL: t2:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movq
; CHECK-NEXT:    paddw %mm0, %mm0
; CHECK-NEXT:    movd %mm0, %rax
; CHECK-NEXT:    retq
  %t = load x86_mmx, x86_mmx* %p
  %u = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %t, x86_mmx %t)
  %s = bitcast x86_mmx %u to i64
  ret i64 %s
}

define i64 @t3(x86_mmx* %p) {
; CHECK-LABEL: t3:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movq
; CHECK-NEXT:    paddb %mm0, %mm0
; CHECK-NEXT:    movd %mm0, %rax
; CHECK-NEXT:    retq
  %t = load x86_mmx, x86_mmx* %p
  %u = tail call x86_mmx @llvm.x86.mmx.padd.b(x86_mmx %t, x86_mmx %t)
  %s = bitcast x86_mmx %u to i64
  ret i64 %s
}

@R = external global x86_mmx

define void @t4(<1 x i64> %A, <1 x i64> %B) {
; CHECK-LABEL: t4:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    movd
; CHECK-NEXT:    movd
; CHECK:    retq
entry:
  %tmp2 = bitcast <1 x i64> %A to x86_mmx
  %tmp3 = bitcast <1 x i64> %B to x86_mmx
  %tmp7 = tail call x86_mmx @llvm.x86.mmx.paddus.w(x86_mmx %tmp2, x86_mmx %tmp3)
  store x86_mmx %tmp7, x86_mmx* @R
  tail call void @llvm.x86.mmx.emms()
  ret void
}

define i64 @t5(i32 %a, i32 %b) nounwind readnone {
; CHECK-LABEL: t5:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movd
; CHECK-NEXT:    movd
; CHECK-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[0,1,1,3]
; CHECK-NEXT:    movd %xmm0, %rax
; CHECK-NEXT:    retq
  %v0 = insertelement <2 x i32> undef, i32 %a, i32 0
  %v1 = insertelement <2 x i32> %v0, i32 %b, i32 1
  %conv = bitcast <2 x i32> %v1 to i64
  ret i64 %conv
}

declare x86_mmx @llvm.x86.mmx.pslli.q(x86_mmx, i32)

define <1 x i64> @t6(i64 %t) {
; CHECK-LABEL: t6:
; CHECK:       ## BB#0:
; CHECK-NEXT:    movd
; CHECK-NEXT:    psllq $48, %mm0
; CHECK-NEXT:    movd %mm0, %rax
; CHECK-NEXT:    retq
  %t1 = insertelement <1 x i64> undef, i64 %t, i32 0
  %t0 = bitcast <1 x i64> %t1 to x86_mmx
  %t2 = tail call x86_mmx @llvm.x86.mmx.pslli.q(x86_mmx %t0, i32 48)
  %t3 = bitcast x86_mmx %t2 to <1 x i64>
  ret <1 x i64> %t3
}

declare x86_mmx @llvm.x86.mmx.paddus.w(x86_mmx, x86_mmx)
declare x86_mmx @llvm.x86.mmx.padd.b(x86_mmx, x86_mmx)
declare x86_mmx @llvm.x86.mmx.padd.w(x86_mmx, x86_mmx)
declare x86_mmx @llvm.x86.mmx.padd.d(x86_mmx, x86_mmx)
declare x86_mmx @llvm.x86.mmx.padd.q(x86_mmx, x86_mmx)
declare void @llvm.x86.mmx.emms()

