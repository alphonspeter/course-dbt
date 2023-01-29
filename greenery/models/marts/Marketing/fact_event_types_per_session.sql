{# run the macro 'get_distinct_column_values' to get different event_types from stg_events table #}
{# - is to remove white lines while compiling #}
{%- set event_types = get_distinct_column_values(column_name= 'event_type', model_name = ref('stg_postgres_events')) -%} 

select 
    session_id

    {# loop through different event_types to count the number of sessions per event_type #}
    ,{%- for event_type in event_types %}
    count (case when event_type = '{{event_type}}' then session_id end) as {{event_type}}_occurence
    {%- if not loop.last %},{% endif -%} {# this is done to avoid trailing comma at the last run of the loop. If its the last run, then avoid placing a comma #}
    {% endfor %}
    from {{ ref('stg_postgres_events') }}
    group by 1

