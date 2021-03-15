Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A091B33C342
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhCORDi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbhCORDE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:03:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B6DC061762
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=c2SxynwctQmTrDaAlmNiLuiJ0yItv+NCnzUmPWG2FW0=; b=EEfd8scG3WhEpo9LjuRvaR5uBj
        WM3SF/ayJgPVZyZmsnLwT+N2AKMe7izmK9CGDnqkFAv6Rb3DT3MYTx71BozaDHOFKfju/gdkSJ4rk
        4ybbsE26jxdtd+sd+RX9+gJlDeTdZNgiWfNKXmQ9Tjp2nz/XnEaUM17+NG65Dgf80OxNATOyTxSdN
        g40MoEPhuOO4b7xpiKK+DhBwMbjRNRNKng5vL3UsOLPTRsKUldNn0qtBwvGAkb1HEQAJVyywNbK94
        8d+yxNqwf0BO0y39XqRE2TbS0dA+vF6NbVERpA827p0V9bsgVH1Itia3/JlHHhY8v1Wegqp8VfSiW
        8+aiHnKf9OvRc0IYBe1ZtgznfrLty6sr+CTwcVw4KluOqJZxQEePHzkLZMSJpmNPsxMvVksuO+KTI
        Pn6U/qiRzwhTSxhv2JFXlrdtJ1yd2PTqN4DexXguSVMg84K+5A248Hv2E5EcYZQHTmBExextpxwAh
        l8/NAYPf7BHLnvWfF/y8CARa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqcQ-00057k-CZ; Mon, 15 Mar 2021 17:03:02 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 09/10] io-wq: add io_wq_worker_comm() helper function for dynamic proc_task_comm() generation
Date:   Mon, 15 Mar 2021 18:01:47 +0100
Message-Id: <9aa08ab77fcaf45b5e2975404da6a6f1e93b809a.1615826736.git.metze@samba.org>
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
 fs/io-wq.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/io-wq.h |  4 +++
 2 files changed, 81 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5c7d2a8c112e..1267171f6388 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -559,6 +559,83 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	raw_spin_unlock_irq(&worker->wqe->lock);
 }
 
+/* used to show worker information through /proc/PID/{comm,stat,status} */
+void io_wq_worker_comm(char *buf, size_t size, struct task_struct *tsk)
+{
+	struct io_worker *worker = tsk->pf_io_worker;
+	bool working = false;
+	unsigned flags = 0;
+	unsigned int cpu;
+	int node;
+	int wqe_node = NUMA_NO_NODE;
+	int off;
+
+	BUG_ON(!(tsk->flags & PF_IO_WORKER));
+
+	/* prepend iothread/ to the actual comm */
+	off = scnprintf(buf, size, "iothread/%s", tsk->comm);
+	if (off < 0)
+		return;
+
+	cpu = task_cpu(tsk);
+	node = cpu_to_node(cpu);
+
+	if (worker && io_worker_get(worker)) {
+		spin_lock_irq(&worker->lock);
+		flags = worker->flags;
+		working = worker->cur_work != NULL;
+		wqe_node = worker->wqe->node;
+		spin_unlock_irq(&worker->lock);
+		io_worker_release(worker);
+	}
+
+	/*
+	 * It may or may not run on the desired node
+	 */
+	if (node == wqe_node)
+		off += scnprintf(buf + off, size - off, "/+numa%u", node);
+	else
+		off += scnprintf(buf + off, size - off, "/-numa%u", node);
+	if (off < 0)
+		return;
+
+	/*
+	 * It maybe created via create_io_thread(), but not
+	 * via the create_io_worker() wrapper.
+	 */
+	if (worker == NULL)
+		return;
+
+	if (!(flags & IO_WORKER_F_UP))
+		off += scnprintf(buf + off, size - off, "-down");
+	else if (flags & IO_WORKER_F_FREE)
+		off += scnprintf(buf + off, size - off, "-free");
+	else if (flags & IO_WORKER_F_RUNNING) {
+		if (working)
+			off += scnprintf(buf + off, size - off, "+working");
+		else
+			off += scnprintf(buf + off, size - off, "+running");
+		if (off < 0)
+			return;
+	}
+	if (off < 0)
+		return;
+
+	if (flags & IO_WORKER_F_BOUND)
+		off += scnprintf(buf + off, size - off, "+bound");
+	else
+		off += scnprintf(buf + off, size - off, "-unbound");
+	if (off < 0)
+		return;
+
+	if (flags & IO_WORKER_F_FIXED)
+		off += scnprintf(buf + off, size - off, "+fixed");
+	if (off < 0)
+		return;
+
+	return;
+}
+
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 80d590564ff9..470f854256d1 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -140,6 +140,7 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 #if defined(CONFIG_IO_WQ)
 extern void io_wq_worker_sleeping(struct task_struct *);
 extern void io_wq_worker_running(struct task_struct *);
+extern void io_wq_worker_comm(char *buf, size_t size, struct task_struct *tsk);
 #else
 static inline void io_wq_worker_sleeping(struct task_struct *tsk)
 {
@@ -147,6 +148,9 @@ static inline void io_wq_worker_sleeping(struct task_struct *tsk)
 static inline void io_wq_worker_running(struct task_struct *tsk)
 {
 }
+static inline void io_wq_worker_comm(char *buf, size_t size, struct task_struct *tsk)
+{
+}
 #endif
 
 static inline bool io_wq_current_is_worker(void)
-- 
2.25.1

