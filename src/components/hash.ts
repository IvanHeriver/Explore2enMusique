export function fromHash(hash: string): { [key: string]: string } {
  if (!hash || hash == "" || !hash.startsWith("#")) {
    return {};
  }
  hash = hash.substring(1);
  const raw_params = hash.split("&");
  const params: { [key: string]: string } = {};
  raw_params.forEach((p) => {
    const entry = p.split("=");
    if (entry.length == 2) {
      params[entry[0]] = entry[1];
    }
  });
  return params;
}

export function toHash(object: { [key: string]: string }): string {
  let hash = "#";
  Object.entries(object).forEach((e, i) => {
    hash = `${hash}${i > 0 ? "&" : ""}${e[0]}=${e[1]}`;
  });
  return hash;
}

export function updateHash(
  hash: string,
  object: { [key: string]: string | null }
): string {
  const params = fromHash(hash);
  Object.entries(object).forEach((e) => {
    if (e[1] == null) {
      delete params[e[0]];
    } else {
      params[e[0]] = e[1];
    }
  });
  return toHash(params);
}
