
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  nz = 0
  xmax = 200
  ymax = 200
  elem_type = QUAD4
  uniform_refine = 0
[]

[GlobalParams]
  outputs = 'exodus console csv'
  derivative_order = 2
[]

[AuxVariables]
  [./free_energy]
    family = MONOMIAL
    order = CONSTANT
  [../]
  [./eta_grad_energy]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[Functions]
[]

[AuxKernels]
  [./free_energy]
    type = TotalFreeEnergy
    variable = free_energy
    f_name = F
    interfacial_vars = 'c eta1 eta2 eta3 eta4'
    kappa_names = 'kappa_c kappa_eta kappa_eta kappa_eta kappa_eta'
  [../]
[]

[Variables]
  [./c]
    [./InitialCondition]
      type = FunctionIC
      function = '0.5 + 0.05*(cos(0.105*x)*cos(0.11*y)+(cos(0.13*x)*cos(0.087*y))^2+cos(0.025*x-0.15*y)*cos(0.07*x-0.02*y))'
    [../]
  [../]
  [./w]
  [../]
  [./eta1]
    [./InitialCondition]
      type = FunctionIC
      function = '0.1*(cos((0.01*1)*x-4)*cos((0.007+0.01*1)*y) + cos((0.11+0.01*1)*x)*cos((0.11+0.01)*y) +
                  1.5*(cos((0.046+0.001*1)*x + (0.0405+0.001*1)*y)*cos((0.031+0.001*1)*x - (0.004+0.001*1)*y))^2)^2'
    [../]
  [../]
  [./eta2]
    [./InitialCondition]
      type = FunctionIC
      function = '0.1*(cos((0.01*2)*x-4)*cos((0.007+0.01*2)*y) + cos((0.11+0.01*2)*x)*cos((0.11+0.01)*y) +
                  1.5*(cos((0.046+0.001*2)*x + (0.0405+0.001*2)*y)*cos((0.031+0.001*2)*x - (0.004+0.001*2)*y))^2)^2'
    [../]
  [../]
  [./eta3]
    [./InitialCondition]
      type = FunctionIC
      function = '0.1*(cos((0.01*3)*x-4)*cos((0.007+0.01*3)*y) + cos((0.11+0.01*3)*x)*cos((0.11+0.01)*y) +
                  1.5*(cos((0.046+0.001*3)*x + (0.0405+0.001*3)*y)*cos((0.031+0.001*3)*x - (0.004+0.001*3)*y))^2)^2'
    [../]
  [../]
  [./eta4]
    [./InitialCondition]
      type = FunctionIC
      function = '0.1*(cos((0.01*4)*x-4)*cos((0.007+0.01*4)*y) + cos((0.11+0.01*4)*x)*cos((0.11+0.01)*y) +
                  1.5*(cos((0.046+0.001*4)*x + (0.0405+0.001*4)*y)*cos((0.031+0.001*4)*x - (0.004+0.001*4)*y))^2)^2'
    [../]
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
    coupled_variables = 'eta1 eta2 eta3 eta4'
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./eta1_dot]
    type = TimeDerivative
    variable = eta1
  [../]
  [./ACBulk1]
    type = AllenCahn
    variable = eta1
    coupled_variables = 'c eta2 eta3 eta4'
    f_name = F
    mob_name = L
  [../]
  [./ACInterface1]
    type = ACInterface
    variable = eta1
    kappa_name = kappa_eta
    mob_name = L
  [../]
  [./eta2_dot]
    type = TimeDerivative
    variable = eta2
  [../]
  [./ACBulk2]
    type = AllenCahn
    variable = eta2
    coupled_variables = 'c eta1 eta3 eta4'
    f_name = F
    mob_name = L
  [../]
  [./ACInterface2]
    type = ACInterface
    variable = eta2
    kappa_name = kappa_eta
    mob_name = L
  [../]
  [./eta3_dot]
    type = TimeDerivative
    variable = eta3
  [../]
  [./ACBulk3]
    type = AllenCahn
    variable = eta3
    coupled_variables = 'c eta1 eta2 eta4'
    f_name = F
    mob_name = L
  [../]
  [./ACInterface3]
    type = ACInterface
    variable = eta3
    kappa_name = kappa_eta
    mob_name = L
  [../]
  [./eta4_dot]
    type = TimeDerivative
    variable = eta4
  [../]
  [./ACBulk4]
    type = AllenCahn
    variable = eta4
    coupled_variables = 'c eta1 eta2 eta3'
    f_name = F
    mob_name = L
  [../]
  [./ACInterface4]
    type = ACInterface
    variable = eta4
    kappa_name = kappa_eta
    mob_name = L
  [../]
