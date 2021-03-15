Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0412F33C338
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhCORDI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbhCORC2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:28 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C75C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=F7PWeuCvWuXy7l/hmr0OyIZ/FsqPZvoEpakotQ7WWp0=; b=DlYqvxj/FfYFj/GkJ2vuP8uC0/
        41+O62lNbvqXBBnDL/K6XyYGAOJImLPIeL/bT8Hl8BaPnsC89cCe5jcH/tJyXSFqI+CF0p/HbcoSY
        Wt8EJ4va7wqvlSeJjboxw1rF9OZAGREWS2E4YgUTNvI3+a4+4FA4YRf4w79CdVr0MPv6SMYU56kJL
        lmAISlc46F0A2ooSBHx+cZ/QpO8/mSknKpnn6Xk0uMWuwEpwykAB0QmMSIgzCNJudV2W5/rFBpAoz
        hRhOY8aKIxM15TgvR3l5v29r14ASv1WnPYyQ8e3C72c6pmi3FbDlQLSHhbnWRS6wIu8oKuDGFCKd0
        19QhW0xtRjARBBeG+8dL221yuqfF+Rnd9u3Bm8IkFQE7J7J/S19MfuCYjA6W02z/WyEw5kzj3Ckxe
        +7AT47knVTRFiPlPB64N8qd8LDXtflmiiZ77jGNQ/eaYgzN0vdU8Ag9JHD/c70NxMQ3zPDBgcE5jc
        Odldc8Yb+x2u55Gl4+WU6Tgb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqbq-000577-KH; Mon, 15 Mar 2021 17:02:26 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 04/10] io_uring: complete sq_thread setup before calling wake_up_new_task()
Date:   Mon, 15 Mar 2021 18:01:42 +0100
Message-Id: <5102936526dda9cd29e30d036c6eee7fd0388b7c.1615826736.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615826736.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 059bf8b9eb72..e7e2d87cd9c1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6690,18 +6690,8 @@ static int io_sq_thread(void *data)
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
-	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
 
-	sprintf(buf, "iou-sqp-%d", sqd->task_pid);
-	set_task_comm(current, buf);
-
-	if (sqd->sq_cpu != -1)
-		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
-		set_cpus_allowed_ptr(current, cpu_online_mask);
-	current->flags |= PF_NO_SETAFFINITY;
-
 	down_read(&sqd->rw_lock);
 
 	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
@@ -7853,6 +7843,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		fdput(f);
 	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		char tsk_comm[TASK_COMM_LEN];
 		struct task_struct *tsk;
 		struct io_sq_data *sqd;
 		bool attached;
@@ -7914,6 +7905,15 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err_sqpoll;
 		}
 
+		sprintf(tsk_comm, "iou-sqp-%d", sqd->task_pid);
+		set_task_comm(tsk, tsk_comm);
+
+		if (sqd->sq_cpu != -1)
+			set_cpus_allowed_ptr(tsk, cpumask_of(sqd->sq_cpu));
+		else
+			set_cpus_allowed_ptr(tsk, cpu_online_mask);
+		tsk->flags |= PF_NO_SETAFFINITY;
+
 		sqd->thread = tsk;
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
-- 
2.25.1

