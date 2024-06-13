const fs = await import("fs");

const available_data_names = [
  "A850061001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_ORCHIDEE",
  "A850061001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_ORCHIDEE",
  "A850061001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_ORCHIDEE",
  "A850061001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_ORCHIDEE",
  "B720000001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "B720000001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_GRSD",
  "B720000001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "B720000001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_GRSD",
  "D019223001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "D019223001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_GRSD",
  "D019223001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "D019223001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_GRSD",
  "E648093001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_SMASH",
  "E648093001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_SMASH",
  "E648093001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_SMASH",
  "E648093001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_SMASH",
  "F704000000__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_ORCHIDEE",
  "F704000000__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_ORCHIDEE",
  "F704000000__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_ORCHIDEE",
  "F704000000__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_ORCHIDEE",
  "G206021010__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "G206021010__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_GRSD",
  "G206021010__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "G206021010__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_GRSD",
  "H322011003__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_CTRIP",
  "H322011003__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_CTRIP",
  "H322011003__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_CTRIP",
  "H322011003__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_CTRIP",
  "I352102001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_SIM2",
  "I352102001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_SIM2",
  "I352102001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_SIM2",
  "I352102001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_SIM2",
  "J930061101__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_CTRIP",
  "J930061101__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_ORCHIDEE",
  "J930061101__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_CTRIP",
  "J930061101__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_ORCHIDEE",
  "J930061101__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_CTRIP",
  "J930061101__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_ORCHIDEE",
  "J930061101__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_CTRIP",
  "J930061101__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_ORCHIDEE",
  "K683002001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_MORDOR-TS",
  "K683002001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_MORDOR-TS",
  "K683002001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_MORDOR-TS",
  "K683002001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_MORDOR-TS",
  "L700061001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_EROS",
  "L700061001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_EROS",
  "L700061001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_EROS",
  "L700061001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_EROS",
  "M624001000__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_J2000",
  "M624001000__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_J2000",
  "M624001000__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_J2000",
  "M624001000__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_J2000",
  "N351161000__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_CTRIP",
  "N351161000__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_CTRIP",
  "N351161000__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_CTRIP",
  "N351161000__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_CTRIP",
  "O614001001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_MORDOR-SD",
  "O614001001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_MORDOR-SD",
  "O614001001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_MORDOR-SD",
  "O614001001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_MORDOR-SD",
  "P258001001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_SIM2",
  "P258001001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_SIM2",
  "P258001001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_SIM2",
  "P258001001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_SIM2",
  "Q312001002__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_SMASH",
  "Q312001002__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_SMASH",
  "Q312001002__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_SMASH",
  "Q312001002__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_SMASH",
  "R222001001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_CTRIP",
  "R222001001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_CTRIP",
  "R222001001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_CTRIP",
  "R222001001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_CTRIP",
  "S224251001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_SIM2",
  "S224251001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_SIM2",
  "S224251001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_SIM2",
  "S224251001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_SIM2",
  "U142001001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_J2000",
  "U142001001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_J2000",
  "U142001001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_J2000",
  "U142001001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_J2000",
  "V720001002__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "V720001002__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_GRSD",
  "V720001002__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "V720001002__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_GRSD",
  "W320001001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_J2000",
  "W320001001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_J2000",
  "W320001001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_J2000",
  "W320001001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_J2000",
  "X300101301__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_MORDOR-SD",
  "X300101301__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_MORDOR-SD",
  "X300101301__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_MORDOR-SD",
  "X300101301__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_MORDOR-SD",
  "Y142201001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_SMASH",
  "Y142201001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_SMASH",
  "Y142201001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_SMASH",
  "Y142201001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_SMASH",
  "Y237002001__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_SMASH",
  "Y237002001__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_SMASH",
  "Y237002001__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_SMASH",
  "Y237002001__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_SMASH",
  "Y624000101__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "Y624000101__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_GRSD",
  "Y624000101__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_GRSD",
  "Y624000101__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_GRSD",
  "Y902000101__CNRM-CM5_historical-rcp85_ALADIN63_ADAMONT_MORDOR-SD",
  "Y902000101__EC-EARTH_historical-rcp85_HadREM3-GA7_ADAMONT_MORDOR-SD",
  "Y902000101__HadGEM2-ES_historical-rcp85_ALADIN63_ADAMONT_MORDOR-SD",
  "Y902000101__HadGEM2-ES_historical-rcp85_CCLM4-8-17_ADAMONT_MORDOR-SD",
];

export type TDataInfo = {
  fullname: string;
  code: string;
  gcm: string;
  proj: string;
  rcm: string;
  bias_correction: string;
  hydro_model: string;
};

export type TCatchmentInfo = {
  code: string;
  name: string;
  x: number;
  y: number;
};

export type TCatchmentData = {
  info: TCatchmentInfo;
  data: TDataInfo[];
};

function processName(filename: string): TDataInfo | null {
  const pattern =
    /^([A-Za-z0-9-]+)__([A-Za-z0-9-]+)_([A-Za-z0-9-]+)_([A-Za-z0-9-]+)_([A-Za-z0-9-]+)_([A-Za-z0-9-]+)$/;
  const match = filename.match(pattern);

  if (match) {
    const [fullname, code, gcm, proj, rcm, bias_correction, hydro_model] =
      match;
    return {
      fullname,
      code,
      gcm,
      proj,
      rcm,
      bias_correction,
      hydro_model,
    };
  } else {
    console.log(`No match for name: ${filename}`);
    return null;
  }
}

function getCatchmentInfo() {
  const catchment_info_raw = fs.readFileSync("./data/bv_info.txt", "utf8");
  const catchment_info_tbl = catchment_info_raw
    .split("\r\n")
    .map((l) => l.split(";"));
  const catchment_info_map: Map<string, TCatchmentInfo> = new Map();
  for (let catchment of catchment_info_tbl) {
    catchment_info_map.set(catchment[0], {
      code: catchment[0],
      name: catchment[1],
      x: parseFloat(catchment[2]),
      y: parseFloat(catchment[3]),
    });
  }
  return catchment_info_map;
}

export function getAvailableStations() {
  const catchment = getCatchmentInfo();
  const station: Map<string, TCatchmentData> = new Map();
  for (let data_name of available_data_names) {
    // get the metadata
    const data = processName(data_name);
    if (data == null) {
      console.error(`Not data found for data name "${data_name}"`);
      continue;
    }
    const catchment_data_or_null = station.get(data.code);
    const catchment_info_or_null = catchment.get(data.code);
    if (catchment_info_or_null == undefined) {
      console.error(`Not catchment info found for station "${data.code}"`);
      continue;
    }
    const catchment_data: TCatchmentData =
      catchment_data_or_null == undefined
        ? {
            info: catchment_info_or_null,
            data: [],
          }
        : catchment_data_or_null;
    catchment_data.data = [...catchment_data.data, data];
    station.set(data.code, catchment_data);
  }
  return station;
}
