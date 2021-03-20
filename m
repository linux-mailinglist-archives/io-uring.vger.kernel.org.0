Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F31342945
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 01:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCTABh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 20:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCTABM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 20:01:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9314AC061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 17:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=WhPCB05GOBHRw6bRJ4ite5LfV/D8+1OCHigBySvTQ/8=; b=i326fUpvT1eJLF/IXts51L/Hhm
        F5Fpnl7PEDF+PMW0WY+lr8IAzyajLDatQ/LWcwJKbm3pgPI39YbUZ5iARar43OLzSFzeQGEUpI6CK
        lfXYAtm5ig640EeBsStiEndqfoBUjp3YWi8/bh0iqadp/+bIu039CSOF4E1BQ9aSE2fAuutRW7cKo
        wrTM9Xsdhjp5GFExBKUqV0DJOQyMPf5hqDyi44H/J41+Elf5nJkpUS1x7dr1+CMTeTYbGFboH/O3p
        gxpBKhLgiDpNQzVcj6dQZ/hUPBw46XM94NFe9jQwyXZszcMj1xXwGorgPAESDftXScVe9YqBw8ytE
        Z/BN2sk6nH2ugN4c54Bbk5dAaQ0c5fSRBYyPDlrZv1Jwz7etLMSq+vf5NHpejY6PYep/N216uRCmq
        ABeXdfmSVCJUY+yaB4Wequ7ZqhM8PJM0NJVnwqoHIni7JJhgZuXnEX3v86bRQYxF9t1yWbEcZQ6v4
        aNSmd6hfE6OBhKChLwz10Sq6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNP3F-0007X5-KB; Sat, 20 Mar 2021 00:01:09 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 4/5] io_uring: complete sq_thread setup before calling wake_up_new_task()
Date:   Sat, 20 Mar 2021 01:00:30 +0100
Message-Id: <cb91a26d18eea02cb2d6b24923d97cae4af0d92e.1616197787.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1616197787.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org> <cover.1616197787.git.metze@samba.org>
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
index cf46b890a36f..320672930d87 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6721,19 +6721,10 @@ static int io_sq_thread(void *data)
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
 	mutex_lock(&sqd->lock);
+
 	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
@@ -7887,6 +7878,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		fdput(f);
 	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		char tsk_comm[TASK_COMM_LEN];
 		struct task_struct *tsk;
 		struct io_sq_data *sqd;
 		bool attached;
@@ -7943,6 +7935,15 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
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

