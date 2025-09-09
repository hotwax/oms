package co.hotwax.common;

import java.util.Map;
import java.util.HashMap;

public class CommerceUtil {
    public static Map<String, Object> getPaginationValues(Integer viewSize, Integer viewIndex, Integer listSize) {
        Map<String, Object> result = new HashMap<>();
        if (listSize != null) {
            Integer lowIndex = (viewIndex * viewSize) + 1;
            Integer highIndex = (viewIndex + 1) * viewSize;
            if(highIndex > listSize) {
                highIndex = listSize;
            }
            Integer viewIndexLast = (listSize % viewSize) != 0 ? (listSize / viewSize + 1) : (listSize / viewSize);
            result.put("lowIndex", lowIndex);
            result.put("highIndex", highIndex);
            result.put("viewIndexLast", viewIndexLast);
        }
        return result;
    }

}
