namespace java com.baifendian.swordfish.rpc

/**
 * 返回结果对象
 */
struct RetInfo {
  /**
   * 返回状态码（0-成功，1-失败）
   */
  1: i32 status,

  /**
   * 错误信息，当有错误的情况下返回
   */
  2: string msg
}

/**
 * 返回结果信息，返回包括执行 id 信息
 */
struct RetResultInfo {
  /**
   * 返回状态
   */
  1: RetInfo retInfo,

  /**
   * 返回 exec Id
   */
  2: list<i32> execIds
}

/**
 * Schedule 信息对象
 */
struct ScheduleInfo {
  /**
   * 调度的起始时间(long型)
   */
  1: i64 startDate,

  /** 调度的结束时间(long型) */
  2: i64 endDate,
   	
  /** cron 表达式 */
  3: string crontab
}

/**
 * 执行的一些信息
 */
struct ExecInfo {
  /**
   * 表示执行的节点名称, 传 空或 null 表示执行工作流
   */
  1: string nodeName,

  /**
   * 节点依赖类型, 默认仅执行节点
   */
  2: i32 nodeDep = 0,

  /**
   * 报警类型, 默认不报警
   */
  3: i32 notifyType = 0,

  /**
   * 报警邮箱列表
   */
  4: list<string> notifyMails,

  /**
   * 超时时间, 单位: 秒
   */
  5: i32 timeout = 1800,

  /**
   * 失败策略
   */
  6: i32 failurePolicy = 0
}

/**
 * 心跳汇报信息对象
 */
struct HeartBeatData {
  /**
   * 汇报时间
   */
  1: i64 reportDate,

  /**
   * 汇报时间
   */
  2: i64 receiveDate,

  /**
   * cpu 使用率
   */
  3: double cpuUsed,

  /**
   * 内存使用率
   */
  4: double memUsed,

  /**
   * workflow execId list
   */
  5: list<i32> execIds
}

/**
 * Master 服务接口, 供 web-server 调用使用
 */
service MasterService {

  /**
   * 设置某个 workflow 的调度信息
   *
   * projectId : 项目 id
   * flowId : workflow id
   */
  RetInfo setSchedule(1:i32 projectId, 2:i32 flowId),

  /**
   * 删除某个 workflow 的调度
   *
   * projectId : 项目 id
   * flowId : execJobId
   */
  RetInfo deleteSchedule(1:i32 projectId, 2:i32 flowId),

  /**
   * 删除某个项目的所有调度
   *
   * projectId : 项目 id
   */
  RetInfo deleteSchedules(1:i32 projectId),

  /**
   * 执行某个 workflow
   *
   * projectId : project id
   * flowId : workflow id
   * runTime : 执行时间
   * execInfo : 执行信息
   */
  RetResultInfo execFlow(1:i32 projectId, 2:i32 flowId, 3:i64 runTime, 4:ExecInfo execInfo),

  /**
   * 取消在执行的指定 workflow
   *
   * execId : 执行 id
   */
  RetInfo cancelExecFlow(1:i32 execId),

  /**
   * 执行某个流任务
   *
   * execId : 执行 id
   */
  RetInfo execStreamingJob(1:i32 execId),

  /**
   * 取消在执行的指定流任务
   *
   * execId : 执行 id
   */
  RetInfo cancelStreamingJob(1:i32 execId),

  /**
   * 恢复已经暂停的流任务
   *
   * execId : 执行 id
   */
  RetInfo activateStreamingJob(1:i32 execId),

  /**
   * 暂停指定的流任务
   *
   * execId : 执行 id
   */
  RetInfo deactivateStreamingJob(1:i32 execId),

  /**
   * 给一个 workflow 补数据
   *
   * projectId : 项目 ID
   * flowId : 工作流 ID
   * scheduleInfo: 补数据相关信息(此处不通过调度去执行)
   */
  RetResultInfo appendWorkFlow(1:i32 projectId, 2:i32 flowId, 3:ScheduleInfo scheduleInfo, 4:ExecInfo execInfo),

  /**
   * 注册 execServer
   * ip :  ip 地址
   * port : 端口号
   * registerTime : 注册时间
   */
  RetInfo registerExecutor(1:string ip, 2:i32 port, 3:i64 registerTime),

  /**
   * execServer 删除下线
   *
   * ip :  ip 地址
   * port : 端口号
   */
  RetInfo downExecutor(1:string ip, 2:i32 port),

  /**
   * execServer 汇报心跳
   *
   * ip :  ip 地址
   * port : 端口号
   * heartBeatData : 心跳信息
   */
  RetInfo executorReport(1:string ip, 2:i32 port, 3:HeartBeatData heartBeatData),

  /**
   * 执行某个 adHoc SQL
   *
   * adHocId : adHoc id
   */
  RetInfo execAdHoc(1:i32 adHocId)
}

/**
 * Worker 服务接口, 供 master-server 调用使用
 */
service WorkerService {
  /**
   * 执行某个 workflow
   *
   * execId : 执行 id
   */
  RetInfo execFlow(1:i32 execId),

  /**
   * 取消在执行的指定workflow
   *
   * execId : 执行 id
   */
  RetInfo cancelExecFlow(1:i32 execId),

  /**
   * 执行某个流任务
   *
   * execId : 执行 id
   */
  RetInfo execStreamingJob(1:i32 execId),

  /**
   * 取消在执行的指定流任务
   *
   * execId : 执行 id
   */
  RetInfo cancelStreamingJob(1:i32 execId),

  /**
   * 恢复暂停的流任务
   *
   * execId : 执行 id
   */
  RetInfo activateStreamingJob(1:i32 execId),

  /**
   * 暂停流任务
   *
   * execId : 执行 id
   */
  RetInfo deactivateStreamingJob(1:i32 execId),

  /**
   * 执行某个 adHoc SQL
   *
   * adHocId : adHoc id
   */
  RetInfo execAdHoc(1:i32 adHocId)
}
