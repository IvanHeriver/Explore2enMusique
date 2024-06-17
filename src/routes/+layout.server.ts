import { getAvailableStations } from "../components/process_station_data";
import { marked } from "marked";
const fs = await import("fs");

function processMarkdownFile(filepath: string) {
  const raw = fs.readFileSync(filepath, "utf8");
  const md = marked.parse(raw) as string;
  return md;
}
export async function load() {
  const data = getAvailableStations();
  const about_raw_text = fs.readFileSync(`./data/short.md`, "utf8");
  const about_text = marked.parse(about_raw_text) as string;
  return {
    short: processMarkdownFile(`./data/short.md`),
    explore2: processMarkdownFile(`./data/explore2.md`),
    sonification: processMarkdownFile(`./data/sonification.md`),
    data,
  };
}

export const prerender = true;
