enum AudioStateExt {
  ready(profileIcon: 'mic.png',),
  play(profileIcon: 'stop.png',),
  stop(profileIcon: 'play.png',),
  recording(profileIcon: 'stop.png',),
  ;

  final String profileIcon;

  const AudioStateExt({
    required this.profileIcon,
  });
}