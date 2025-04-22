Return-Path: <io-uring+bounces-7601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8EEA95C70
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 05:02:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4723188EEFE
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 03:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2E38249F;
	Tue, 22 Apr 2025 03:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8RIyfTZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB87110A1F;
	Tue, 22 Apr 2025 03:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745290930; cv=none; b=PZN1nnYzWPv4FJacPxAI+V4jw1FGiY+r31JArjSjcDsu3OJSNV9H0I8PDzssDLfjgifvkG3ynW1FsxMLTtkRiVOFGy2kDo9fy2vCcJZsXjrs3xXMJiz7dYa/I3dCVruiuCjPjvc1HEvzdKOltMEoyw2+if/GFShQNFG/gATPgUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745290930; c=relaxed/simple;
	bh=5ON3Qc96t4HPtldyPAv1fdNFgCXbMaHyskQ2ScUxLXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BMxA3XkejjTYOHT9L0Le1N5sGIFeuL2WKLXnlHyxyr9QTxgFaxSUaRESlTz+TbJLnOZMc1RSaRavUpwnPKfBCI6mGYnYjA4rxKaEy3w0i9/Q/2H8FVMRbujHNdMrqI7GzV+0wzpPq5m69VFHQkwxCTtjscQZ4bFYjN1sFvuvPCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8RIyfTZ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-73712952e1cso4320394b3a.1;
        Mon, 21 Apr 2025 20:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745290928; x=1745895728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=46xNBkAds9S2JuwMvzLESb7WgL9Z7roCgubVvThFP7A=;
        b=j8RIyfTZ7lxLY2/BTjnS5sVx38Tc0wSDmwe9aRR3rXw/gwCnSAsGBpjLfZ9pmLKSRz
         1UFAEALV72tddXCaDDD/PDrHy4gUs/r22yWxpdJ1FvgE1ky9+19LsOQ+a995vJL3IlXK
         AYrKnKsOdvfyfxX4NIaY4/3Z1iJbBUjwr/CS7NYxpboO+CWp/ewhkXfss5uX2t0bPLrR
         tfmefGTsdnIr1oFcrbfYgdQ5IaVKOfrctm+eggMYyoEHAJnzf8V6hoL+x8z54Er8oPki
         xtH/zqzhRUHlWshW9sM1/6XqxVx2aXAlIMoFpAnsrVfSYDsXJFbxcXYiNp1KH9Mz0c/X
         E0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745290928; x=1745895728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=46xNBkAds9S2JuwMvzLESb7WgL9Z7roCgubVvThFP7A=;
        b=VMUUcNoCAdti7ObmaGiVZ9P4KmvIYSZ7RjGHLLbxOmLj0/BQVMHfGaJ+3fe0BwpFsR
         R8W+tauwrwIFXY00Bm1J9yhR8qZpWZpfzErfjwb1kcTIdsn14EvlY2XFaXH8tK55NzsL
         HF4EzkAlgIq0nPtPzSDTpb8EFHHa6sTVU7MVCoq8F5jViROA9JwEgVXOUXAQa+JmT71T
         mhK9jiW4PrJ7NHtHMvnlh1pONokJ3ZeHyq9ECiT9oTpgh/yZEvFyd03OutntJpzEmpkN
         4hsJA11JiX3PRFl/1ctsykGNgDaDI/G5BROJGykWQboYAQNAiht5VOWMgNuqf834UjrG
         NsNw==
X-Forwarded-Encrypted: i=1; AJvYcCUGt0J4KpEonIdT+ig9BBt3OGMY/Z7Zeo9eP4ejwaVbwCngC19fyvH8VtEdPtkGzOQ832u7Ab7tgCEk49Kc@vger.kernel.org, AJvYcCVDtKUMsgeL7FllDM4cHm+gIG+ilcP91guSpGOsAJb/koo91mKGAVetCzE8txSRWclY/Hr2u+cRiw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyckd7fZvRJpLu3nMp5oBeles1upx1McMb9ca5C5QHf8v5JiUF1
	wzZzt7eoWvFVlt4Gxv1ffJZiPzeXn+BFnGCWGyOsYW5b8DigosRY7x95ZrRZIDE=
