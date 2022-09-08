@RestResource(urlMapping='/v1/mpesa-transactions/')
global with sharing class MpesaStkPushWebService {
    public MpesaStkPushWebService() {

    }
    @HttpPost
    global static void postMpesaTransactions() {
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        system.debug('responseMap '+responseMap);

    }
}

// https://daraja-sf-developer-edition.um5.force.com/services/apexrest/v1/mpesa-transactions/

/* Mpesa response body
{    
    "Body": {        
       "stkCallback": {            
          "MerchantRequestID": "29115-34620561-1",            
          "CheckoutRequestID": "ws_CO_191220191020363925",            
          "ResultCode": 0,            
          "ResultDesc": "The service request is processed successfully.",            
          "CallbackMetadata": {                
             "Item": [{                        
                "Name": "Amount",                        
                "Value": 1.00                    
             },                    
             {                        
                "Name": "MpesaReceiptNumber",                        
                "Value": "NLJ7RT61SV"                    
             },                    
             {                        
                "Name": "TransactionDate",                        
                "Value": 20191219102115                    
             },                    
             {                        
                "Name": "PhoneNumber",                        
                "Value": 254708374149                    
             }]            
          }        
       }    
    }
 }
 */