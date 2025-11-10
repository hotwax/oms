## Upgrade Steps

### Ship to Store Feature Upgrade Steps (Author:Yash Verma)

### Add CarrierShipmentMethod Entity
To modify the delivery days for the Ship to Store shipment method, use the following data:

**Example:**
````
<CarrierShipmentMethod
deliveryDays="7"
partyId="NA"
roleTypeId="CARRIER"
sequenceNumber="80"
shipmentMethodTypeId="SHIP_TO_STORE"/>
````

### Add ProductStoreShipmentMeth Entity related data

To enable the Ship to Store feature, you need to associate the SHIP_TO_STORE shipment method with a specific Product Store using the following data.

**Mandatory fields:**

- productStoreId: <your_productStoreId>
- productStoreShipMethId: <your_productStoreShipMethId>
- partyId: _NA_
- roleTypeId: CARRIER
- shipmentMethodTypeId: SHIP_TO_STORE

**Example:**
````
<ProductStoreShipmentMeth 
  partyId="_NA_" 
  productStoreId="<your_productStoreId>" 
  productStoreShipMethId="<your_productStoreShipMethId>" 
  roleTypeId="CARRIER" 
  shipmentMethodTypeId="SHIP_TO_STORE"/>
````

### To generate Shipping labels for Ship to Store orders
You need to add the data carrier wise

**Below is an example for Drivin carrier**
````
<CarrierShipmentMethod carrierServiceCode="STS" 
  deliveryDays="7" 
  partyId="DRIVIN" 
  roleTypeId="CARRIER" 
  shipmentMethodTypeId="SHIP_TO_STORE"/>
                           
<ProductStoreShipmentMeth  
  isTrackingRequired="Y" 
  partyId="DRIVIN" 
  productStoreId="ADOC_STORE" 
  productStoreShipMethId="10132" 
  roleTypeId="CARRIER" 
  shipmentGatewayConfigId="DRIVIN_CONFIG" 
  shipmentMethodTypeId="SHIP_TO_STORE"/>

<ShipmentRequest carrierPartyId="DRIVIN" 
  requestType="SHIPMENT_ACCEPT" 
  shipmentMethodTypeId="SHIP_TO_STORE" 
  serviceName="postMoquiOrder"/>
    
<ShipmentRequest carrierPartyId="DRIVIN" 
  requestType="VOID_LABEL_REQUEST" 
  shipmentMethodTypeId="SHIP_TO_STORE" 
  serviceName="voidMoquiOrder"/>
`````


