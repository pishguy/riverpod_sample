import 'package:flutter_riverpod/flutter_riverpod.dart';

final libraryStateNotifierProvider = StateNotifierProvider<LibraryNotifier, Library>((ref) => LibraryNotifier());

class LibraryNotifier extends StateNotifier<Library> {
  LibraryNotifier() : super(_initial);
  static Library _initial = Library('', []);

  void clearAll() => state = Library('', []);

  List<Users> getServices({int productId = 1}) {
    final index = state.books.indexWhere((product) => product.bookId == productId);
    return index >= 0 ? state.books[index].users : <Users>[];
  }

  void increment({required int bookId, required int userId}) {
    final newState = Library(state.title, [...state.books]);
    for (final book in newState.books){
      if(book.bookId == bookId){
        int userIndex = book.users.indexWhere((u) => u.userId == userId);
        if(userIndex>=0){
          Users(userId,book.users[userIndex].count+1);
        }
      }
    }

    state = newState;
  }

  void create({required int bookId, required int userId}) {
    state = Library(state.title, [
      Books(bookId, [Users(userId, 1)])
    ]);
  }

  void decrement({required int productId, required int serviceId}) {
  }
}

class Library {
  final String title;
  final List<Books> books;

  const Library(this.title, this.books);
}

class Books {
  final int bookId;
  final List<Users> users;

  Books(this.bookId, this.users);
}

class Users {
  final int userId;
  final int count;

  const Users(this.userId, this.count);
}
