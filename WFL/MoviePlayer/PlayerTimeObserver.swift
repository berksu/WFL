//
//  PlayerTimeObserver.swift
//  WFL
//
//  Created by Berksu Kısmet on 21.12.2021.
//


import Combine
import AVKit

class PlayerTimeObserver {
  let publisher = PassthroughSubject<TimeInterval, Never>()
  private var timeObservation: Any?
  
    init(player: AVPlayer, observingTime: Double) {
    // Periodically observe the player's current time, whilst playing
    timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: observingTime, preferredTimescale: 100), queue: nil) { [weak self] time in
      guard let self = self else { return }
      // Publish the new player time
      self.publisher.send(time.seconds)
    }
  }
}
