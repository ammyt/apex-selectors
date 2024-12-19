# apex-selectors
Optimizing SOQL queries with a selector framework.

This is by no means a perfect tool, rather just something small I developed for myself to make SOQL queries a bit more maintainable. You are free to use this / make it better.

## Usage

### Basic Query

```java
List<Account> results = (List<Account>) Selector.of('Account').executeQuery();
```

### Query with Filters

```java
List<Account> results = (List<Account>) Selector.of('Account')
    .filter('Id = :accountId')
    .bindParams(new Map<String, Object> {
        'accountId' => accountId
    })
    .executeQuery();
```

### Query with Order By

```java
List<Account> results = (List<Account>) Selector.of('Account')
    .orderBy('Name')
    .executeQuery();
```

### Query with Limit

```java
Account result = (Account) Selector.of('Account').setLimit(1).executeQuery();
```

### Query with Specific Fields

```java
Account result = (Account) Selector.of('Account').over('Name, Parent.Name')
    .setLimit(1)
    .executeQuery();
```

### Combining Multiple Options

```java
List<Account> results = (List<Account>) Selector.of('Account')
    .over('Id, Name')
    .filter('Name LIKE :name')
    .bindParams(new Map<String, Object> {
        'name' => '%Acme%'
    })
    .orderBy('Name DESC')
    .setLimit(10)
    .executeQuery();
```

## Old (Still Working)

You can also create a class per Object, if this is your preferred flavor.

### Implementation

```java
public class AccountSelector extends AbstractSelector {
    // Constructor is private to control instantiation
    private AccountSelector() {
        super('Account');
    }

    private AccountSelector(String fields) {
        super('Account', fields);
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

### Usage

```javascript
List<Account> results = (List<Account>) AccountSelector.fetch().executeQuery();

List<Account> results = (List<Account>) AccountSelector.fetch()
            .filter('Id = :accountId')
            .bindParams(new Map<String, Object> {
                'accountId' => accountId
            })
            .executeQuery();

List<Account> results = (List<Account>) AccountSelector.fetch()
            .orderBy('Name')
            .executeQuery();

Account result = (Account) AccountSelector.fetch().setLimit(1).executeQuery();

Account result = (Account) AccountSelector.fetch('Name, Parent.Name').setLimit(1).executeQuery();

```

