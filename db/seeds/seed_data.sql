TRUNCATE TABLE booking_events, hotel_bookings RESTART IDENTITY CASCADE;

INSERT INTO hotel_bookings (
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    CASE
        WHEN gs % 5 = 0 THEN '11111111-1111-1111-1111-111111111111'::uuid
        WHEN gs % 5 = 1 THEN '22222222-2222-2222-2222-222222222222'::uuid
        WHEN gs % 5 = 2 THEN '33333333-3333-3333-3333-333333333333'::uuid
        WHEN gs % 5 = 3 THEN '44444444-4444-4444-4444-444444444444'::uuid
        ELSE '55555555-5555-5555-5555-555555555555'::uuid
    END AS org_id,

    'hotel_' || ((gs % 20) + 1) AS hotel_id,

    CASE
        WHEN gs % 5 = 0 THEN 'delhi'
        WHEN gs % 5 = 1 THEN 'mumbai'
        WHEN gs % 5 = 2 THEN 'bangalore'
        WHEN gs % 5 = 3 THEN 'bhubaneswar'
        ELSE 'kolkata'
    END AS city,

    CURRENT_DATE + ((gs % 20) || ' days')::interval AS checkin_date,
    CURRENT_DATE + (((gs % 20) + 2) || ' days')::interval AS checkout_date,

    ROUND((1000 + random() * 20000)::numeric, 2) AS amount,

    CASE
        WHEN gs % 4 = 0 THEN 'confirmed'
        WHEN gs % 4 = 1 THEN 'cancelled'
        WHEN gs % 4 = 2 THEN 'pending'
        ELSE 'completed'
    END AS status,

    NOW() - ((gs % 90) || ' days')::interval AS created_at

FROM generate_series(1, 10000) AS gs;

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'booking_created',
    jsonb_build_object(
        'source', 'seed_script',
        'city', city,
        'status', status,
        'amount', amount
    ),
    created_at
FROM hotel_bookings
ORDER BY created_at DESC
LIMIT 500;

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    CASE
        WHEN status = 'confirmed' THEN 'payment_success'
        WHEN status = 'cancelled' THEN 'booking_cancelled'
        WHEN status = 'pending' THEN 'payment_pending'
        ELSE 'booking_completed'
    END,
    jsonb_build_object(
        'status', status,
        'event_generated_by', 'seed_script'
    ),
    created_at + INTERVAL '10 minutes'
FROM hotel_bookings
ORDER BY created_at DESC
LIMIT 500;




