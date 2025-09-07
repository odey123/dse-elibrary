const functions = require('firebase-functions');
const admin = require('firebase-admin');
const cors = require('cors')({ origin: true });
const { getStorage } = require('firebase-admin/storage');
const axios = require("axios");
const { Parser } = require("json2csv");
// var serviceAccount = require("C:/Users/user/Downloads/dse-elibrary-75930-firebase-adminsdk-fbsvc-9ef43177b0");

admin.initializeApp(
    // {
    //     credential: admin.credential.cert(serviceAccount),
    //     databaseURL: "https://dse-elibrary-75930-default-rtdb.firebaseio.com"
    // }
);

// const users = [
//     { email: 'systemselibrarya01@gmail.com', password: 'Systems@1999', },
// ]

// users.forEach(async (user) => {
//     try {
//         const userRecord = await admin.auth().createUser({
//             email: user.email,
//             password: user.password,
//             emailVerified: true,
//         });

//         // Set custom claims to mark as admin
//         await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });

//         console.log(`Admin user created with UID: ${userRecord.uid}`);

//     } catch (error) {
//         console.error('Error creating admin user:', error);
//     }

// })

exports.onboardStudent = functions.https.onCall(async (requests, response) => {
    try {
        const { firstName, lastName, email, level, gender, UId } = requests.data;

        const userRecord = await admin.auth().getUser(UId);
        const claims = userRecord.customClaims || {};

        if (!(claims.admin || claims.role === "hod")) {
            throw new functions.https.HttpsError("permission-denied", "Only admins can onboard students.");
        }

        if (!firstName || !lastName || !email || !level || !gender || !UId) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required fields.");
        }

        const password = lastName.toLowerCase();
        const minLength = 6;
        const finalPassword = password.length < minLength
            ? password + '#'.repeat(minLength - password.length)
            : password;

        let newUser;
        try {
            newUser = await admin.auth().createUser({
                email: email,
                password: finalPassword,
                emailVerified: true,
                displayName: `${firstName} ${lastName}`,
            });
        } catch (authError) {
            switch (authError.code) {
                case "auth/email-already-exists":
                    throw new functions.https.HttpsError("already-exists", "A user with this email already exists.");
                case "auth/invalid-email":
                    throw new functions.https.HttpsError("invalid-argument", "The email address is invalid.");
                case "auth/operation-not-allowed":
                    throw new functions.https.HttpsError("failed-precondition", "Email/password authentication is disabled.");
                case "auth/weak-password":
                    throw new functions.https.HttpsError("invalid-argument", "The password is too weak.");
                case "permission-denied":
                    throw new functions.https.HttpsError("permission-denied", "You do not have permission to create this user.");
                default:
                    throw new functions.https.HttpsError("internal", authError.message);
            }
        }

        try {
            await admin.auth().setCustomUserClaims(newUser.uid, { role: "student" });
        } catch (claimsError) {
            throw new functions.https.HttpsError("internal", "Failed to set custom claims.");
        }

        try {
            await admin.firestore().collection("students").doc(newUser.uid).set({
                first_name: firstName,
                last_name: lastName,
                email: email,
                level: level,
                gender: gender,
                uid: newUser.uid,
                role: 'student',
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                search_text: `${firstName.toLowerCase()}${lastName.toLowerCase()}`,
            });
        } catch (firestoreError) {
            switch (firestoreError.code) {
                case "permission-denied":
                    throw new functions.https.HttpsError("permission-denied", "You do not have permission to write to Firestore.");
                case "deadline-exceeded":
                    throw new functions.https.HttpsError("deadline-exceeded", "Request took too long, please try again.");
                case "resource-exhausted":
                    throw new functions.https.HttpsError("resource-exhausted", "Too many requests, please try later.");
                default:
                    throw new functions.https.HttpsError("internal", firestoreError.message);
            }
        }

        return {
            success: true,
            message: `Student ${firstName} ${lastName} onboarded successfully.`,
            uid: newUser.uid,
        };
    } catch (error) {
        console.error("Error onboarding student:", error);
        throw new functions.https.HttpsError(error.code || "internal", error.message);
    }
});

