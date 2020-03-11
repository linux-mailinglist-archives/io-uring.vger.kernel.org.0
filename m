Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F791180D78
	for <lists+io-uring@lfdr.de>; Wed, 11 Mar 2020 02:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgCKB02 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 21:26:28 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:49189 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727528AbgCKB02 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 21:26:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TsFiUGD_1583889977;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TsFiUGD_1583889977)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 11 Mar 2020 09:26:24 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: io_uring_enter(2) don't poll while SETUP_IOPOLL|SETUP_SQPOLL enabled
Date:   Wed, 11 Mar 2020 09:26:09 +0800
Message-Id: <20200311012609.35482-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.14.4.44.g2045bb6
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, applications don't need
to do io completion events polling again, they can rely on io_sq_thread to do
polling work, which can reduce cpu usage and uring_lock contention.

I modify fio io_uring engine codes a bit to evaluate the performance:
static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
                        continue;
                }

-               if (!o->sqpoll_thread) {
+               if (o->sqpoll_thread && o->hipri) {
                        r = io_uring_enter(ld, 0, actual_min,
                                                IORING_ENTER_GETEVENTS);
                        if (r < 0) {

and use "fio  -name=fiotest -filename=/dev/nvme0n1 -iodepth=$depth -thread
-rw=read -ioengine=io_uring  -hipri=1 -sqthread_poll=1  -direct=1 -bs=4k
-size=10G -numjobs=1  -time_based -runtime=120"

original codes
--------------------------------------------------------------------
iodepth       |        4 |        8 |       16 |       32 |       64
bw            | 1133MB/s | 1519MB/s | 2090MB/s | 2710MB/s | 3012MB/s
fio cpu usage |     100% |     100% |     100% |     100% |     100%
--------------------------------------------------------------------

with patch
--------------------------------------------------------------------
iodepth       |        4 |        8 |       16 |       32 |       64
bw            | 1196MB/s | 1721MB/s | 2351MB/s | 2977MB/s | 3357MB/s
fio cpu usage |    63.8% |   74.4%% |    81.1% |    83.7% |    82.4%
--------------------------------------------------------------------
bw improve    |     5.5% |    13.2% |    12.3% |     9.8% |    11.5%
--------------------------------------------------------------------

From above test results, we can see that bw has above 5.5%~13%
improvement, and fio process's cpu usage also drops much. Note this
won't improve io_sq_thread's cpu usage when SETUP_IOPOLL|SETUP_SQPOLL
are both enabled, in this case, io_sq_thread always has 100% cpu usage.
I think this patch will be friendly to applications which will often use
io_uring_wait_cqe() or similar from liburing.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6a595c1..9f56723 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1574,6 +1574,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	}
 
 	io_commit_cqring(ctx);
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		io_cqring_ev_posted(ctx);
 	io_free_req_many(ctx, &rb);
 }
 
@@ -6637,7 +6639,14 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 
 		min_complete = min(min_complete, ctx->cq_entries);
 
-		if (ctx->flags & IORING_SETUP_IOPOLL) {
+		/*
+		 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
+		 * space applications don't need to do io completion events
+		 * polling again, they can rely on io_sq_thread to do polling
+		 * work, which can reduce cpu usage and uring_lock contention.
+		 */
+		if (ctx->flags & IORING_SETUP_IOPOLL &&
+		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
 			ret = io_iopoll_check(ctx, &nr_events, min_complete);
 		} else {
 			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
-- 
1.8.3.1

