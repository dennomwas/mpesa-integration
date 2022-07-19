public with sharing class AuthorizeMpesa {
    private static final Safaricom_mpesa__mdt varMpesa = Safaricom_mpesa__mdt.getInstance('mpesa_variables');
    private static final String CONSUMER_KEY           = varMpesa.Consumer_key__c;
    private static final String CONSUMER_SECRET        = varMpesa.Consumer_secret__c;
    private static final String AUTH_URL               = varMpesa.Authentication_URL__c;

    public static String getAuthorization() {
        String accessToken;
        Blob credentials = Blob.valueOf(CONSUMER_KEY+':'+CONSUMER_SECRET);
        String authorization = EncodingUtil.base64Encode(credentials);

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(AUTH_URL);
        req.setHeader('Authorization', 'Basic '+authorization);

        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                System.debug('===Response=== '+res.getBody());
                Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
                accessToken = String.valueOf(results.get('access_token'));
            }
        } catch (CalloutException e) {
            System.debug('Callout exception '+ e.getMessage());
        }
        return accessToken;
    }
}