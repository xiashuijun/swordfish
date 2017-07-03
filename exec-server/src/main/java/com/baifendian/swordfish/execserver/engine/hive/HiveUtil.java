/*
 * Copyright (C) 2017 Baifendian Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *          http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.baifendian.swordfish.execserver.engine.hive;

import com.baifendian.swordfish.common.hive.metastore.HiveMetaPoolClient;
import com.baifendian.swordfish.common.hive.service2.HiveService2Client;
import com.baifendian.swordfish.common.hive.service2.HiveService2ConnectionInfo;
import com.baifendian.swordfish.dao.BaseDao;
import java.text.MessageFormat;
import java.util.UUID;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class HiveUtil extends BaseDao {

  private final Logger logger = LoggerFactory.getLogger(getClass());

  public static final int DEFAULT_QUERY_PROGRESS_THREAD_TIMEOUT = 10 * 1000;

  // 配置信息
  @Autowired
  HiveConfig hiveConfig;

  // hive service2 的客户端连接
  @Autowired
  HiveService2Client hiveService2Client;

  // hive meta 的客户端连接
  @Autowired
  HiveMetaPoolClient hiveMetaPoolClient;

  /**
   * 采用非注解方式的时候, 需要自己获取这些实例
   */
  @Override
  public void init() {
    hiveConfig = MyHiveFactoryUtil.getInstance();
    hiveService2Client = hiveConfig.hiveService2Client();
    hiveMetaPoolClient = hiveConfig.hiveMetaPoolClient();

    logger.info("Hive config, thrift uri:{}, meta uri:{}", hiveConfig.getThriftUris(),
        hiveConfig.getMetastoreUris());
  }

  /**
   * 获取临时表名称
   *
   * @param projectId 项目 id
   * @param execId 执行 id
   * @param jobId job 的 id
   */
  public static String getTmpTableName(int projectId, int execId, String jobId) {
    String uuidSuffix = UUID.randomUUID().toString().replace('-', '_');

    return MessageFormat
        .format("impexp_{0}_{1}_{2}_{3}", String.valueOf(projectId), String.valueOf(execId), jobId,
            uuidSuffix);
  }

  /**
   * 判断是否是查询请求
   */
  public static boolean isTokQuery(String sql) {
    if (StringUtils.isEmpty(sql)) {
      return false;
    }

    sql = sql.toLowerCase();

    if (sql.startsWith("select")
        || sql.startsWith("describe")
        || sql.startsWith("explain")) {
      return true;
    }

    return false;
  }

  /**
   * 是否类似于 show 语句的查询（show/desc/describe） <p>
   *
   * @return 如果是 'show/desc/describe' 语句返回 true, 否则返回 false
   */
  public static boolean isLikeShowStm(String sql) {
    if (StringUtils.isEmpty(sql)) {
      return false;
    }

    sql = sql.toLowerCase();

    if (sql.startsWith("show") || sql.startsWith("desc")) {
      return true;
    }

    return false;
  }

  public HiveService2Client getHiveService2Client() {
    return hiveService2Client;
  }

  public HiveMetaPoolClient getHiveMetaPoolClient() {
    return hiveMetaPoolClient;
  }

  /**
   * 获取连接信息 <p>
   *
   * @see {@link HiveService2ConnectionInfo}
   */
  public HiveService2ConnectionInfo getHiveService2ConnectionInfo(String userName) {
    HiveService2ConnectionInfo hiveService2ConnectionInfo = new HiveService2ConnectionInfo();

    hiveService2ConnectionInfo.setUser(userName);
    hiveService2ConnectionInfo.setUri(hiveConfig.getThriftUris());

    return hiveService2ConnectionInfo;
  }
}