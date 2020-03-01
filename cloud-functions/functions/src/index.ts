import * as loadFunctions from 'firebase-function-tools';
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

const config = functions.config().firebase
admin.initializeApp(config)
loadFunctions(__dirname, exports)
