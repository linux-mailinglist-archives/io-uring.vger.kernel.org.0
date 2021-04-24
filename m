Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABB236A397
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 01:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhDXX1f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 19:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhDXX1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 19:27:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F17C061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 16:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=ajZTDHCj2TUNbSdxVFae/BLkuwP+FZOeBPR0qAbxsXM=; b=EOHlbn8nmM/W+E0H+fDAeANClO
        iNNtQR9ASDGX/rWFDPL8UUNx+isFOohFrCrFZcT5wj0x1LXYumHBTcJ6EVJS11MCa/FHpb2KSetLH
        0Y6ojSRMk0Z4dMljhY9ChTv4PDumVRNaeDMlImhvLOUFcvf3AD0728K6g4wDG/MLkVcvuYtbxyKmE
        oqaNV29ws8uFLTzuM4bIurGAztzlRRnmtzgj6e1dnzGSC+rBUPjbIz0EgSOQso9LS+/OpSflBdWQo
        S83e4HiZXkoROIBQmQjqoULimH0NPlZalTIyrfWhuhjoQJIWjAkWQ5q7sMrBC1eHhX8d4eDcMEpJ4
        axKsMNzuAHqAA7dDCiHWArUOdcK+DJ+mhVdW7jirfrGfyShM6UZjiaDytA0KEKouiotzEJEaoYJbf
        k0SK4rdrCvUYqNei6ibvz94iERNm+mmbnpl6sq6NUQyFioUhJJsh8l8GtWPWZfCMVU9AhQHyIok0m
        nePVyRCx+ufh9Bz+p8gzGZO0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1laRfq-0007Ww-Nr; Sat, 24 Apr 2021 23:26:54 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 4/6] io_uring: complete sq_thread setup before calling wake_up_new_task()
Date:   Sun, 25 Apr 2021 01:26:06 +0200
Message-Id: <d9ef1236abbe13401a7bbc50eb55be7ee15e5483.1619306115.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619306115.git.metze@samba.org>
References: <cover.1619306115.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 234c4b8a015c..856289b13488 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6781,19 +6781,10 @@ static int io_sq_thread(void *data)
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
-	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
 
-	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
-	set_task_comm(current, buf);
-
-	if (sqd->sq_cpu != -1)
-		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
-		set_cpus_allowed_ptr(current, cpu_online_mask);
-	current->flags |= PF_NO_SETAFFINITY;
-
 	mutex_lock(&sqd->lock);
+
 	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
@@ -7888,6 +7879,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		fdput(f);
 	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		char tsk_comm[TASK_COMM_LEN];
 		struct task_struct *tsk;
 		struct io_sq_data *sqd;
 		bool attached;
@@ -7940,6 +7932,15 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err_sqpoll;
 		}
 
+		snprintf(tsk_comm, sizeof(tsk_comm), "iou-sqp-%d", sqd->task_pid);
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

