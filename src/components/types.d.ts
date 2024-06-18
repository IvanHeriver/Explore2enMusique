export type TNarrativeConfig = {
  gcm: string[];
  rcm: string[];
  name: string;
};

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

export type TNarrativeDetail = {
  name: string;
  color_name: string;
  title: string;
  markdown: string;
  color: string;
  icon_path: string;
};
