import { HashMap } from '@kit.ArkTS';

// 保存账号
export const account = new HashMap<string, string>();
account.set("admin", "123456")

// 音乐数据类
export class Music {
  id: number;
  name: string;
  singer: string;
  album: string;
  duration: number;   // 秒（估算值，播放时会自动获取真实值）
  cover: Resource;
  fileName: string;   // resources/rawfile 下的文件名，如 '薛之谦_潮流季.mp3'
  cover_bg: Resource;
  lyrics?: string;

  constructor(id:number,name: string, singer: string, album: string, duration: number, cover: Resource, fileName: string, cover_bg: Resource, lyrics?: string) {
    this.id = id
    this.name = name;
    this.singer = singer;
    this.album = album;
    this.duration = duration;
    this.cover = cover;
    this.fileName = fileName;
    this.cover_bg = cover_bg;
    this.lyrics = lyrics;
  }
}

// 示例音乐列表（使用本地 rawfile）
export function createMusicList(): Music[] {
  return [
    new Music(1,'潮流季', '薛之谦', '潮流季', 239000, $r('app.media.music_bg_chaoliuji'),
      '薛之谦_潮流季.mp3',$r('app.media.music_detail_bg_chaoliuji'),'潮流季 - 薛之谦\n' +
        '词：郭顶\n' +
        '曲：郭顶\n' +
        '天桥上加冕新装\n' +
        '闪耀过塔尖繁华\n' +
        '跻身最热门排行\n' +
        '仿佛世界都变金装\n' +
        '当时间蒙上尘沙\n' +
        '喧哗未尽也淡忘\n' +
        '限时供应的眼光\n' +
        '谁又能消费一世欣赏\n' +
        '关了灯的房间里头\n' +
        '另一个我在对我说\n' +
        '这个城市的灯火不属于我\n' +
        '乘着摩天轮划过星空\n' +
        '顺势又降落\n' +
        '是什么成全了我又离开我\n' +
        '原来潮流是一场换季\n' +
        '最美抵不过一季限期\n' +
        '是不是要拥有接受失去的勇气\n' +
        '才值得幸运\n' +
        '也许流行是一种光景\n' +
        '还在褪去时意犹未尽\n' +
        '只想卸下一身珠光宝气的我\n' +
        '可以曾讨过你欢心\n' +
        '当时间蒙上尘沙\n' +
        '喧哗未尽也淡忘\n' +
        '限时供应的眼光\n' +
        '谁又能消费一世欣赏\n' +
        '关了灯的房间里头\n' +
        '另一个我在对我说\n' +
        '这个城市的灯火不属于我\n' +
        '乘着摩天轮划过星空\n' +
        '顺势又降落\n' +
        '是什么成全了我又离开我\n' +
        '原来潮流是一场换季\n' +
        '最美抵不过一季限期\n' +
        '是不是要拥有接受失去的勇气\n' +
        '才值得幸运\n' +
        '也许流行是一种光景\n' +
        '还在褪去时意犹未尽\n' +
        '只想卸下一身珠光宝气的我\n' +
        '可以曾讨过你欢心\n' +
        '原来潮流是一场换季\n' +
        '最美抵不过一季限期\n' +
        '难道真要看得清时间\n' +
        '所有动机才懂得珍惜\n' +
        '也许流行是一种光景\n' +
        '才会褪去时意犹未尽\n' +
        '只想卸下一身珠光宝气的我\n' +
        '有幸还能讨你欢心\n'),
    new Music(2,'Wonderful_World_ChakYoun9', 'ChakYoun9', '测试专辑', 257000, $r('app.media.music_bg_Wonderful'),
      'Wonderful_World_ChakYoun9.mp3',$r('app.media.music_detail_bg_Wonderful'),''),
    new Music(3,'青花瓷', '周杰伦', '我很忙', 239000, $r('app.media.music_bg_qinghuaci'),
      '周杰伦_青花瓷.mp3',$r('app.media.music_detail_bg_qinghuaci'),'青花瓷 - 周杰伦 (Jay Chou)\n' +
        '词：方文山\n' +
        '曲：周杰伦\n' +
        '编曲：钟兴民\n' +
        '素胚勾勒出青花笔锋浓转淡\n' +
        '瓶身描绘的牡丹一如你初妆\n' +
        '冉冉檀香透过窗心事我了然\n' +
        '宣纸上走笔至此搁一半\n' +
        '釉色渲染仕女图韵味被私藏\n' +
        '而你嫣然的一笑如含苞待放\n' +
        '你的美一缕飘散\n' +
        '去到我去不了的地方\n' +
        '天青色等烟雨 而我在等你\n' +
        '炊烟袅袅升起 隔江千万里\n' +
        '在瓶底书汉隶仿前朝的飘逸\n' +
        '就当我为遇见你伏笔\n' +
        '天青色等烟雨 而我在等你\n' +
        '月色被打捞起 晕开了结局\n' +
        '如传世的青花瓷自顾自美丽\n' +
        '你眼带笑意\n' +
        '色白花青的锦鲤跃然于碗底\n' +
        '临摹宋体落款时却惦记着你\n' +
        '你隐藏在窑烧里千年的秘密\n' +
        '极细腻犹如绣花针落地\n' +
        '帘外芭蕉惹骤雨门环惹铜绿\n' +
        '而我路过那江南小镇惹了你\n' +
        '在泼墨山水画里\n' +
        '你从墨色深处被隐去\n' +
        '天青色等烟雨 而我在等你\n' +
        '炊烟袅袅升起 隔江千万里\n' +
        '在瓶底书汉隶仿前朝的飘逸\n' +
        '就当我为遇见你伏笔\n' +
        '天青色等烟雨 而我在等你\n' +
        '月色被打捞起 晕开了结局\n' +
        '如传世的青花瓷自顾自美丽\n' +
        '你眼带笑意\n' +
        '天青色等烟雨 而我在等你\n' +
        '炊烟袅袅升起 隔江千万里\n' +
        '在瓶底书汉隶仿前朝的飘逸\n' +
        '就当我为遇见你伏笔\n' +
        '天青色等烟雨 而我在等你\n' +
        '月色被打捞起 晕开了结局\n' +
        '如传世的青花瓷自顾自美丽\n' +
        '你眼带笑意\n'),
    new Music(4,'beauty_and_a_beat', 'justin_biber', 'Believe', 180000, $r('app.media.music_bg_beautyandabeat'),
      'beauty_and_a_beat_justin_bieber.mp3',$r('app.media.mysic_detail_bg_beautyandabeat'),'Beauty And A Beat - Justin Bieber (贾斯汀·比伯)/Nicki Minaj (妮琪·米娜)\n' +
        'Lyrics by：Max Martin/Zedd/Savan Kotecha/Nicki Minaj\n' +
        'Composed by：Max Martin/Zedd/Savan Kotecha/Nicki Minaj\n' +
        'Produced by：Max Martin/Zedd\n' +
        'Yeah\n' +
        'Young Money\n' +
        'Nicki Minaj\n' +
        'Justin\n' +
        'Show you off\n' +
        'Tonight I wanna show you off aye aye aye\n' +
        'What you got\n' +
        'A billion could\'ve never bought aye aye aye\n' +
        'We gonna party like it\'s ３０１２ tonight\n' +
        'I wanna show you all the finer things in life\n' +
        'So just forget about the world we young tonight\n' +
        'I\'m coming for ya I\'m coming for ya\n' +
        'Cause all I need is a beauty and a beat\n' +
        'Who can make my life complete\n' +
        'It\'s all \'bout you\n' +
        'When the music makes you move\n' +
        'Baby do it like you do\n' +
        '\'Cause\n' +
        'Body rock\n' +
        'Girl I can feel your body rock aye aye aye\n' +
        'Take a bow\n' +
        'You\'re on the hottest ticket now ooh aye aye aye\n' +
        'We gonna party like it\'s ３０１２ tonight\n' +
        'I want to show you all the finer things in life\n' +
        'So just forget about the world we young tonight\n' +
        'I\'m coming for ya I\'m coming for ya\n' +
        'Cause all I need is a beauty and a beat\n' +
        'Who can make my life complete\n' +
        'It\'s all \'bout you\n' +
        'When the music makes you move\n' +
        'Baby do it like you do\n' +
        'In time ink lines\n' +
        '******* couldn\'t get on my incline\n' +
        'World tours it\'s mine\n' +
        'Ten little letters on a big sign\n' +
        'Justin Bieber you know I\'mma hit \'em with the ether\n' +
        'Buns out wiener but I gotta keep an eye out for Selener\n' +
        'Beauty beauty and the beast\n' +
        'Beauty from the East\n' +
        'Beautiful confessions of the priest\n' +
        'Beast beauty from the streets beat will get deceased\n' +
        'Every time Beauty on the beat\n' +
        'Body rock\n' +
        'Girl I wanna feel your body rock\n' +
        'Cause all I need is a beauty and a beat\n' +
        'Who can make my life complete\n' +
        'It\'s all \'bout you\n' +
        'When the music makes you move\n' +
        'Baby do it like you do\n'),
    new Music(5,'咏春', '七朵组合', '咏春', 271000, $r('app.media.musci_bg_yongchun'),
      '七朵组合_咏春.mp3',$r('app.media.music_detail_bg_yongchun'),'咏春 - 七朵组合 (SevenSense)\n' +
        '词：花晶晶\n' +
        '曲：何亮\n' +
        '编曲：何亮\n' +
        '拾一片落叶仰望新旧交叠\n' +
        '嫩绿自梢头微微微微露脸\n' +
        '被清风忽略花开得犹豫不决\n' +
        '独徘徊等你等你等你的一切\n' +
        '洒一地斑驳阳光穿过新叶\n' +
        '心事空流转思念渐渐倾斜\n' +
        '草长莺飞慰藉孤单的残雪\n' +
        '放开手让寒冷胆怯\n' +
        '日高悬风拂面留下丝丝温暖\n' +
        '别辜负眼前季节\n' +
        '花踌躇柳轻叹敢问情何以堪\n' +
        '徒伤悲青春年月\n' +
        '春知晓梦不觉恰似你我那年\n' +
        '不经事却说离别\n' +
        '燕归来莺语乱谁在歌咏春天\n' +
        '眼清澈笑容无邪\n' +
        '拾一片落叶仰望新旧交叠\n' +
        '嫩绿自梢头微微露脸\n' +
        '被清风忽略花开得犹豫不决\n' +
        '独徘徊等你等你的一切\n' +
        '许一个心愿忘记忧伤情节\n' +
        '闭上眼合十双手默默叨念\n' +
        '阳光映在眼睑我不再拒绝\n' +
        '暖暖的暖暖的补心里空缺\n' +
        '云淡淡天很蓝思绪慢慢走远\n' +
        '春光细细流淌幸福漫过指尖\n' +
        '是谁在看风景她又被谁看见\n' +
        '谁转身微微笑谁的心事释然\n' +
        '洒一地斑驳阳光穿过新叶\n' +
        '心事空流转思念渐渐倾斜\n' +
        '草长莺飞慰藉孤单的残雪\n' +
        '放开手让寒冷胆怯\n' +
        '日高悬风拂面留下丝丝温暖\n' +
        '别辜负眼前季节\n' +
        '花踌躇柳轻叹敢问情何以堪\n' +
        '徒伤悲青春年月\n' +
        '春知晓梦不觉恰似你我那年\n' +
        '不经事却说离别\n' +
        '燕归来莺语乱谁在歌咏春天\n' +
        '眼清澈笑容无邪\n' +
        '春知晓梦不觉恰似你我那年\n' +
        '不经事却说离别\n' +
        '燕归来莺语乱谁在歌咏春天\n' +
        '眼清澈笑容无邪\n' +
        '是谁在歌咏春天\n')
  ]
}

