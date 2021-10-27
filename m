Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC9743CB73
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 16:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbhJ0OEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 10:04:52 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:46721 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242372AbhJ0OEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 10:04:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UtuRLZW_1635343336;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtuRLZW_1635343336)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 22:02:23 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.16 v3 0/8] task work optimization
Date:   Wed, 27 Oct 2021 22:02:08 +0800
Message-Id: <20211027140216.20008-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tested this patchset by manually replace __io_queue_sqe() in
io_queue_sqe() by io_req_task_queue() to construct 'heavy' task works.
Then test with fio:

ioengine=io_uring
sqpoll=1
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=600
randrepeat=0
group_reporting=1
filename=/dev/nvme0n1

2/8 set unlimited priority_task_list, 8/8 set a limitation of
1/3 * (len_prority_list + len_normal_list), data below:
   depth     no 8/8   include 8/8      before this patchset
    1        7.05         7.82              7.10
    2        8.47         8.48              8.60
    4        10.42        9.99              10.42
    8        13.78        13.13             13.22
    16       27.41        27.92             24.33
    32       49.40        46.16             53.08
    64       102.53       105.68            103.36
    128      196.98       202.76            205.61
    256      372.99       375.61            414.88
    512      747.23       763.95            791.30
    1024     1472.59      1527.46           1538.72
    2048     3153.49      3129.22           3329.01
    4096     6387.86      5899.74           6682.54
    8192     12150.25     12433.59          12774.14
    16384    23085.58     24342.84          26044.71

It seems 2/8 is better, haven't tried other choices other than 1/3,
still put 8/8 here for people's further thoughts.

Hao Xu (8):
  io-wq: add helper to merge two wq_lists
  io_uring: add a priority tw list for irq completion work
  io_uring: add helper for task work execution code
  io_uring: split io_req_complete_post() and add a helper
  io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
  io_uring: add nr_ctx to record the number of ctx in a task
  io_uring: batch completion in prior_task_list
  io_uring: add limited number of TWs to priority task list

 fs/io-wq.h    |  21 +++++++
 fs/io_uring.c | 168 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 138 insertions(+), 51 deletions(-)

-- 
2.24.4

