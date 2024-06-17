import { pushState } from "$app/navigation";

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

export function getDataFromURLhash(key: string): string | undefined {
  return fromHash(window.location.hash)[key];
}

// let push_state_debouncer: number | null = null;
export function updateURLhash(object: { [key: string]: string | null }) {
  const hash = updateHash(window.location.hash, object);
  pushState(hash, {});
  // if (push_state_debouncer != null) {
  //   window.clearTimeout(push_state_debouncer);
  // }
  // push_state_debouncer = window.setTimeout(() => {
  // }, 0);
}
