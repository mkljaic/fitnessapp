-- =========================================================
-- FITNESS APP DATABASE SCHEMA
-- PostgreSQL / Supabase
-- =========================================================

-- =========================================================
-- 1. ENUM TIPOVI
-- =========================================================

-- Spol korisnika
CREATE TYPE sex_type AS ENUM ('male', 'female', 'other');

-- Razina aktivnosti korisnika
CREATE TYPE activity_level_type AS ENUM (
    'sedentary',
    'light',
    'moderate',
    'active',
    'very_active'
);

-- Cilj korisnika
CREATE TYPE goal_type AS ENUM (
    'lose_weight',
    'maintain_weight',
    'gain_muscle'
);

-- Izvor logiranja hrane
CREATE TYPE food_log_source_type AS ENUM (
    'manual',
    'image',
    'ai'
);

-- Vrsta obroka
CREATE TYPE meal_category_type AS ENUM (
    'breakfast',
    'lunch',
    'dinner',
    'snack',
    'other'
);

-- Generirao plan
CREATE TYPE generated_by_type AS ENUM (
    'system',
    'ai',
    'manual'
);

-- Status plana
CREATE TYPE plan_status_type AS ENUM (
    'draft',
    'active',
    'archived',
    'completed'
);

-- Subscription plan
CREATE TYPE subscription_plan_type AS ENUM (
    'monthly',
    'semiannual',
    'yearly'
);

-- Status pretplate
CREATE TYPE subscription_status_type AS ENUM (
    'trialing',
    'active',
    'expired',
    'cancelled',
    'past_due'
);

-- Provider pretplate
CREATE TYPE subscription_provider_type AS ENUM (
    'app_store',
    'google_play',
    'revenuecat',
    'stripe'
);

-- Tip AI zahtjeva
CREATE TYPE ai_request_type AS ENUM (
    'food_image_calorie_estimation',
    'meal_plan_generation',
    'workout_plan_generation',
    'progress_suggestion'
);

-- Mišićna skupina
CREATE TYPE muscle_group_type AS ENUM (
    'chest',
    'back',
    'legs',
    'shoulders',
    'biceps',
    'triceps',
    'core',
    'glutes',
    'full_body',
    'cardio',
    'other'
);

-- Težina vježbe / kategorija vježbe
CREATE TYPE exercise_category_type AS ENUM (
    'strength',
    'hypertrophy',
    'cardio',
    'mobility',
    'bodyweight',
    'rehab',
    'other'
);

-- =========================================================
-- 2. USERS / PROFILES
-- =========================================================

-- Napomena:
-- U Supabaseu auth.users već postoji.
-- Ova tablica referencira auth.users(id).

CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Poveznica na Supabase auth korisnika
    user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,

    first_name TEXT,
    last_name TEXT,

    sex sex_type,
    birth_date DATE,

    height_cm NUMERIC(5,2) CHECK (height_cm > 0),
    current_weight_kg NUMERIC(6,2) CHECK (current_weight_kg > 0),

    activity_level activity_level_type,
    goal goal_type,

    target_weight_kg NUMERIC(6,2) CHECK (target_weight_kg > 0),

    calculated_bmr NUMERIC(8,2),
    calculated_tdee NUMERIC(8,2),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_user_profiles_user_id ON public.user_profiles(user_id);

-- =========================================================
-- 3. POVIJEST METRIKA KORISNIKA
-- =========================================================

CREATE TABLE public.user_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    weight_kg NUMERIC(6,2) NOT NULL CHECK (weight_kg > 0),
    body_fat_percentage NUMERIC(5,2) CHECK (body_fat_percentage >= 0 AND body_fat_percentage <= 100),
    muscle_mass_kg NUMERIC(6,2) CHECK (muscle_mass_kg >= 0),

    calculated_bmr NUMERIC(8,2),
    calculated_tdee NUMERIC(8,2),

    activity_level activity_level_type,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    notes TEXT
);

CREATE INDEX idx_user_metrics_user_id ON public.user_metrics(user_id);
CREATE INDEX idx_user_metrics_recorded_at ON public.user_metrics(recorded_at DESC);
CREATE INDEX idx_user_metrics_user_recorded_at ON public.user_metrics(user_id, recorded_at DESC);

-- =========================================================
-- 4. FOOD DATABASE
-- =========================================================

