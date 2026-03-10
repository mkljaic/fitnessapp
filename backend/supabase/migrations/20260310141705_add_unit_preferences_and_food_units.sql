-- =========================================================
-- UNIT PREFERENCES + FOOD UNITS
-- =========================================================

-- ---------------------------------------------------------
-- 1. ENUMOVI ZA KORISNIČKE PREFERENCE
-- ---------------------------------------------------------

CREATE TYPE unit_system_type AS ENUM ('metric', 'imperial');

CREATE TYPE weight_unit_type AS ENUM ('kg', 'lb');

CREATE TYPE height_unit_type AS ENUM ('cm', 'ft_in');

CREATE TYPE food_mass_unit_preference_type AS ENUM ('g', 'oz');

CREATE TYPE food_volume_unit_preference_type AS ENUM ('ml', 'fl_oz');

-- ---------------------------------------------------------
-- 2. ENUM ZA STVARNE JEDINICE U UNOSU HRANE
-- ---------------------------------------------------------

CREATE TYPE food_unit_type AS ENUM (
    'g',
    'kg',
    'oz',
    'lb',
    'ml',
    'l',
    'fl_oz',
    'piece',
    'serving',
    'cup',
    'tbsp',
    'tsp'
);

-- ---------------------------------------------------------
-- 3. USER PROFILES - PREFERENCE JEDINICA
-- ---------------------------------------------------------

ALTER TABLE public.user_profiles
ADD COLUMN unit_system unit_system_type NOT NULL DEFAULT 'metric',
ADD COLUMN preferred_weight_unit weight_unit_type NOT NULL DEFAULT 'kg',
ADD COLUMN preferred_height_unit height_unit_type NOT NULL DEFAULT 'cm',
ADD COLUMN preferred_food_mass_unit food_mass_unit_preference_type NOT NULL DEFAULT 'g',
ADD COLUMN preferred_food_volume_unit food_volume_unit_preference_type NOT NULL DEFAULT 'ml';

-- ---------------------------------------------------------
-- 4. FOODS - KONTROLIRANE JEDINICE
-- ---------------------------------------------------------

ALTER TABLE public.foods
ALTER COLUMN serving_size_unit TYPE food_unit_type
USING serving_size_unit::food_unit_type;

-- ---------------------------------------------------------
-- 5. MEAL ITEMS - PODRŠKA ZA MASU I VOLUMEN
-- ---------------------------------------------------------

ALTER TABLE public.meal_items
ADD COLUMN milliliters NUMERIC(8,2) CHECK (milliliters > 0);

ALTER TABLE public.meal_items
ALTER COLUMN unit TYPE food_unit_type
USING unit::food_unit_type;

-- ---------------------------------------------------------
-- 6. FOOD LOG ITEMS - PODRŠKA ZA MASU I VOLUMEN
-- ---------------------------------------------------------

ALTER TABLE public.food_log_items
ADD COLUMN unit food_unit_type,
ADD COLUMN milliliters NUMERIC(8,2) CHECK (milliliters > 0);

-- Ako već postoji unit kao TEXT u food_log_items, koristi ovo umjesto gornjeg:
-- ALTER TABLE public.food_log_items
-- ALTER COLUMN unit TYPE food_unit_type
-- USING unit::food_unit_type;

-- ---------------------------------------------------------
-- 7. DODATNE VALIDACIJE
-- ---------------------------------------------------------

ALTER TABLE public.meal_items
ADD CONSTRAINT meal_items_measurement_check
CHECK (
    grams IS NOT NULL
    OR milliliters IS NOT NULL
    OR unit IN ('piece', 'serving', 'cup', 'tbsp', 'tsp')
);

ALTER TABLE public.food_log_items
ADD CONSTRAINT food_log_items_measurement_check
CHECK (
    grams IS NOT NULL
    OR milliliters IS NOT NULL
    OR unit IN ('piece', 'serving', 'cup', 'tbsp', 'tsp')
);