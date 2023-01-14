String API_GET_BASE =
    'https://the-trivia-api.com/api/questions?limit=1&categories=';

class QuestionCategory {
  final String categoryName;
  final String apiCall;
  const QuestionCategory(this.categoryName, this.apiCall);
}

final List<QuestionCategory> availableCategories = [
  QuestionCategory("Arts and Literature", "arts_and_literature"),
  QuestionCategory("Film and TV", "film_and_tv"),
  QuestionCategory("Food and drink", "food_and_drink"),
  QuestionCategory("General knowledge", "general_knowledge"),
  QuestionCategory("Geography", "geography"),
  QuestionCategory("history", "history"),
  QuestionCategory("music", "music"),
  QuestionCategory("science", "science"),
  QuestionCategory("Society and Culture", "society_and_culture"),
  QuestionCategory("Sport and leisure", "sport_and_leisure"),
];

String createAPIcall(List<int> indexOfCategories) {
  if (indexOfCategories.length == 0) {
    return "";
  }
  String apiRequest =
      API_GET_BASE; // + availableCategories[indexOfCategories[0]];
  for (int i = 0; i < indexOfCategories.length; i++) {
    apiRequest = apiRequest + availableCategories[indexOfCategories[i]].apiCall;
    if (i < indexOfCategories.length - 1) {
      apiRequest = apiRequest + ",";
    }
  }
  return apiRequest;
}