CREATE TABLE public.foods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name TEXT NOT NULL,
    brand TEXT,

    serving_size_value NUMERIC(8,2) NOT NULL CHECK (serving_size_value > 0),
    serving_size_unit TEXT NOT NULL,

    calories NUMERIC(8,2) NOT NULL CHECK (calories >= 0),
    protein_g NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (protein_g >= 0),
    carbs_g NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (carbs_g >= 0),
    fat_g NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (fat_g >= 0),
    fiber_g NUMERIC(8,2) DEFAULT 0 CHECK (fiber_g >= 0),

    source TEXT,
    verified BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_foods_name ON public.foods(name);
CREATE INDEX idx_foods_brand ON public.foods(brand);

-- =========================================================
-- 5. USER CUSTOM MEALS
-- =========================================================

CREATE TABLE public.meals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    name TEXT NOT NULL,
    meal_category meal_category_type DEFAULT 'other',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_meals_user_id ON public.meals(user_id);

CREATE TABLE public.meal_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    meal_id UUID NOT NULL REFERENCES public.meals(id) ON DELETE CASCADE,
    food_id UUID NOT NULL REFERENCES public.foods(id) ON DELETE RESTRICT,

    quantity NUMERIC(8,2) NOT NULL CHECK (quantity > 0),
    unit TEXT NOT NULL,
    grams NUMERIC(8,2) CHECK (grams > 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_meal_items_meal_id ON public.meal_items(meal_id);
CREATE INDEX idx_meal_items_food_id ON public.meal_items(food_id);

-- =========================================================
-- 6. FOOD LOGGING
-- =========================================================

CREATE TABLE public.food_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    logged_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    meal_category meal_category_type DEFAULT 'other',

    total_calories NUMERIC(8,2) DEFAULT 0 CHECK (total_calories >= 0),

    source_type food_log_source_type NOT NULL DEFAULT 'manual',
    image_url TEXT,
    ai_confidence NUMERIC(5,2) CHECK (ai_confidence >= 0 AND ai_confidence <= 100),

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_food_logs_user_id ON public.food_logs(user_id);
CREATE INDEX idx_food_logs_logged_at ON public.food_logs(logged_at DESC);
CREATE INDEX idx_food_logs_user_logged_at ON public.food_logs(user_id, logged_at DESC);

CREATE TABLE public.food_log_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    food_log_id UUID NOT NULL REFERENCES public.food_logs(id) ON DELETE CASCADE,

    -- Može biti null ako je AI/custom unos
    food_id UUID REFERENCES public.foods(id) ON DELETE SET NULL,

    custom_food_name TEXT,

    quantity NUMERIC(8,2) NOT NULL CHECK (quantity > 0),
    grams NUMERIC(8,2) CHECK (grams > 0),

    calories NUMERIC(8,2) NOT NULL CHECK (calories >= 0),
    protein_g NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (protein_g >= 0),
    carbs_g NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (carbs_g >= 0),
    fat_g NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (fat_g >= 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Mora postojati ili food_id ili custom_food_name
    CONSTRAINT food_log_item_food_or_custom_check
    CHECK (
        food_id IS NOT NULL OR custom_food_name IS NOT NULL
    )
);

CREATE INDEX idx_food_log_items_food_log_id ON public.food_log_items(food_log_id);
CREATE INDEX idx_food_log_items_food_id ON public.food_log_items(food_id);

-- =========================================================
-- 7. EXERCISE LIBRARY
-- =========================================================

CREATE TABLE public.exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name TEXT NOT NULL,
    category exercise_category_type NOT NULL DEFAULT 'strength',
    muscle_group muscle_group_type NOT NULL DEFAULT 'other',

    equipment TEXT,
    description TEXT,
    image_url TEXT,
    video_url TEXT,

    difficulty TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_exercises_name ON public.exercises(name);
CREATE INDEX idx_exercises_category ON public.exercises(category);
CREATE INDEX idx_exercises_muscle_group ON public.exercises(muscle_group);

-- =========================================================
-- 8. WORKOUT ROUTINES
-- =========================================================

CREATE TABLE public.workout_routines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    name TEXT NOT NULL,
    goal goal_type,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_workout_routines_user_id ON public.workout_routines(user_id);

CREATE TABLE public.workout_routine_exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    routine_id UUID NOT NULL REFERENCES public.workout_routines(id) ON DELETE CASCADE,
    exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE RESTRICT,

    sort_order INTEGER NOT NULL DEFAULT 0 CHECK (sort_order >= 0),

    target_sets INTEGER CHECK (target_sets > 0),
    target_reps INTEGER CHECK (target_reps > 0),
    target_weight NUMERIC(8,2) CHECK (target_weight >= 0),
    rest_seconds INTEGER CHECK (rest_seconds >= 0),

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_workout_routine_exercises_routine_id ON public.workout_routine_exercises(routine_id);
CREATE INDEX idx_workout_routine_exercises_exercise_id ON public.workout_routine_exercises(exercise_id);

-- =========================================================
-- 9. WORKOUT SESSIONS
-- =========================================================

CREATE TABLE public.workout_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    routine_id UUID REFERENCES public.workout_routines(id) ON DELETE SET NULL,

    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,

    duration_seconds INTEGER CHECK (duration_seconds >= 0),
    session_volume NUMERIC(10,2) CHECK (session_volume >= 0),

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT workout_session_time_check
    CHECK (ended_at IS NULL OR ended_at >= started_at)
);

