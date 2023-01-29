{% macro get_distinct_column_values(column_name, model_name) %}

{# set the name of the query as 'distinct query' #}
{% set distinct_query %}
select distinct
{{ column_name }} 
from {{ model_name }}
{% endset %}
 
{# store the output of the query in a variable called results #}
{% set results = run_query(distinct_query) %}
{# This is actually an Agate table. To get the payment methods back as a list, we need to do some further transformation as below. #}

{% if execute %}
{# Return the first column values #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{# return the unique values of the first column as a list #}
{{ return(results_list) }}

{% endmacro %}

