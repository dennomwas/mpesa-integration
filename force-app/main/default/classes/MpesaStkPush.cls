public with sharing class MpesaStkPush {
    Integer BusinessShortCode;
    String  Password;
    String  Timestamp;
    String  TransactionType; 
    Double  Amount; 
    Long    PartyA;       
    Integer PartyB;      
    Long    PhoneNumber; 
    String  CallBackURL;  
    String  AccountReference;
    String  TransactionDesc;
    private static final String ACCESS_TOKEN = AuthorizeMpesa.getAuthorization();
    
    // get variables from custom metadata
	private static final Safaricom_mpesa__mdt varMpesa = Safaricom_mpesa__mdt.getInstance('mpesa_variables');
    private static final String STK_PUSH_URL           = varMpesa.Stk_push_URL__c;
    private static final String CALL_BACK_URL          = varMpesa.Callback_URL__c;
    private static final String TILL_PASSWORD          = varMpesa.Password__c;
    private static final String TRANSACTION_TYPE       = varMpesa.Transaction_type__c;
    private static final Integer BUSINESS_TILL_NUMBER  = Integer.valueOf(varMpesa.Business_number__c);
    
    // timestamp format: 20220603202903 yyyyMMhhmmss
    public static String getTimeStamp() {
        String strTimestamp = String.valueOfGmt(DateTime.now());
        return strTimestamp.remove('-').remove(':').deleteWhitespace();
    }

    // encode the passkey 
    public static String encodedPassKey() {
        Blob passkey = Blob.valueOf( BUSINESS_TILL_NUMBER+TILL_PASSWORD+getTimeStamp());
        return EncodingUtil.base64Encode(passkey);
    }

    // push mpesa payment to customer
    public static void tillNumberPayment(String recordId) { 
        Opportunity oppty = [SELECT Id, 
                                    Amount, 
                                    Phone_Number__c 
                            FROM Opportunity 
                            WHERE Id =:recordId 
                            LIMIT 1];

        Long customerNumber     = Long.valueOf(oppty.Phone_Number__c); 
        Double amountToPay      = Double.valueOf(oppty.Amount);
        String accountReference = 'MWAS MADE THIS'; //TODO: Add name e.g Company name to be displayed on the STK Push request on phone.
        String transactionDesc  = oppty.Id; //TODO: Add unique identifier e.g. recordId for the item being paid for
        
        MpesaStkPush reqBody = new MpesaStkPush(BUSINESS_TILL_NUMBER,
                                                encodedPassKey(),
                                                getTimeStamp(),
                                                TRANSACTION_TYPE,
                                                amountToPay,
                                                customerNumber,
                                                BUSINESS_TILL_NUMBER,
                                                customerNumber,
                                                CALL_BACK_URL,
                                                accountReference,
                                                transactionDesc);
        // make the http request
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer '+ACCESS_TOKEN);
        req.setEndpoint(STK_PUSH_URL);
        req.setBody(JSON.serialize(reqBody));
        
        try {
            HttpResponse res = http.send(req);
            system.debug('Status Code: '+ res.getStatusCode());
            if (res.getStatusCode() == 200) {
                System.debug('Response Body: '+res.getBody());
            }
        } catch (CalloutException e) {
            System.debug('Callout Error '+ e.getMessage());
        }
    }
    // Constructor for STK Push payload
    public MpesaStkPush(Integer businessShortCode,
                        String  password,
                        String  timestamp,
                        String  transactionType,
                        Double  amount,
                        Long    partyA,
                        Integer partyB,
                        Long    phoneNumber,
                        String  callBackURL,
                        String  accountReference,
                        String  transactionDesc) {
        this.businessShortCode = BusinessShortCode;
        this.password          = Password;
        this.timestamp         = Timestamp;
        this.transactionType   = TransactionType;
        this.amount            = Amount;
        this.partyA            = PartyA;
        this.partyB            = PartyB;
        this.phoneNumber       = PhoneNumber;
        this.callBackURL       = CallBackURL;
        this.accountReference  = AccountReference;
        this.transactionDesc   = TransactionDesc;
    }
}
