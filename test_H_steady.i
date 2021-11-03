[Mesh]
  [leaky_mesh_top]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 250
    xmin = 1
    xmax = 1000
    bias_x = 1.01
    ny = 10
    ymin = -45
    ymax = 0
  []
  [aquifer_mesh]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 250
    xmin = 1
    xmax = 1000
    bias_x = 1.01
    ny = 10
    ymax = -45
    ymin = -55
  []
  [leaky_mesh_bottom]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 250
    xmin = 1
    xmax = 1000
    bias_x = 1.01
    ny = 10
    ymin = -100
    ymax = -55
  []
  [mesh_top]
    type = StitchedMeshGenerator
    inputs = 'leaky_mesh_top aquifer_mesh'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'bottom top'
  []
  [mesh]
    type = StitchedMeshGenerator
    inputs = 'mesh_top leaky_mesh_bottom'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'bottom top'
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
  []
[]

[ICs]
  [porepressure]
    type = FunctionIC
    variable = porepressure
    function = '-10000*y'
  []
[]

[BCs]
  [pp]
    type = FunctionDirichletBC
    variable = porepressure
    function = 0
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
  [pp_end]
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
  type = Steady
  solve_type = Newton
[]

[Outputs]
  exodus = true
  csv = true
  file_base = hydro_ss
[]
