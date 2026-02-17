# Webhook Configuration Guide

Follow these steps to configure webhook endpoints for any external system.


## 2. Define Webhook Configurations
**Why:** The `co.hotwax.common.WebhookConfig` entity is the source of truth for your webhooks. It tells the system *where* to send data (URL), *what* data to send (Topic), and *how* to sign it (Secret).

**Format:**
```xml
<co.hotwax.common.WebhookConfig
    webhookConfigId="[UNIQUE_IDENTIFIER]"
    topicEnumId="[WEBHOOK_TOPIC]"
    remoteUrl="[ENDPOINT_URL]"
    sharedSecret="[SECURE_KEY]"
    description="[OPTIONAL_DESCRIPTION]"/>
```
*   `webhookConfigId`: A unique ID for this configuration (e.g., `CLIENT_ORDER_CREATED`).
*   `topicEnumId`: The specific business event to subscribe to.
*   `remoteUrl`: The HTTPS endpoint where the payload will be POSTed.
*   `sharedSecret`: A secure key used to generate the HMAC SHA-256 signature for verifying payload integrity.

## 3. Choose Your Topics
**Why:** You should only subscribe to the events that are relevant to your integration. Subscribing to unnecessary topics adds load to both systems.

**Available Topics:**
*   `ORDER_CREATED` - Triggered when a new sales order is placed.
*   `ORDER_APPROVED` - Triggered when an order is approved.
*   `ORDER_COMPLETED` - Triggered when an order is fully completed (all items shipped).
*   `ITEM_BROKERED` - Triggered when an order item is assigned to a facility.
*   `ITEM_REJECTED` - Triggered when an item is rejected by a facility.
*   `SHIPMENT_APPROVED` - Triggered when a shipment is approved.
*   `SHIPMENT_PACKED` - Triggered when a shipment is packed.
*   `SHIPMENT_SHIPPED` - Triggered when a shipment is shipped.

## 4. Configuration Template
**Why:** Use this template to quickly set up a full suite of standard webhooks for a new client integration.

**Template:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<entity-facade-xml type="seed">
    <!-- Replace [CLIENT_ID], [DOMAIN], and [SHARED_SECRET] with actual values -->

    <co.hotwax.common.WebhookConfig webhookConfigId="[CLIENT_ID]_ORDER_CREATED"
        topicEnumId="ORDER_CREATED"
        remoteUrl="https://[DOMAIN]/webhooks/order-created"
        sharedSecret="[SHARED_SECRET]"
        description="Order Created Webhook"/>

    <co.hotwax.common.WebhookConfig webhookConfigId="[CLIENT_ID]_ORDER_APPROVED"
        topicEnumId="ORDER_APPROVED"
        remoteUrl="https://[DOMAIN]/webhooks/order-approved"
        sharedSecret="[SHARED_SECRET]"
        description="Order Approved Webhook"/>

    <co.hotwax.common.WebhookConfig webhookConfigId="[CLIENT_ID]_ORDER_COMPLETED"
        topicEnumId="ORDER_COMPLETED"
        remoteUrl="https://[DOMAIN]/webhooks/order-completed"
        sharedSecret="[SHARED_SECRET]"
        description="Order Completed Webhook"/>

    <co.hotwax.common.WebhookConfig webhookConfigId="[CLIENT_ID]_SHIPMENT_SHIPPED"
        topicEnumId="SHIPMENT_SHIPPED"
        remoteUrl="https://[DOMAIN]/webhooks/shipment-shipped"
        sharedSecret="[SHARED_SECRET]"
        description="Shipment Shipped Webhook"/>
</entity-facade-xml>
```
