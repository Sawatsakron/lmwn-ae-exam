# Project Structure

### Data Model
The data model follows a layered approach:

```bash
models/
├── staging/        # Initial transformation layer for raw data
├── intermediate/   # Transitional models
├── marts/          # Business-focused fact and dimensional models
└── reports/        # Final reporting models for business teams
```
### Reports
The reports are created based on specific business requirements and can be accessed directly from the DuckDB database.

- **Performance Marketing Team**
    - report_campaign_effectiveness
    - report_customer_acquisition
    - report_retargeting_performance

- **Fleet Management Team**
  - report_driver_performance
  - report_delivery_zone_heatmap
  - report_driver_incentive_impact
  - report_amount_paid_incentive

- **Customer Service Team**
  - report_complaint_summary
  - report_driver_complaints
  - report_restaurant_quality_complaints
