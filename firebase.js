
const firebaseConfig = {
  apiKey: "AIzaSyDqMUyzmjENFG9gtUYTQl74PVzJkErgcus",
  authDomain: "a-g-store-ec785.firebaseapp.com",
  projectId: "a-g-store-ec785",
  storageBucket: "a-g-store-ec785.firebasestorage.app",
  messagingSenderId: "71612385194",
  appId: "1:71612385194:web:a08128d55434d6ac1ccdd3"
};

if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig);
}

window.firebaseAuth = firebase.auth();
window.firebaseDb = firebase.firestore();
window.firebaseStorage = firebase.storage();