export const card_bg_color: string[] = [
  '#ffe7810f','#ff81d91f',"#ffdbd8d8","#ffb83939","#ff43bce0"
]

'#ff43bce0'

export const text_1: string[] = [
  '大家都在听','喜欢'
]

//歌单
// 定义歌单接口
export interface Playlist {
  id: number;
  name: string;
  description: string;
  cover: Resource;
  singer: string;
}

// 生成歌单假数据
export function createPlaylistData(): Playlist[] {
  return [
    {
      id: 1,
      name: '华语流行金曲榜',
      description: '最新最热华语流行歌曲，每日更新',
      cover: $r('app.media.playlist_1'),
      singer: '周杰伦 / 陈奕迅'
    },
    {
      id: 2,
      name: '欧美热歌推荐',
      description: 'Billboard热门单曲精选',
      cover: $r('app.media.playlist_2'),
      singer: 'Ed Sheeran / Adele'
    },
    {
      id: 3,
      name: '抖音热门BGM',
      description: '抖音爆款背景音乐合集',
      cover: $r('app.media.playlist_3'),
      singer: '告五人 / 伍佰'
    },
    {
      id: 4,
      name: '经典老歌怀旧',
      description: '那些年我们一起听的歌',
      cover: $r('app.media.playlist_4'),
      singer: 'Beyond / 邓丽君'
    },
    {
      id: 5,
      name: '治愈系纯音乐',
      description: '放松心情，舒缓压力',
      cover: $r('app.media.playlist_5'),
      singer: '久石让 / 班得瑞'
    }
  ];
}

