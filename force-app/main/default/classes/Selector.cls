public class Selector extends AbstractSelector {

    // Private constructor to enforce the use of factory method
    private Selector(String objectAPIName) {
        super(objectAPIName);
    }

    // Factory method to instantiate selector with just the object API name
    public static Selector of(String objectAPIName) {
        return new Selector(objectAPIName);
    }

    // Fluent method to specify fields after object is instantiated
    public Selector over(String fields) {
        this.query = generateQueryString(fields);
        return this;
    }
}