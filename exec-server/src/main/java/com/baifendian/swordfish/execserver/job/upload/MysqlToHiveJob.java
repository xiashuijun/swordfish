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
package com.baifendian.swordfish.execserver.job.upload;

import com.baifendian.swordfish.common.job.struct.node.BaseParam;
import com.baifendian.swordfish.execserver.job.JobProps;
import org.slf4j.Logger;

import java.io.File;

/**
 * mysql 导入 hive 任务
 */
public class MysqlToHiveJob extends UploadJob {

  public MysqlToHiveJob(JobProps props, boolean isLongJob, Logger logger) {
    super(props, isLongJob, logger);
  }

  @Override
  public String getDataXJson() {
    return null;
  }

  @Override
  public BaseParam getParam() {
    return null;
  }

  @Override
  public String createCommand() throws Exception {
    return null;
  }

  @Override
  public void initJob() {

  }
}
