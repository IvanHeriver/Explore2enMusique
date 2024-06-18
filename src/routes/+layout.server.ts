import { getAvailableStations } from "../components/process_station_data";
import { marked } from "marked";
import type { TNarrativeDetail } from "../components/types";
const fs = await import("fs");

function processMarkdownFile(filepath: string) {
  const raw = fs.readFileSync(filepath, "utf8");
  const md = marked.parse(raw) as string;
  return md;
}

function loadNarratives(): TNarrativeDetail[] {
  const json = JSON.parse(
    fs.readFileSync("./data/narratives.json", "utf8")
  ) as TNarrativeDetail[];
  return json.map((n) => {
    return { ...n, markdown: processMarkdownFile(`./data/${n.markdown}`) };
  });
}

export async function load() {
  const narratives = loadNarratives();
  console.log(narratives);
  return {
    short: processMarkdownFile(`./data/short.md`),
    explore2: processMarkdownFile(`./data/explore2.md`),
    sonification: processMarkdownFile(`./data/sonification.md`),
    narratives: narratives,
    data: getAvailableStations(),
  };
}

export const prerender = true;
