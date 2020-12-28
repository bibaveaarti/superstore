view: derived_demo {
  derived_table: {
    sql: SELECT CUSTOMER_ID, CUSTOMER_NAME, SALES, REGION FROM "PUBLIC"."ORDERS"    where
    {% condition region_filter %} REGION {% endcondition %}
-- REGION ='South'
      ;;
      # datagroup_trigger: superstor_demo_data_default_datagroup
      # sql_trigger_value:  ;;
  }

  filter: region_filter {
    type: string
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}."CUSTOMER_ID" ;;
  }

  dimension: customer_name {
    type: string
    sql: ${TABLE}."CUSTOMER_NAME" ;;
  }

  dimension: sales {
    type: number
    sql: ${TABLE}."SALES" ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}."REGION" ;;
  }

  set: detail {
    fields: [customer_id, customer_name, sales, region]
  }
}
