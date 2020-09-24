Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938012766A1
	for <lists+io-uring@lfdr.de>; Thu, 24 Sep 2020 04:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIXCz1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Sep 2020 22:55:27 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42105 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgIXCz1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Sep 2020 22:55:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U9vmSlV_1600916124;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0U9vmSlV_1600916124)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Sep 2020 10:55:24 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH RESEND] io_uring: show sqthread pid and cpu in fdinfo
Date:   Thu, 24 Sep 2020 10:55:24 +0800
Message-Id: <1600916124-19563-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In most cases we'll specify IORING_SETUP_SQPOLL and run multiple
io_uring instances in a host. Since all sqthreads are named
"io_uring-sq", it's hard to distinguish the relations between
application process and its io_uring sqthread.
With this patch, application can get its corresponding sqthread pid
and cpu through show_fdinfo.
Steps:
1. Get io_uring fd first.
$ ls -l /proc/<pid>/fd | grep -w io_uring
2. Then get io_uring instance related info, including corresponding
sqthread pid and cpu.
$ cat /proc/<pid>/fdinfo/<io_uring_fd>

pos:	0
flags:	02000002
mnt_id:	13
SqThread:	6929
SqThreadCpu:	2
UserFiles:	1
    0: testfile
UserBufs:	0
PollList:

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b426aa..9c8b3b3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8415,6 +8415,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	int i;
 
 	mutex_lock(&ctx->uring_lock);
+	seq_printf(m, "SqThread:\t%d\n", (ctx->flags & IORING_SETUP_SQPOLL) ?
+					 task_pid_nr(ctx->sqo_thread) : -1);
+	seq_printf(m, "SqThreadCpu:\t%d\n", (ctx->flags & IORING_SETUP_SQPOLL) ?
+					    task_cpu(ctx->sqo_thread) : -1);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; i < ctx->nr_user_files; i++) {
 		struct fixed_file_table *table;
-- 
1.8.3.1

