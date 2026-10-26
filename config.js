
/*
 * A&G Store — Firebase Configuration
 * Firebase Authentication
 * Cloud Firestore
 * Firebase Storage
 *
 * Project ID: a-g-store-ec785
 *
 * ملاحظة:
 * هذا الملف يجهز الاتصال بالخدمات فقط.
 * حماية لوحة التحكم تعتمد أيضًا على قواعد الأمان
 * والتحقق من صلاحيات المسؤول.
 */

// 1. Import Firebase SDK
import { initializeApp } from "firebase/app";

import {
  getAuth,
  setPersistence,
  browserLocalPersistence
} from "firebase/auth";

import {
  getFirestore
} from "firebase/firestore";

import {
  getStorage
} from "firebase/storage";

// 2. Firebase project configuration
const firebaseConfig = {
  apiKey: "AIzaSyDqMUyzmjENFG9gtUYTQl74PVzJkErgcus",
  authDomain: "a-g-store-ec785.firebaseapp.com",
  projectId: "a-g-store-ec785",
  storageBucket: "a-g-store-ec785.firebasestorage.app",
  messagingSenderId: "71612385194",
  appId: "1:71612385194:web:a08128d55434d6ac1ccdd3"
};

// 3. Initialize Firebase
const app = initializeApp(firebaseConfig);

// 4. Initialize Authentication
export const auth = getAuth(app);

// Keep the user signed in across browser sessions.
export const authPersistence = setPersistence(
  auth,
  browserLocalPersistence
);

// 5. Initialize Cloud Firestore
export const db = getFirestore(app);

// 6. Initialize Firebase Storage
export const storage = getStorage(app);

// 7. Export the Firebase application
export default app;

