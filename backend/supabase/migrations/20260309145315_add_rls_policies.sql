-- =========================================================
-- RLS POLICIES
-- =========================================================

-- ---------------------------------------------------------
-- 1. Omogući RLS na svim app tablicama
-- ---------------------------------------------------------

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_metrics ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.foods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_items ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.food_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_log_items ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.workout_routines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_routine_exercises ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.workout_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_session_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_sets ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.meal_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_plan_items ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.workout_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_plan_items ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.user_streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_requests ENABLE ROW LEVEL SECURITY;

-- ---------------------------------------------------------
-- 2. USER-OWNED TABLICE: korisnik vidi/mijenja samo svoje
-- ---------------------------------------------------------

-- user_profiles
CREATE POLICY "user_profiles_select_own"
ON public.user_profiles
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "user_profiles_insert_own"
ON public.user_profiles
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "user_profiles_update_own"
ON public.user_profiles
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "user_profiles_delete_own"
ON public.user_profiles
FOR DELETE
USING (user_id = (select auth.uid()));

-- user_metrics
CREATE POLICY "user_metrics_select_own"
ON public.user_metrics
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "user_metrics_insert_own"
ON public.user_metrics
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "user_metrics_update_own"
ON public.user_metrics
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "user_metrics_delete_own"
ON public.user_metrics
FOR DELETE
USING (user_id = (select auth.uid()));

-- meals
CREATE POLICY "meals_select_own"
ON public.meals
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "meals_insert_own"
ON public.meals
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "meals_update_own"
ON public.meals
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "meals_delete_own"
ON public.meals
FOR DELETE
USING (user_id = (select auth.uid()));

-- food_logs
CREATE POLICY "food_logs_select_own"
ON public.food_logs
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "food_logs_insert_own"
ON public.food_logs
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "food_logs_update_own"
ON public.food_logs
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "food_logs_delete_own"
ON public.food_logs
FOR DELETE
USING (user_id = (select auth.uid()));

-- workout_routines
CREATE POLICY "workout_routines_select_own"
ON public.workout_routines
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "workout_routines_insert_own"
ON public.workout_routines
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "workout_routines_update_own"
ON public.workout_routines
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "workout_routines_delete_own"
ON public.workout_routines
FOR DELETE
USING (user_id = (select auth.uid()));

-- workout_sessions
CREATE POLICY "workout_sessions_select_own"
ON public.workout_sessions
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "workout_sessions_insert_own"
ON public.workout_sessions
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "workout_sessions_update_own"
ON public.workout_sessions
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "workout_sessions_delete_own"
ON public.workout_sessions
FOR DELETE
USING (user_id = (select auth.uid()));

-- meal_plans
CREATE POLICY "meal_plans_select_own"
ON public.meal_plans
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "meal_plans_insert_own"
ON public.meal_plans
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "meal_plans_update_own"
ON public.meal_plans
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "meal_plans_delete_own"
ON public.meal_plans
FOR DELETE
USING (user_id = (select auth.uid()));

-- workout_plans
CREATE POLICY "workout_plans_select_own"
ON public.workout_plans
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "workout_plans_insert_own"
ON public.workout_plans
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "workout_plans_update_own"
ON public.workout_plans
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "workout_plans_delete_own"
ON public.workout_plans
FOR DELETE
USING (user_id = (select auth.uid()));

-- user_streaks
CREATE POLICY "user_streaks_select_own"
ON public.user_streaks
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "user_streaks_insert_own"
ON public.user_streaks
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "user_streaks_update_own"
ON public.user_streaks
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "user_streaks_delete_own"
ON public.user_streaks
FOR DELETE
USING (user_id = (select auth.uid()));

-- subscriptions
CREATE POLICY "subscriptions_select_own"
ON public.subscriptions
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "subscriptions_insert_own"
ON public.subscriptions
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "subscriptions_update_own"
ON public.subscriptions
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "subscriptions_delete_own"
ON public.subscriptions
FOR DELETE
USING (user_id = (select auth.uid()));

-- ai_requests
CREATE POLICY "ai_requests_select_own"
ON public.ai_requests
FOR SELECT
USING (user_id = (select auth.uid()));

CREATE POLICY "ai_requests_insert_own"
ON public.ai_requests
FOR INSERT
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "ai_requests_update_own"
ON public.ai_requests
FOR UPDATE
USING (user_id = (select auth.uid()))
WITH CHECK (user_id = (select auth.uid()));

CREATE POLICY "ai_requests_delete_own"
ON public.ai_requests
FOR DELETE
USING (user_id = (select auth.uid()));

