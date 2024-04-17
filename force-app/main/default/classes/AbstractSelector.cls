public abstract class AbstractSelector implements ISelector {
    protected String query;
    protected Integer limitValue;
    protected Map<String, Object> bindParams;
    
    // Constructor
    protected AbstractSelector() {
        this.bindParams = new Map<String, Object>();
        this.query = generateQueryString(); // Dynamically generate the query string
    }

    protected AbstractSelector(String fields) {
        this.bindParams = new Map<String, Object>();
        this.query = generateQueryString(fields); // Dynamically generate the query string
    }
    
    // Dynamically generate the SOQL query string based on the SObject type
    private String generateQueryString() {
        List<String> fieldNames = new List<String>();
        // Corrected: Access fields through getDescribe()
        Map<String, Schema.SObjectField> fieldMap = this.getSObjectType().getDescribe().fields.getMap();
        for (String fieldName : fieldMap.keySet()) {
            fieldNames.add(fieldName);
        }
        return 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + getSObjectType().getDescribe().getName();
    }

    private String generateQueryString(String fields) {
        return 'SELECT ' + fields + ' FROM ' + getSObjectType().getDescribe().getName();
    }
    
    // Abstract method to be implemented by concrete classes to specify their SObject type
    protected abstract Schema.SObjectType getSObjectType();
    
    // Method implementations for ISelector interface
    public ISelector filter(String condition) {
        if (this.query.contains('WHERE')) {
            this.query += ' AND ' + condition;
        } else {
            this.query += ' WHERE ' + condition;
        }
        return this;
    }
    
    public ISelector orderBy(String field) {
        this.query += ' ORDER BY ' + field;
        return this;
    }
    
    public ISelector setLimit(Integer limitRecords) {
        this.limitValue = limitRecords;
        this.query += ' LIMIT ' + limitRecords.toString();
        return this;
    }
    
    public ISelector bindParams(Map<String, Object> params) {
        this.bindParams.putAll(params);
        return this;
    }
    
    public Object executeQuery() {
        List<SObject> results;
        // Check if bindParams is not empty to decide which query method to use
        if (!this.bindParams.isEmpty()) {
            // Use the custom query method with bind parameters
            results = Database.queryWithBinds(this.query, bindParams, AccessLevel.SYSTEM_MODE);
        } else {
            // Fallback to the standard query method if no bind parameters are present
            results = Database.query(this.query);
        }

        // Handle the limit value logic as before
        if (this.limitValue == 1) {
            return results.isEmpty() ? null : results[0];
        } else {
            return results;
        }
    } 
}
