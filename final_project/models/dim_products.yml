version: 2

models:
  - name: dim_product
    description: product Dimension. One row per product
    columns:
      - name: productkey
        description: The surrogate key of the product
        tests:
          - not_null
          - unique
      - name: product_id
        description: The business / source key of the product
        tests:
          - not_null
          - unique
      - name: product_name
        description: The name of the product
      - name: product_category
        description: The category of the product