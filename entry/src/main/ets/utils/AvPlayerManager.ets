// utils/AvPlayerManager.ets
import { media } from '@kit.MediaKit'
import { BusinessError } from '@kit.BasicServicesKit'

export class AvPlayerManager {
  private player: media.AVPlayer | null = null
  private isPlaying: boolean = false
  private currentTime: number = 0
  private duration: number = 0

  // 用于外部读取
  getIsPlaying(): boolean {
    return this.isPlaying
  }

  getCurrentTime(): number {
    return this.currentTime
  }

  getDuration(): number {
    return this.duration
  }

  // 使用状态机回调驱动播放
  async playRawFile(fdSrc: media.AVFileDescriptor): Promise<void> {
    console.info('[playRawFile] 开始播放本地音频')

    // 释放旧播放器
    await this.release()

    return new Promise<void>(async (resolve, reject) => {
      try {
        const timeoutId = setTimeout(() => {
          console.error('[playRawFile] 播放超时')
          reject(new Error('播放超时'))
        }, 15000)

        // 创建新播放器
        this.player = await media.createAVPlayer()
        console.info('[playRawFile] AVPlayer 创建成功')

        // 错误回调
        this.player.on('error', (error: BusinessError) => {
          console.error('[playRawFile] 播放器错误:', JSON.stringify(error))
          clearTimeout(timeoutId)
          this.isPlaying = false
          reject(new Error(`播放器错误: ${error.message}`))
        })

        // 状态机回调 - 官方推荐方式
        this.player.on('stateChange', async (state: string) => {
          console.info('[playRawFile] 状态变化:', state)

          if (state === 'initialized') {
            console.info('[playRawFile] 已初始化，调用 prepare()')
            try {
              this.player!.prepare().then(() => {
                console.info('[playRawFile] prepare() 完成')
              }).catch((err: BusinessError) => {
                console.error('[playRawFile] prepare() 失败:', err.message)
                clearTimeout(timeoutId)
                reject(new Error(`prepare 失败: ${err.message}`))
              })
            } catch (e) {
              console.error('[playRawFile] prepare() 异常:', JSON.stringify(e))
              clearTimeout(timeoutId)
              reject(new Error(`prepare 异常: ${JSON.stringify(e)}`))
            }
          } else if (state === 'prepared') {
            this.duration = this.player?.duration || 0
            console.info('[playRawFile] 已准备，时长:', this.duration, '调用 play()')
            try {
              this.player!.play()
              console.info('[playRawFile] play() 已调用')
            } catch (e) {
              console.error('[playRawFile] play() 异常:', JSON.stringify(e))
              clearTimeout(timeoutId)
              reject(new Error(`play 异常: ${JSON.stringify(e)}`))
            }
          } else if (state === 'playing') {
            this.isPlaying = true
            console.info('[playRawFile] 播放中')
            clearTimeout(timeoutId)
            resolve()
          } else if (state === 'paused') {
            this.isPlaying = false
          } else if (state === 'completed') {
            console.info('[playRawFile] 播放完成')
            this.isPlaying = false
            this.currentTime = 0
          } else if (state === 'stopped') {
            this.isPlaying = false
            this.currentTime = 0
          } else if (state === 'released') {
            this.player = null
            console.info('[playRawFile] 播放器已释放')
          } else if (state === 'error') {
            console.error('[playRawFile] 播放器进入错误状态')
            clearTimeout(timeoutId)
            this.isPlaying = false
            reject(new Error('播放器进入错误状态'))
          }
        })

        // timeUpdate 回调
        this.player.on('timeUpdate', (time: number) => {
          this.currentTime = time
        })

        // 设置源 - 触发状态机开始运转
        console.info('[playRawFile] 设置 fdSrc...')
        this.player.fdSrc = fdSrc
        console.info('[playRawFile] fdSrc 设置成功')
      } catch (error) {
        console.error('[playRawFile] 初始化异常:', JSON.stringify(error))
        reject(new Error(`播放初始化异常: ${JSON.stringify(error)}`))
      }
    })
  }

  // 网络播放（保留兼容）
  async play(url: string): Promise<void> {
    console.info('[play] 开始播放 URL:', url)
    await this.release()

    return new Promise<void>(async (resolve, reject) => {
      try {
        const timeoutId = setTimeout(() => {
          reject(new Error('播放超时'))
        }, 15000)

        this.player = await media.createAVPlayer()
        console.info('[play] AVPlayer 创建成功')

        this.player.on('error', (error: BusinessError) => {
          console.error('[play] 播放器错误:', JSON.stringify(error))
          clearTimeout(timeoutId)
          this.isPlaying = false
          reject(new Error(`播放器错误: ${error.message}`))
        })

        this.player.on('stateChange', async (state: string) => {
          console.info('[play] 状态变化:', state)

          if (state === 'initialized') {
            console.info('[play] 已初始化，调用 prepare()')
            try {
              this.player!.prepare().then(() => {
                console.info('[play] prepare() 完成')
              }).catch((err: BusinessError) => {
                clearTimeout(timeoutId)
                reject(new Error(`prepare 失败: ${err.message}`))
              })
            } catch (e) {
              clearTimeout(timeoutId)
              reject(new Error(`prepare 异常: ${JSON.stringify(e)}`))
            }
          } else if (state === 'prepared') {
            this.duration = this.player?.duration || 0
            console.info('[play] 已准备，调用 play()')
            try {
              this.player!.play()
            } catch (e) {
              clearTimeout(timeoutId)
              reject(new Error(`play 异常: ${JSON.stringify(e)}`))
            }
          } else if (state === 'playing') {
            this.isPlaying = true
            clearTimeout(timeoutId)
            resolve()
          } else if (state === 'paused') {
            this.isPlaying = false
          } else if (state === 'completed') {
            this.isPlaying = false
            this.currentTime = 0
          } else if (state === 'released') {
            this.player = null
          } else if (state === 'error') {
            clearTimeout(timeoutId)
            this.isPlaying = false
            reject(new Error('播放器进入错误状态'))
          }
        })

        this.player.on('timeUpdate', (time: number) => {
          this.currentTime = time
        })

        console.info('[play] 设置 url...')
        this.player.url = url
        console.info('[play] url 设置成功')
      } catch (error) {
        reject(new Error(`播放初始化异常: ${JSON.stringify(error)}`))
      }
    })
  }

  pause() {
    if (this.player && this.isPlaying) {
      this.player.pause()
      this.isPlaying = false
      console.info('[pause] 已暂停')
    }
  }

  resume() {
    if (this.player && !this.isPlaying) {
      this.player.play()
      this.isPlaying = true
      console.info('[resume] 已恢复播放')
    }
  }

  async seek(time: number) {
    if (this.player && time >= 0) {
      try {
        await this.player.seek(time)
        this.currentTime = time
        console.info('[seek] 跳转到:', time)
      } catch (e) {
        console.warn('[seek] 失败:', JSON.stringify(e))
      }
    }
  }

  async stop() {
    if (this.player) {
      try {
        await this.player.stop()
      } catch (e) {
        console.warn('[stop] 出错:', JSON.stringify(e))
      }
      this.isPlaying = false
      this.currentTime = 0
    }
  }

  async release() {
    if (this.player) {
      try {
        this.player.off('error')
        this.player.off('stateChange')
        this.player.off('timeUpdate')
        await this.player.release()
        console.info('[release] 播放器已释放')
      } catch (e) {
        console.warn('[release] 出错:', JSON.stringify(e))
      }
      this.player = null
      this.isPlaying = false
      this.currentTime = 0
      this.duration = 0
    }
  }
}
