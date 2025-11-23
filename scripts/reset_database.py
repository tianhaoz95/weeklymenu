import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os

# Path to your service account key file
# Make sure this file is secure and NOT committed to version control
SERVICE_ACCOUNT_KEY_PATH = 'serviceAccountKey.json'

# --- Helper function for recursive deletion (as Firestore Admin SDK delete() for doc doesn't delete subcollections) ---
def delete_collection(coll_ref, batch_size):
    docs = coll_ref.limit(batch_size).stream()
    deleted = 0

    for doc in docs:
        print(f'Deleting doc {doc.id} from collection {coll_ref.id}')
        # Recursively delete subcollections of the document
        for subcollection_ref in doc.reference.collections():
            delete_collection(subcollection_ref, batch_size)
        doc.reference.delete()
        deleted = deleted + 1

    if deleted >= batch_size:
        return delete_collection(coll_ref, batch_size)

# --- Main reset function ---
def reset_firestore(db, batch_size=100):
    print("Starting Firestore database reset...")

    # 1. Delete old top-level /recipes collection
    print("\nDeleting top-level 'recipes' collection (old structure)...")
    delete_collection(db.collection('recipes'), batch_size)
    print("Finished deleting top-level 'recipes' collection.")

    # 2. Delete old top-level /weekly_menus collection
    print("\nDeleting top-level 'weekly_menus' collection (old structure)...")
    delete_collection(db.collection('weekly_menus'), batch_size)
    print("Finished deleting top-level 'weekly_menus' collection.")

    # 3. Delete /users collection and all its subcollections
    print("\nDeleting 'users' collection and all its subcollections...")
    users_ref = db.collection('users')
    users_docs = users_ref.stream()

    for user_doc in users_docs:
        user_id = user_doc.id
        print(f"  Deleting data for user: {user_id}")

        # Delete subcollections under this user
        # Explicitly list expected subcollections (recipes, weekly_menus, preferences)
        # Firestore SDK list_collections() only shows direct subcollections
        # For simplicity in this script, we'll assume these fixed subcollection names
        
        # Delete /users/{user_id}/recipes
        print(f"    Deleting /users/{user_id}/recipes...")
        delete_collection(users_ref.document(user_id).collection('recipes'), batch_size)

        # Delete /users/{user_id}/weekly_menus
        print(f"    Deleting /users/{user_id}/weekly_menus...")
        delete_collection(users_ref.document(user_id).collection('weekly_menus'), batch_size)
        
        # Delete /users/{user_id}/preferences (and its subcollection 'settings')
        print(f"    Deleting /users/{user_id}/preferences...")
        preferences_ref = users_ref.document(user_id).collection('preferences')
        delete_collection(preferences_ref, batch_size)

        # Delete the user document itself
        user_doc.reference.delete()
        print(f"  Deleted user document: {user_id}")
    
    print("Finished deleting 'users' collection and all its subcollections.")
    print("\nFirestore database reset complete.")

if __name__ == "__main__":
    if not os.path.exists(SERVICE_ACCOUNT_KEY_PATH):
        print(f"Error: Service account key file '{SERVICE_ACCOUNT_KEY_PATH}' not found.")
        print("Please place your Firebase service account key JSON file in the 'scripts' directory.")
        exit(1)

    # Initialize Firebase Admin SDK
    cred = credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH)
    firebase_admin.initialize_app(cred)

    db = firestore.client()

    # Confirm before deleting
    confirm = input("This will delete ALL data in your Firestore project. Are you sure? (yes/no): ")
    if confirm.lower() == 'yes':
        reset_firestore(db)
    else:
        print("Database reset canceled.")
