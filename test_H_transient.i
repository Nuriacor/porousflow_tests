[Mesh]
  [file]
    type = FileMeshGenerator
    file = mec_ss.e
    use_for_exodus_restart = true
  []
[]

[Problem]
  coord_type = RZ
[]

[GlobalParams]
  PorousFlowDictator = dictator
  biot_coefficient = 1
  multiply_by_density = true
[]

[Variables]
  [porepressure]
    initial_from_file_var = porepressure
  []
[]

[BCs]
  [pp]
    type = FunctionDirichletBC
    variable = porepressure
    function = 1 #Make this almost zero
    boundary = top
  []
[]

[Modules]
  [FluidProperties]
    [the_simple_fluid]
      type = SimpleFluidProperties
      thermal_expansion = 0.0
      bulk_modulus = 2E9
      viscosity = 1E-3
      density0 = 1000.0
    []
  []
[]


[PorousFlowBasicTHM]
  coupling_type = Hydro
  porepressure = porepressure
  gravity = '0 -10 0'
  fp = the_simple_fluid
[]

[Materials]
  [porosity]
    type = PorousFlowPorosityConst
    porosity = 0.2
  []
  [biot_modulus]
    type = PorousFlowConstantBiotModulus
    solid_bulk_compliance = 1E-10
    fluid_bulk_modulus = 2E9
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1.0E-13 0 0 0 1.0E-13 0 0 0 1E-13'
  []
  [density]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 1700.0
  []
[]

[Postprocessors]
  [pp_0]
    type = PointValue
    point = '1 -100 0'
    variable = porepressure
    execute_on = 'TIMESTEP_END'
  []
  [pp_inf]
    type = PointValue
    point = '1000 -100 0'
    variable = porepressure
    execute_on = 'TIMESTEP_END'
  []
[]


[Preconditioning]
  [mumps]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = 'gmres      asm      lu           NONZERO                   2             '
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0
  end_time = 1
  dtmax = 1

[]

[Outputs]
  csv = true
[]
