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
  import Feature from "ol/Feature";
  import Point from "ol/geom/Point";
  import { Icon, Style } from "ol/style";
  import { Vector as VectorSource } from "ol/source.js";
  import { Vector as VectorLayer } from "ol/layer.js";
  import Overlay from "ol/Overlay";
  import type { Coordinate } from "ol/coordinate";

  import { onMount } from "svelte";
  import { pushState } from "$app/navigation";

  import type {
    TCatchmentData,
    TCatchmentInfo,
    TDataInfo,
  } from "./process_station_data";
  import CatchmentPopup from "./CatchmentMapPopup.svelte";
  import CachmentFullPopup from "./CatchmentFullMapPopup.svelte";
  import { fromHash, updateHash } from "./hash";

  export let catchments: TCatchmentData[];

  const water_drop_icon = new Style({
    image: new Icon({
      anchor: [0.5, 0],
      anchorXUnits: "fraction",
      anchorYUnits: "fraction",
      src: "./water_drop.png",
      scale: 0.1,
    }),
  });

  const water_drop_icon_orange = new Style({
    image: new Icon({
      anchor: [0.5, 0],
      anchorXUnits: "fraction",
      anchorYUnits: "fraction",
      src: "./water_drop_orange.png",
      scale: 0.1,
    }),
  });

  let map: Map;

  let zoom = 5;
  let center = proj.fromLonLat([5, 45]);

  let push_state_debouncer: number | null = null;
  function updateURLhash(object: { [key: string]: string | null }) {
    const hash = updateHash(window.location.hash, object);
    if (push_state_debouncer != null) {
      window.clearTimeout(push_state_debouncer);
    }
    push_state_debouncer = window.setTimeout(() => {
      pushState(hash, {});
    }, 500);
  }

  function handleUrl() {
    const hash = window.location.hash;
    const params = fromHash(hash);
    // map
    if (params.map) {
      const parts = params.map.split("/");
      if (parts.length === 3) {
        zoom = parseFloat(parts[0]);
        center = [parseFloat(parts[1]), parseFloat(parts[2])];
        map.getView().setCenter(center);
        map.getView().setZoom(zoom);
      }
    }
    if (params.code) {
      const catchment = catchments.find((c) => c.info.code === params.code);
      if (!catchment) {
        updateURLhash({ code: null });
        return;
      }
      handleFullCatchmentPopup(catchment);
    }
  }

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
    let shouldUpdateHistoryState = true;
    map.on("moveend", () => {
      if (!shouldUpdateHistoryState) {
        shouldUpdateHistoryState = true;
        return;
      }
      const zoom = view.getZoom();
      const center = view.getCenter();
      if (!center || !zoom) {
        return;
      }
      updateURLhash({
        map: `${zoom.toFixed(2)}/${center[0].toFixed(2)}/${center[1].toFixed(2)}`,
      });
    });
    window.addEventListener("popstate", function (event) {
      if (event.state === null) {
        return;
      }
      shouldUpdateHistoryState = false;
      handleUrl();
    });
    handleUrl();

    // ****************************************************
    // load IGN data
    const resolutions = [];
    const matrixIds = [];
    const proj3857 = proj.get("EPSG:3857");
    if (proj3857 == null) {
      return;
    }
    const maxResolution = extent.getWidth(proj3857.getExtent()) / 256;

    for (let i = 0; i < 20; i++) {
      matrixIds[i] = i.toString();
      resolutions[i] = maxResolution / Math.pow(2, i);
    }

    const tileGrid = new WMTSTileGrid({
      origin: [-20037508, 20037508],
      resolutions: resolutions,
      matrixIds: matrixIds,
    });

    const ign_source = new WMTS({
      url: "https://data.geopf.fr/wmts",
      layer: "GEOGRAPHICALGRIDSYSTEMS.PLANIGNV2",
      matrixSet: "PM",
      format: "image/png",
      projection: "EPSG:3857",
      tileGrid: tileGrid,
      style: "normal",
      attributions:
        '<a href="https://www.ign.fr/" target="_blank">' +
        '<img src="https://www.ign.fr/files/default/styles/thumbnail/public/2020-06/logoIGN_300x200.png" width="25px" title="Institut national de l\'' +
        'information géographique et forestière" alt="IGN"></a>',
    });
    const ign = new TileLayer({
      source: ign_source,
    });
    map.addLayer(ign);

    // ****************************************************
    // dealing with station data

    // register Lamber93 projection
    proj4.defs(
      "EPSG:2154",
      "+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    );
    register(proj4);

    // creating the catchments features
    const features: Feature<Point>[] = [];
    for (let catchment of catchments) {
      const feature = new Feature({
        geometry: new Point(
          proj.transform(
            [catchment.info.x, catchment.info.y],
            "EPSG:2154",
            "EPSG:3857"
          )
        ),
        name: `${catchment.info.name} (${catchment.info.code})`,
        code: catchment.info.code,
        info: catchment.info,
        data: catchment.data,
      });
      feature.setStyle(water_drop_icon);
      features.push(feature);
    }

    const vectorSource = new VectorSource({
      features: features,
    });

    const vectorLayer = new VectorLayer({
      source: vectorSource,
    });

    map.addLayer(vectorLayer);

    // ****************************************************
    // dealing with  events

    // on click, load catchment compoennt
    map.on("click", function (e) {
      const last_feature = map.forEachFeatureAtPixel(
        e.pixel,
        function (feature) {
          return feature;
        }
      );
      // reset
      features.forEach((f) => f.setStyle(water_drop_icon));
      map_container.style.cursor = "unset";
      if (popup) {
        map.removeOverlay(popup);
      }
      // open popup
      if (last_feature) {
        const info = last_feature.get("info") as TCatchmentInfo;
        const data = last_feature.get("data") as TDataInfo[];
        handleFullCatchmentPopup({ info, data });
        updateURLhash({ code: info.code });
      }
    });

    // on mouse move, load popup preview
    map.on("pointermove", function (e) {
      if (e.dragging) {
        return;
      }
      const last_feature = map.forEachFeatureAtPixel(
        e.pixel,
        function (feature) {
          return feature;
        }
      );
      // reset
      features.forEach((f) => f.setStyle(water_drop_icon));
      map_container.style.cursor = "unset";
      if (popup) {
        map.removeOverlay(popup);
      }
      // open popup
      if (last_feature) {
        handleCatchmentPopup(
          e.coordinate,
          last_feature.get("info") as TCatchmentInfo
        );
        map_container.style.cursor = "pointer";
        const point = last_feature as Feature<Point>;
        point.setStyle(water_drop_icon_orange);
      }
    });
  });

  // ncatchment preview popup
  let popup: Overlay | null = null;
  function handleCatchmentPopup(
    coordinates: Coordinate,
    catchment_info: TCatchmentInfo
  ) {
    const div = document.createElement("div");
    new CatchmentPopup({
      target: div,
      props: {
        info: catchment_info,
        // close_cb: () => {
        //   if (popup) {
        //     map.removeOverlay(popup);
        //   }
        // },
      },
    });
    popup = new Overlay({
      element: div,
      positioning: "bottom-center",
      offset: [0, -10],
      stopEvent: false,
    });
    popup.setPosition(coordinates);
    map.addOverlay(popup);
  }

  // catchment frame
  function handleFullCatchmentPopup(catchment: TCatchmentData) {
    catchment_container.innerHTML = "";
    catchment_container.style.display = "block";
    new CachmentFullPopup({
      target: catchment_container,
      props: {
        catchment: catchment,
        close_cb: () => {
          catchment_container.innerHTML = "";
          catchment_container.style.display = "none";
          updateURLhash({ code: null });
        },
      },
    });
  }

  let catchment_container: HTMLDivElement;
  let map_container: HTMLDivElement;
</script>

<div class="catchment-container" bind:this={catchment_container}></div>
<div class="map-container">
  <div id="map" bind:this={map_container}></div>
</div>

<style>
  .catchment-container {
    position: absolute;
    inset: 0;
    z-index: 100000;
    display: none;
  }
  .map-container {
    position: absolute;
    inset: 0;
  }
  #map {
    height: 100%;
    width: 100%;
  }
  :global(.ol-overlaycontainer-stopevent) {
    position: absolute;
    inset: 4.5rem auto auto 0.5rem;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    gap: 0.25rem;
  }
  :global(.ol-zoom) {
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
</style>
