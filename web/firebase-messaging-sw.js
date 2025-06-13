importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyB_qZT4ORvCMcBMC-HzNgU7JQrYizDmZNg",
  authDomain: "tea-routine.firebaseapp.com",
  projectId: "tea-routine",
  messagingSenderId: "579243881828",
  appId: "1:579243881828:web:425096d802a98eddcd3671"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Mensagem em background:', payload);
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
    icon: '/firebase-logo.png' // opcional
  });
});
