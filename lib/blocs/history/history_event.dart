sealed class HistoryEvents {}

final class GetHistoryEvent extends HistoryEvents {}

final class AddHistoryEvent extends HistoryEvents {
  final String code;

  AddHistoryEvent({
    required this.code,
  });
}

final class DeleteHistoryEvent extends HistoryEvents {
  final int id;

  DeleteHistoryEvent({required this.id});
}
