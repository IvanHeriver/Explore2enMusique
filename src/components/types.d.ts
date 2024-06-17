export type TNarrative = {
  gcm: string[];
  rcm: string[];
  color: "none" | "green" | "yellow" | "orange" | "violet";
  label: string;
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