CREATE INDEX idx_workout_sessions_user_id ON public.workout_sessions(user_id);
CREATE INDEX idx_workout_sessions_routine_id ON public.workout_sessions(routine_id);
CREATE INDEX idx_workout_sessions_started_at ON public.workout_sessions(started_at DESC);
CREATE INDEX idx_workout_sessions_user_started_at ON public.workout_sessions(user_id, started_at DESC);

CREATE TABLE public.workout_session_exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workout_session_id UUID NOT NULL REFERENCES public.workout_sessions(id) ON DELETE CASCADE,
    exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE RESTRICT,

    sort_order INTEGER NOT NULL DEFAULT 0 CHECK (sort_order >= 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_workout_session_exercises_session_id ON public.workout_session_exercises(workout_session_id);
CREATE INDEX idx_workout_session_exercises_exercise_id ON public.workout_session_exercises(exercise_id);

CREATE TABLE public.workout_sets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_exercise_id UUID NOT NULL REFERENCES public.workout_session_exercises(id) ON DELETE CASCADE,

    set_number INTEGER NOT NULL CHECK (set_number > 0),
    reps INTEGER CHECK (reps >= 0),
    weight NUMERIC(8,2) CHECK (weight >= 0),

    duration_seconds INTEGER CHECK (duration_seconds >= 0),
    distance_m NUMERIC(10,2) CHECK (distance_m >= 0),

    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_workout_sets_session_exercise_id ON public.workout_sets(session_exercise_id);
CREATE INDEX idx_workout_sets_completed_at ON public.workout_sets(completed_at DESC);

-- =========================================================
-- 10. MEAL PLANS
-- =========================================================

CREATE TABLE public.meal_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    generated_by generated_by_type NOT NULL DEFAULT 'manual',
    goal goal_type,

    start_date DATE NOT NULL,
    end_date DATE,

    status plan_status_type NOT NULL DEFAULT 'draft',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT meal_plan_date_check
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE INDEX idx_meal_plans_user_id ON public.meal_plans(user_id);
CREATE INDEX idx_meal_plans_status ON public.meal_plans(status);

CREATE TABLE public.meal_plan_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    meal_plan_id UUID NOT NULL REFERENCES public.meal_plans(id) ON DELETE CASCADE,

    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),

    meal_name TEXT NOT NULL,
    description TEXT,
    target_calories NUMERIC(8,2) CHECK (target_calories >= 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_meal_plan_items_meal_plan_id ON public.meal_plan_items(meal_plan_id);

-- =========================================================
-- 11. WORKOUT PLANS
-- =========================================================

CREATE TABLE public.workout_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    generated_by generated_by_type NOT NULL DEFAULT 'manual',
    goal goal_type,

    start_date DATE NOT NULL,
    end_date DATE,

    status plan_status_type NOT NULL DEFAULT 'draft',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT workout_plan_date_check
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE INDEX idx_workout_plans_user_id ON public.workout_plans(user_id);
CREATE INDEX idx_workout_plans_status ON public.workout_plans(status);

CREATE TABLE public.workout_plan_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workout_plan_id UUID NOT NULL REFERENCES public.workout_plans(id) ON DELETE CASCADE,

    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),

    routine_id UUID REFERENCES public.workout_routines(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_workout_plan_items_workout_plan_id ON public.workout_plan_items(workout_plan_id);

-- =========================================================
-- 12. STREAKS
-- =========================================================

CREATE TABLE public.user_streaks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,

    current_food_streak_days INTEGER NOT NULL DEFAULT 0 CHECK (current_food_streak_days >= 0),
    longest_food_streak_days INTEGER NOT NULL DEFAULT 0 CHECK (longest_food_streak_days >= 0),

    current_workout_streak_weeks INTEGER NOT NULL DEFAULT 0 CHECK (current_workout_streak_weeks >= 0),
    longest_workout_streak_weeks INTEGER NOT NULL DEFAULT 0 CHECK (longest_workout_streak_weeks >= 0),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_user_streaks_user_id ON public.user_streaks(user_id);

-- =========================================================
-- 13. SUBSCRIPTIONS
-- =========================================================

CREATE TABLE public.subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    provider subscription_provider_type NOT NULL DEFAULT 'revenuecat',
    plan_type subscription_plan_type,

    trial_start_at TIMESTAMPTZ,
    trial_end_at TIMESTAMPTZ,

    subscription_start_at TIMESTAMPTZ,
    subscription_end_at TIMESTAMPTZ,

    status subscription_status_type NOT NULL DEFAULT 'trialing',

    external_transaction_id TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT subscription_trial_check
    CHECK (trial_end_at IS NULL OR trial_start_at IS NULL OR trial_end_at >= trial_start_at),

    CONSTRAINT subscription_period_check
    CHECK (subscription_end_at IS NULL OR subscription_start_at IS NULL OR subscription_end_at >= subscription_start_at)
);

