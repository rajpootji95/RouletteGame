import 'dart:async';

import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';
import 'package:roullet_app/Helper_Constants/sounds_source_path.dart';

class AudioController {
  static final Logger _log = Logger('AudioController');
   bool mute = false;
  SoLoud? _soLoud;

  SoundHandle? _musicHandle;

   Map<String, AudioSource> loadedSounds = {};
   List<SoundHandle> soundHandles = [];

  Future<void> initialize() async {
    _soLoud = SoLoud.instance;
    await _soLoud!.init();
  }

  void dispose() {
    _soLoud?.deinit();
  }
   muteAudio(){
    mute = !mute;
    if(mute){
      fadeOutMusic();
    }
    else{
      startMusic();
    }
   }

  Future<void> playSound(String assetKey,soundType) async {
    if (mute){
      return;
    }
    try{
      if(loadedSounds.containsKey(soundType)){
        await _soLoud!.play(loadedSounds[soundType]!);
      }
      else{
        final source = await _soLoud!.loadAsset(assetKey);
        loadedSounds[soundType] = source;
        await _soLoud!.play(source,volume: 1.0);
      }

    }
    on SoLoudException catch (e) {
      _log.severe("Cannot play sound '$assetKey'. Ignoring.", e);
    }
  }

  Future<void> startMusic() async {
    if (_musicHandle != null) {
      if (_soLoud!.getIsValidVoiceHandle(_musicHandle!)) {
        _log.info('Music is already playing. Stopping first.');
        await _soLoud!.stop(_musicHandle!);
      }
    }

    final musicSource = await _soLoud!
        .loadAsset(SoundSource.backgroundMusicJazzTrio, mode: LoadMode.disk);
    musicSource.allInstancesFinished.first.then((_) {
      _soLoud!.disposeSource(musicSource);
      _log.info('Music source disposed');
      _musicHandle = null;
    });
    _musicHandle = await _soLoud!.play(
        musicSource,
        volume: 0.2,
        looping: true,
        loopingStartAt: const Duration(seconds: 25, milliseconds: 43),
    );
  }

  void fadeOutMusic() {
    if (_musicHandle == null) {
      _log.info('Nothing to fade out');
      return;
    }
    const length = Duration(seconds: 3);
    _soLoud!.fadeVolume(_musicHandle!, 0, length);
    _soLoud!.scheduleStop(_musicHandle!, length);
  }

  void applyFilter() {
    _soLoud!.addGlobalFilter(FilterType.freeverbFilter);
    _soLoud!.setFilterParameter(FilterType.freeverbFilter, 0, 0.2);
    _soLoud!.setFilterParameter(FilterType.freeverbFilter, 2, 0.9);
  }

  void removeFilter() {
    // _soLoud!.removeGlobalFilter(FilterType.freeverbFilter);
   _soLoud!.removeGlobalFilter(FilterType.freeverbFilter);
  }
}