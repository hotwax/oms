<#if products?has_content>
  <#assign firstProduct = products?first/>
  <#assign csvField = "">
  <#list firstProduct.keySet() as fieldName>
    <#if fieldName != "product-id" && fieldName != "facility-id">
      <#assign csvField = fieldName>
      <#break>
    </#if>
  </#list>
  <#if "allow-brokering" == csvField>
    <#assign entityField = "allowBrokering" />
  <#elseif "allow-pickup" == csvField>
    <#assign entityField = "allowPickup" />
  <#else>
    <#assign entityField = "minimumStock" />
  </#if>
  <#list products as product>
    <#if product['product-id']?has_content && product['facility-id']?has_content>
      <#assign productFacility = ec.entity.find("org.apache.ofbiz.product.facility.ProductFacility").condition("productId", product['product-id']).condition("facilityId", product['facility-id']).selectField("allowBrokering, allowPickup, minimumStock").one()!>
      <#if !productFacility?has_content || !productFacility[entityField]?has_content || (product[csvField]?has_content && productFacility[entityField]?string != product[csvField]?string)>
        <#if "Y" != skipHeader!>
          <#list firstProduct.keySet() as field>${field}<#if field_has_next>,</#if><#t></#list>
          <#assign  skipHeader="Y"/>
        </#if>
        <#list firstProduct.keySet() as field>${product[field]}<#if field_has_next>,</#if><#t></#list>
      </#if>
    </#if>
  </#list>
</#if>