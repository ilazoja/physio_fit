import * as functions from 'firebase-functions';
import * as sgMail from "@sendgrid/mail";

const API_KEY = functions.config().sendgrid.key;
const TEMPLATE_ID = functions.config().sendgrid.template;
sgMail.setApiKey(API_KEY);

export default functions.https.onCall(
  async (data, context) => {
    const msg = {
      to: data.email,
      from: "info.xenonlabs@gmail.com",
      templateId: TEMPLATE_ID,
      dynamic_template_data: {
        subject: data.subject,
        name: data.name,
        body: data.body
      }
    };

    await sgMail.send(msg);

    return { success: true };
  }
);