exports.onboardStudentsFromCSV = functions.https.onCall(async (requests, response) => {
    try {
        const { students, UId } = requests.data;

        const userRecord = await admin.auth().getUser(UId);
        const claims = userRecord.customClaims || {};

        if (!Array.isArray(students)) {
            throw new functions.https.HttpsError("invalid-argument", "Students data must be an array.");
        }

        if (!(claims.admin || claims.role === "hod")) {
            throw new functions.https.HttpsError("permission-denied", "Only admins can onboard students.");
        }

        let onboardedStudents = [];

        for (const student of students) {
            const firstName = student['First Name'];
            const lastName = student['Last Name'];
            const email = student['Email'];
            const level = student['Level'];
            const gender = student['Gender'];

            // Check for missing fields
            if (!firstName || !lastName || !email || !level || !gender) {
                continue;
            }

            const password = lastName.toLowerCase();
            const finalPassword = password.length < 6 ? password + '#'.repeat(6 - password.length) : password;

            let newUser;
            try {
                newUser = await admin.auth().createUser({
                    email: email,
                    password: finalPassword,
                    emailVerified: true,
                    displayName: `${firstName} ${lastName}`,
                });
            } catch (authError) {
                console.error(`Error creating user for ${email}: ${authError.message}`);
                continue;
            }

            try {
                await admin.auth().setCustomUserClaims(newUser.uid, { role: "student" });
            } catch (claimsError) {
                console.error(`Error setting custom claims for ${email}: ${claimsError.message}`);
                continue;
            }

            try {
                await admin.firestore().collection("students").doc(newUser.uid).set({
                    first_name: firstName,
                    last_name: lastName,
                    email: email,
                    level: level,
                    gender: gender,
                    uid: newUser.uid,
                    role: 'student',
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                    search_text: `${firstName.toLowerCase()}${lastName.toLowerCase()}`,
                });
            } catch (firestoreError) {
                console.error(`Error saving student data for ${email}: ${firestoreError.message}`);
                continue;
            }

            onboardedStudents.push({ firstName, lastName, email, uid: newUser.uid });
        }

        return {
            success: true,
            message: `${onboardedStudents.length} students onboarded successfully.`,
            onboardedStudents
        };
    } catch (error) {
        console.error("Error onboarding students:", error);
        throw new functions.https.HttpsError("internal", error.message);
    }
});

exports.onboardLecturer = functions.https.onCall(async (requests, response) => {
    try {
        const {
            firstName,
            lastName,
            email,
            preferredAcademicName,
            prefix,
            levelCourseAdvisor,
            gender,
            UId,
        } = requests.data;

        const userRecord = await admin.auth().getUser(UId);
        const claims = userRecord.customClaims || {};

        if (!(claims.admin || claims.role === "hod")) {
            throw new functions.https.HttpsError("permission-denied", "Only admins can onboard students.");
        }

        if (!firstName || !lastName || !email || !preferredAcademicName || !prefix || !levelCourseAdvisor || !gender || !UId) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required fields.");
        }

        const password = lastName.toLowerCase();
        const minLength = 6;
        const finalPassword = password.length < minLength
            ? password + '#'.repeat(minLength - password.length)
            : password;

        let newUser;
        try {
            newUser = await admin.auth().createUser({
                email: email,
                password: finalPassword,
                emailVerified: true,
                displayName: `${preferredAcademicName}`,
            });
        } catch (authError) {
            switch (authError.code) {
                case "auth/email-already-exists":
                    throw new functions.https.HttpsError("already-exists", "A user with this email already exists.");
                case "auth/invalid-email":
                    throw new functions.https.HttpsError("invalid-argument", "The email address is invalid.");
                case "auth/operation-not-allowed":
                    throw new functions.https.HttpsError("failed-precondition", "Email/password authentication is disabled.");
                case "auth/weak-password":
                    throw new functions.https.HttpsError("invalid-argument", "The password is too weak.");
                case "permission-denied":
                    throw new functions.https.HttpsError("permission-denied", "You do not have permission to create this user.");
                default:
                    throw new functions.https.HttpsError("internal", authError.message);
            }
        }

        try {
            await admin.auth().setCustomUserClaims(newUser.uid, { role: "lecturer" });
        } catch (claimsError) {
            throw new functions.https.HttpsError("internal", "Failed to set custom claims.");
        }

        try {
            await admin.firestore().collection("lecturers").doc(newUser.uid).set({
                first_name: firstName,
                last_name: lastName,
                email: email,
                preferred_academic_name: preferredAcademicName,
                prefix: prefix,
                level_course_advisor: levelCourseAdvisor,
                gender: gender,
                uid: newUser.uid,
                role: 'lecturer',
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                search_text: `${firstName.toLowerCase()}${lastName.toLowerCase()}`,
            });
        } catch (firestoreError) {
            switch (firestoreError.code) {
                case "permission-denied":
                    throw new functions.https.HttpsError("permission-denied", "You do not have permission to write to Firestore.");
                case "deadline-exceeded":
                    throw new functions.https.HttpsError("deadline-exceeded", "Request took too long, please try again.");
                case "resource-exhausted":
                    throw new functions.https.HttpsError("resource-exhausted", "Too many requests, please try later.");
                default:
                    throw new functions.https.HttpsError("internal", firestoreError.message);
            }
        }

        return {
            success: true,
            message: `Lecturer ${preferredAcademicName} onboarded successfully.`,
            uid: newUser.uid,
        };
    } catch (error) {
        console.error("Error onboarding lecturer:", error);
        throw new functions.https.HttpsError(error.code || "internal", error.message);
    }
});

