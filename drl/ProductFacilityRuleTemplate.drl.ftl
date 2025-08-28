<#assign ruleGroup = ec.entity.find("co.hotwax.rule.RuleGroup").condition("ruleGroupId", ruleGroupId).condition("statusId", "ATP_RG_ACTIVE").one()!>
<#if ruleGroup?has_content>
<#assign decisionRules = ec.entity.find("co.hotwax.rule.DecisionRule").condition("ruleGroupId", ruleGroupId).condition("statusId", "ATP_RULE_ACTIVE").orderBy("sequenceNum asc").list()!>
<#if decisionRules?has_content>

  <#-- Set the package and imports -->
  package co.hotwax.rule;
  dialect "mvel"
  import org.moqui.util.ContextStack;
  import java.math.BigDecimal;
  import java.util.HashMap;
  global org.moqui.context.ExecutionContext ec;
  global java.util.Map productFacilityDetail;

  <#assign ruleCount = decisionRules?size>
  <#list decisionRules as decisionRule>
    <#assign ruleActions = ec.entity.find("co.hotwax.rule.RuleAction").condition("ruleId", decisionRule.ruleId).orderBy("sequenceNum asc").list()!>
    <#assign ruleConditions = ec.entity.find("co.hotwax.rule.RuleCondition").condition("ruleId", decisionRule.ruleId).condition("conditionTypeEnumId", "ENTCT_ATP_FILTER").orderBy("sequenceNum asc").list()!>

    <#assign conditionFieldNames = []>
    <#list ruleConditions as ruleCondition>
      <#if !conditionFieldNames?seq_contains(ruleCondition.fieldName)>
        <#assign conditionFieldNames = conditionFieldNames + [ruleCondition.fieldName]/>
      </#if>
    </#list>

    <#assign facilityConditions = ec.entity.find("co.hotwax.rule.RuleCondition").condition("ruleId", decisionRule.ruleId).condition("conditionTypeEnumId", "ENTCT_ATP_FACILITIES").list()!>
    <#assign facilityIds = []/>
    <#if facilityConditions?has_content>
      <#assign facilityCondition = facilityConditions?first/>
      <#if "ALL" == facilityCondition.fieldValue!>
        <#assign allConfigFacilities = ec.entity.find("co.hotwax.product.store.ProductStoreFacilityDetail").selectField("facilityId").condition("productStoreId", ruleGroup.productStoreId).condition("facilityTypeId", "CONFIGURATION").list()!>
        <#if allConfigFacilities?has_content>
          <#list allConfigFacilities as configFacility>
            <#assign facilityIds = facilityIds + [configFacility.facilityId]>
          </#list>
        </#if>
      <#else>
        <#assign facilityIds = Static["co.hotwax.common.DecisionRuleHelper"].valueToCollection(facilityCondition.fieldValue)/>
      </#if>
    </#if>
    <#if !facilityIds?has_content>
      <#assign facilityGroupConditions = ec.entity.find("co.hotwax.rule.RuleCondition").condition("ruleId", decisionRule.ruleId).condition("conditionTypeEnumId", "ENTCT_ATP_FAC_GROUPS").list()!>
        <#assign includedFacilityGroupIds = []>
        <#assign excludedFacilityGroupIds = []>
        <#if facilityGroupConditions?has_content>
          <#assign facilityGroupCondition = facilityGroupConditions?first/>
          <#if "ALL" == facilityGroupCondition.fieldValue!>
            <#assign allFacilities = ec.entity.find("co.hotwax.product.store.ProductStoreFacilityDetail").selectField("facilityId").condition("productStoreId", ruleGroup.productStoreId).condition("facilityTypeId", "not-equals", "VIRTUAL_FACILITY").condition("parentFacilityTypeId", "not-equals", "VIRTUAL_FACILITY").list()!>
            <#if allFacilities?has_content>
              <#list allFacilities as facility>
                <#assign facilityIds = facilityIds + [facility.facilityId]>
              </#list>
            </#if>
          </#if>
          <#if !facilityIds?has_content>
          <#list facilityGroupConditions as facilityGroupCondition>
            <#if "in" == facilityGroupCondition.operator>
              <#assign includedFacilityGroupIds = includedFacilityGroupIds + Static["co.hotwax.common.DecisionRuleHelper"].valueToCollection(facilityGroupCondition.fieldValue)/>
            <#elseif "not-in" == facilityGroupCondition.operator>
              <#assign excludedFacilityGroupIds = excludedFacilityGroupIds + Static["co.hotwax.common.DecisionRuleHelper"].valueToCollection(facilityGroupCondition.fieldValue)/>
            </#if>
          </#list>

         <#assign includedFacilityIds = []>
         <#assign excludedFacilityIds = []>
          <#assign facilityGroupMembers = ec.entity.find("org.apache.ofbiz.product.facility.FacilityGroupMember").condition("facilityGroupId", "in", includedFacilityGroupIds).conditionDate("", "", ec.user.nowTimestamp).list()!>
          <#list facilityGroupMembers as facilityGroupMember>
            <#assign includedFacilityIds = includedFacilityIds + [facilityGroupMember.facilityId]>
          </#list>
          <#assign facilityGroupMembers = ec.entity.find("org.apache.ofbiz.product.facility.FacilityGroupMember").condition("facilityGroupId", "in", excludedFacilityGroupIds).conditionDate("", "", ec.user.nowTimestamp).list()!>
          <#list facilityGroupMembers as facilityGroupMember>
            <#assign excludedFacilityIds = excludedFacilityIds + [facilityGroupMember.facilityId]>
          </#list>

          <#list includedFacilityIds as includedFacilityId>
            <#if !excludedFacilityIds?seq_contains(includedFacilityId)>
              <#assign facilityIds = facilityIds + [includedFacilityId]>
            </#if>
          </#list>
          </#if>
        </#if>
    </#if>
    <#if facilityIds?has_content>
      rule "${decisionRule.ruleId}"
      salience ${ruleCount}
      when
       <#--First checking if the condition fields exist in the input data and then applying rule conditions -->
       $product : Map(<#list conditionFieldNames as fieldName>containsKey("${fieldName}"), </#list> <#list ruleConditions as ruleCondition><#if ruleCondition_index gt 0>,</#if>${Static["co.hotwax.common.DecisionRuleHelper"].makeDroolsCondition(ruleCondition)!}</#list>)
      then
        <#list ruleActions as ruleAction>
          <#list facilityIds as facilityId>
            $actionValues = new HashMap();
            $actionValues.put("${ruleAction.fieldName}", "${ruleAction.fieldValue}")
            $actionValues.put("facility-id", "${facilityId}")
            $actionValues.put("product-id", $product.get("productId"))
            productFacilityDetail.put("${facilityId}-" + $product.get("productId"), $actionValues);
          </#list>
        </#list>
      end
    </#if>
    <#assign ruleCount = ruleCount - 1>
  </#list>
</#if>
</#if>