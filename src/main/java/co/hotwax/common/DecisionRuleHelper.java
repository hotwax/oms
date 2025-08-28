package co.hotwax.common;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.moqui.entity.EntityCondition;
import org.moqui.entity.EntityValue;
import org.moqui.impl.context.ExecutionContextFactoryImpl;
import org.moqui.impl.entity.EntityConditionFactoryImpl;
import org.moqui.util.SystemBinding;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



public class DecisionRuleHelper {
    protected static final Logger logger = LoggerFactory.getLogger(DecisionRuleHelper.class);

    enum DroolsOperator { EQUALS, NOT_EQUAL, LESS_THAN, GREATER_THAN,
            LESS_THAN_EQUAL_TO, GREATER_THAN_EQUAL_TO, IN, NOT_IN, CONTAINS, NOT_CONTAINS, OR, AND }

    protected static final Map<DroolsOperator, String> droolsOperatorStringMap = new HashMap<DroolsOperator, String>();
    static {
        droolsOperatorStringMap.put(DroolsOperator.EQUALS, "==");
        droolsOperatorStringMap.put(DroolsOperator.NOT_EQUAL, "!=");
        droolsOperatorStringMap.put(DroolsOperator.LESS_THAN, "<");
        droolsOperatorStringMap.put(DroolsOperator.GREATER_THAN, ">");
        droolsOperatorStringMap.put(DroolsOperator.LESS_THAN_EQUAL_TO, "<=");
        droolsOperatorStringMap.put(DroolsOperator.GREATER_THAN_EQUAL_TO, ">=");
        droolsOperatorStringMap.put(DroolsOperator.IN, "in");
        droolsOperatorStringMap.put(DroolsOperator.NOT_IN, "notin");
        droolsOperatorStringMap.put(DroolsOperator.CONTAINS, "contains");
        droolsOperatorStringMap.put(DroolsOperator.NOT_CONTAINS, "not contains");
        droolsOperatorStringMap.put(DroolsOperator.AND, "&&");
        droolsOperatorStringMap.put(DroolsOperator.OR, "||");
    }

    protected static final Map<String, DroolsOperator> droolsStringOperatorMap = new HashMap<String, DroolsOperator>();
    static {
        droolsStringOperatorMap.put("equals", DroolsOperator.EQUALS);
        droolsStringOperatorMap.put("not-equals", DroolsOperator.NOT_EQUAL);
        droolsStringOperatorMap.put("less-than", DroolsOperator.LESS_THAN);
        droolsStringOperatorMap.put("greater-than", DroolsOperator.GREATER_THAN);
        droolsStringOperatorMap.put("less-than-equal-to", DroolsOperator.LESS_THAN_EQUAL_TO);
        droolsStringOperatorMap.put("greater-than-equal-to", DroolsOperator.GREATER_THAN_EQUAL_TO);
        droolsStringOperatorMap.put("in", DroolsOperator.IN);
        droolsStringOperatorMap.put("not-in", DroolsOperator.NOT_IN);
        droolsStringOperatorMap.put("contains", DroolsOperator.CONTAINS);
        droolsStringOperatorMap.put("not-contains", DroolsOperator.NOT_CONTAINS);
        droolsStringOperatorMap.put("and", DroolsOperator.AND);
        droolsStringOperatorMap.put("or", DroolsOperator.OR);
    }

    static String getDroolsOperatorString(DroolsOperator op) { return new StringBuilder(" ").append(droolsOperatorStringMap.get(op)).append(" ").toString(); }
    
    static DroolsOperator getDroolsOperator(String opName) {
        if (opName == null) return DroolsOperator.EQUALS;
        DroolsOperator co = droolsStringOperatorMap.get(opName);
        return co != null ? co : DroolsOperator.EQUALS;
    }


    public static String makeDroolsCondition(EntityValue ev) {
        StringBuilder condition = new StringBuilder();
        Object value = ev.get("fieldValue");
        Object field = ev.get("fieldName");

        DroolsOperator operator = getDroolsOperator(ev.getString("operator"));
        List<DroolsOperator> simpleOperators = new ArrayList<DroolsOperator>(Arrays.asList(DroolsOperator.EQUALS,
                DroolsOperator.NOT_EQUAL, DroolsOperator.GREATER_THAN, DroolsOperator.GREATER_THAN_EQUAL_TO,
                DroolsOperator.LESS_THAN, DroolsOperator.LESS_THAN_EQUAL_TO));
        if (simpleOperators.contains(operator)) {
            condition.append(field).append(getDroolsOperatorString(operator));
            if (operator == DroolsOperator.EQUALS || operator == DroolsOperator.NOT_EQUAL) {
                condition.append(wrapValueInDoubleQuotes(value));
            } else {
                condition.append(value);
            }
        } else if (operator == DroolsOperator.CONTAINS || operator == DroolsOperator.NOT_CONTAINS) {
            DroolsOperator joinOperator = (operator == DroolsOperator.CONTAINS) ? DroolsOperator.OR : DroolsOperator.AND;
            List<String> fieldValuesIn = (List<String>) valueToCollection(value);
            condition.append("(");
            boolean isFirstValue = true;
            for (String fieldValue : fieldValuesIn) {
                if (!isFirstValue) {
                    condition.append(getDroolsOperatorString(joinOperator));
                }
                condition.append(field).append(getDroolsOperatorString(operator)).append(wrapValueInDoubleQuotes(fieldValue));
                isFirstValue = false;
            }
            condition.append(")");
        } else if (operator == DroolsOperator.IN || operator == DroolsOperator.NOT_IN) {
            List<String> fieldValuesIn = (List<String>) valueToCollection(value);
            boolean isFirstValue = true;
            condition.append(field).append(getDroolsOperatorString(operator)).append("(");
            for (String fieldValue : fieldValuesIn) {
                if (!isFirstValue) {
                    condition.append(", ");
                }
                condition.append(wrapValueInDoubleQuotes(fieldValue));
                isFirstValue = false;
            }
            condition.append(")");
        }
        return condition.toString();
    }

    public static String wrapValueInDoubleQuotes(Object value) {
        StringBuilder updatedValue = new StringBuilder();
        return updatedValue.append("\"").append(value).append("\"").toString();
    }

    public static Object valueToCollection(Object value) {
        if (value instanceof CharSequence) {
            String valueStr = value.toString();
            // note: used to do this, now always put in List: if (valueStr.contains(","))
            value = Arrays.asList(valueStr.split(","));
        }
        // TODO: any other useful types to convert?
        return value;
    }
}
