Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0383433C336
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhCORDI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbhCORCW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE686C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=o0yc+m9kh41c58kCVURfi74/HsMF9KNOkK53AWnls3Y=; b=trkllKG0MLciizdPnVaxtuv6B2
        3sYzKYWHDISHUURDslZ6ec7Wz41vmw3EUQagvAUMbT8Jofb6WIpqmhe+kOSUHXfvedmoIYIKGcs2Y
        w/zzl9sx0GLvg2NOcR0UHMtRw4rX6Qft0YgVKT9YJ6DnZxIbts1xVK33XKiXvQIOL+D4OQlHeFZ8w
        V7MYED4JrfTMgkiEWeFrcU3YQoyWFP192yu8KFd9dIBqlINruua3nOXQBxYKz+HpLXIiAjvzm7ETq
        7s9F+gXPr4uot49Sd+TztKEZwbqlNrdR8JA/iG0XnD5/4Hsgk6fpuTIK99gTMcHamMObmIebg4U6K
        W/ZnDZ0h5Gp/1yElQamSlYMZKodybybZLn/U4E/dYxzKKkaiWMNBdatGvpJiKJG9wrztF3vaPhXOg
        gecJwRNXvzBgmNC0XnGNycWhnt4zaK5mrjzPsLr3Xqftf7G53XAk3YSKSYxeSXY+G5TBEo5ZrGlJo
        mXTmsRTqpjnUmTFukq1DRmS2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqbj-00056u-UT; Mon, 15 Mar 2021 17:02:20 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 03/10] io-wq: call set_task_comm() before wake_up_new_task()
Date:   Mon, 15 Mar 2021 18:01:41 +0100
Message-Id: <a80c237e136adf660b4b564942e26a2469a9ee54.1615826736.git.metze@samba.org>
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

