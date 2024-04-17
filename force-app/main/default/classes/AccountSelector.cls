public class AccountSelector extends AbstractSelector {
    // Constructor is private to control instantiation
    private AccountSelector() {
        super();
    }

    private AccountSelector(String fields) {
        super(fields);
    }

    protected override Schema.SObjectType getSObjectType() {
        return Schema.getGlobalDescribe().get('Account');
    }

    // Static factory method to instantiate AccountSelector
    public static AccountSelector fetch() {
        return new AccountSelector();
    }

    public static AccountSelector fetch(String fields) {
        return new AccountSelector(fields);
    }
}
