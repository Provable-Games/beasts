import { useState } from 'react';
import {
  BEAST_TYPE_NAMES,
  type Beast,
  beastPower,
  fullBeastName,
  isGenesis,
} from '@provable-games/beasts-sdk';

interface Props {
  beast: Beast;
  speciesName: string;
  /** `undefined` while loading, `null` when the provider could not be read. */
  art: string | null | undefined;
  rank?: number;
  onClick?: () => void;
  subtitle?: string;
}

/**
 * One Beast, as a tile. Everything shown except the species name and the art
 * comes straight out of the token ID.
 */
export function BeastTile({ beast, speciesName, art, rank, onClick, subtitle }: Props) {
  const genesis = isGenesis(beast);
  // The contract validates art structurally — media type, base64, magic bytes
  // — but cannot prove the payload decodes. A species whose art is malformed
  // must degrade to a note, not a browser's broken-image icon.
  const [decodeFailed, setDecodeFailed] = useState(false);
  const body = (
    <>
      <div className={`tile__art ${beast.shiny ? 'tile__art--shiny' : ''}`}>
        {art === undefined ? (
          <span className="tile__art-note">…</span>
        ) : art === null || decodeFailed ? (
          <span className="tile__art-note">
            {decodeFailed ? 'Art will not render' : 'Art unavailable'}
          </span>
        ) : (
          <img src={art} alt={speciesName} onError={() => setDecodeFailed(true)} />
        )}
        {genesis && <span className="tile__badge">Genesis</span>}
        {beast.animated === 1 && <span className="tile__badge tile__badge--corner">GIF</span>}
      </div>

      <div className="tile__name" title={fullBeastName(beast, speciesName)}>
        {fullBeastName(beast, speciesName)}
      </div>

      <div className="tile__meta">
        {subtitle ??
          `${BEAST_TYPE_NAMES[beast.beastType]} · T${beast.tier} · Power ${beastPower(beast)}`}
      </div>

      <div className="tile__stats">
        <span>Lv {beast.level}</span>
        <span>HP {beast.health}</span>
        {/* Genesis Beasts sit outside the ranked list, so rank 0 is "unranked",
            not "first". */}
        <span>{genesis ? 'Unranked' : rank ? `Rank ${rank}` : ''}</span>
      </div>
    </>
  );

  return onClick ? (
    <button className="tile tile--clickable" onClick={onClick}>
      {body}
    </button>
  ) : (
    <div className="tile">{body}</div>
  );
}
