@RestResource(urlMapping='/v1/mpesa-transactions/')
global with sharing class MpesaStkPushWebService {
    public MpesaStkPushWebService() {

    }
    @HttpPost
    global static void postMpesaTransactions() {
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        system.debug('responseMap '+responseMap);

        // extract the body from the response
        Map<String, Object> body = (Map<String, Object>)responseMap.get('Body');
        system.debug('body '+body);

        // extract the stkCallback object from the body
        Map<String, Object> stkCallback = (Map<String, Object>)body.get('stkCallback');
        system.debug('stkCallback '+stkCallback);

        // extract the CallbackMetadata object from the stkCallback object
        Map<String, Object> CallbackMetadata = (Map<String, Object>)stkCallback.get('CallbackMetadata');
        system.debug('CallbackMetadata '+CallbackMetadata);

        // extract mpesa items from the CallbackMetadata object
        List<Object> mpesaItems = (List<Object>)CallbackMetadata.get('Item');
        for (Object mpesaItem : mpesaItems) {
            system.debug('mpesaItem '+mpesaItems);
        }
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