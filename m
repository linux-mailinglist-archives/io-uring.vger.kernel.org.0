Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7FA2A3CB0
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 07:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgKCGQJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 01:16:09 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:59177 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbgKCGQJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 01:16:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UE3fUMp_1604384160;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UE3fUMp_1604384160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Nov 2020 14:16:01 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v2 0/2] improve SQPOLL handling
Date:   Tue,  3 Nov 2020 14:15:58 +0800
Message-Id: <20201103061600.11053-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first patch tries to improve various issues in current implementation:
  The prepare_to_wait() usage in __io_sq_thread() is weird. If multiple ctxs
share one same poll thread, one ctx will put poll thread in TASK_INTERRUPTIBLE,
but if other ctxs have work to do, we don't need to change task's stat at all.
I think only if all ctxs don't have work to do, we can do it.
  We use round-robin strategy to make multiple ctxs share one same poll thread,
but there are various condition in __io_sq_thread(), which seems complicated and
may affect round-robin strategy.

The second patch adds a IORING_SETUP_SQPOLL_PERCPU flag, for those rings which
have SQPOLL enabled and are willing to be bound to one same cpu, hence share
one same poll thread, add a capability that these rings can share one poll thread
by specifying a new IORING_SETUP_SQPOLL_PERCPU flag. FIO tool can integrate this
feature easily, so we can test multiple rings to share same poll thread easily.


TEST:
  This patch set have passed liburing test cases.

  I also make fio support IORING_SETUP_SQPOLL_PERCPU flag, and make some
io stress tests, no errors or performance regression. See below fio job file:

First in unpatched kernel, I test a fio file which only contains one job
with iodepth being 128, see below:
[global]
ioengine=io_uring
sqthread_poll=1
registerfiles=1
fixedbufs=1
hipri=1
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=120
ramp_time=0
randrepeat=0
group_reporting=1
filename=/dev/nvme0n1
sqthread_poll_cpu=15

[job0]
cpus_allowed=5
iodepth=128
sqthread_poll_cpu=9

performance data: IOPS: 453k, avg lat: 282.37usec


Second in unpatched kernel, I test a fio file which contains 4 jobs
with each iodepth being 32, see below:
[global]
ioengine=io_uring
sqthread_poll=1
registerfiles=1
fixedbufs=1
hipri=1
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=120
ramp_time=0
randrepeat=0
group_reporting=1
filename=/dev/nvme0n1
sqthread_poll_cpu=15

[job0]
cpus_allowed=5
iodepth=32
sqthread_poll_cpu=9

[job1]
cpus_allowed=6
iodepth=32
sqthread_poll_cpu=9

[job2]
cpus_allowed=7
iodepth=32
sqthread_poll_cpu=9

[job3]
cpus_allowed=8
iodepth=32
sqthread_poll_cpu=9
performance data: IOPS: 254k, avg lat: 503.80 usec, obvious performance
drop.

Finally in patched kernel, I test a fio file which contains 4 jobs
with each iodepth being 32, and now we enable sqthread_poll_percpu
flag, see blow:

[global]
ioengine=io_uring
sqthread_poll=1
registerfiles=1
fixedbufs=1
hipri=1
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=120
ramp_time=0
randrepeat=0
group_reporting=1
filename=/dev/nvme0n1
#sqthread_poll_cpu=15
sqthread_poll_percpu=1  # enable percpu feature

[job0]
cpus_allowed=5
iodepth=32
sqthread_poll_cpu=9

[job1]
cpus_allowed=6
iodepth=32
sqthread_poll_cpu=9

[job2]
cpus_allowed=7
iodepth=32
sqthread_poll_cpu=9

performance data: IOPS: 438k, avg lat: 291.69usec


From above teses, we can see that IORING_SETUP_SQPOLL_PERCPU is easy to
use, and no obvious performance regression.
Note I don't test IORING_SETUP_ATTACH_WQ in above three test cases, it's
a little hard to support IORING_SETUP_ATTACH_WQ in fio.

Xiaoguang Wang (2):
  io_uring: refactor io_sq_thread() handling
  io_uring: support multiple rings to share same poll thread by
    specifying same cpu

 fs/io_uring.c                 | 289 +++++++++++++++++++---------------
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 166 insertions(+), 124 deletions(-)

-- 
2.17.2

