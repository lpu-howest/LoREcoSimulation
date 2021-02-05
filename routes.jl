using Genie.Router
using AbmController

route("/") do
  serve_static_file("welcome.html")
end

# added
function hello_world()
  "Hello World"
end

route("/hello", hello_world)

route("/abm", AbmController.abm_run)
