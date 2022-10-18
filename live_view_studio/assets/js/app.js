// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";
import { Socket } from "phoenix";
import NProgress from "nprogress";
import { LiveSocket } from "phoenix_live_view";
import InfiniteScroll from "./infinite-scroll";
import DatePicker from "./date-picker";
import FormatPhone from "./format-phone";
import LineChart from "./line-chart";
import IncidentMap from "./incident-map"

let Hooks = {
  InfiniteScroll: InfiniteScroll,
  DatePicker: DatePicker,
  FormatPhone: FormatPhone,
  LineChart: LineChart
};

Hooks.LineChart = {
  mounted() {
    const { labels, values } = JSON.parse(this.el.dataset.chartData);
    this.chart = new LineChart(this.el, labels, values)

    this.handleEvent("new-point", ({ label, value }) => {
      this.chart.addPoint(label, value)
    });
  }
}

Hooks.IncidentMap = {
  mounted() {
    this.map = new IncidentMap(this.el, [6.18, -75.58], event => {

    })

    const incidents = JSON.parse(this.el.dataset.incidents);

    incidents.forEach(incident => {
      this.map.addMarker(incident)
    });
  }
}



let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
