
CREATE TABLE asset.providers (
    code  VARCHAR(20) PRIMARY KEY,
    label VARCHAR(100) NOT NULL
);

CREATE TABLE asset.asset_classes (
    code        VARCHAR(20)  PRIMARY KEY,   -- 'EQUITY', 'ETF', 'BOND', 'CRYPTO', 'FUND', 'COMMODITY'
    label       VARCHAR(50)  NOT NULL
);

CREATE TABLE asset.sectors (
    code        VARCHAR(50)  PRIMARY KEY,   -- 'TECHNOLOGY', 'HEALTHCARE', etc.
    label       VARCHAR(100) NOT NULL
);

CREATE TABLE asset.exchanges (
    code        VARCHAR(20)  PRIMARY KEY,   -- 'NASDAQ', 'NYSE', 'BMV', 'LSE'
    name        VARCHAR(100) NOT NULL,
    country     VARCHAR(10)  NOT NULL,      -- ISO 3166-1 alpha-2: 'US', 'MX', 'GB'
    timezone    VARCHAR(50)  NOT NULL       -- 'America/New_York'
);

-- ──────────────────────────────────────────────
-- Security (el activo como entidad corporativa)
-- ──────────────────────────────────────────────
CREATE TABLE asset.assets (
    asset_id        UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(200) NOT NULL,
    asset_class     VARCHAR(20)  NOT NULL REFERENCES asset.asset_classes(code),
    sector          VARCHAR(50)  REFERENCES asset.sectors(code),
    isin            VARCHAR(12)  UNIQUE,             -- ISO 6166, global y único
    base_currency   CHAR(3)      NOT NULL,           -- ISO 4217: 'USD', 'MXN'
    country         VARCHAR(10),                     -- País de emisión
    status          VARCHAR(20)  NOT NULL DEFAULT 'active'
                                 CHECK (status IN ('active', 'suspended', 'delisted')),
    listed_at       DATE,
    delisted_at     DATE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- ──────────────────────────────────────────────
-- Listing (cómo cotiza el security en un mercado)
-- ──────────────────────────────────────────────
CREATE TABLE asset.asset_listings (
    listing_id      UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    asset_id        UUID         NOT NULL REFERENCES asset.assets(asset_id),
    exchange        VARCHAR(20)  NOT NULL REFERENCES asset.exchanges(code),
    ticker          VARCHAR(20)  NOT NULL,
    currency        CHAR(3)      NOT NULL,           -- Moneda de cotización en este exchange
    is_primary      BOOLEAN      NOT NULL DEFAULT false,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT uq_exchange_ticker UNIQUE (exchange, ticker)  -- ticker único por bolsa
);

-- Solo un listing puede ser primario por asset
CREATE UNIQUE INDEX uq_primary_listing
    ON asset.asset_listings (asset_id)
    WHERE is_primary = true;

-- ──────────────────────────────────────────────
-- Índices de búsqueda
-- ──────────────────────────────────────────────
CREATE INDEX idx_assets_status        ON asset.assets (status);
CREATE INDEX idx_assets_asset_class   ON asset.assets (asset_class);
CREATE INDEX idx_assets_sector        ON asset.assets (sector);
CREATE INDEX idx_assets_base_currency ON asset.assets (base_currency);
CREATE INDEX idx_assets_name_search   ON asset.assets USING gin (to_tsvector('english', name));

CREATE INDEX idx_listings_asset_id    ON asset.asset_listings (asset_id);
CREATE INDEX idx_listings_ticker      ON asset.asset_listings (ticker);      -- búsqueda por ticker solo
CREATE INDEX idx_listings_exchange    ON asset.asset_listings (exchange);
CREATE INDEX idx_listings_currency    ON asset.asset_listings (currency);

ALTER TABLE asset.asset_listings
    ADD COLUMN provider VARCHAR(20)
        REFERENCES asset.providers(code);

-- Da permisos al usuario postgres en el schema forex
GRANT USAGE ON SCHEMA asset TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA asset TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA asset TO postgres;

-- Para tablas futuras también
ALTER DEFAULT PRIVILEGES IN SCHEMA asset 
  GRANT ALL ON TABLES TO postgres;

ALTER DEFAULT PRIVILEGES IN SCHEMA asset 
  GRANT ALL ON SEQUENCES TO postgres;

-- Agregar columnas faltantes en assets
ALTER TABLE asset.assets
    ADD COLUMN figi            VARCHAR(20)  UNIQUE,
    ADD COLUMN identifier      VARCHAR(50)  UNIQUE NOT NULL,
    ADD COLUMN identifier_type VARCHAR(10)  NOT NULL CHECK (identifier_type IN ('isin', 'figi'));

-- Agregar columnas faltantes en asset_listings
ALTER TABLE asset.asset_listings
    ADD COLUMN market   VARCHAR(50),
    ADD COLUMN indices  TEXT;  -- JSON serializado: '["sp500","sic_acciones"]'