exports.onboardHod = functions.https.onCall(async (requests, response) => {
    try {
        const { firstName, lastName, email, preferredAcademicName, prefix, levelCourseAdvisor, gender, UId } = requests.data;

        const userRecord = await admin.auth().getUser(UId);
        const claims = userRecord.customClaims || {};

        if (!claims.admin) {
            throw new functions.https.HttpsError("permission-denied", "Only admins can onboard HODs.");
        }

        if (!firstName || !lastName || !email || !preferredAcademicName || !prefix || !levelCourseAdvisor || !gender || !UId) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required fields.");
        }

        const password = lastName.toLowerCase();
        const minLength = 6;
        const finalPassword = password.length < minLength
            ? password + '#'.repeat(minLength - password.length)
            : password;

        let newUser;
        try {
            newUser = await admin.auth().createUser({
                email: email,
                password: finalPassword,
                emailVerified: true,
                displayName: `${preferredAcademicName}`,
            });
        } catch (authError) {
            switch (authError.code) {
                case "auth/email-already-exists":
                    throw new functions.https.HttpsError("already-exists", "A user with this email already exists.");
                case "auth/invalid-email":
                    throw new functions.https.HttpsError("invalid-argument", "The email address is invalid.");
                case "auth/operation-not-allowed":
                    throw new functions.https.HttpsError("failed-precondition", "Email/password authentication is disabled.");
                case "auth/weak-password":
                    throw new functions.https.HttpsError("invalid-argument", "The password is too weak.");
                case "permission-denied":
                    throw new functions.https.HttpsError("permission-denied", "You do not have permission to create this user.");
                default:
                    throw new functions.https.HttpsError("internal", authError.message);
            }
        }

        // Set custom role as hod
        try {
            await admin.auth().setCustomUserClaims(newUser.uid, { role: "hod" });
        } catch (claimsError) {
            throw new functions.https.HttpsError("internal", "Failed to set custom claims.");
        }

        try {
            await admin.firestore().collection("hod").doc(newUser.uid).set({
                first_name: firstName,
                last_name: lastName,
                email: email,
                preferred_academic_name: preferredAcademicName,
                prefix: prefix,
                level_course_advisor: levelCourseAdvisor,
                gender: gender,
                uid: newUser.uid,
                role: "hod",
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                search_text: `${firstName.toLowerCase()}${lastName.toLowerCase()}`,
            });
        } catch (firestoreError) {
            switch (firestoreError.code) {
                case "permission-denied":
                    throw new functions.https.HttpsError("permission-denied", "You do not have permission to write to Firestore.");
                case "deadline-exceeded":
                    throw new functions.https.HttpsError("deadline-exceeded", "Request took too long, please try again.");
                case "resource-exhausted":
                    throw new functions.https.HttpsError("resource-exhausted", "Too many requests, please try later.");
                default:
                    throw new functions.https.HttpsError("internal", firestoreError.message);
            }
        }

        return {
            success: true,
            message: `HOD ${prefix} ${preferredAcademicName} (${firstName} ${lastName}) onboarded successfully.`,
            uid: newUser.uid,
        };
    } catch (error) {
        console.error("Error onboarding HOD:", error);
        throw new functions.https.HttpsError(error.code || "internal", error.message);
    }
});

exports.deleteUsersFromAuth = functions.https.onCall(async (requests, response) => {
    try {
        const { uids, UId } = requests.data;

        const userRecord = await admin.auth().getUser(UId);
        const claims = userRecord.customClaims || {};

        if (!(claims.admin || claims.role === "hod")) {
            throw new functions.https.HttpsError("permission-denied", "Only admins can upgrade data.");
        }

        // Loop through each UID and delete the corresponding user from Firebase Authentication
        for (const uid of uids) {
            try {
                await admin.auth().deleteUser(uid);
                console.log(`User with UID ${uid} deleted successfully.`);
            } catch (error) {
                console.log(`Error deleting user with UID ${uid}: ${error.message}`);
            }
        }

        return { success: true, message: "Users deleted successfully from Firebase Authentication." };

    } catch (error) {
        console.error("Error deleting users from Firebase Authentication:", error);
        throw new functions.https.HttpsError(error.code || "internal", error.message);
    }
});

