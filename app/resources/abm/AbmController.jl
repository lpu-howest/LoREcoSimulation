module AbmController
using Agents, Plots

@agent SchellingAgent GridAgent{2} begin
    mood::Bool
    group::Int
end

space = GridSpace((10, 10), periodic = false)

properties = Dict(:min_to_be_happy => 3)
schelling = ABM(SchellingAgent, space; properties)

function initialize(; numagents = 320, griddims = (20, 20), min_to_be_happy = 3)
    space = GridSpace(griddims, periodic = false)
    properties = Dict(:min_to_be_happy => min_to_be_happy)
    model = ABM(
        SchellingAgent,
        space;
        properties = properties,
        scheduler = random_activation,
    )
    # populate the model with agents, adding equal amount of the two types of agents
    # at random positions in the model
    for n = 1:numagents
        agent = SchellingAgent(n, (1, 1), false, n < numagents / 2 ? 1 : 2)
        add_agent_single!(agent, model)
    end
    return model
end

function agent_step!(agent, model)
    agent.mood == true && return # do nothing if already happy
    minhappy = model.min_to_be_happy
    neighbor_positions = nearby_positions(agent, model)
    count_neighbors_same_group = 0
    # For each neighbor, get group and compare to current agent's group
    # and increment count_neighbors_same_group as appropriately.
    for neighbor in nearby_agents(agent, model)
        if agent.group == neighbor.group
            count_neighbors_same_group += 1
        end
    end
    # After counting the neighbors, decide whether or not to move the agent.
    # If count_neighbors_same_group is at least the min_to_be_happy, set the
    # mood to true. Otherwise, move the agent to a random position.
    if count_neighbors_same_group ≥ minhappy
        agent.mood = true
    else
        move_agent_single!(agent, model)
    end
    return
end


#=
adata = [:pos, :mood, :group]
model = initialize()
data, _ = run!(model, agent_step!, 5; adata)
data[1:10, :] # print only a few rows
=#
# added
function abm_run()
    adata = [(:mood, sum)]
    model = initialize()
    data, _ = run!(model, agent_step!, 5; adata)
    data
end

#=
groupcolor(a) = a.group == 1 ? :blue : :orange
groupmarker(a) = a.group == 1 ? :circle : :square
#plotabm(model; ac = groupcolor, am = groupmarker, as = 4)

model = initialize();
anim = @animate for i in 0:10
    p1 = plotabm(model; ac = groupcolor, am = groupmarker, as = 4)
    title!(p1, "step $(i)")
    step!(model, agent_step!, 1)
end

gif(anim, "schelling.gif", fps = 2)
=#

end
