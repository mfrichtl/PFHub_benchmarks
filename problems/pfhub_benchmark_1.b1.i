
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 200
  ny = 200
  nz = 0
  xmin = 0
  xmax = 199
  ymin = 0
  ymax = 199
  elem_type = QUAD4
  uniform_refine = 0
[]

[GlobalParams]
  outputs = 'exodus console csv'
[]

[AuxVariables]
[]

[Functions]
[]

[AuxKernels]
[]

[Variables]
  [./c]
    [./InitialCondition]
      type = FunctionIC
      function = '0.5 + 0.01*(cos(0.105*x)*cos(0.11*y)+(cos(0.13*x)*cos(0.087*y))^2+cos(0.025*x-0.15*y)*cos(0.07*x-0.02*y))'
    [../]
  [../]
  [./w]
  [../]
[]

[Controls]
[]

[Kernels]
  [./c_dot]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
  [./c_res]
    type = SplitCHParsed
    f_name = F
    variable = c
    kappa_name = kappa_c
    w = w
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
[]

[BCs]
  [./flux]
    type = NeumannBC
    variable = c
    value = 0
    boundary = '0 1 2 3'
  [../]
[]

[Materials]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'kappa_c  M'
    prop_values = '2        5'
  [../]

  [./free_energy]
    type = DerivativeParsedMaterial
    expression = 'rho_s*(c-c_alpha)^2*(c_beta-c)^2'
    coupled_variables = 'c'
    constant_names =       'rho_s c_alpha c_beta'
    constant_expressions = '5     0.3     0.7'
    outputs = 'exodus'
    property_name = F
    derivative_order = 2
  [../]
[]

[UserObjects]

[]

[Postprocessors]
  [./total_energy]
    type = ElementIntegralMaterialProperty
    mat_prop = F
    outputs = 'csv console'
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
  [./dt]
    type = TimestepSize
    outputs = 'csv console'
  [../]
  [./flux]
    type = SideDiffusiveFluxIntegral
    variable = c
    diffusivity = M
    outputs = 'csv console'
    boundary = '0 1 2 3'
  [../]
[]

[VectorPostprocessors]
  
[]

[Preconditioning]
  # This preconditioner makes sure the Jacobian Matrix is fully populated. Our
  # kernels compute all Jacobian matrix entries.
  # This allows us to use the Newton solver below.
  [./SMP]
    type = SMP
    full = true
    ksp_norm = preconditioned
  [../]
[]

# [Adaptivity]
#   [./Markers]
#     [./grad_c]
#       type = ValueThresholdMarker
#       variable = jump_c
#       coarsen = 0.001
#       refine = 0.01
#       third_state = DO_NOTHING
#     [../]
#   [../]
#   [./Indicators]
#     [./jump_c]
#       type = GradientJumpIndicator
#       variable = c
#     [../]
#   [../]
#   marker = grad_c
#   cycles_per_step = 1
#   recompute_markers_during_cycles = true
# []

[Executioner]
  type = Transient
  scheme = 'bdf2'
  solve_type = 'NEWTON'
  #petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  #petsc_options_value = 'asm      31                 preonly       lu           4'
  #petsc_options_iname = '-pc_type'
  #petsc_options_value = 'lu'
  #petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  #petsc_options_value = 'hypre boomeramg 31'
  
  l_max_its = 25
  nl_max_its = 15
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-10
  normalize_solution_diff_norm_by_dt = true
  steady_state_detection = true
  #num_steps = 10
  
  start_time = 0.0
  end_time   = 1000000

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    cutback_factor = 0.75
    growth_factor = 1.25
    optimal_iterations = 8
    iteration_window = 2
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  perf_graph = true
  print_linear_residuals = false
  [./console]
    type = Console
  [../]
  [./exodus]
    type = Exodus
    interval = 100
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
  [./csv]
    type = CSV
  [../]
[]
