Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA02F342943
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 01:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCTABh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 20:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhCTABF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 20:01:05 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8B7C061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 17:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=o0yc+m9kh41c58kCVURfi74/HsMF9KNOkK53AWnls3Y=; b=bJlWmEWkVpcxXISrNtJ6DyGRE1
        Ah6mDUALa6RM24YCnvywfc3a8Wmlf5VyG3ERm6BPBfwhAKuHuYIrnHvEHPQq8ItrByfTVPShT5dmy
        6R15GQVhtdzn5dWbVp91hWT6l9F2LgE2bdxADMmxq2EE21Zic1elqQUfAmrk0bVrqRFtsEHWj7/AN
        TDVuwwBQ5lhufDAD4qPPR5US1mm5zytuVwLVr5a56q/T2jDALmQ9qMA3oA+blAmFrIvW8li51isVR
        U5VRcqdxs18pO4A/U0epDenzc8LWpHPcNUfsi0wCKzNe5lYrGFkghrwVsmleMy7eYYc+wVoUnjNB7
        +xazru/j8o4wdqIbafE15hVrexQWGsFh+GrwcfE+/YU4nahvjAiYPVeDLjBFXFQPzxVCIe0gX1h4y
        TVrnRJtchH3o9V1pF5E3abXdaP7oDlBbSiaQpatpHwVYahTQM5ZROKSh+F2nztcEK0O8gbDXwpvUH
        lRtwc9l1dk/2zO4TPzlAw2ec;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNP38-0007Wu-Ij; Sat, 20 Mar 2021 00:01:02 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 3/5] io-wq: call set_task_comm() before wake_up_new_task()
Date:   Sat, 20 Mar 2021 01:00:29 +0100
Message-Id: <aeba8ea8727f7d82de7e3b56251fb7064c18921e.1616197787.git.metze@samba.org>
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
 fs/io-wq.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e05f996d088f..d6b15a627f9a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -479,14 +479,10 @@ static int io_wqe_worker(void *data)
 	struct io_worker *worker = data;
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	io_wqe_inc_running(worker);
 
-	sprintf(buf, "iou-wrk-%d", wq->task_pid);
-	set_task_comm(current, buf);
-
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
@@ -567,6 +563,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
+	char tsk_comm[TASK_COMM_LEN];
 	struct task_struct *tsk;
 
 	__set_current_state(TASK_RUNNING);
@@ -591,6 +588,9 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		return false;
 	}
 
+	sprintf(tsk_comm, "iou-wrk-%d", wq->task_pid);
+	set_task_comm(tsk, tsk_comm);
+
 	tsk->pf_io_worker = worker;
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, cpumask_of_node(wqe->node));
@@ -702,12 +702,8 @@ static void io_wq_cancel_pending(struct io_wq *wq)
 static int io_wq_manager(void *data)
 {
 	struct io_wq *wq = data;
-	char buf[TASK_COMM_LEN];
 	int node;
 
-	sprintf(buf, "iou-mgr-%d", wq->task_pid);
-	set_task_comm(current, buf);
-
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		io_wq_check_workers(wq);
@@ -782,6 +778,11 @@ static int io_wq_fork_manager(struct io_wq *wq)
 	atomic_set(&wq->worker_refs, 1);
 	tsk = create_io_thread(io_wq_manager, wq, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
+		char tsk_comm[TASK_COMM_LEN];
+
+		sprintf(tsk_comm, "iou-mgr-%d", wq->task_pid);
+		set_task_comm(tsk, tsk_comm);
+
 		wq->manager = get_task_struct(tsk);
 		wake_up_new_task(tsk);
 		return 0;
-- 
2.25.1

