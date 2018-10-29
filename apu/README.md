# SameSuite

## APU tests

This sub-suite contains tests that test a Game Boy's, or an emulator's, APU in a sample-accurate manner.

### Results

 * Pre-CGB devices – pass `div_write_trigger` and `div_write_trigger_10` (Tested: DMG-B, blob). Other tests fail because they rely on the CGB-only PCM registers.
 * CPU-CGB-C – passes the channel 3 tests and non-channel-specific tests. Most other tests fail (see To Do)
 * CPU-CGB-D - passes all tests, except `channel_1_sweep_restart_2`
 * CPU-CGB-E – passes all tests
 * SameBoy – when emulating CGB-CPU-E, passes all tests except `channel_4_freq_change` and `channel_1_sweep_restart_2`.
 
### To Do

 * A quirk in CPU-CGB revisions C and older makes registers PCM12 and PCM34 report a glitched PCM amplitude for channels 1, 2 and 4 if they're read in the same M-cycle they change. This behavior needs be be understood, tested and documented.
   * This quirk is what causes tests testing those channels fail. Once this quirk is understood, some tests (for example, the LFSR tests) can be modified to avoid the glitch and pass on all revisions, while the other tests should be split into revision specific versions.
 * The NRX2 glitch (aka "Zombie Mode") behaves differently across CPU-CGB revisions. Currently, only revision E is tested and documented.
 * Verify these tests pass on the all devices not affected by the PCMXX glitch mentioned above – the Game Boy Advance line remains.
 * Write mixer tests to test analog behavior and channel mixing
 * Understand why `channel_1_sweep_restart_2` fails on SameBoy and CPU-CGB-D. Once understood, write a test ROM for CPU-CGB-D.