[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./consts]
    type = GenericConstantMaterial
    prop_names  = 'kappa_c  kappa_eta M L '
    prop_values = '3        3         5 5'
  [../]

  [./switching]
    type = DerivativeParsedMaterial
    expression = 'eta1^3*(6*eta1^2-15*eta1+10) +
                  eta2^3*(6*eta2^2-15*eta2+10) +
                  eta3^3*(6*eta3^2-15*eta3+10) +
                  eta4^3*(6*eta4^2-15*eta4+10)'
    coupled_variables = 'eta1 eta2 eta3 eta4'
    property_name = h
    outputs = 'exodus'
  [../]

  [./barrier]
    type = DerivativeParsedMaterial
    expression = 'eta1^2*(1-eta1)^2 + 
                  eta2^2*(1-eta2)^2 +
                  eta3^2*(1-eta3)^2 +
                  eta4^2*(1-eta4)^2 +
                  alpha*((eta1*eta2)^2+(eta1*eta3)^2+(eta1*eta4)^2 +
                  (eta2*eta1)^2 + (eta2*eta3)^2 + (eta2*eta4)^2 +
                  (eta3*eta1)^2 + (eta3*eta2)^2 + (eta3*eta4)^2 +
                  (eta4*eta1)^2 + (eta4*eta2)^2 + (eta4*eta3)^2)'
    coupled_variables = 'eta1 eta2 eta3 eta4'
    constant_names =       'alpha'
    constant_expressions = '5'
    outputs = 'exodus'
    property_name = g
  [../]

  [./free_energy_alpha]
    type = DerivativeParsedMaterial
    expression = 'rho*(c-c_alpha)^2'
    coupled_variables = 'c'
    constant_names =       'rho  c_alpha'
    constant_expressions = '2    0.3    '
    property_name = F_alpha
    outputs = 'exodus'
  [../]

  [./free_energy_beta]
    type = DerivativeParsedMaterial
    expression = 'rho*(c_beta-c)^2'
    coupled_variables = 'c'
    constant_names =       'rho c_beta'
    constant_expressions = '2   0.7   '
    property_name = F_beta
    outputs = 'exodus'
  [../]

  [./f_chem]
    type = DerivativeParsedMaterial
    expression = 'F_alpha*(1-h) + F_beta*h + w*g'
    coupled_variables = 'c eta1 eta2 eta3 eta4'
    material_property_names = 'F_alpha(c) F_beta(c) h(eta1,eta2,eta3,eta4) g(eta1,eta2,eta3,eta4)'
    constant_names =       'w'
    constant_expressions = '1'
    property_name = F
    outputs = 'exodus'
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
  [./mem_usage]
    type = MemoryUsage
    mem_type = physical_memory
    value_type = total
    mem_units = kilobytes
    outputs = 'csv'
  [../]
  [./walltime]
    type = PerfGraphData
    section_name = "Root"
    data_type = total
    outputs = 'csv'
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
  steady_state_detection = true
  steady_state_tolerance = 5e-5
  #num_steps = 10
  
  start_time = 0.0
  end_time   = 1000000

  [./Adaptivity]
    initial_adaptivity = 2
    max_h_level = 2
    interval = 1
    refine_fraction = 0.85
    coarsen_fraction = 0.15
  [../]

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.01
    cutback_factor = 0.75
    growth_factor = 1.25
    optimal_iterations = 8
    iteration_window = 2
    #linear_iteration_ratio = 100
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
    interval = 1
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
