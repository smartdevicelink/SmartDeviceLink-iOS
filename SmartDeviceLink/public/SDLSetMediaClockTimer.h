//  SDLSetMediaClockTimer.h
//

#import "SDLRPCRequest.h"

#import "SDLUpdateMode.h"
#import "SDLAudioStreamingIndicator.h"
#import "SDLSeekStreamingIndicator.h"

@class SDLStartTime;

/**
 * Sets the media clock/timer value and the update method (e.g.count-up,
 * count-down, etc.)
 * <p>
 * Function Group: Base <p>
 * <b>HMILevel needs to be FULL, LIMITIED or BACKGROUND</b>
 * </p>
 *
 * Since SmartDeviceLink 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSetMediaClockTimer : SDLRPCRequest

/**
 Create a media clock timer that counts up, e.g from 0:00 to 4:18.

 This will fail if startTime is greater than endTime

 @param startTime The start time interval, e.g. (0) 0:00
 @param endTime The end time interval, e.g. (258) 4:18
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countUpFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(countUp(from:to:playPauseIndicator:)) __deprecated_msg("Use countUpFromStartTimeInterval:toEndTimeInterval:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate: instead");

/**
 Create a media clock timer that counts up, e.g from 0:00 to 4:18.

 This will fail if startTime is greater than endTime

 @param startTime The start time interval, e.g. (0) 0:00
 @param endTime The end time interval, e.g. (258) 4:18
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @param countRate set the media playback timer, if `nil`, will default to 1.0
 @param forwardSeekIndicator - forwardSeekIndicator
 @param backSeekIndicator - backSeekIndicator
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countUpFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator countRate:(nullable NSNumber<SDLFloat> *)countRate NS_SWIFT_NAME(countUp(from:to:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:));

/**
 Create a media clock timer that counts up, e.g from 0:00 to 4:18.

 This will fail if startTime is greater than endTime

 @param startTime The start time interval, e.g. 0:00
 @param endTime The end time interval, e.g. 4:18
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countUpFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(countUp(from:to:playPauseIndicator:)) __deprecated_msg("Use countUpFromStartTime:toEndTime:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate: instead");

/**
 Create a media clock timer that counts up, e.g from 0:00 to 4:18.

 This will fail if startTime is greater than endTime

 @param startTime The start time interval, e.g. 0:00
 @param endTime The end time interval, e.g. 4:18
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @param forwardSeekIndicator - forwardSeekIndicator
 @param backSeekIndicator - backSeekIndicator
 @param countRate set the media playback timer, if `nil`, will default to 1.0
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countUpFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator countRate:(nullable NSNumber<SDLFloat> *)countRate NS_SWIFT_NAME(countUp(from:to:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:));

/**
 Create a media clock timer that counts down, e.g. from 4:18 to 0:00

 This will fail if endTime is greater than startTime

 @param startTime The start time interval, e.g. (258) 4:18
 @param endTime The end time interval, e.g. (0) 0:00
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countDownFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(countDown(from:to:playPauseIndicator:)) __deprecated_msg("Use countDownFromStartTimeInterval:toEndTimeInterval:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate: instead");

/**
 Create a media clock timer that counts down, e.g. from 4:18 to 0:00

 This will fail if endTime is greater than startTime

 @param startTime The start time interval, e.g. (258) 4:18
 @param endTime The end time interval, e.g. (0) 0:00
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @param forwardSeekIndicator - forwardSeekIndicator
 @param backSeekIndicator - backSeekIndicator
 @param countRate set the media playback timer, if `nil`, will default to 1.0
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countDownFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator countRate:(nullable NSNumber<SDLFloat> *)countRate NS_SWIFT_NAME(countDown(from:to:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:));

/**
 Create a media clock timer that counts down, e.g. from 4:18 to 0:00

 This will fail if endTime is greater than startTime

 @param startTime The start time interval, e.g. 4:18
 @param endTime The end time interval, e.g. 0:00
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countDownFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(countDown(from:to:playPauseIndicator:)) __deprecated_msg("Use countDownFromStartTime:toEndTime:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate: instead");

/**
 Create a media clock timer that counts down, e.g. from 4:18 to 0:00

 This will fail if endTime is greater than startTime

 @param startTime The start time interval, e.g. 4:18
 @param endTime The end time interval, e.g. 0:00
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @param forwardSeekIndicator - forwardSeekIndicator
 @param backSeekIndicator - backSeekIndicator
 @param countRate set the media playback timer, if `nil`, will default to 1.0
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countDownFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator countRate:(nullable NSNumber<SDLFloat> *)countRate NS_SWIFT_NAME(countDown(from:to:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:));

/**
 Pause an existing (counting up / down) media clock timer

 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)pauseWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(pause(playPauseIndicator:));

/**
 Update a pause time (or pause and update the time) on a media clock timer

 @param startTime The new start time interval
 @param endTime The new end time interval
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)updatePauseWithNewStartTimeInterval:(NSTimeInterval)startTime endTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(pause(newStart:newEnd:playPauseIndicator:));

/**
 Update a pause time (or pause and update the time) on a media clock timer

 @param startTime The new start time
 @param endTime The new end time
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)updatePauseWithNewStartTime:(SDLStartTime *)startTime endTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(pause(newStart:newEnd:playPauseIndicator:));

/**
 Resume a paused media clock timer. It resumes at the same time at which it was paused.

 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)resumeWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator  NS_SWIFT_NAME(resume(playPauseIndicator:)) __deprecated_msg("Use resumeWithPlayPauseIndicator:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:");

/**
 Resume a paused media clock timer. It resumes at the same time at which it was paused.

 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @param forwardSeekIndicator - forwardSeekIndicator
 @param backSeekIndicator - backSeekIndicator
 @param countRate set the media playback timer
 @return An object of SetMediaClockTimer, if `nil`, will default to 1.0
 */
