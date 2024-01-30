import 'dart:async';
import 'dart:typed_data';
import 'auth.dart';

class AuthBLoc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  AuthBLoc() : super(AuthStateInitial()) {
    on<AuthLoginEvent>(_loginMethod);
    on<AuthSignupEvent>(_signupMethod);
  }
  FutureOr<void> _loginMethod(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await auth.signInWithEmailAndPassword(
          email: event.email, password: event.password);

      emit(AuthLoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthLoginFailed(e.message!));
    }
  }

  FutureOr<void> _signupMethod(
      AuthSignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);
      var image = await uploadImage(event.imageFile);
      User user = userCredential.user!;
      await user.updateDisplayName(event.firstName);
      await user.updatePhotoURL(image);
      print(image);
      print(auth.currentUser!.displayName);
      await firestore.collection("users").doc(userCredential.user!.uid).set({
        "firstName": event.firstName,
        "lastName": event.lastName,
        "age": event.age,
        "email": event.email,
        "image": image,
      });
      emit(AuthSignupSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthSignupFailed(e.message!));
    }
  }

  Future<String> uploadImage(Uint8List file) async {
    var ref = storage.ref().child("images");
    var uploadTask = await ref.putData(file);
    var downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }
}
