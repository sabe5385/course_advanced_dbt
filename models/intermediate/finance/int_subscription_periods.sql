WITH

-- Import CTEs
-- Get raw monthly subscriptions
monthly_subscriptions AS (
    SELECT
        subscription_id,
        user_id,
        starts_at,
        ends_at,
        plan_name,
        pricing,
        {{ trunc_to_month('starts_at') }} AS start_month,
        {{ trunc_to_month('ends_at') }} AS end_month
    FROM
        {{ unit_testing_select_table(ref('dim_subscriptions'), ref('unit_test_input_dim_subscription_mrr')) }}
    WHERE
        billing_period = 'monthly'
),

-- Logic CTEs
-- Create subscription period start_month and end_month ranges
subscription_periods AS (
    SELECT
        subscription_id,
        user_id,
        plan_name,
        pricing AS monthly_amount,
        starts_at,
        ends_at,
        start_month,

        -- For users that cancel in the first month, set their end_month to next month because the subscription remains active until the end of the first month
        -- For users who haven't ended their subscription yet (end_month is NULL) set the end_month to one month from the current date (these rows will be removed from the final CTE)
        CASE
            WHEN start_month = end_month THEN DATEADD('month', 1, end_month)
            WHEN end_month IS NULL THEN DATE(DATEADD('month', 1, DATE_TRUNC('month', CURRENT_DATE)))
            ELSE end_month
        END AS end_month
    FROM
        monthly_subscriptions
)

SELECT * FROM subscription_periods