//排行榜
// data/RankData.ets

// 歌曲信息接口
export interface SongInfo {
  songName: string;
  singer: string;
  cover: Resource;  // 每首歌单独的图片
}

// 排行榜项接口（每个包含3首歌）
export interface RankItem {
  id: number;
  title: string;  // 排行榜标题
  songs: SongInfo[];  // 3首歌，每首有歌曲名、歌手、图片
}

// 生成排行榜假数据（3个对象，每个对象3首歌）
export function createRankData(): RankItem[] {
  return [
    {
      id: 1,
      title: '华语热歌榜',
      songs: [
        {
          songName: '孤勇者',
          singer: '陈奕迅',
          cover: $r('app.media.musiclist_1_1')
        },
        {
          songName: '光年之外',
          singer: '邓紫棋',
          cover: $r('app.media.musiclist_1_2')
        },
        {
          songName: '消愁',
          singer: '毛不易',
          cover: $r('app.media.musiclist_1_3')
        }
      ]
    },
    {
      id: 2,
      title: '抖音热歌榜',
      songs: [
        {
          songName: '与你到永久',
          singer: '伍佰',
          cover: $r('app.media.musiclist_2_1')
        },
        {
          songName: '恋爱循环',
          singer: '花澤香菜',
          cover: $r('app.media.musiclist_2_2')
        },
        {
          songName: '给你一瓶魔法药水',
          singer: '告五人',
          cover: $r('app.media.musiclist_2_3')
        }
      ]
    },
    {
      id: 3,
      title: '经典老歌榜',
      songs: [
        {
          songName: '海阔天空',
          singer: 'Beyond',
          cover: $r('app.media.musiclist_3_1')
        },
        {
          songName: '月亮代表我的心',
          singer: '邓丽君',
          cover: $r('app.media.musiclist_3_2')
        },
        {
          songName: '吻别',
          singer: '张学友',
          cover: $r('app.media.musiclist_3_3')
        }
      ]
    }
  ];
}

//点击图标和文字
export interface Singer {
  id: number;
  avatar: Resource;  // 头像
  name: string;      // 歌手名
}

export function createSingerList(): Singer[] {
  return [
    {
      id: 1,
      avatar: $r('app.media.person_fill'),
      name: '歌手'
    },
    {
      id: 2,
      avatar: $r('app.media.bar_chart_fill'),
      name: '排行'
    },
    {
      id: 3,
      avatar: $r('app.media.file_music_fill'),
      name: '歌单'
    },
    {
      id: 4,
      avatar: $r('app.media.journal_album'),
      name: '专辑'
    },
    {
      id: 5,
      avatar: $r('app.media.bag_heart_fill'),
      name: '商城'
    }
  ];
}