exports.addCourse = functions.https.onCall(async (requests, response) => {
    try {
        const { courseName, courseCode, unit, level, semester, ownerUid, ownerName } = requests.data;

        if (!courseName || !courseCode || !unit || !level || !semester || !ownerUid || !ownerName) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required fields.");
        }

        const userRecord = await admin.auth().getUser(ownerUid);
        const claims = userRecord.customClaims || {};

        if (claims.role !== "lecturer" || claims.role !== "hod") {
            throw new functions.https.HttpsError("permission-denied", "Only lecturers can add courses.");
        }

        // Check if courseCode already exists
        const existingCourseQuery = await admin.firestore()
            .collection("courses")
            .where("course_code", "==", courseCode)
            .limit(1)
            .get();

        if (!existingCourseQuery.empty) {
            const existingDoc = existingCourseQuery.docs[0];
            const existingOwners = existingDoc.data().owner_uid || [];

            // Avoid duplicate UIDs
            if (!existingOwners.includes(ownerUid)) {
                await existingDoc.ref.update({
                    owner_uid: admin.firestore.FieldValue.arrayUnion(ownerUid)
                });
            }

            return {
                success: true,
                message: `You’ve been added as a co-owner to course ${courseCode} - ${courseName}.`,
            };
        }


        try {
            const courseRef = admin.firestore().collection("courses").doc();
            await courseRef.set({
                course_name: courseName,
                course_code: courseCode,
                unit: unit,
                level: level,
                semester: semester,
                owner_uid: [ownerUid],
                owner_name: ownerName,
                course_id: courseRef.id,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
            });
        } catch (firestoreError) {
            switch (firestoreError.code) {
                case "permission-denied":
                    throw new functions.https.HttpsError("permission-denied", "You do not have permission to write to Firestore.");
                case "deadline-exceeded":
                    throw new functions.https.HttpsError("deadline-exceeded", "Request took too long, please try again.");
                case "resource-exhausted":
                    throw new functions.https.HttpsError("resource-exhausted", "Too many requests, please try later.");
                default:
                    throw new functions.https.HttpsError("internal", firestoreError.message);
            }
        }

        return {
            success: true,
            message: `Course ${courseCode} - ${courseName} added successfully.`,
        };
    } catch (error) {
        console.error("Error adding course:", error);
        throw new functions.https.HttpsError(error.code || "internal", error.message);
    }
});

exports.getPdfBase64 = functions.https.onCall(async (request, response) => {
    try {
        const { filePath, requesterUid } = request.data;

        if (!filePath || !requesterUid) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required fields.");
        }

        const bucket = admin.storage().bucket();
        const file = bucket.file(filePath);

        const [exists] = await file.exists();
        if (!exists) {
            throw new functions.https.HttpsError("not-found", "The requested file does not exist.");
        }

        const [contents] = await file.download();
        const base64String = contents.toString('base64');

        return {
            success: true,
            base64: base64String,
            message: "PDF fetched and encoded successfully.",
        };

    } catch (error) {
        console.error("Error fetching PDF:", error);
        throw new functions.https.HttpsError(error.code || "internal", error.message);
    }
});

exports.getPdfBase64FromUrl = functions.https.onCall(async (request, response) => {
    try {
        const { fileUrl, requesterUid } = request.data;

        if (!fileUrl || !requesterUid) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required fields.");
        }

        // Fetch PDF file from public download URL
        const response = await axios.get(fileUrl, {
            responseType: "arraybuffer",
        });

        const base64String = Buffer.from(response.data).toString("base64");

        return {
            success: true,
            base64: base64String,
            message: "PDF fetched and encoded successfully.",
        };

    } catch (error) {
        console.error("Error fetching PDF from URL:", error);
        throw new functions.https.HttpsError("internal", error.message || "Something went wrong.");
    }
});

