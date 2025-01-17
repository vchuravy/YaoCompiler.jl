module YaoCompiler

export @device, @gate, @ctrl, @measure, @barrier
# reflections
export @code_yao, @code_qasm
export gate_count
export Intrinsics

using LinearAlgebra

include("runtime/locations.jl")

using TimerOutputs
const to = TimerOutput()
timings() = (TimerOutputs.print_timer(to); println())
enable_timings() = (TimerOutputs.enable_debug_timings(Compiler); return)

using ExprTools
using MLStyle
using YaoAPI
using BitBasis
using ZXCalculus

using Core:
    CodeInfo,
    SSAValue,
    Const,
    PartialStruct,
    Slot,
    GotoIfNot,
    GotoNode,
    SlotNumber,
    Argument,
    ReturnNode
using Core.Compiler:
    InferenceParams,
    InferenceResult,
    OptimizationParams,
    OptimizationState,
    Bottom,
    AbstractInterpreter,
    VarTable,
    InferenceState,
    CFG,
    NewSSAValue,
    IRCode,
    InstructionStream,
    CallMeta
using Core.Compiler:
    get_world_counter,
    get_inference_cache,
    may_optimize,
    isconstType,
    isconcretetype,
    widenconst,
    isdispatchtuple,
    isinlineable,
    is_inlineable_constant,
    copy_exprargs,
    convert_to_ircode,
    coverage_enabled,
    argtypes_to_type,
    userefs,
    UseRefIterator,
    UseRef,
    MethodResultPure,
    is_pure_intrinsic_infer,
    intrinsic_nothrow,
    quoted,
    anymap,
    # Julia passes
    compact!,
    ssa_inlining_pass!,
    getfield_elim_pass!,
    adce_pass!,
    type_lift_pass!,
    verify_linetable,
    verify_ir,
    slot2reg

using Base.Meta: ParseError

export Routine,
    GenericRoutine,
    IntrinsicRoutine,
    RoutineSpec,
    IntrinsicSpec,
    @ctrl,
    @measure,
    @gate,
    @barrier,
    @device
export routine_name

include("compiler/patch.jl")
include("compiler/routine.jl")
include("compiler/intrinsics.jl")
include("compiler/qasm.jl")

using .QASM: @qasm_str
export @qasm_str

# compiler internal extensions
include("compiler/interpreter.jl")
include("compiler/codeinfo.jl")
include("compiler/optimize.jl")

# code generators
include("compiler/codegen/codegen.jl")

include("compiler/reflection.jl")
include("compiler/utils.jl")
# include("compiler/validation.jl")
# include("compiler/trace.jl")

function __init__()
    TimerOutputs.reset_timer!(to)
end

include("runtime/intrinsics.jl")

end # module
