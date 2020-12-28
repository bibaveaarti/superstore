view: returns {
  sql_table_name: "PUBLIC"."RETURNS"
    ;;

  dimension: file_name {
    type: string
    sql: ${TABLE}."_FILE" ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      quarter_of_year,
      year
    ]
    sql: CAST(${TABLE}."_FIVETRAN_SYNCED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: _line {
    type: number
    sql: ${TABLE}."_LINE" ;;
  }

  dimension: order_id {
    # primary_key: yes
    type: string
    # hidden: yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: returned {
    type: string
    sql: ${TABLE}."RETURNED" ;;
  }

  measure: count {
    view_label: "Group"
    type: count
    drill_fields: [orders.product_name, orders.order_id, orders.customer_name]
  }
}