exports.exportStudentsToCSV = functions.https.onCall(async (request, response) => {
    try {
        const { uid } = request.data;

        // Check if the user is an admin
        const user = await admin.auth().getUser(uid);
        const claims = user.customClaims || {};
        if (!(claims.admin || claims.role === "hod")) {
            throw new functions.https.HttpsError('permission-denied', 'Only admins can export data.');
        }

        // Fetch the students data
        const studentsRef = admin.firestore().collection('students');
        const snapshot = await studentsRef.get();

        if (snapshot.empty) {
            throw new functions.https.HttpsError('not-found', 'No students found.');
        }

        // Process the students data
        const studentsData = [];
        snapshot.forEach(doc => {
            const student = doc.data();
            studentsData.push({
                first_name: student.first_name,
                last_name: student.last_name,
                gender: student.gender,
                email: student.email,
                level: student.level
            });
        });

        // Define CSV fields
        const fields = [
            { label: 'First Name', value: 'first_name' },
            { label: 'Last Name', value: 'last_name' },
            { label: 'Gender', value: 'gender' },
            { label: 'Email', value: 'email' },
            { label: 'Level', value: 'level' }
        ];

        // Use a CSV writer to convert the data to CSV format
        const parser = new Parser({ fields });
        const csv = parser.parse(studentsData);
        const base64Csv = Buffer.from(csv).toString("base64");

        return {
            filename: `students_data.csv`,
            base64Csv,
        };

    } catch (error) {
        console.error("CSV Export Error:", error);
        throw new functions.https.HttpsError(error.code || 'internal', error.message);
    }
});

exports.exportLecturersToCSV = functions.https.onCall(async (request, response) => {
    try {
        const { uid } = request.data;

        // Check if the user is an admin
        const user = await admin.auth().getUser(uid);
        const claims = user.customClaims || {};
        if (!(claims.admin || claims.role === "hod")) {
            throw new functions.https.HttpsError('permission-denied', 'Only admins can export data.');
        }

        // Fetch the students data
        const lecturersRef = admin.firestore().collection('lecturers');
        const snapshot = await lecturersRef.get();

        if (snapshot.empty) {
            throw new functions.https.HttpsError('not-found', 'No lecturers found.');
        }

        // Process the students data
        const lecturersData = [];
        snapshot.forEach(doc => {
            const lecturer = doc.data();
            lecturersData.push({
                preferred_academic_name: lecturer.preferred_academic_name,
                gender: lecturer.gender,
                email: lecturer.email,
                level_course_advisor: lecturer.level_course_advisor
            });
        });

        // Define CSV fields
        const fields = [
            { label: 'Name', value: 'preferred_academic_name' },
            { label: 'Gender', value: 'gender' },
            { label: 'Email', value: 'email' },
            { label: 'Level Course Advisor', value: 'level_course_advisor' }
        ];

        // Use a CSV writer to convert the data to CSV format
        const parser = new Parser({ fields });
        const csv = parser.parse(lecturersData);
        const base64Csv = Buffer.from(csv).toString("base64");

        return {
            filename: `lecturers_data.csv`,
            base64Csv,
        };

    } catch (error) {
        console.error("CSV Export Error:", error);
        throw new functions.https.HttpsError(error.code || 'internal', error.message);
    }
});

exports.exportHODToCSV = functions.https.onCall(async (request, response) => {
    try {
        const { uid } = request.data;

        // Check if the user is an admin
        const user = await admin.auth().getUser(uid);
        const claims = user.customClaims || {};
        if (!claims.admin) {
            throw new functions.https.HttpsError('permission-denied', 'Only admins can export data.');
        }

        // Fetch the students data
        const hodsRef = admin.firestore().collection('hod');
        const snapshot = await hodsRef.get();

        if (snapshot.empty) {
            throw new functions.https.HttpsError('not-found', 'No HOD found.');
        }

        // Process the students data
        const hodData = [];
        snapshot.forEach(doc => {
            const hod = doc.data();
            hodData.push({
                preferred_academic_name: hod.preferred_academic_name,
                gender: hod.gender,
                email: hod.email,
                level_course_advisor: hod.level_course_advisor
            });
        });

        // Define CSV fields
        const fields = [
            { label: 'Name', value: 'preferred_academic_name' },
            { label: 'Gender', value: 'gender' },
            { label: 'Email', value: 'email' },
            { label: 'Level Course Advisor', value: 'level_course_advisor' }
        ];

        // Use a CSV writer to convert the data to CSV format
        const parser = new Parser({ fields });
        const csv = parser.parse(hodData);
        const base64Csv = Buffer.from(csv).toString("base64");

        return {
            filename: `hod_data.csv`,
            base64Csv,
        };

    } catch (error) {
        console.error("CSV Export Error:", error);
        throw new functions.https.HttpsError(error.code || 'internal', error.message);
    }
});








