class DocumentHistoryItem {
  final int id;
  final String docName;
  final String status;
  final int userId;

  const DocumentHistoryItem({
    required this.id,
    required this.docName,
    required this.status,
    required this.userId,
  });

  factory DocumentHistoryItem.fromJson(Map<String, dynamic> json) {
    return DocumentHistoryItem(
      id: json['id'],
      docName: json['docName'],
      status: json['status'],
      userId: json['userId'],
    );
  }
}