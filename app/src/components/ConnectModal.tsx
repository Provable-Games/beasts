import { useConnect } from '@starknet-react/core';
import type { Connector } from '@starknet-react/core';
import { useState } from 'react';

interface Props {
  onClose: () => void;
}

/**
 * Wallet picker.
 *
 * Connectors arrive from `WalletProvider`: Cartridge Controller first (it
 * needs no extension, which is the likely case for a first-time artist), then
 * any injected wallet. Recommended-but-not-installed wallets are still listed
 * so the choice is visible rather than hidden — clicking one sends the artist
 * to its download page, which is `InjectedConnector`'s own behaviour.
 *
 * Connection failures are shown here. Swallowing them is what makes a Connect
 * button look broken.
 */
export function ConnectModal({ onClose }: Props) {
  const { connect, connectors } = useConnect();
  const [pending, setPending] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function pick(connector: Connector) {
    setPending(connector.id);
    setError(null);
    try {
      await connect({ connector });
      onClose();
    } catch (e) {
      setError(describe(e));
    } finally {
      setPending(null);
    }
  }

  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal" onClick={(e) => e.stopPropagation()}>
        <header className="modal__header">
          <h3>Connect a wallet</h3>
          <button className="modal__close" onClick={onClose} aria-label="Close">
            ×
          </button>
        </header>

        <p className="muted">
          You need Sepolia STRK to register a Beast. Browsing and previewing
          work without a wallet.
        </p>

        <ul className="wallets">
          {connectors.map((connector) => {
            // Controller runs in a hosted iframe, so it is always available;
            // injected wallets are only there if their extension is.
            const installed = connector.available();
            return (
              <li key={connector.id}>
                <button
                  className="wallet"
                  disabled={pending !== null || !installed}
                  onClick={() => void pick(connector)}
                >
                  <WalletIcon connector={connector} />
                  <span className="wallet__name">{connector.name}</span>
                  <span className="wallet__state">
                    {pending === connector.id
                      ? 'Connecting…'
                      : installed
                        ? ''
                        : 'Not detected'}
                  </span>
                </button>
              </li>
            );
          })}
        </ul>

        {connectors.some((c) => !c.available()) && (
          <p className="muted modal__hint">
            Wallets marked “Not detected” need their browser extension
            installed. Install it, then reload this page.
          </p>
        )}

        {error && <p className="field__error">{error}</p>}
      </div>
    </div>
  );
}

function WalletIcon({ connector }: { connector: Connector }) {
  const icon = connector.icon;
  const src = typeof icon === 'string' ? icon : (icon?.dark ?? icon?.light);
  if (!src) return <span className="wallet__icon wallet__icon--blank" />;
  return <img className="wallet__icon" src={src} alt="" />;
}

function describe(error: unknown): string {
  const message = error instanceof Error ? error.message : String(error);
  if (/reject|denied|cancel/i.test(message)) return 'Connection cancelled.';
  if (/not found|no wallet|unavailable/i.test(message)) {
    return 'That wallet is not installed in this browser.';
  }
  return message;
}