+ (instancetype)resumeWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator countRate:(nullable NSNumber<SDLFloat> *)countRate NS_SWIFT_NAME(resume(playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:));

/**
 Remove a media clock timer from the screen

 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)clearWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(clear(playPauseIndicator:));

/**
 * @param updateMode - updateMode
 * @return A SDLSetMediaClockTimer object
 */
- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode;

/**
 Create a SetMediaClockTimer RPC with all available parameters. It's recommended to use the specific initializers above.

 @param updateMode The type of SetMediaClockTimer RPC
 @param startTime The start time. Only valid in some updateModes.
 @param endTime The end time. Only valid in some updateModes.
 @param playPauseIndicator The display of the play/pause button
 @return An object of SetMediaClockTimer
 */
- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode startTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(init(updateMode:startTime:endTime:playPauseIndicator:)) __deprecated_msg("Use initWithUpdateMode:startTime:endTime:audioStreamingIndicator:forwardSeekIndicator:backSeekIndicator:countRate: instead");

/**
 * @param updateMode - updateMode
 * @param startTime - startTime
 * @param endTime - endTime
 * @param audioStreamingIndicator - audioStreamingIndicator
 * @param forwardSeekIndicator - forwardSeekIndicator
 * @param backSeekIndicator - backSeekIndicator
 * @param countRate - countRate
 * @return A SDLSetMediaClockTimer object
 */
- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode startTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime audioStreamingIndicator:(nullable SDLAudioStreamingIndicator)audioStreamingIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator countRate:(nullable NSNumber<SDLFloat> *)countRate;

/**
 * A Start Time with specifying hour, minute, second values
 *
 * @discussion A startTime object with specifying hour, minute, second values
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>If "updateMode" is COUNTUP or COUNTDOWN, this parameter
 *            must be provided</li>
 *            <li>Will be ignored for PAUSE/RESUME and CLEAR</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) SDLStartTime *startTime;
/**
 * An END time of type SDLStartTime, specifying hour, minute, second values
 *
 * @discussion An SDLStartTime object with specifying hour, minute, second values
 */
@property (strong, nonatomic, nullable) SDLStartTime *endTime;
/**
 * The media clock/timer update mode (COUNTUP/COUNTDOWN/PAUSE/RESUME)
 *
 * @discussion a Enumeration value (COUNTUP/COUNTDOWN/PAUSE/RESUME)
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>When updateMode is PAUSE, RESUME or CLEAR, the start time value
 *            is ignored</li>
 *            <li>When updateMode is RESUME, the timer resumes counting from
 *            the timer's value when it was paused</li>
 *            </ul>
 */
@property (strong, nonatomic) SDLUpdateMode updateMode;

/**
 * The audio streaming indicator used for a play/pause button.
 *
 * @discussion Set the indicator icon of a play/pause button depending on the
 * current audio playback. This parameter is optional. If omitted the last indicator sent
 * will not change.
 */
@property (strong, nonatomic, nullable) SDLAudioStreamingIndicator audioStreamingIndicator;

/**
 * Used to control the forward seek button to either skip forward a set amount of time or to the next track.
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) SDLSeekStreamingIndicator *forwardSeekIndicator;

/**
 * Used to control the back seek button to either skip back a set amount of time or to the previous track.
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) SDLSeekStreamingIndicator *backSeekIndicator;

/**
 * The value of this parameter is the amount that the media clock timer will advance per 1.0 seconds of real time. Values less than 1.0 will therefore advance the timer slower than real-time, while values greater than 1.0 will advance the timer faster than real-time. e.g. If this parameter is set to `0.5`, the timer will advance one second per two seconds real-time, or at 50% speed. If this parameter is set to `2.0`, the timer will advance two seconds per one second real-time, or at 200% speed.
 * {"num_min_value": 0.1, "num_max_value": 100.0, "default_value": 1.0}
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *countRate;

@end

NS_ASSUME_NONNULL_END
