connection: "superstore_demo_data"

# include all the views
include: "/views/**/*.view"
include: "/*.view"

datagroup: superstor_demo_data_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: superstor_demo_data_default_datagroup

explore: fivetran_audit {}

explore: people {}

explore: returns {
  label: "Return table"
  sql_always_where: ${orders.region} = 'South' ;;
  join: orders {
    type: left_outer
    sql_on: ${returns.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }
}

explore: orders {}

explore: derived_demo {}