-- ---------------------------------------------------------
-- 3. CHILD TABLICE: pristup samo ako je parent korisnikov
-- ---------------------------------------------------------

-- meal_items -> meals
CREATE POLICY "meal_items_select_own_parent"
ON public.meal_items
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.meals m
    WHERE m.id = meal_items.meal_id
      AND m.user_id = (select auth.uid())
  )
);

CREATE POLICY "meal_items_insert_own_parent"
ON public.meal_items
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.meals m
    WHERE m.id = meal_items.meal_id
      AND m.user_id = (select auth.uid())
  )
);

CREATE POLICY "meal_items_update_own_parent"
ON public.meal_items
FOR UPDATE
USING (
  EXISTS (
    SELECT 1
    FROM public.meals m
    WHERE m.id = meal_items.meal_id
      AND m.user_id = (select auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.meals m
    WHERE m.id = meal_items.meal_id
      AND m.user_id = (select auth.uid())
  )
);

CREATE POLICY "meal_items_delete_own_parent"
ON public.meal_items
FOR DELETE
USING (
  EXISTS (
    SELECT 1
    FROM public.meals m
    WHERE m.id = meal_items.meal_id
      AND m.user_id = (select auth.uid())
  )
);

-- food_log_items -> food_logs
CREATE POLICY "food_log_items_select_own_parent"
ON public.food_log_items
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.food_logs fl
    WHERE fl.id = food_log_items.food_log_id
      AND fl.user_id = (select auth.uid())
  )
);

CREATE POLICY "food_log_items_insert_own_parent"
ON public.food_log_items
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.food_logs fl
    WHERE fl.id = food_log_items.food_log_id
      AND fl.user_id = (select auth.uid())
  )
);

CREATE POLICY "food_log_items_update_own_parent"
ON public.food_log_items
FOR UPDATE
USING (
  EXISTS (
    SELECT 1
    FROM public.food_logs fl
    WHERE fl.id = food_log_items.food_log_id
      AND fl.user_id = (select auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.food_logs fl
    WHERE fl.id = food_log_items.food_log_id
      AND fl.user_id = (select auth.uid())
  )
);

CREATE POLICY "food_log_items_delete_own_parent"
ON public.food_log_items
FOR DELETE
USING (
  EXISTS (
    SELECT 1
    FROM public.food_logs fl
    WHERE fl.id = food_log_items.food_log_id
      AND fl.user_id = (select auth.uid())
  )
);

-- workout_routine_exercises -> workout_routines
CREATE POLICY "workout_routine_exercises_select_own_parent"
ON public.workout_routine_exercises
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_routines wr
    WHERE wr.id = workout_routine_exercises.routine_id
      AND wr.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_routine_exercises_insert_own_parent"
ON public.workout_routine_exercises
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.workout_routines wr
    WHERE wr.id = workout_routine_exercises.routine_id
      AND wr.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_routine_exercises_update_own_parent"
ON public.workout_routine_exercises
FOR UPDATE
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_routines wr
    WHERE wr.id = workout_routine_exercises.routine_id
      AND wr.user_id = (select auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.workout_routines wr
    WHERE wr.id = workout_routine_exercises.routine_id
      AND wr.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_routine_exercises_delete_own_parent"
ON public.workout_routine_exercises
FOR DELETE
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_routines wr
    WHERE wr.id = workout_routine_exercises.routine_id
      AND wr.user_id = (select auth.uid())
  )
);

-- workout_session_exercises -> workout_sessions
CREATE POLICY "workout_session_exercises_select_own_parent"
ON public.workout_session_exercises
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_sessions ws
    WHERE ws.id = workout_session_exercises.workout_session_id
      AND ws.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_session_exercises_insert_own_parent"
ON public.workout_session_exercises
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.workout_sessions ws
    WHERE ws.id = workout_session_exercises.workout_session_id
      AND ws.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_session_exercises_update_own_parent"
ON public.workout_session_exercises
FOR UPDATE
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_sessions ws
    WHERE ws.id = workout_session_exercises.workout_session_id
      AND ws.user_id = (select auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.workout_sessions ws
    WHERE ws.id = workout_session_exercises.workout_session_id
      AND ws.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_session_exercises_delete_own_parent"
ON public.workout_session_exercises
FOR DELETE
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_sessions ws
    WHERE ws.id = workout_session_exercises.workout_session_id
      AND ws.user_id = (select auth.uid())
  )
);

