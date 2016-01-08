#Export tiles from service

This sample shows how to export tiles from a tiled map service. The tiled map service must have the export tiles capability enabled. This sample makes use of OAuth 2.0's App Login. This concept is explained in detail on the [developers page](https://developers.arcgis.com/qt/qml/guide/use-oauth-2-0-authentication.htm#ESRI_SECTION1_87EACC3702244E378C0F69E0CEE20A07). In order to use this sample, you must follow the instructions in the previously mentioned help document, and register your app on the developers page. Registering the app will give you a client ID and a client secret. These are what you will need to add into your code.

It is worth noting that this is simply a proof of concept, and that it is not advisable to directly add your client id and client secret directly to your source code. Rather, you should use a proxy or some method of encryption to securely authenticate the app without having credentials directly in the source code.

![image](https://cloud.githubusercontent.com/assets/4107363/12187553/c3c71d68-b561-11e5-8518-00d30f9b04ef.png)