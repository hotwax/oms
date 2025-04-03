package co.hotwax.oms.util

import groovy.transform.CompileStatic
import org.moqui.entity.EntityValue
import org.moqui.impl.context.ExecutionContextFactoryImpl
import org.slf4j.Logger
import org.slf4j.LoggerFactory

@CompileStatic
class OmsUtil {
    protected final static Logger logger = LoggerFactory.getLogger(OmsUtil.class);

    public static boolean hasParentType(ExecutionContextFactoryImpl ecfi , String entityName, String primaryKey, String childType, String parentTypeField, String parentType) {
        EntityValue entityValue = ecfi.entityFacade.find(entityName)
                .condition(primaryKey, childType).useCache(true).disableAuthz().one()
        if (entityValue == null) {
            return false;
        }
        if (parentType == entityValue.get(primaryKey)) {
            return true
        }
        if (entityValue.get(parentTypeField) != null) {
            if (parentType == entityValue.get(parentTypeField)) {
                return true
            } else {
                return hasParentType(ecfi, entityName, primaryKey, entityValue.getString(parentTypeField), parentTypeField, parentType);
            }
        }
        return false;
    }
}