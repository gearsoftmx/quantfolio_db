INSERT INTO asset.asset_classes (code, label) VALUES
    ('EQUITY',    'Acciones'),
    ('ETF',       'ETF'),
    ('BOND',      'Bono'),
    ('CRYPTO',    'Criptomoneda'),
    ('FUND',      'Fondo de Inversión'),
    ('COMMODITY', 'Materia Prima');

INSERT INTO asset.exchanges (code, name, country, timezone) VALUES
    ('NASDAQ', 'Nasdaq Stock Market',         'US', 'America/New_York'),
    ('NYSE',   'New York Stock Exchange',     'US', 'America/New_York'),
    ('BMV',    'Bolsa Mexicana de Valores',   'MX', 'America/Mexico_City'),
    ('LSE',    'London Stock Exchange',       'GB', 'Europe/London'),
    ('BATS',   'BATS Global Markets',         'US', 'America/New_York');

INSERT INTO asset.providers (code, label) VALUES
    ('yahoo_finance',  'Yahoo Finance'),
    ('openfigi',       'OpenFIGI'),
    ('databursatil',   'DataBursatil'),
    ('banxico',        'Banco de México'),
    ('fred',           'Federal Reserve (FRED)'),
    ('ecb',            'European Central Bank'),
    ('coingecko',      'CoinGecko'),
    ('coinmarketcap',  'CoinMarketCap'),
    ('alpha_vantage',  'Alpha Vantage'),
    ('polygon',        'Polygon.io'),
    ('quandl',         'Quandl / Nasdaq Data Link'),
    ('morningstar',    'Morningstar'),
    ('iex_cloud',      'IEX Cloud'),
    ('twelve_data',    'Twelve Data'),
    ('world_bank',     'World Bank');