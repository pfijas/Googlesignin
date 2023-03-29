import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

//creating object(_auth) for FirebaseAuth class using instance property
final FirebaseAuth _auth = FirebaseAuth.instance;
//creating object (googleSignIn) for GoogleSignIn class using constructer
// of GoogleSignIn()
final GoogleSignIn googleSignIn = GoogleSignIn();

//creating variables of the type string for get values like name,email,profilepic
// from signin emailid
String? name;
String? email;
String? imageUrl;

//creating a future methode called signInWithGoogle for performing google signin
// in your app to use by multiple users at the same time
Future<String> signInWithGoogle() async {
  //first initializing firebase into your app
  await Firebase.initializeApp();

  //calling signIn method of GoogleSignIn Class using object of GoogleSignIn
  // Class as googleSignIn and stored in googleSignInAccount
  final googleSignInAccount = await googleSignIn.signIn();
  //storing authentication details of signied account using object called
  // googleSignInAccount and stored into googleSignInAuthentication
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
  //to check wheather the signied account is original.
  //for that verifying accessToken and idToken of that mailid with the
  // GoogleAuthProvider and check the crediantials(emailid,password)is correct
  // and original and stored in authCredential object of AuthCredential
     final AuthCredential authCredential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  //if the account is verified or original loginto the app using the user
  // cridentials(email and password)and stored the result in  authResult
  final UserCredential authResult =
      await _auth.signInWithCredential(authCredential);
  //storing details like email name photo from auth result to user object
  final user = authResult.user;


  if (user != null) {
    //checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;
//space between name
    if (name!.contains(" ")) {
      name = name!;
    }

    //check wheather the user is signined using any other methods other than email
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User? currentUser = _auth!.currentUser;
    assert(user.uid == currentUser!.uid);

    print('signInWithGoogle succeeded:$user');
    return '$user';
  }

  return '';
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed out");
}
