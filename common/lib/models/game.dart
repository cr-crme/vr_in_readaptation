import 'dart:convert';

import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'locale_text.dart';
import 'options/options.dart';

class Game extends ItemSerializable {
  final String title;
  final String collection;
  final String console;

  static const String assetsRoot =
      'https://raw.githubusercontent.com/cr-crme/vr_in_readaptation/main/common/lib/assets';

  final String videoPath = '${Game.assetsRoot}/images/placeholder.png';
  final String thumbnailPath = '${Game.assetsRoot}/images/placeholder.png';

  // Information about the game
  final Map<String, String> _description;
  final Map<String, String> _time;
  final Map<String, String> _position;
  final Map<String, String> _numberPlayers;
  final Map<String, String> _progression;
  final Map<String, String> _performanceFeedback;
  final Map<String, String> _resultsFeedback;
  final Map<String, String> _physicalRequirements;
  final Map<String, String> _motorSkills;
  final Map<String, String> _sideNotes;
  final Map<String, String> _cognitiveRequirements;

  // Decision algorithm elements
  final OptionList<UpperExtremity> upperExtremity;
  final OptionList<LowerExtremity> lowerExtremity;
  final OptionList<Contraindications> contraindications;
  final OptionList<GameGoal> goal;
  final OptionList<GameLength> length;
  final Difficulty difficulty;
  final CanSave canSave;

  Game.fromSerialized(Map<String, dynamic> map)
      : title = map['title'],
        collection = map['collection'],
        console = map['console'],
        _description = map['information']['description'].cast<String, String>(),
        _time = map['information']['time'].cast<String, String>(),
        _position = map['information']['position'].cast<String, String>(),
        _numberPlayers =
            map['information']['numberPlayers'].cast<String, String>(),
        _progression = map['information']['progression'].cast<String, String>(),
        _performanceFeedback =
            map['information']['performanceFeedback'].cast<String, String>(),
        _resultsFeedback =
            map['information']['resultsFeedback'].cast<String, String>(),
        _physicalRequirements =
            map['information']['physicalRequirements'].cast<String, String>(),
        _motorSkills = map['information']['motorSkills'].cast<String, String>(),
        _sideNotes = map['information']['sideNotes'].cast<String, String>(),
        _cognitiveRequirements =
            map['information']['cognitiveRequirements'].cast<String, String>(),
        upperExtremity = OptionList<UpperExtremity>.deserialize(
          map['filter']['upper'],
          UpperExtremity.from,
        ),
        lowerExtremity = OptionList<LowerExtremity>.deserialize(
          map['filter']['lower'],
          LowerExtremity.from,
        ),
        contraindications = OptionList<Contraindications>.deserialize(
          map['filter']['contra'],
          Contraindications.from,
        ),
        goal = OptionList<GameGoal>.deserialize(
          map['filter']['goal'],
          GameGoal.from,
        ),
        length = OptionList<GameLength>.deserialize(
          map['filter']['length'],
          GameLength.from,
        ),
        difficulty = Difficulty.from(choice: map['filter']['difficulty']),
        canSave = CanSave.from(choice: map['filter']['canSave']);

  @override
  Map<String, dynamic> serializedMap() {
    return {
      'title': title,
      'collection': collection,
      'console': console,
      'information': {
        'description': _description,
        'time': _time,
        'position': _position,
        'numberPlayers': _numberPlayers,
        'progression': _progression,
        'performanceFeedback': _performanceFeedback,
        'resultsFeedback': _resultsFeedback,
        'physicalRequirements': _physicalRequirements,
        'motorSkills': _motorSkills,
        'sideNotes': _sideNotes,
        'cognitiveRequirements': _cognitiveRequirements,
      },
      'filter': {
        'upper': upperExtremity.serialize(),
        'lower': lowerExtremity.serialize(),
        'contra': contraindications.serialize(),
        'goal': goal.serialize(),
        'length': length.serialize(),
        'difficulty': difficulty.serialize(),
        'canSave': canSave.serialize(),
      }
    };
  }

  String description(BuildContext context) =>
      _description[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String time(BuildContext context) =>
      _time[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String position(BuildContext context) =>
      _position[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String numberPlayers(BuildContext context) =>
      _numberPlayers[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String progression(BuildContext context) =>
      _progression[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String performanceFeedback(BuildContext context) =>
      _performanceFeedback[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String resultsFeedback(BuildContext context) =>
      _resultsFeedback[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String physicalRequirements(BuildContext context) =>
      _physicalRequirements[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String motorSkills(BuildContext context) =>
      _motorSkills[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String sideNotes(BuildContext context) =>
      _sideNotes[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
  String cognitiveRequirements(BuildContext context) =>
      _cognitiveRequirements[LocaleText.of(context).language] ??
      LocaleText.of(context).informationNotAvailable;
}

Future<List<Game>> readGames() async {
  const jsonPath = '${Game.assetsRoot}/json/all_games.json';

  final input = await http.get(Uri.parse(jsonPath));
  Map<String, dynamic> map = jsonDecode(input.body);
  List<Game> out = [];
  for (final game in map.keys) {
    out.add(Game.fromSerialized(map[game]));
  }
  return out;
}
