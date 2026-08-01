import { describe, it, expect } from "vitest";
import {
  parseTokenUri,
  decodeSvgDataUri,
  parseMetadataAttributes,
  buildTokenUriFromJsonString,
  buildTokenUri,
  encodeSvgDataUri,
  validateMetadataJson,
  parseTokenUriDetailed,
  parseTokenUriSafe,
} from "../metadata";

describe("metadata helpers", () => {
  it("parses token URI with literal newlines in description", () => {
    const rawJson = `{"name":"Beast","description":"Line1
Line2","image":"data:image/svg+xml;base64,PHN2Zy8+","attributes":[{"trait_type":"Token ID","value":"1"},{"trait_type":"Beast ID","value":"3"},{"trait_type":"Beast","value":"Jiangshi"},{"trait_type":"Type","value":"Magic"},{"trait_type":"Tier","value":"1"},{"trait_type":"Level","value":"42"},{"trait_type":"Health","value":"1337"},{"trait_type":"Power","value":"210"},{"trait_type":"Rank","value":"5"},{"trait_type":"Shiny","value":"0"},{"trait_type":"Animated","value":"1"},{"trait_type":"Genesis","value":"1"}]}`;
    const tokenUri = `data:application/json;base64,${Buffer.from(rawJson, "utf8").toString("base64")}`;

    const metadata = parseTokenUri(tokenUri);
    expect(metadata.name).toBe("Beast");
    expect(metadata.description.includes("Line1")).toBe(true);
    expect(metadata.description.includes("Line2")).toBe(true);
  });

  it("decodes svg data URIs", () => {
    const svg = "<svg></svg>";
    const dataUri = `data:image/svg+xml;base64,${Buffer.from(svg).toString("base64")}`;
    expect(decodeSvgDataUri(dataUri)).toBe(svg);
  });

  it("encodes svg data URIs", () => {
    const svg = "<svg></svg>";
    const dataUri = encodeSvgDataUri(svg);
    expect(decodeSvgDataUri(dataUri)).toBe(svg);
  });

  it("parses typed metadata attributes", () => {
    const rawJson = `{"name":"Beast","description":"Desc","image":"data:image/svg+xml;base64,PHN2Zy8+","attributes":[{"trait_type":"Token ID","value":"1"},{"trait_type":"Beast ID","value":"3"},{"trait_type":"Beast","value":"Jiangshi"},{"trait_type":"Type","value":"Magic"},{"trait_type":"Tier","value":"1"},{"trait_type":"Level","value":"42"},{"trait_type":"Health","value":"1337"},{"trait_type":"Power","value":"210"},{"trait_type":"Rank","value":"5"},{"trait_type":"Shiny","value":"0"},{"trait_type":"Animated","value":"1"},{"trait_type":"Genesis","value":"1"}]}`;
    const tokenUri = `data:application/json;base64,${Buffer.from(rawJson, "utf8").toString("base64")}`;
    const metadata = parseTokenUri(tokenUri);
    const parsed = parseMetadataAttributes(metadata);

    expect(parsed.tokenId).toBe(1);
    expect(parsed.beastId).toBe(3);
    expect(parsed.beast).toBe("Jiangshi");
    expect(parsed.type).toBe("Magic");
    expect(parsed.tier).toBe(1);
    expect(parsed.level).toBe(42);
    expect(parsed.health).toBe(1337);
    expect(parsed.power).toBe(210);
    expect(parsed.rank).toBe(5);
    expect(parsed.shiny).toBe(0);
    expect(parsed.animated).toBe(1);
    expect(parsed.genesis).toBe(1);
  });

  it("builds token URIs from raw JSON strings", () => {
    const rawJson = `{"name":"Beast","description":"Line1
Line2","image":"data:image/svg+xml;base64,PHN2Zy8+","attributes":[]}`;
    const tokenUri = buildTokenUriFromJsonString(rawJson);
    const parsed = parseTokenUri(tokenUri);
    expect(parsed.description.includes("Line1")).toBe(true);
    expect(parsed.description.includes("Line2")).toBe(true);
  });

  it("builds token URIs from JSON objects", () => {
    const metadata = {
      name: "Beast",
      description: "Desc",
      image: "data:image/svg+xml;base64,PHN2Zy8+",
      attributes: [],
    };
    const tokenUri = buildTokenUri(metadata);
    const parsed = parseTokenUri(tokenUri);
    expect(parsed.name).toBe("Beast");
  });

  it("validates metadata JSON shape", () => {
    const ok = validateMetadataJson({
      name: "Beast",
      description: "Desc",
      image: "data:image/svg+xml;base64,PHN2Zy8+",
      attributes: [{ trait_type: "Token ID", value: "1" }],
    });
    expect(ok.ok).toBe(true);

    const bad = validateMetadataJson({
      name: "Beast",
      description: "Desc",
      image: "data:image/svg+xml;base64,PHN2Zy8+",
      attributes: [{ trait_type: "Token ID", value: 1 }],
    });
    expect(bad.ok).toBe(false);
  });

  it("parses token URIs into detailed views", () => {
    const rawJson = `{"name":"Beast","description":"Desc","image":"data:image/svg+xml;base64,PHN2Zy8+","attributes":[{"trait_type":"Token ID","value":"1"}]}`;
    const tokenUri = buildTokenUriFromJsonString(rawJson);
    const detailed = parseTokenUriDetailed(tokenUri, { decodeSvg: true });
    expect(detailed.attributes.tokenId).toBe(1);
    expect(detailed.imageSvg).toBe("<svg/>");
  });

  it("safe-parses invalid token URIs", () => {
    const tokenUri = "data:application/json;base64,invalid";
    const result = parseTokenUriSafe(tokenUri, { validate: true });
    expect(result.ok).toBe(false);
    expect(result.error).toBeDefined();
  });
});
