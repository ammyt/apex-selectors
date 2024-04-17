/*
 * Interface for Selector
 * Created by: Roman Tayeh
 */
public interface ISelector {
    ISelector filter(String condition);
    ISelector orderBy(String field);
    ISelector setLimit(Integer limitRecords);
    ISelector bindParams(Map<String, Object> params);
    Object executeQuery();
}