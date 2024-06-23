class Team {
  final String teamId;
  final String teamName;
  final String projectName;
  final String supervisor;
  final String startDate;
  final String teamsImage;
  final List<String> teamMembers;

  
  Team({
    required this.teamId,
    required this.teamName,
    required this.projectName,
    required this.supervisor,
    required this.startDate,
    required this.teamsImage,
    required this.teamMembers,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['teamId'],
      teamName: json['teamName'],
      projectName: json['projectName'],
      supervisor: json['supervisor'],
      startDate: json['startDate'],
      teamsImage: json['teamsImage'],
      teamMembers: List<String>.from(json['teamMembers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamName': teamName,
      'projectName': projectName,
      'supervisor': supervisor,
      'startDate': startDate,
      'teamsImage': teamsImage,
      'teamMembers': teamMembers,
    };
  }
}
