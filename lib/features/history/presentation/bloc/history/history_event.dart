sealed class HistoryEvents {}

final class GetHistoryEvent extends HistoryEvents {}

final class AddHistoryEvent extends HistoryEvents {
  final String code;
  final bool isGenerated;

  AddHistoryEvent({
    required this.code,
    required this.isGenerated,
  });
}

final class DeleteHistoryEvent extends HistoryEvents {
  final int id;

  DeleteHistoryEvent({required this.id});
}
