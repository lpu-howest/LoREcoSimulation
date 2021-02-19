module SchellingController
using Agents, Plots
using Genie.Renderer.Html
using Tables
using PrettyTables



#=@agent SchellingAgent{Int} GridAgent{2} begin
    mood::Bool
    group::Int
end=#
mutable struct SchellingAgent <: AbstractAgent
    id::Int # The identifier number of the agent
    pos::Dims{2} # The x, y location of the agent on a 2D grid
    mood::Bool # whether the agent is happy in its position. (true = happy)
    group::Int # The group of the agent,  determines mood as it interacts with neighbors
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
    adata = [:pos, :mood, :group]

    model = initialize()
    data, _ = run!(model, agent_step!, 5; adata)
    data[1:10, :]
end

function abm_run_html()
    adata = [:pos, :mood, :group]
    model = initialize()
    data, _ = run!(model, agent_step!, 5; adata)
    #print(data[1:10, :])
    #pretty_table(data, formatters = ft_printf("%.3f", [2,3]), highlighters = (hl_lt(0.2), hl_gt(0.8)))
    #pretty_table(data[1:10, :], backend = :html, formatters = ft_printf("%.3f", [2,3]))

    html(:schelling, :abm,  agents = Tables.namedtupleiterator(data))
end

function abm_run_table()
    adata = [:pos, :mood, :group]
    model = initialize()
    data, _ = run!(model, agent_step!, 5; adata)
    #print(data[1:10, :])
    #pretty_table(data, formatters = ft_printf("%.3f", [2,3]), highlighters = (hl_lt(0.2), hl_gt(0.8)))
    #pretty_table(data[1:10, :], backend = :html, formatters = ft_printf("%.3f", [2,3]))

    html(:schelling, :table,  agents = Tables.namedtupleiterator(data))
end
function abm_run_graph()
    adata = [:pos, :mood, :group]
    model = initialize()
    data, _ = run!(model, agent_step!, 5; adata)
    #print(data[1:10, :])
    #pretty_table(data, formatters = ft_printf("%.3f", [2,3]), highlighters = (hl_lt(0.2), hl_gt(0.8)))
    #pretty_table(data[1:10, :], backend = :html, formatters = ft_printf("%.3f", [2,3]))

    html(:schelling, :graph,  agents = Tables.namedtupleiterator(data))
end
function abm_run_scatter()
    adata = [:pos, :mood, :group]
    model = initialize()
    data, _ = run!(model, agent_step!, 5; adata)
    #print(data[1:10, :])
    #pretty_table(data, formatters = ft_printf("%.3f", [2,3]), highlighters = (hl_lt(0.2), hl_gt(0.8)))
    #pretty_table(data[1:10, :], backend = :html, formatters = ft_printf("%.3f", [2,3]))

    html(:schelling, :scatter,  agents = Tables.namedtupleiterator(data))
end
mutable struct Row
    id::String # The identifier number of the agent
    pos::String # The x, y location of the agent on a 2D grid
    mood::String # whether the agent is happy in its position. (true = happy)
    group::String # The group of the agent,  determines mood as it interacts with neighbors
end


struct Book
  title::String
  author::String
end

const BillGatesBooks = Book[
  Book("The Best We Could Do", "Thi Bui"),
  Book("Evicted: Poverty and Profit in the American City", "Matthew Desmond"),
  Book("Believe Me: A Memoir of Love, Death, and Jazz Chickens", "Eddie Izzard"),
  Book("The Sympathizer", "Viet Thanh Nguyen"),
  Book("Energy and Civilization, A History", "Vaclav Smil")
]

function billgatesbooks()
    html(:schelling, :schelling, books = BillGatesBooks)
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
