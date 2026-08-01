import { BEAST_TYPE_NAMES, BeastType, prefixName, suffixName } from '@provable-games/beasts-sdk';

interface Props {
  name: string;
  tier: number;
  beastType: BeastType;
  art?: string;
  shiny: boolean;
  /** Sample affixes, so the artist can see how a named variant reads. */
  prefix: number;
  suffix: number;
  level: number;
  health: number;
}

/**
 * Approximation of the card the contract renders.
 *
 * This is NOT the on-chain SVG — that is built by `src/beast_svg.cairo` and
 * only exists once a species is registered. This preview mirrors its layout
 * and the values it derives so an artist can judge their art in context
 * before paying for a transaction. After registration the app shows the real
 * `token_uri` output instead.
 */
export function CardPreview({
  name,
  tier,
  beastType,
  art,
  shiny,
  prefix,
  suffix,
  level,
  health,
}: Props) {
  const power = level * (6 - tier);
  const displayName =
    prefix > 0 && suffix > 0
      ? `"${prefixName(prefix)} ${suffixName(suffix)}" ${name || 'Unnamed'}`
      : name || 'Unnamed';

  return (
    <div className={`card ${shiny ? 'card--shiny' : ''}`}>
      <div className="card__title" title={displayName}>
        {displayName}
      </div>

      <div className="card__art">
        {art ? (
          <img src={art} alt={`${name} artwork`} />
        ) : (
          <div className="card__art-empty">Upload art to preview</div>
        )}
      </div>

      <div className="card__stats">
        <Stat label="Tier" value={String(tier)} />
        <Stat label="Type" value={BEAST_TYPE_NAMES[beastType]} />
        <Stat label="Power" value={String(power)} />
      </div>

      <div className="card__stats">
        <Stat label="Level" value={String(level)} />
        <Stat label="Health" value={String(health)} />
        <Stat label="Rank" value="—" />
      </div>

      <p className="card__note">
        Preview only — the collection renders this card fully onchain.
        {prefix > 0 && ' Affixes shown are a sample: every mint draws its own.'}{' '}
        Ranks and kill stats appear once a Beast is minted.
      </p>
    </div>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div className="stat">
      <div className="stat__label">{label}</div>
      <div className="stat__value">{value}</div>
    </div>
  );
}
