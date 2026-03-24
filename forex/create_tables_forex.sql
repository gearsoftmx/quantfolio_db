CREATE SCHEMA IF NOT EXISTS forex;

CREATE TABLE IF NOT EXISTS forex.currency (
    code CHAR(3) PRIMARY KEY,
    country_iso_code CHAR(3),
    name VARCHAR(50),
    symbol VARCHAR(10),
    country_code VARCHAR(2),
    is_active BOOLEAN DEFAULT true,
    decimals SMALLINT,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS forex.rate (
    id BIGSERIAL PRIMARY KEY,
    from_currency CHAR(3) REFERENCES forex.currency(code),
    to_currency CHAR(3) REFERENCES forex.currency(code),
    provider_id VARCHAR(20),
    rate_type VARCHAR(10) CHECK (rate_type IN ('FIX', 'SPOT', 'CLOSE')),
    rate_date DATE,
    rate DECIMAL(18,8),
    is_inverse BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    CONSTRAINT unique_rate UNIQUE (from_currency, to_currency, provider_id, rate_date, rate_type)
);

GRANT USAGE ON SCHEMA forex TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA forex TO anon, authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA forex TO anon, authenticated;

CREATE INDEX idx_rate_from_to_type_date ON forex.rate(from_currency, to_currency, rate_type, rate_date);
CREATE INDEX idx_rate_type ON forex.rate(rate_type);
CREATE INDEX idx_rate_date ON forex.rate(rate_date);
CREATE INDEX idx_rate_provider ON forex.rate(provider_id);