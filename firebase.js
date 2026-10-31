import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";

const firebaseConfig = {
  apiKey: "AIzaSyDqMUyzmjENFG9gtUYTQl74PVzJkErgcus",
  authDomain: "a-g-store-ec785.firebaseapp.com",
  projectId: "a-g-store-ec785",
  storageBucket: "a-g-store-ec785.firebasestorage.app",
  messagingSenderId: "71612385194",
  appId: "1:71612385194:web:a08128d55434d6ac1ccdd3"
};

const app = initializeApp(firebaseConfig);

window.firebaseAuth = getAuth(app);
window.firebaseDb = getFirestore(app);
window.firebaseStorage = getStorage(app);
