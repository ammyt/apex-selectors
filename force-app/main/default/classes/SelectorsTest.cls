@isTest
public class SelectorsTest {
    
    // Utility method to create test data
    private static void createTestAccounts(Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(
                Name = 'Test Account' + i
            ));
        }
        insert accounts;
    }

    @isTest
    static void testFetchAllAccounts() {
        // Setup test data
        createTestAccounts(5);
        
        // Execute the test
        AccountSelector selector = AccountSelector.fetch();
        List<Account> results = (List<Account>)selector.executeQuery();

        // Verify results
        System.assertEquals(5, results.size(), 'Should fetch all accounts');
    }

    //Test query specific fields
    @isTest
    static void testFetchSpecificFields() {
        // Setup test data
        createTestAccounts(1);

        // Execute the test
        AccountSelector selector = AccountSelector.fetch('Id, Name');
        List<Account> results = (List<Account>)selector.executeQuery();

        // Verify results
        System.assertEquals(1, results.size(), 'Should fetch all accounts');
        System.assertNotEquals(null, results[0].Id, 'Should fetch Id field');
        System.assertNotEquals(null, results[0].Name, 'Should fetch Name field');
    }

    @isTest
    static void testFilterCondition() {
        // Setup test data
        createTestAccounts(3);
        insert new Account(
            Name = 'Unique Account'
        );

        // Execute the test with a filter condition
        List<Account> results = (List<Account>) AccountSelector.fetch().filter('Name = \'Unique Account\'').executeQuery();

        // Verify that only the filtered account is returned
        System.assertEquals(1, results.size(), 'Should return only 1 account with the unique Name');
        System.assertEquals('Unique Account', results[0].Name, 'The returned account should have the unique City');
    }

    @isTest
    static void testLimit() {
        // Setup test data
        createTestAccounts(10);

        // Execute the test with a limit
        List<Account> results = (List<Account>) AccountSelector.fetch().setLimit(5).executeQuery();

        // Verify that only 5 accounts are returned due to the limit
        System.assertEquals(5, results.size(), 'Should return only 5 accounts due to the limit');
    }

    @isTest
    static void testBindParams() {
        // Setup test data
        createTestAccounts(3);
        Account account = [SELECT Id FROM Account LIMIT 1];
        Id accountId = account.Id;

        // Execute the test with bind params
        List<Account> results = (List<Account>) AccountSelector.fetch()
            .filter('Id = :accountId')
            .bindParams(new Map<String, Object> {
                'accountId' => accountId
            })
            .executeQuery();

        // Verify that only the account with the specified Id is returned
        System.assertEquals(1, results.size(), 'Should return only 1 account with the specified Id');
        System.assertEquals(account.Id, results[0].Id, 'The returned account should have the specified Id');
    }

    @isTest
    static void testOrderBy() {
        // Setup test data
        createTestAccounts(3);

        // Execute the test with an order by clause
        List<Account> results = (List<Account>) AccountSelector.fetch()
            .orderBy('Name')
            .executeQuery();

        // Verify that the accounts are returned in descending order of City
        System.assertEquals(3, results.size(), 'Should return all accounts');
        System.assertEquals('Test Account0', results[0].Name, 'The first account should be the one with the lowest Name');
        System.assertEquals('Test Account1', results[1].Name, 'The second account should be the one with the second lowest Name');
        System.assertEquals('Test Account2', results[2].Name, 'The third account should be the one with the highest Name');
    }
}