; RUN: llc -mtriple=x86_64-apple-darwin %s -o %t -filetype=obj -O0
; RUN: llvm-dwarfdump -debug-dump=info %t | FileCheck %s

; CHECK: DW_TAG_rvalue_reference_type

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define void @_Z3fooOi(i32* %i) uwtable ssp {
entry:
  %i.addr = alloca i32*, align 8
  store i32* %i, i32** %i.addr, align 8
  call void @llvm.dbg.declare(metadata i32** %i.addr, metadata !11, metadata !MDExpression()), !dbg !12
  %0 = load i32*, i32** %i.addr, align 8, !dbg !13
  %1 = load i32, i32* %0, align 4, !dbg !13
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %1), !dbg !13
  ret void, !dbg !15
}

declare void @llvm.dbg.declare(metadata, metadata, metadata) nounwind readnone

declare i32 @printf(i8*, ...)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!17}

!0 = !MDCompileUnit(language: DW_LANG_C_plus_plus, producer: "clang version 3.2 (trunk 157054) (llvm/trunk 157060)", isOptimized: false, emissionKind: 0, file: !16, enums: !1, retainedTypes: !1, subprograms: !3, globals: !1, imports:  !1)
!1 = !{}
!3 = !{!5}
!5 = !MDSubprogram(name: "foo", linkageName: "_Z3fooOi", line: 4, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 5, file: !16, scope: !6, type: !7, function: void (i32*)* @_Z3fooOi, variables: !1)
!6 = !MDFile(filename: "foo.cpp", directory: "/Users/echristo/tmp")
!7 = !MDSubroutineType(types: !8)
!8 = !{null, !9}
!9 = !MDDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !10)
!10 = !MDBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!11 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "i", line: 4, arg: 1, scope: !5, file: !6, type: !9)
!12 = !MDLocation(line: 4, column: 17, scope: !5)
!13 = !MDLocation(line: 6, column: 3, scope: !14)
!14 = distinct !MDLexicalBlock(line: 5, column: 1, file: !16, scope: !5)
!15 = !MDLocation(line: 7, column: 1, scope: !14)
!16 = !MDFile(filename: "foo.cpp", directory: "/Users/echristo/tmp")
!17 = !{i32 1, !"Debug Info Version", i32 3}
