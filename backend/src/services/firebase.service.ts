import { initializeApp, cert, getApps, App } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';

const STORAGE_BUCKET = process.env.FIREBASE_STORAGE_BUCKET || 'dse-elibrary-75930.firebasestorage.app';
const PROJECT_ID = process.env.FIREBASE_PROJECT_ID || 'dse-elibrary-75930';

function initApp(): App {
  if (getApps().length > 0) return getApps()[0];

  const privateKey = process.env.FIREBASE_PRIVATE_KEY;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;

  if (privateKey && clientEmail) {
    return initializeApp({
      credential: cert({
        projectId: PROJECT_ID,
        privateKey: privateKey.replace(/\\n/g, '\n'),
        clientEmail,
      }),
      storageBucket: STORAGE_BUCKET,
    });
  }

  // Application Default Credentials — works automatically on Firebase Functions / Cloud Run
  return initializeApp({ projectId: PROJECT_ID, storageBucket: STORAGE_BUCKET });
}

initApp();

export const db = getFirestore();
export const bucket = getStorage().bucket();
export { FieldValue };
