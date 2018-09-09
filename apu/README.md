# SameSuite

## APU tests

This sub-suite contains tests that test a Game Boy's, or an emulator's, APU in a sample-accurate manner.

### Results

 * Pre-CGB devices – pass `div_write_trigger` and `div_write_trigger_10` (Tested: DMG-B, blob). Other tests fail because they rely on the CGB-only PCM registers.
 * CGB-CPU-C – passes the channel 3 tests and non-channel-specific tests. Most other tests fail (see To Do)
 * CGB-CPU-E – passes all tests
 * SameBoy – when emulating CGB-CPU-E, passes all tests except `channel_4_freq_change`.
 
### To Do

 * A quirk in CGB-CPU revisions C and older makes registers PCM12 and PCM34 report a glitched PCM amplitude for channels 1, 2 and 4 if they're read in the same M-cycle they change. This behavior needs be be understood, tested and documented.
   * This quirk is what causes tests testing those channels fail. Once this quirk is understood, some tests (for example, the LFSR tests) can be modified to avoid the glitch and pass on all revisions, while the other tests should be split into revision specific versions.
 * The NRX2 glitch (aka "Zombie Mode") behaves differently across CGB-CPU revisions. Currently, only revision E is tested and documented.
 * Verify these tests pass on the devices not affected by the PCMXX glitch mentioned above – CGB-CPU-D and AGB and newer devices.
 * Write mixer tests to test analog behavior and channel mixing