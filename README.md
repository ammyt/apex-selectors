# apex-selectors
Optimizing SOQL queries with a selector framework.

This is by no means a perfect tool, rather just something small I developed for myself to make SOQL queries a bit more maintainable. You are free to use this / make it better.


## Implementation

```java
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

```

## Usage

```javascript
List<Account> results = (List<Account>) AddressSelector.fetch().executeQuery();

List<Account> results = (List<Account>) AddressSelector.fetch()
            .filter('Id = :accountId')
            .bindParams(new Map<String, Object> {
                'accountId' => accountId
            })
            .executeQuery();

List<Account> results = (List<Account>) AddressSelector.fetch()
            .orderBy('Name')
            .executeQuery();

Account result = (Account) AddressSelector.fetch().setLimit(1).executeQuery();

```

