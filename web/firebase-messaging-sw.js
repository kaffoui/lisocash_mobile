importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
  apiKey: "AIzaSyDSKJI2BYn8xeOZ8lIYkUpmS4dmkk4pju0",
       authDomain: "lisocash-9980b.firebaseapp.com",
       projectId: "lisocash-9980b",
       storageBucket: "lisocash-9980b.appspot.com",
       messagingSenderId: "845217810394",
       appId: "1:845217810394:web:2bb6ebb6b6fe499cda22e3",
       measurementId: "G-27HYJ139N3",
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});