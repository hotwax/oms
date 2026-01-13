package co.hotwax.common;

import org.moqui.context.ExecutionContext;
import org.moqui.entity.EntityList;
import org.moqui.entity.EntityValue;

import java.util.HashMap;
import java.util.Map;

public class OrderReaderWorker {

    public static String getFacilityIdentification( ExecutionContext ec, String facilityId, String facilityIdenTypeId) {
        String idValue = null;
        try {
            EntityList facilityIdentification = ec.getEntity().find("co.hotwax.facility.FacilityIdentification").condition("facilityId", facilityId).condition("facilityIdenTypeId", facilityIdenTypeId).useCache(true).list().filterByDate("fromDate", "thruDate", ec.getUser().getNowTimestamp());
            if (facilityIdentification != null) {
                idValue = facilityIdentification.getFirst().getString("idValue");
            }
        } catch (Exception e) {
            ec.getLogger().error("Error finding facility identification for facilityId: " + facilityId, e);
        }
        return idValue;
    }
}