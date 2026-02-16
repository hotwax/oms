# Webhook Configuration Data Preparation

## WebhookConfig Format
```xml
<co.hotwax.common.WebhookConfig webhookConfigId="[UNIQUE_ID]" 
    topicEnumId="[WEBHOOK_TOPIC]" 
    remoteUrl="[WEBHOOK_ENDPOINT_URL]" 
    sharedSecret="[SHARED_SECRET]"/>
```

## Available Topics
- `ORDER_CREATED` - Order Created
- `ORDER_APPROVED` - Order Approved  
- `ORDER_COMPLETED` - Order Completed
- `ITEM_BROKERED` - Item Brokered
- `ITEM_REJECTED` - Item Rejected
- `SHIPMENT_APPROVED` - Shipment Approved
- `SHIPMENT_PACKED` - Shipment Packed
- `SHIPMENT_SHIPPED` - Shipment Shipped

## Example Configurations
```xml
<co.hotwax.common.WebhookConfig webhookConfigId="CLIENT_ORDER_CREATE" 
    topicEnumId="ORDER_CREATED" 
    remoteUrl="https://client-domain.com/webhooks/order-created" 
    sharedSecret="client-order-create-secret"/>

<co.hotwax.common.WebhookConfig webhookConfigId="CLIENT_ORDER_APPROVE" 
    topicEnumId="ORDER_APPROVED" 
    remoteUrl="https://client-domain.com/webhooks/order-approved" 
    sharedSecret="client-order-approve-secret"/>

<co.hotwax.common.WebhookConfig webhookConfigId="CLIENT_SHIP_SHIP" 
    topicEnumId="SHIPMENT_SHIPPED" 
    remoteUrl="https://client-domain.com/webhooks/shipment-shipped" 
    sharedSecret="client-ship-ship-secret"/>
```

## Data File Location
Add configurations to: `/data/WebhookSeedData.xml`