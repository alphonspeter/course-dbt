{% macro grant_role(role) %}

{# set the query name as 'grant_query' #}
{% set grant_query %}
GRANT USAGE ON SCHEMA {{ schema }} TO ROLE {{ role }};
GRANT SELECT ON {{ this }} to role {{ role }};
{% endset %}

{# run the query 'grant_query' #}
{% set results = run_query(grant_query) %}

{% endmacro%}