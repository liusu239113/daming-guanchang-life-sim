# Audio Module

## Classes

`Audio` · `Sound` · `SoundSource` · `SoundSource3D` · `SoundListener`

详细 API 见 `.emmylua/Audio.d.lua`、`.emmylua/Sound.d.lua`、`.emmylua/SoundSource.d.lua` 等。

## `Sound` 与 `SoundSource`

- `Sound` 是音频资源。`sound:GetFrequency()` 返回素材的默认采样率，单位是 Hz，例如 `44100` 或 `48000`。
- `SoundSource` 是播放实例。`source:GetFrequency()` 返回该实例当前采用的绝对播放频率，单位同样是 Hz。
- 在 `SoundSource:Play(sound, frequency, gain)` 中，`frequency` 是绝对 Hz，**不是 pitch 倍率**。
- 播放只修改 `SoundSource` 的频率，不会修改 `Sound`，所以播放后再次调用 `sound:GetFrequency()` 仍返回素材采样率。
- Lua 属性 `source.frequency` 等价于 `source:SetFrequency(...)`，同样接收绝对 Hz，而不是 pitch 倍率。`sound.frequency` 和 `sound.intFrequency` 则是只读的素材采样率。

## 播放音效

不改变 pitch 时，推荐显式传 `0`，让本次播放使用素材采样率：

```lua
local sound = cache:GetResource("Sound", "Sounds/Hit.wav")
local source = node:CreateComponent("SoundSource")

source:Play(sound, 0, 0.8)
```

`0` 是 `Play` 入口的特殊值：引擎会先将其替换为 `sound:GetFrequency()`。它不是 pitch `0x`，也不是混音器的“不重采样快速路径”。只有最终播放频率等于音频设备的 mix rate 时，播放步进才是 1:1。

## 改变 pitch

pitch 必须先乘以素材采样率，再传给 `Play`：

```lua
local pitch = 0.94 + math.random() * 0.14
local playbackFrequency = sound:GetFrequency() * pitch

source:Play(sound, playbackFrequency, 0.8)
```

不要直接传倍率：

```lua
-- 错误：0.95 会被解释为 0.95 Hz，而不是 0.95x pitch。
source:Play(sound, 0.95, 0.8)
```

混音器按以下比例推进素材播放位置：

```text
playback step = source frequency / audio mix rate
```

例如，48,000 Hz 的素材若被设置为 `0.95 Hz`，在默认 44,100 Hz 的设备 mix rate 下，每个输出采样的播放步进约为 `0.95 / 44100`；相对于素材原速的播放速度则是 `0.95 / 48000`。一秒的音效会被拉长到约 14 小时（`48000 / 0.95` 秒，与 mix rate 无关），听感上通常等同于没有声音。

## 复用 `SoundSource`

`source:Play(sound)` 只会在当前 `source` 频率为 `0` 时读取素材采样率。如果该实例上一次播放设置过非零频率，无参重载会继续沿用旧值；复用同一个 `SoundSource` 播放不同采样率的素材时尤其容易意外变调。

```lua
-- 每次明确恢复到当前素材采样率。
source:Play(sound, 0, gain)

-- 每次明确设置相对于当前素材的 pitch。
source:Play(sound, sound:GetFrequency() * pitch, gain)
```

`source:SetFrequency(0)` 本身只把播放实例的频率设为零。素材频率的回填发生在下一次 `Play(sound)` 中，因此不要在已经播放时把 `0` 当成即时“恢复原速”操作。
