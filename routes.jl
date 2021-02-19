using Genie.Router
using SchellingController
using AbmController

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
route("/abmhtml", SchellingController.abm_run_html)
route("/abmtable", SchellingController.abm_run_table)
route("/abmgraph", SchellingController.abm_run_graph)
route("/abmscatter", SchellingController.abm_run_scatter)
route("/lorecoagents", AbmController.loreco_run_table)