X-Gm-Gg: ASbGnctQjNHS9MANDg8nS4k7aLsdkm3HOqRMeBtjm0mMRkieIon8Zu3VKasZrLkd/KO
	WjZAb34PhcGAqVIEY3QVlhKh9SmXYmR66fZr9ZbMGaBchkiVM+yTMd4vK4BhHJUGUkF7Cf/FX1h
	smL8+yjIXaNB+q5BnKl7JvEA8iDqSYgGObBzx8snrDyxNQmSlj9hInTi12Q3nWfYVoFE8hpRUsF
	HMc+e32wJy8j/3IcNxtwNt4FwzZIMXeF3TOQEacBFnuFSB4aiX8ocvRkDOaQe5J3zYWKy+816v/
	aqTP1epild9m0MTK7FnV7tU7w83m/0ASIddTra3xCecK5Ru8AaGvluWXILBhFc2jbhfxIHP/F2w
	x9erFdEt8jp/3nwR/+qd2NdeOEJQkNEkfPF4FoZrzaFIVLLNZRL0eViYtlXldUS5VALrqqqhTL7
	MkfmLy
X-Google-Smtp-Source: AGHT+IHvRxiGMIV549Ju+407cklJuhZxZinWGWSbAzqkqNkr54azKuXxE0PPpHlGwWmLTfZOrpm95w==
X-Received: by 2002:a05:6a00:35c8:b0:736:50d1:fc84 with SMTP id d2e1a72fcca58-73dc1616ae5mr18996998b3a.21.1745290927944;
        Mon, 21 Apr 2025 20:02:07 -0700 (PDT)
Received: from linux-devops-jiangzhiwei-1.asia-southeast1-a.c.monica-ops.internal (92.206.124.34.bc.googleusercontent.com. [34.124.206.92])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbfaacf9fsm7620725b3a.130.2025.04.21.20.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 20:02:07 -0700 (PDT)
From: Zhiwei Jiang <qq282012236@gmail.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhiwei Jiang <qq282012236@gmail.com>
Subject: [PATCH] io_uring: Add new functions to handle user fault scenarios
Date: Tue, 22 Apr 2025 03:01:53 +0000
Message-Id: <20250422030153.1166445-1-qq282012236@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the Firecracker VM scenario, sporadically encountered threads with
the UN state in the following call stack:
[<0>] io_wq_put_and_exit+0xa1/0x210
[<0>] io_uring_clean_tctx+0x8e/0xd0
[<0>] io_uring_cancel_generic+0x19f/0x370
[<0>] __io_uring_cancel+0x14/0x20
[<0>] do_exit+0x17f/0x510
[<0>] do_group_exit+0x35/0x90
[<0>] get_signal+0x963/0x970
[<0>] arch_do_signal_or_restart+0x39/0x120
[<0>] syscall_exit_to_user_mode+0x206/0x260
[<0>] do_syscall_64+0x8d/0x170
[<0>] entry_SYSCALL_64_after_hwframe+0x78/0x80
The cause is a large number of IOU kernel threads saturating the CPU
and not exiting. When the issue occurs, CPU usage 100% and can only
be resolved by rebooting. Each thread's appears as follows:
iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork_asm
iou-wrk-44588  [kernel.kallsyms]  [k] ret_from_fork
iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
iou-wrk-44588  [kernel.kallsyms]  [k] io_write
iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault
iou-wrk-44588  [kernel.kallsyms]  [k] schedule
iou-wrk-44588  [kernel.kallsyms]  [k] __schedule
iou-wrk-44588  [kernel.kallsyms]  [k] __raw_spin_unlock_irq
iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker_sleeping

I tracked the address that triggered the fault and the related function
graph, as well as the wake-up side of the user fault, and discovered this
: In the IOU worker, when fault in a user space page, this space is
associated with a userfault but does not sleep. This is because during
scheduling, the judgment in the IOU worker context leads to early return.
Meanwhile, the listener on the userfaultfd user side never performs a COPY
to respond, causing the page table entry to remain empty. However, due to
the early return, it does not sleep and wait to be awakened as in a normal
user fault, thus continuously faulting at the same address,so CPU loop.

Therefore, I believe it is necessary to specifically handle user faults by
setting a new flag to allow schedule function to continue in such cases,
make sure the thread to sleep.Export the relevant functions and struct for
user fault.

Signed-off-by: Zhiwei Jiang <qq282012236@gmail.com>
---
 io_uring/io-wq.c | 57 +++++++++++++++---------------------------------
 io_uring/io-wq.h | 45 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 41 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 04a75d666195..8faad766d565 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -26,12 +26,6 @@
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
 #define WORKER_INIT_LIMIT	3
 
-enum {
-	IO_WORKER_F_UP		= 0,	/* up and active */
-	IO_WORKER_F_RUNNING	= 1,	/* account as running */
-	IO_WORKER_F_FREE	= 2,	/* worker on free list */
-};
-
 enum {
 	IO_WQ_BIT_EXIT		= 0,	/* wq exiting */
 };
@@ -40,33 +34,6 @@ enum {
 	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
 };
 
