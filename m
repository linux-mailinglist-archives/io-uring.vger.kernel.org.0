Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374EE3C61F6
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 19:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhGLRea (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 13:34:30 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:49101 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235199AbhGLRe3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 13:34:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UfbxgOT_1626111094;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UfbxgOT_1626111094)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Jul 2021 01:31:40 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: store pid of sqthread for userspace usage
Date:   Tue, 13 Jul 2021 01:31:34 +0800
Message-Id: <20210712173134.112426-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

users may want to change the schedule policy and priority of sqthread.
So it's good to store this info in io_uring_params.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 1 +
 include/uapi/linux/io_uring.h | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca9172f51a77..9f7101f3c28d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8054,6 +8054,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
+		p->sq_thread_pid = task_pid_vnr(tsk);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 79126d5cd289..07b624be7a66 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -254,7 +254,10 @@ struct io_uring_params {
 	__u32 sq_entries;
 	__u32 cq_entries;
 	__u32 flags;
-	__u32 sq_thread_cpu;
+	union {
+		__u32 sq_thread_cpu;
+		__s32 sq_thread_pid;
+	};
 	__u32 sq_thread_idle;
 	__u32 features;
 	__u32 wq_fd;
-- 
2.24.4

