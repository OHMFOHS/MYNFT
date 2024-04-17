/**@type {import("next").NextConfig} */
module.exports = {
  reactStrictMode: true,
  exportTrailingSlash: true,
  images: {
    unoptimized: true,
    domains: ["gateway.pinata.cloud"],
    formats: ["image/webp"],
  },
};
