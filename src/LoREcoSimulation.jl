module LoREcoSimulation

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = LoREcoSimulation))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = LoREcoSimulation.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
