  cd(@__DIR__)
  import Pkg
  Pkg.activate(".")
  using Revise

  function main()
    include(joinpath("src", "LoREcoSimulation.jl"))
  end; main()
