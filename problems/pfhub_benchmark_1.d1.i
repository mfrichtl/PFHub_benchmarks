
[Mesh]
  [./sphere]
    type = SphereMeshGenerator
    radius = 100
    nr = 3
    n_smooth = 2
  [../]
  uniform_refine = 0
[]

[GlobalParams]
  outputs = 'exodus console csv pgraph'
[]

[AuxVariables]
  [./free_energy]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[Functions]
  [./c_func]
    type = ParsedFunction
    expression = 'c0 + eps*(cos(8*acos(z/r))*cos(15*atan(y/x)) + (cos(12*acos(z/r))*cos(10*atan(y/x)))^2 + cos(2.5*acos(z/r) -1.5*atan(y/x))*cos(7*acos(z/r)-2*atan(y/x)))'
    symbol_names = 'c0   eps  r'
    symbol_values = '0.5 0.05 100'
  [../]
[]

[AuxKernels]
  [./free_energy]
    type = TotalFreeEnergy
    variable = free_energy
    f_name = F
    interfacial_vars = c
    kappa_names = kappa_c
  [../]
[]

[Variables]
  [./c]
    [./InitialCondition]
      type = FunctionIC
      function = c_func
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
  [./bulk_energy]
    type = ElementIntegralMaterialProperty
    mat_prop = F
    outputs = 'csv console'
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
  [./total_energy]
    type = ElementIntegralVariablePostprocessor
    variable = free_energy
    outputs = 'csv console'
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
  [./dt]
    type = TimestepSize
    outputs = 'csv console'
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
  
  l_max_its = 50
  l_abs_tol = 1e-10
  nl_max_its = 15
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11
  normalize_solution_diff_norm_by_dt = true
  steady_state_tolerance = 1e-06
  steady_state_detection = true
  line_search = none
  #num_steps = 10
  
  start_time = 0.0
  end_time   = 1000000
  dtmin = 1e-6

  [./Adaptivity]
    initial_adaptivity = 2
    max_h_level = 2
    interval = 1
    refine_fraction = 0.85
    coarsen_fraction = 0.15
  [../]
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    cutback_factor = 0.95
    growth_factor = 1.05
    optimal_iterations = 8
    iteration_window = 2
    linear_iteration_ratio = 100
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  print_linear_residuals = false
  [./console]
    type = Console
  [../]
  [./exodus]
    type = Exodus
    interval = 50
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
  [./csv]
    type = CSV
  [../]
  [./pgraph]
    type = PerfGraphOutput
    execute_on = 'FINAL FAILED'
  [../]
[]
