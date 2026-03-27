version: 2

models:
  - name: fact_order_fulfillment
    description: "One row per fulfillment event from FudgeMart and FudgeFlix"
    columns:
      - name: fulfillment_id
        description: "Natural key for the fulfillment event"
        tests:
          - not_null

      - name: customer_key
        description: "Business key for the customer (will map to dim_customer)"
        tests:
          - not_null

      - name: item_key
        description: "Business key for the item (will map to dim_item)"
        tests:
          - not_null

      - name: order_key
        description: "Business key for the order (will map to dim_order)"
        tests:
          - not_null

      - name: order_date
        description: "Raw order date"
        tests:
          - not_null

      - name: shipped_date
        description: "Raw shipped date"

      - name: returned_date
        description: "Raw returned date"

      - name: quantity
        description: "Quantity fulfilled"
        tests:
          - not_null

      - name: unit_price
        description: "Unit price at time of fulfillment"
        tests:
          - not_null

      - name: extended_price
        description: "quantity * unit_price"

      - name: fulfillment_channel
        description: "Shipping, Rental, Streaming, etc."

      - name: source_system
        description: "FudgeMart or FudgeFlix"
        tests:
          - not_null
