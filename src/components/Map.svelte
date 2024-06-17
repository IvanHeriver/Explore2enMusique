<script lang="ts">
  import proj4 from "proj4";
  import * as proj from "ol/proj";
  import { register } from "ol/proj/proj4";
  import * as extent from "ol/extent";
  import Map from "ol/Map.js";
  import TileLayer from "ol/layer/Tile.js";
  import View from "ol/View.js";
  import WMTS from "ol/source/WMTS.js";
  import WMTSTileGrid from "ol/tilegrid/WMTS";
  import Overlay from "ol/Overlay";
  import OSM from "ol/source/OSM.js";

  import { onMount } from "svelte";

  import CatchmentPopup from "./CatchmentMapPopup.svelte";

  import type { TCatchmentData, TCatchmentInfo } from "./types";
  import MapPin from "./MapPin.svelte";
  import { getDataFromURLhash, updateURLhash } from "./hash";

  export let catchments: TCatchmentData[];

  let map: Map;

  let zoom = 5;
  let center = proj.fromLonLat([5, 45]);
  let should_update_history_state = true;

  onMount(() => {
    // ****************************************************
    // initialize the map
    map = new Map({
      target: "map",
      view: new View({
        zoom: zoom,
        center: center,
      }),
    });

    const view = map.getView();

    // ****************************************************
    // handle history navigation (zoom and location)

    let hash_debouncer: number | null = null;
    map.on("moveend", () => {
      if (!should_update_history_state) {
        should_update_history_state = true;
        return;
      }
      const zoom = view.getZoom();
      const center = view.getCenter();
      if (!center || !zoom) {
        return;
      }
      if (hash_debouncer) {
        window.clearTimeout(hash_debouncer);
      }
      hash_debouncer = window.setTimeout(() => {
        updateURLhash({
          map: `${zoom.toFixed(2)}/${center[0].toFixed(2)}/${center[1].toFixed(2)}`,
        });
      }, 200);
    });

    processMapNavInfo();

    // ****************************************************
    // load IGN data
    const resolutions = [];
    const matrix_ids = [];
    const proj3857 = proj.get("EPSG:3857");
    if (proj3857 == null) {
      return;
    }
    const max_resolution = extent.getWidth(proj3857.getExtent()) / 256;

    for (let i = 0; i < 20; i++) {
      matrix_ids[i] = i.toString();
      resolutions[i] = max_resolution / Math.pow(2, i);
    }

    const ign_tile_grid = new WMTSTileGrid({
      origin: [-20037508, 20037508],
      resolutions: resolutions,
      matrixIds: matrix_ids,
    });

    const ign_source = new WMTS({
      url: "https://data.geopf.fr/wmts",
      layer: "GEOGRAPHICALGRIDSYSTEMS.PLANIGNV2",
      matrixSet: "PM",
      format: "image/png",
      projection: "EPSG:3857",
      tileGrid: ign_tile_grid,
      style: "normal",
      attributions:
        '<a href="https://www.ign.fr/" target="_blank">' +
        '<img src="https://www.ign.fr/files/default/styles/thumbnail/public/2020-06/logoIGN_300x200.png" width="25px" title="Institut national de l\'' +
        'information géographique et forestière" alt="IGN"></a>',
    });
    const ign = new TileLayer({
      source: ign_source,
    });
    // map.addLayer(ign);

    // ****************************************************
    // load OSM data
    const osm_source = new OSM();
    const osm_layer = new TileLayer({
      source: osm_source,
    });
    map.addLayer(osm_layer);

    // ****************************************************
    // dealing with station data

    // register Lamber93 projection
    proj4.defs(
      "EPSG:2154",
      "+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    );
    register(proj4);

    let catchment_info_popup: Overlay | undefined;

    // creating the catchments features
    for (let catchment of catchments) {
      const coordinates = proj.transform(
        [catchment.info.x, catchment.info.y],
        "EPSG:2154",
        "EPSG:3857"
      );
      const div = document.createElement("div");
      new MapPin({
        target: div,
        props: {
          info: catchment.info,
          onHover: (info: TCatchmentInfo) => {
            const div_popup = document.createElement("div");
            new CatchmentPopup({
              target: div_popup,
              props: {
                info: info,
              },
            });
            catchment_info_popup = new Overlay({
              element: div_popup,
              positioning: "bottom-center",
              insertFirst: false,
              offset: [0, 0],
              stopEvent: false,
            });
            catchment_info_popup.setPosition(coordinates);
            map.addOverlay(catchment_info_popup);
            return () => {
              if (catchment_info_popup) {
                map.removeOverlay(catchment_info_popup);
              }
            };
          },
        },
      });
      const popup = new Overlay({
        element: div,
        positioning: "top-center",
        offset: [0, 0],
        stopEvent: false,
      });
      popup.setPosition(coordinates);
      map.addOverlay(popup);
    }
    window.addEventListener("popstate", function (event) {
      if (event.state === null) {
        return;
      }
      should_update_history_state = false;
      processMapNavInfo();
    });
  });

  function processMapNavInfo() {
    const info = getDataFromURLhash("map");
    if (!map || !info) {
      return;
    }
    const parts = info.split("/");
    if (parts.length === 3) {
      zoom = parseFloat(parts[0]);
      center = [parseFloat(parts[1]), parseFloat(parts[2])];
      map.getView().setCenter(center);
      map.getView().setZoom(zoom);
      should_update_history_state = false;
      map.render();
    }
  }

  let map_container: HTMLDivElement;
</script>

<div class="map-container">
  <div id="map" bind:this={map_container}></div>
</div>

<style>
  .map-container {
    position: fixed;
    inset: 0;
  }
  #map {
    height: 100%;
    width: 100%;
  }
  :global(.ol-zoom) {
    position: absolute;
    inset: 4.5rem auto auto 0.5rem;
    display: flex;
    gap: 0.25rem;
  }
  :global(.map button) {
    width: 1.5rem;
    height: 1.5rem;
  }
  :global(.ol-hidden) {
    display: none;
  }
  :global(.ol-collapsed > ul) {
    display: none;
  }

  :global(.ol-attribution) {
    position: absolute;
    background: rgba(255, 255, 255, 0.7);
    padding: 5px;
    bottom: var(--footer-height);
    right: 0;
    font-size: 12px;
  }

  :global(.ol-attribution button) {
    display: none;
  }
  :global(.ol-attribution ul) {
    margin: 0;
    padding: 0;
  }

  :global(.ol-attribution li) {
    list-style: none;
  }
</style>