-- workout_sets -> workout_session_exercises -> workout_sessions
CREATE POLICY "workout_sets_select_own_parent"
ON public.workout_sets
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_session_exercises wse
    JOIN public.workout_sessions ws ON ws.id = wse.workout_session_id
    WHERE wse.id = workout_sets.session_exercise_id
      AND ws.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_sets_insert_own_parent"
ON public.workout_sets
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.workout_session_exercises wse
    JOIN public.workout_sessions ws ON ws.id = wse.workout_session_id
    WHERE wse.id = workout_sets.session_exercise_id
      AND ws.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_sets_update_own_parent"
ON public.workout_sets
FOR UPDATE
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_session_exercises wse
    JOIN public.workout_sessions ws ON ws.id = wse.workout_session_id
    WHERE wse.id = workout_sets.session_exercise_id
      AND ws.user_id = (select auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.workout_session_exercises wse
    JOIN public.workout_sessions ws ON ws.id = wse.workout_session_id
    WHERE wse.id = workout_sets.session_exercise_id
      AND ws.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_sets_delete_own_parent"
ON public.workout_sets
FOR DELETE
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_session_exercises wse
    JOIN public.workout_sessions ws ON ws.id = wse.workout_session_id
    WHERE wse.id = workout_sets.session_exercise_id
      AND ws.user_id = (select auth.uid())
  )
);

-- meal_plan_items -> meal_plans
CREATE POLICY "meal_plan_items_select_own_parent"
ON public.meal_plan_items
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.meal_plans mp
    WHERE mp.id = meal_plan_items.meal_plan_id
      AND mp.user_id = (select auth.uid())
  )
);

CREATE POLICY "meal_plan_items_insert_own_parent"
ON public.meal_plan_items
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.meal_plans mp
    WHERE mp.id = meal_plan_items.meal_plan_id
      AND mp.user_id = (select auth.uid())
  )
);

CREATE POLICY "meal_plan_items_update_own_parent"
ON public.meal_plan_items
FOR UPDATE
USING (
  EXISTS (
    SELECT 1
    FROM public.meal_plans mp
    WHERE mp.id = meal_plan_items.meal_plan_id
      AND mp.user_id = (select auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.meal_plans mp
    WHERE mp.id = meal_plan_items.meal_plan_id
      AND mp.user_id = (select auth.uid())
  )
);

CREATE POLICY "meal_plan_items_delete_own_parent"
ON public.meal_plan_items
FOR DELETE
USING (
  EXISTS (
    SELECT 1
    FROM public.meal_plans mp
    WHERE mp.id = meal_plan_items.meal_plan_id
      AND mp.user_id = (select auth.uid())
  )
);

-- workout_plan_items -> workout_plans
CREATE POLICY "workout_plan_items_select_own_parent"
ON public.workout_plan_items
FOR SELECT
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_plans wp
    WHERE wp.id = workout_plan_items.workout_plan_id
      AND wp.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_plan_items_insert_own_parent"
ON public.workout_plan_items
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.workout_plans wp
    WHERE wp.id = workout_plan_items.workout_plan_id
      AND wp.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_plan_items_update_own_parent"
ON public.workout_plan_items
FOR UPDATE
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_plans wp
    WHERE wp.id = workout_plan_items.workout_plan_id
      AND wp.user_id = (select auth.uid())
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM public.workout_plans wp
    WHERE wp.id = workout_plan_items.workout_plan_id
      AND wp.user_id = (select auth.uid())
  )
);

CREATE POLICY "workout_plan_items_delete_own_parent"
ON public.workout_plan_items
FOR DELETE
USING (
  EXISTS (
    SELECT 1
    FROM public.workout_plans wp
    WHERE wp.id = workout_plan_items.workout_plan_id
      AND wp.user_id = (select auth.uid())
  )
);

-- ---------------------------------------------------------
-- 4. SHARED READ-ONLY TABLICE
-- authenticated korisnici smiju čitati, ne smiju pisati
-- ---------------------------------------------------------

-- foods
CREATE POLICY "foods_select_authenticated"
ON public.foods
FOR SELECT
USING ((select auth.role()) = 'authenticated');

-- exercises
CREATE POLICY "exercises_select_authenticated"
ON public.exercises
FOR SELECT
USING ((select auth.role()) = 'authenticated');

-- ---------------------------------------------------------
-- 5. VIEWOVI trebaju poštovati RLS pozivatelja
-- ---------------------------------------------------------

ALTER VIEW public.daily_calorie_summary
SET (security_invoker = true);

ALTER VIEW public.workout_session_summary
SET (security_invoker = true);