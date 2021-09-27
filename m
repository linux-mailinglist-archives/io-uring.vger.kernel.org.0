Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC37418EF1
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 08:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhI0GTG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 02:19:06 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:37887 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232283AbhI0GTG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 02:19:06 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpiKFOp_1632723441;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpiKFOp_1632723441)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 14:17:27 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 0/6] task_work optimization
Date:   Mon, 27 Sep 2021 14:17:13 +0800
Message-Id: <20210927061721.180806-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The main patches are 3/6 and 6/6. 3/6 is to set a new task list and
complete its task works prior to the normal task works in old task list.

6/6 is an optimization of batching completion of task works in the new
task list if they all have same ctx which is the normal situation, the
benefit is we now batch them regardless uring_lock.

Tested this patchset by manually replace __io_queue_sqe() to
io_req_task_complete() to construct 'heavy' task works. Then test with
fio:

ioengine=io_uring
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=600
randrepeat=0
group_reporting=1
filename=/dev/nvme0n1

Tried various iodepth.
The peak IOPS for this patch is 314K, while the old one is 249K.
For avg latency, difference shows when iodepth grow:
depth and avg latency(usec):
	depth      new          old
	 1        22.80        23.77
	 2        23.48        24.54
	 4        24.26        25.57
	 8        29.21        32.89
	 16       53.61        63.50
	 32       106.29       131.34
	 64       217.21       256.33
	 128      421.59       513.87
 	 256      815.15       1050.99

without this patchset
iodepth=1
clat percentiles (usec):
 |  1.00th=[    7],  5.00th=[    7], 10.00th=[    8], 20.00th=[    8],
 | 30.00th=[    8], 40.00th=[    8], 50.00th=[    8], 60.00th=[    8],
 | 70.00th=[    8], 80.00th=[    8], 90.00th=[   82], 95.00th=[   97],
 | 99.00th=[   99], 99.50th=[   99], 99.90th=[  100], 99.95th=[  101],
 | 99.99th=[  126]
iodepth=2
clat percentiles (usec):
 |  1.00th=[    7],  5.00th=[    7], 10.00th=[    7], 20.00th=[    8],
 | 30.00th=[    8], 40.00th=[    8], 50.00th=[    8], 60.00th=[    9],
 | 70.00th=[   10], 80.00th=[   10], 90.00th=[   83], 95.00th=[   97],
 | 99.00th=[  100], 99.50th=[  102], 99.90th=[  126], 99.95th=[  145],
 | 99.99th=[  971]
iodepth=4
clat percentiles (usec):
 |  1.00th=[    7],  5.00th=[    7], 10.00th=[    8], 20.00th=[    8],
 | 30.00th=[    8], 40.00th=[    9], 50.00th=[    9], 60.00th=[   10],
 | 70.00th=[   11], 80.00th=[   13], 90.00th=[   86], 95.00th=[   98],
 | 99.00th=[  105], 99.50th=[  115], 99.90th=[  139], 99.95th=[  149],
 | 99.99th=[  169]
iodepth=8
clat percentiles (usec):
 |  1.00th=[    7],  5.00th=[    8], 10.00th=[    9], 20.00th=[   12],
 | 30.00th=[   13], 40.00th=[   16], 50.00th=[   18], 60.00th=[   20],
 | 70.00th=[   22], 80.00th=[   27], 90.00th=[   95], 95.00th=[  105],
 | 99.00th=[  121], 99.50th=[  131], 99.90th=[  157], 99.95th=[  167],
 | 99.99th=[  206]
iodepth=16
clat percentiles (usec):
 |  1.00th=[   25],  5.00th=[   33], 10.00th=[   37], 20.00th=[   41],
 | 30.00th=[   44], 40.00th=[   46], 50.00th=[   49], 60.00th=[   51],
 | 70.00th=[   55], 80.00th=[   63], 90.00th=[  125], 95.00th=[  137],
 | 99.00th=[  155], 99.50th=[  165], 99.90th=[  198], 99.95th=[  235],
 | 99.99th=[ 1844]
iodepth=32
clat percentiles (usec):
 |  1.00th=[   92],  5.00th=[   98], 10.00th=[  102], 20.00th=[  106],
 | 30.00th=[  110], 40.00th=[  112], 50.00th=[  116], 60.00th=[  120],
 | 70.00th=[  128], 80.00th=[  141], 90.00th=[  192], 95.00th=[  204],
 | 99.00th=[  227], 99.50th=[  235], 99.90th=[  260], 99.95th=[  273],
 | 99.99th=[  322]
iodepth=64
clat percentiles (usec):
 |  1.00th=[  221],  5.00th=[  227], 10.00th=[  231], 20.00th=[  233],
 | 30.00th=[  237], 40.00th=[  239], 50.00th=[  241], 60.00th=[  243],
 | 70.00th=[  247], 80.00th=[  253], 90.00th=[  318], 95.00th=[  330],
 | 99.00th=[  351], 99.50th=[  359], 99.90th=[  388], 99.95th=[  400],
 | 99.99th=[  529]
iodepth=128
clat percentiles (usec):
 |  1.00th=[  465],  5.00th=[  478], 10.00th=[  482], 20.00th=[  486],
 | 30.00th=[  490], 40.00th=[  490], 50.00th=[  494], 60.00th=[  498],
 | 70.00th=[  506], 80.00th=[  553], 90.00th=[  578], 95.00th=[  586],
 | 99.00th=[  635], 99.50th=[  652], 99.90th=[  676], 99.95th=[  717],
 | 99.99th=[ 2278]
