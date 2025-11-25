# Scripts Directory

This directory contains utility scripts for managing the WeeklyMenu project.

## `reset_database.py`

This Python script is designed to completely clear the Firestore database for testing and development purposes. It deletes all specified top-level collections and all user-specific data, ensuring a clean slate.

**WARNING: This script will permanently delete data from your Firestore project. Use with extreme caution, especially in production environments.**

### Setup Instructions

1.  **Install Firebase Admin SDK:**
    If you haven't already, install the Firebase Admin SDK for Python:
    ```bash
    pip install firebase-admin
    ```

2.  **Obtain a Firebase Service Account Key:**
    The script authenticates with your Firebase project using a service account key.
    -   Go to your Firebase project in the Firebase Console.
    -   Navigate to **Project settings** (the gear icon) > **Service accounts**.
    -   Click on "Generate new private key" and then "Generate key". This will download a JSON file (e.g., `your-project-name-firebase-adminsdk-xxxxx-xxxxx.json`).
    -   **Rename** this downloaded JSON file to `serviceAccountKey.json`.
    -   **Place** the `serviceAccountKey.json` file directly into this `scripts/` directory.
    -   **Important:** Add `serviceAccountKey.json` to your `.gitignore` file to prevent accidentally committing it to version control, especially in public repositories.

### Usage

To run the script and reset your Firestore database:

1.  Ensure you have followed the [Setup Instructions](#setup-instructions).
2.  Navigate to the project's root directory in your terminal.
3.  Execute the script:
    ```bash
    python scripts/reset_database.py
    ```
4.  The script will prompt you for confirmation before proceeding with the deletion. Type `yes` to confirm.

### Deletion Scope

The `reset_database.py` script performs the following deletions:

-   **Old Top-Level Collections:**
    -   `/recipes` (all documents within)
    -   `/weekly_menus` (all documents within)
-   **User Data and Subcollections:**
    -   The entire `/users` collection. For each user document within `/users`, it will:
        -   Delete its `/recipes` subcollection.
        -   Delete its `/weekly_menus` subcollection.
        -   Delete its `/preferences` subcollection (including any nested documents like `settings`).
        -   Finally, delete the user document itself.

This ensures a comprehensive cleanup suitable for starting fresh during testing cycles.
