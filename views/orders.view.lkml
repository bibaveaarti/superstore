view: orders {
  sql_table_name: "PUBLIC"."ORDERS"
    ;;
  drill_fields: [order_id]

  dimension: order_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."ORDER_ID" ;;

  }

  dimension: _file {
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

  dimension: _row {
    type: number
    sql: ${TABLE}."_ROW" ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: concat_demo {
    type: string
    sql: UPPER(concat(${city},' ',${country})) ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}."CUSTOMER_ID" ;;
  }

  dimension: customer_name {
    label: "First Name"
    description: "Renamed to first name"
    type: string
    sql: ${TABLE}."CUSTOMER_NAME" ;;
  }

  dimension: discount {
    type: number
    sql: ${TABLE}."DISCOUNT" ;;
  }

  dimension: order_date {
    type: string
    sql: ${TABLE}."ORDER_DATE" ;;
  }

  dimension_group: order_date_group {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
   sql: CAST(${order_date} AS TIMESTAMP_NTZ) ;;
  }


  dimension: days_since_purchase {
    type: number
    sql: DATEDIFF(month, ${order_date_group_date}, current_date());;
  }

dimension: days_since_purchase_tier {
  type: tier
  style: integer
  tiers: [0,30,60,90,180,365]
  sql: ${days_since_purchase};;
}

  dimension: sales_tier {
    type: tier
    style: integer
    tiers: [0,50,100,150,200,500]
    sql: ${sales};;
  }

  dimension: postal_code {
    type: number
    sql: ${TABLE}."POSTAL_CODE" ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}."PRODUCT_NAME" ;;
  }

  dimension: profit {
    type: number
    sql: ${TABLE}."PROFIT" ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}."REGION" ;;
  }

  dimension: row_id {
    hidden: no
    type: number
    sql: ${TABLE}."ROW_ID" ;;
  }
# if age ? 18 then "yes" else "no"
# case when age > 18 ;;
  dimension: sales {
    type: number
    sql: ${TABLE}."SALES" ;;
    # value_format_name: usd
  }

  dimension: sales_check {
    type: yesno
    sql: ${sales} > 100 ;;
  }

  dimension: sales_demo {
    type: number
    sql: ${sales}+100 ;;
    # value_format_name: usd
  }

  measure: sales_new_measure {
    view_label: "Group"
    type: count_distinct
    sql: ${customer_id};;
    value_format_name: decimal_2
    # drill_fields: [order_id, product_name, customer_name, returns.count]
  }

  dimension: segment {
    type: string
    sql: ${TABLE}."SEGMENT" ;;
  }

  dimension: ship_date {
    type: string
    sql: ${TABLE}."SHIP_DATE" ;;
  }

  dimension: ship_mode {
    type: string
    sql: ${TABLE}."SHIP_MODE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: sub_category {
    type: string
    sql: ${TABLE}."SUB_CATEGORY" ;;
  }

  measure: chairs_count_filter {
    type: count
     filters: [sub_category: "Chairs"]
    }

  measure: chairs_count_case {
    type: sum
     sql:  CASE WHEN ${sub_category} = 'Chairs' THEN 1 ELSE NULL END;;
  }

  measure: count_order {
    view_label: "Group"
    type: count
    drill_fields: [new_set*]
  }

  measure: order_check {
    view_label: "Group"
    type: min
    sql: ${sales} ;;
  }

  measure: mean_order {
    type: number
    sql: mean(${count_order}) ;;
    value_format_name: decimal_2
  }

  measure: sum_sales_count {
    type: number
    sql: ${count_order}+${sales_new_measure} ;;
  }

  set: new_set {
    fields: [order_id, product_name, customer_name, returns.count]
  }
}