CREATE INDEX idx_subscriptions_user_id ON public.subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON public.subscriptions(status);
CREATE INDEX idx_subscriptions_user_status ON public.subscriptions(user_id, status);

-- =========================================================
-- 14. AI REQUEST LOGGING
-- =========================================================

CREATE TABLE public.ai_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    request_type ai_request_type NOT NULL,
    input_payload JSONB,
    output_payload JSONB,

    confidence NUMERIC(5,2) CHECK (confidence >= 0 AND confidence <= 100),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ai_requests_user_id ON public.ai_requests(user_id);
CREATE INDEX idx_ai_requests_request_type ON public.ai_requests(request_type);
CREATE INDEX idx_ai_requests_created_at ON public.ai_requests(created_at DESC);

-- =========================================================
-- 15. UPDATED_AT TRIGGER FUNKCIJA
-- =========================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =========================================================
-- 16. TRIGGERI ZA updated_at
-- =========================================================

CREATE TRIGGER trg_user_profiles_updated_at
BEFORE UPDATE ON public.user_profiles
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_foods_updated_at
BEFORE UPDATE ON public.foods
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_meals_updated_at
BEFORE UPDATE ON public.meals
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_food_logs_updated_at
BEFORE UPDATE ON public.food_logs
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_exercises_updated_at
BEFORE UPDATE ON public.exercises
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_workout_routines_updated_at
BEFORE UPDATE ON public.workout_routines
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_subscriptions_updated_at
BEFORE UPDATE ON public.subscriptions
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_user_streaks_updated_at
BEFORE UPDATE ON public.user_streaks
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- =========================================================
-- 17. KORISNE VIEW DEFINICIJE
-- =========================================================

-- Dnevni zbroj kalorija po korisniku
CREATE OR REPLACE VIEW public.daily_calorie_summary AS
SELECT
    fl.user_id,
    DATE(fl.logged_at) AS log_date,
    COALESCE(SUM(fli.calories), 0) AS total_calories,
    COALESCE(SUM(fli.protein_g), 0) AS total_protein_g,
    COALESCE(SUM(fli.carbs_g), 0) AS total_carbs_g,
    COALESCE(SUM(fli.fat_g), 0) AS total_fat_g
FROM public.food_logs fl
LEFT JOIN public.food_log_items fli ON fli.food_log_id = fl.id
GROUP BY fl.user_id, DATE(fl.logged_at);

-- Sažetak treninga
CREATE OR REPLACE VIEW public.workout_session_summary AS
SELECT
    ws.id AS workout_session_id,
    ws.user_id,
    ws.started_at,
    ws.ended_at,
    ws.duration_seconds,
    COUNT(DISTINCT wse.id) AS exercise_count,
    COUNT(wset.id) AS total_sets,
    COALESCE(SUM(COALESCE(wset.weight, 0) * COALESCE(wset.reps, 0)), 0) AS total_volume
FROM public.workout_sessions ws
LEFT JOIN public.workout_session_exercises wse ON wse.workout_session_id = ws.id
LEFT JOIN public.workout_sets wset ON wset.session_exercise_id = wse.id
GROUP BY ws.id, ws.user_id, ws.started_at, ws.ended_at, ws.duration_seconds;