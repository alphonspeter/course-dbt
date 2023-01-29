{% macro warehouse_resize(prod_size, dev_size)%}

{# If statments is done to access if the changes are being executed in production environment or development environment #}
{# Warehouse sizes are varied accordingly based on the environment where the following sql statements are being executed #}
{% if target.name == 'prod' %}
ALTER WAREHOUSE {{ target.warehouse }} SET WAREHOUSE_SIZE = {{ prod_size }};

{% else %}
ALTER WAREHOUSE {{ target.warehouse }} SET WAREHOUSE_SIZE = {{dev_size}};

{% endif %}

{% endmacro %}