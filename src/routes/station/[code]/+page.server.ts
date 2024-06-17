export async function load({ params }) {
  console.log("params", params);
  return { code: params.code };
}

export const prerender = true;
