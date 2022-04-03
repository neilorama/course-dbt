{{
    config(
        materialized='table'
    )
}}

with sessions as (
    select * from {{ ref('fct_sessions')}}
),

funnel as (
    select 
        'Just Page View' as label,
        1 as funnel_level_id,

        count(
            distinct case when (
                page_view > 0
                or add_to_cart > 0
                or checkout > 0
                ) then session_id
                else null
            end
        ) as num_sessions
    from 
        sessions

    union all

    select 
        'Up to Add to Cart' as label,
        2 as funnel_level_id,

        count(
            distinct case when (
                add_to_cart > 0
                or checkout > 0
                ) then session_id
                else null
            end
        ) as num_sessions
    from 
        sessions
    
    union all
    
    select 
        'Checkout' as label,
        3 as funnel_level_id,

        count(
            distinct case when (
                checkout > 0
                ) then session_id
                else null
            end
        ) as num_sessions
    from 
        sessions
),

get_previous_level as (
    select
        label,
        funnel_level_id,
        num_sessions,
        lag(num_sessions) OVER() as num_sessions_level_above
    from
        funnel
),

get_conversions as (
    select
        label,
        funnel_level_id,
        num_sessions,
        num_sessions_level_above,
        round(num_sessions::numeric / num_sessions_level_above::numeric, 2) as level_conversion
    from
        get_previous_level
),

final as (
    select
        label,
        funnel_level_id,
        num_sessions,
        num_sessions_level_above,
        level_conversion,
        coalesce(lag(level_conversion) OVER(), 1) - level_conversion as drop_off_relative,
        1 - level_conversion as drop_off_absolute
    from
        get_conversions
)

select * from final