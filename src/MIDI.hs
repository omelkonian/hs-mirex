module MIDI (readFromMidi, readFromMidiEuterpea, writeToMidi) where

import Euterpea.IO.MIDI.ToMidi (writeMidi)
import Euterpea.IO.MIDI.FromMidi2 (fromMidi2)
import qualified Codec.Midi as MIDI

import Types
import EuterpeaUtils (patternToMusic, musicToPattern)
import TherapicMIDI

writeToMidi :: FilePath -> Pattern -> IO ()
writeToMidi fn = writeMidi fn . patternToMusic

trackNumber :: Int
trackNumber = 0

readFromMidi :: FilePath -> IO Pattern
readFromMidi = parseMID trackNumber

readFromMidiEuterpea :: FilePath -> IO Pattern
readFromMidiEuterpea = fmap (musicToPattern . fromMidi2) . importFile
  where
    importFile :: FilePath -> IO MIDI.Midi
    importFile fn = do
      r <- MIDI.importFile fn
      case r of
        Left err -> error err
        Right m  -> return m
