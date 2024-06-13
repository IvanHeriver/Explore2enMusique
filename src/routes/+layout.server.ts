import { getAvailableStations } from "../components/process_station_data";
export async function load() {
  const data = getAvailableStations();
  return {
    data,
  };
}

export const prerender = true;
