/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Run this function after pressing Claim Item button
exports.sendNotificationOnClaim = functions.https.onCall(async (data, context) => {
    const { fcmToken, title, body } = data;

    const message = {
        token: fcmToken,
        notification: {
            title: title,
            body: body,
        }
    };
    
    try {
        const response = await admin.messaging().send(message);
        console.log('Successfully sent message:', response);
        return { success: true };
    } catch (error) {
        console.error('Error sending message:', error);
        return { success: false, error: error.message};
    }
})