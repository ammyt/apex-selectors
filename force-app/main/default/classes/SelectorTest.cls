@isTest
private class SelectorTest {
    
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
        Selector selector = Selector.of('Account');
        List<Account> results = (List<Account>)selector.executeQuery();

        // Verify results
        System.assertEquals(5, results.size(), 'Should fetch all accountes');
    }

    //Test query specific fields
    @isTest
    static void testFetchSpecificFields() {
        // Setup test data
        createTestAccounts(1);

        // Execute the test
        Selector selector = Selector.of('Account').over('Id, Name');
        List<Account> results = (List<Account>)selector.executeQuery();

        // Verify results
        System.assertEquals(1, results.size(), 'Should fetch all accountes');
        System.assertNotEquals(null, results[0].Id, 'Should fetch Id field');
        System.assertNotEquals(null, results[0].Name, 'Should fetch Name field');
    }

    @isTest
    static void testFilterCondition() {
        // Setup test data
        createTestAccounts(3);
        insert new Account(
            Street__c = '123 Unique St',
            City__c = 'Unique City',
            Country__c = 'Unique Country'
        );

        // Execute the test with a filter condition
        List<Account> results = (List<Account>) Selector.of('Account').filter('City__c = \'Unique City\'').executeQuery();

        // Verify that only the filtered account is returned
        System.assertEquals(1, results.size(), 'Should return only 1 account with the unique City');
        System.assertEquals('Unique City', results[0].City__c, 'The returned account should have the unique City');
    }

    @isTest
    static void testLimit() {
        // Setup test data
        createTestAccounts(10);

        // Execute the test with a limit
        List<Account> results = (List<Account>) Selector.of('Account').setLimit(5).executeQuery();

        // Verify that only 5 accountes are returned due to the limit
        System.assertEquals(5, results.size(), 'Should return only 5 accountes due to the limit');
    }

    @isTest
    static void testBindParams() {
        // Setup test data
        createTestAccounts(3);
        Account account = [SELECT Id FROM Account LIMIT 1];
        Id accountId = account.Id;

        // Execute the test with bind params
        List<Account> results = (List<Account>) Selector.of('Account')
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
        List<Account> results = (List<Account>) Selector.of('Account')
            .orderBy('City__c')
            .executeQuery();

        // Verify that the accountes are returned in descending order of City
        System.assertEquals(3, results.size(), 'Should return all accountes');
        System.assertEquals('Test City0', results[0].City__c, 'The first account should have the Test City');
        System.assertEquals('Test City1', results[1].City__c, 'The second account should have the Test City');
        System.assertEquals('Test City2', results[2].City__c, 'The third account should have the Test City');
    }


}