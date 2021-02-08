using Genie.Router
using SchellingController

route("/") do
  serve_static_file("welcome.html")
end

# added
function hello_world()
  "Hello World"
end

route("/hello", hello_world)

route("/abm", SchellingController.abm_run)
route("/bgbooks", SchellingController.billgatesbooks)
