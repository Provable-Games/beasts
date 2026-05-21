/**
 * Beast SDK Image URL Generation
 *
 * Generates local image URLs for beast NFTs based on their attributes.
 * Images are stored locally in /public/images/beasts/
 */

import { getBeastName } from "./lookups";

/**
 * Image asset path structure:
 * /images/beasts/
 * ├── static/
 * │   ├── regular/     # {beast_name}.png (75 files)
 * │   └── shiny/       # {beast_name}.png (shiny variants)
 * └── animated/
 *     ├── regular/     # {beast_name}.gif
 *     └── shiny/       # {beast_name}.gif
 */

/**
 * Convert beast name to image filename format
 * Handles special cases like "Nemean Lion" -> "nemeanlion"
 */
function toImageFilename(beastName: string): string {
  return beastName.toLowerCase().replace(/\s+/g, "");
}

/**
 * Generate the image URL for a beast based on its attributes
 *
 * @param beastId - Beast type ID (1-75)
 * @param shiny - Whether the beast is shiny
 * @param animated - Whether to use animated GIF
 * @returns Local image URL path
 */
export function getBeastImageUrl(
  beastId: number,
  shiny: boolean,
  animated: boolean
): string {
  const beastName = getBeastName(beastId);
  const filename = toImageFilename(beastName);
  const variant = shiny ? "shiny" : "regular";
  const category = animated ? "animated" : "static";
  const ext = animated ? "gif" : "png";

  return `/images/beasts/${category}/${variant}/${filename}.${ext}`;
}

/**
 * Generate both regular and small image URLs for a beast
 * (Currently returns the same URL as we don't have separate small images)
 *
 * @param beastId - Beast type ID (1-75)
 * @param shiny - Whether the beast is shiny
 * @param animated - Whether to use animated GIF
 * @returns Object with imageUrl and imageSmallUrl
 */
export function getBeastImageUrls(
  beastId: number,
  shiny: boolean,
  animated: boolean
): { imageUrl: string; imageSmallUrl: string } {
  const url = getBeastImageUrl(beastId, shiny, animated);
  return {
    imageUrl: url,
    imageSmallUrl: url, // Same URL for now - could add resized versions later
  };
}

/**
 * Get a static (non-animated) image URL for a beast
 * Useful for thumbnails or performance-sensitive contexts
 *
 * @param beastId - Beast type ID (1-75)
 * @param shiny - Whether the beast is shiny
 * @returns Static PNG image URL
 */
export function getBeastStaticImageUrl(beastId: number, shiny: boolean): string {
  return getBeastImageUrl(beastId, shiny, false);
}

/**
 * Check if an image URL is a local beast image
 */
export function isLocalBeastImage(url: string): boolean {
  return url.startsWith("/images/beasts/");
}