iodepth=256
clat percentiles (usec):
 |  1.00th=[  979],  5.00th=[  988], 10.00th=[  996], 20.00th=[ 1012],
 | 30.00th=[ 1020], 40.00th=[ 1037], 50.00th=[ 1037], 60.00th=[ 1045],
 | 70.00th=[ 1057], 80.00th=[ 1090], 90.00th=[ 1123], 95.00th=[ 1139],
 | 99.00th=[ 1205], 99.50th=[ 1237], 99.90th=[ 1254], 99.95th=[ 1270],
 | 99.99th=[ 1385]

with this patchset
iodepth=1
clat percentiles (usec):
 |  1.00th=[    7],  5.00th=[    7], 10.00th=[    7], 20.00th=[    7],
 | 30.00th=[    7], 40.00th=[    7], 50.00th=[    8], 60.00th=[    8],
 | 70.00th=[    8], 80.00th=[    8], 90.00th=[   82], 95.00th=[   97],
 | 99.00th=[   99], 99.50th=[   99], 99.90th=[  100], 99.95th=[  101],
 | 99.99th=[  125]
iodepth=2
clat percentiles (usec):
 |  1.00th=[    6],  5.00th=[    7], 10.00th=[    7], 20.00th=[    7],
 | 30.00th=[    7], 40.00th=[    7], 50.00th=[    8], 60.00th=[    8],
 | 70.00th=[    9], 80.00th=[   11], 90.00th=[   83], 95.00th=[   97],
 | 99.00th=[  100], 99.50th=[  102], 99.90th=[  127], 99.95th=[  141],
 | 99.99th=[  668]
iodepth=4
clat percentiles (usec):
 |  1.00th=[    6],  5.00th=[    6], 10.00th=[    7], 20.00th=[    7],
 | 30.00th=[    7], 40.00th=[    8], 50.00th=[    8], 60.00th=[    9],
 | 70.00th=[   10], 80.00th=[   12], 90.00th=[   85], 95.00th=[   97],
 | 99.00th=[  104], 99.50th=[  115], 99.90th=[  141], 99.95th=[  149],
 | 99.99th=[  194]
iodepth=8
clat percentiles (usec):
 |  1.00th=[    6],  5.00th=[    7], 10.00th=[    7], 20.00th=[    9],
 | 30.00th=[   11], 40.00th=[   12], 50.00th=[   14], 60.00th=[   15],
 | 70.00th=[   18], 80.00th=[   22], 90.00th=[   93], 95.00th=[  103],
 | 99.00th=[  120], 99.50th=[  130], 99.90th=[  157], 99.95th=[  167],
 | 99.99th=[  208]
iodepth=16
clat percentiles (usec):
 |  1.00th=[   16],  5.00th=[   24], 10.00th=[   28], 20.00th=[   32],
 | 30.00th=[   34], 40.00th=[   37], 50.00th=[   39], 60.00th=[   41],
 | 70.00th=[   44], 80.00th=[   51], 90.00th=[  117], 95.00th=[  128],
 | 99.00th=[  147], 99.50th=[  159], 99.90th=[  194], 99.95th=[  235],
 | 99.99th=[ 1909]
iodepth=32
clat percentiles (usec):
 |  1.00th=[   72],  5.00th=[   78], 10.00th=[   81], 20.00th=[   84],
 | 30.00th=[   86], 40.00th=[   88], 50.00th=[   90], 60.00th=[   93],
 | 70.00th=[   96], 80.00th=[  114], 90.00th=[  169], 95.00th=[  182],
 | 99.00th=[  202], 99.50th=[  212], 99.90th=[  239], 99.95th=[  253],
 | 99.99th=[  302]
iodepth=64
clat percentiles (usec):
 |  1.00th=[  178],  5.00th=[  184], 10.00th=[  186], 20.00th=[  192],
 | 30.00th=[  196], 40.00th=[  200], 50.00th=[  204], 60.00th=[  206],
 | 70.00th=[  210], 80.00th=[  221], 90.00th=[  281], 95.00th=[  293],
 | 99.00th=[  318], 99.50th=[  330], 99.90th=[  355], 99.95th=[  367],
 | 99.99th=[  437]
iodepth=128
clat percentiles (usec):
 |  1.00th=[  379],  5.00th=[  388], 10.00th=[  392], 20.00th=[  396],
 | 30.00th=[  396], 40.00th=[  400], 50.00th=[  404], 60.00th=[  408],
 | 70.00th=[  424], 80.00th=[  437], 90.00th=[  482], 95.00th=[  498],
 | 99.00th=[  529], 99.50th=[  537], 99.90th=[  570], 99.95th=[  635],
 | 99.99th=[ 2311]
iodepth=256
clat percentiles (usec):
 |  1.00th=[  783],  5.00th=[  783], 10.00th=[  791], 20.00th=[  791],
 | 30.00th=[  791], 40.00th=[  799], 50.00th=[  799], 60.00th=[  799],
 | 70.00th=[  807], 80.00th=[  816], 90.00th=[  881], 95.00th=[  889],
 | 99.00th=[  914], 99.50th=[  930], 99.90th=[  979], 99.95th=[  996],
 | 99.99th=[ 1237]


Hao Xu (8):
  io-wq: code clean for io_wq_add_work_after()
  io-wq: add helper to merge two wq_lists
  io_uring: add a limited tw list for irq completion work
  io_uring: add helper for task work execution code
  io_uring: split io_req_complete_post() and add a helper
  io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
  io_uring: add tw_ctx for io_uring_task
  io_uring: batch completion in prior_task_list

 fs/io-wq.h    |  26 ++++++--
 fs/io_uring.c | 170 ++++++++++++++++++++++++++++++++++----------------
 2 files changed, 137 insertions(+), 59 deletions(-)

-- 
2.24.4

