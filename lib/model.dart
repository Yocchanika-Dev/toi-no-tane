class Task {
  String title;
  int status; // 0:日常の問い 1:調べる 2:研究テーマ
  Task(this.title, [this.status = 0]);
  // Task はタスク名を表す title と、状態を表す status を持つ
}
