aws sqs send-message --queue-url 'https://sqs.us-east-1.amazonaws.com/249536929440/satisfaction-audit-extract-sub-beta' --message-body '{"name": "AuditServiceExportNotification", "job-instance-id": "785673", "provider-name": "FulfillmentOptOutMaids-bdea5d8f-48fc-43c8-a84f-2021952a15f8", "job-status": "SUCCESS", "step-status": "SUCCESS", "export-path": "s3://p3-fulfillment/audit-n-extract/prod/maids/2021-02-18/", "guid": "bdea5d8f-48fc-43c8-a84f-2021952a15f8", "dataset-name": "FulfillmentOptOutMaids", "export-name": "FulfillmentOptOutMaids" }'