-/*
- * One for each thread in a wq pool
- */
-struct io_worker {
-	refcount_t ref;
-	unsigned long flags;
-	struct hlist_nulls_node nulls_node;
-	struct list_head all_list;
-	struct task_struct *task;
-	struct io_wq *wq;
-	struct io_wq_acct *acct;
-
-	struct io_wq_work *cur_work;
-	raw_spinlock_t lock;
-
-	struct completion ref_done;
-
-	unsigned long create_state;
-	struct callback_head create_work;
-	int init_retries;
-
-	union {
-		struct rcu_head rcu;
-		struct delayed_work work;
-	};
-};
-
 #if BITS_PER_LONG == 64
 #define IO_WQ_HASH_ORDER	6
 #else
@@ -706,6 +673,16 @@ static int io_wq_worker(void *data)
 	return 0;
 }
 
+void set_userfault_flag_for_ioworker(struct io_worker *worker)
+{
+	set_bit(IO_WORKER_F_FAULT, &worker->flags);
+}
+
+void clear_userfault_flag_for_ioworker(struct io_worker *worker)
+{
+	clear_bit(IO_WORKER_F_FAULT, &worker->flags);
+}
+
 /*
  * Called when a worker is scheduled in. Mark us as currently running.
  */
@@ -715,12 +692,14 @@ void io_wq_worker_running(struct task_struct *tsk)
 
 	if (!worker)
 		return;
-	if (!test_bit(IO_WORKER_F_UP, &worker->flags))
-		return;
-	if (test_bit(IO_WORKER_F_RUNNING, &worker->flags))
-		return;
-	set_bit(IO_WORKER_F_RUNNING, &worker->flags);
-	io_wq_inc_running(worker);
+	if (!test_bit(IO_WORKER_F_FAULT, &worker->flags)) {
+		if (!test_bit(IO_WORKER_F_UP, &worker->flags))
+			return;
+		if (test_bit(IO_WORKER_F_RUNNING, &worker->flags))
+			return;
+		set_bit(IO_WORKER_F_RUNNING, &worker->flags);
+		io_wq_inc_running(worker);
+	}
 }
 
 /*
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index d4fb2940e435..9444912d038d 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -15,6 +15,13 @@ enum {
 	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
 };
 
+enum {
+	IO_WORKER_F_UP		= 0,	/* up and active */
+	IO_WORKER_F_RUNNING	= 1,	/* account as running */
+	IO_WORKER_F_FREE	= 2,	/* worker on free list */
+	IO_WORKER_F_FAULT	= 3,	/* used for userfault */
+};
+
 enum io_wq_cancel {
 	IO_WQ_CANCEL_OK,	/* cancelled before started */
 	IO_WQ_CANCEL_RUNNING,	/* found, running, and attempted cancelled */
@@ -24,6 +31,32 @@ enum io_wq_cancel {
 typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
 typedef void (io_wq_work_fn)(struct io_wq_work *);
 
+/*
+ * One for each thread in a wq pool
+ */
+struct io_worker {
+	refcount_t ref;
+	unsigned long flags;
+	struct hlist_nulls_node nulls_node;
+	struct list_head all_list;
+	struct task_struct *task;
+	struct io_wq *wq;
+	struct io_wq_acct *acct;
+
+	struct io_wq_work *cur_work;
+	raw_spinlock_t lock;
+	struct completion ref_done;
+
+	unsigned long create_state;
+	struct callback_head create_work;
+	int init_retries;
+
+	union {
+		struct rcu_head rcu;
+		struct delayed_work work;
+	};
+};
+
 struct io_wq_hash {
 	refcount_t refs;
 	unsigned long map;
@@ -70,8 +103,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 					void *data, bool cancel_all);
 
 #if defined(CONFIG_IO_WQ)
-extern void io_wq_worker_sleeping(struct task_struct *);
-extern void io_wq_worker_running(struct task_struct *);
+extern void io_wq_worker_sleeping(struct task_struct *tsk);
+extern void io_wq_worker_running(struct task_struct *tsk);
+extern void set_userfault_flag_for_ioworker(struct io_worker *worker);
+extern void clear_userfault_flag_for_ioworker(struct io_worker *worker);
 #else
 static inline void io_wq_worker_sleeping(struct task_struct *tsk)
 {
@@ -79,6 +114,12 @@ static inline void io_wq_worker_sleeping(struct task_struct *tsk)
 static inline void io_wq_worker_running(struct task_struct *tsk)
 {
 }
+static inline void set_userfault_flag_for_ioworker(struct io_worker *worker)
+{
+}
+static inline void clear_userfault_flag_for_ioworker(struct io_worker *worker)
+{
+}
 #endif
 
 static inline bool io_wq_current_is_worker(void)
-- 
2.34.1


