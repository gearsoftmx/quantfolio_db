INSERT INTO forex.currency (code, name, symbol, country_code, country_iso_code, is_active, decimals) VALUES
('USD', 'US Dollar', '$', 'US', 'USD', true, 2),
('EUR', 'Euro', '€', 'EU', 'EUR', true, 2),
('MXN', 'Mexican Peso', '$', 'MX', 'MXN', true, 2),
('JPY', 'Japanese Yen', '¥', 'JP', 'JPY', true, 0),
('GBP', 'British Pound', '£', 'GB', 'GBP', true, 2),
('CAD', 'Canadian Dollar', '$', 'CA', 'CAD', true, 2),
('CHF', 'Swiss Franc', 'Fr', 'CH', 'CHF', true, 2),
('AUD', 'Australian Dollar', '$', 'AU', 'AUD', true, 2),
('CNY', 'Chinese Yuan', '¥', 'CN', 'CNY', true, 2),
('BRL', 'Brazilian Real', 'R$', 'BR', 'BRL', true, 2),
('KRW', 'South Korean Won', '₩', 'KR', 'KRW', true, 0),
('UDI', 'Unidad de Inversión', 'UDI', 'MX', 'MXN', true, 2);

ALTER TABLE forex.rate DROP CONSTRAINT rate_rate_type_check;

ALTER TABLE forex.rate ADD CONSTRAINT rate_rate_type_check 
CHECK (rate_type IN ('FIX', 'SPOT', 'CLOSE', 'INFLATION'));