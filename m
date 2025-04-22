Return-Path: <io-uring+bounces-7609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB0AA96641
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 12:46:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FCD4189D480
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 10:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FDB1E231E;
	Tue, 22 Apr 2025 10:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMtqXC1r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E42E14A4DB;
	Tue, 22 Apr 2025 10:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745318774; cv=none; b=RL+o7MJgx2wZG09Xby0NPXtQ8MaCu6Sv2ar1kwLnohoM5crfKD71tSz5WFYiLrlDhWIGXwPgnXYp5lKyKEZaUS4J+krsijY+HJ0GTd7aTtP7+Pjaqk1piQBNSTCfBdFkdWazVAVw1y6kY5FwRNc6QSX+VTT/NwmVdfYwj/ELrdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745318774; c=relaxed/simple;
	bh=5ON3Qc96t4HPtldyPAv1fdNFgCXbMaHyskQ2ScUxLXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MTktV1monnfw34FPWYaY3pH0Altva83iWSv2238aQq0ZSc25QbeZKBcwq8Zm/MAvNKiMwxz8Z8BwMARSpI5+6rXu7ATCVzZtwot2sbHOmpkkT43OQ/8YZvAM6jn6yWndRs/JU6AGW8laliTv6Bsj37jS2P8WSpGxIpgm/S5d8ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HMtqXC1r; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-af5139ad9a2so3073267a12.1;
        Tue, 22 Apr 2025 03:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745318771; x=1745923571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46xNBkAds9S2JuwMvzLESb7WgL9Z7roCgubVvThFP7A=;
        b=HMtqXC1rMSSl5upHX20PF80AsxXu0w26o2v4L7nhFG6hvtBvDeA67GcPFDHpNmkoJe
         3TzRrqXKlDTW/DCiVA0rCyr6z/01u0ncoqEia6iCu9jCkYvwi731MvZfjzQxVQiqLGUD
         6SmgOGog4Y4AAy1e7hJQMesAEdi/77UnvugqE3Xu2NhyJjqtU3aSg/AJlUGv2NGqDNIw
         E0XQeiB8FcSWeZFkRTuFL3pn9U4taFG2ALWpEx7oreuynRgUHMAB1BhbjJhkihUCTLaG
         AezyZ5xFh1dRPtD1m00veojpP+mEGsYhilgTvjO0ap1sihmSVokbRLjWgr8t+th+wn5h
         IRiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745318771; x=1745923571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46xNBkAds9S2JuwMvzLESb7WgL9Z7roCgubVvThFP7A=;
        b=qLI350bPP+9bKQnbE19YmEmNGsUi3NYOHI0gRlWK1JoJ6+pxY34ypdPiuhYY8R274d
         U/x646DMMZnFv+ie/j22ph/W+S4YE0A3XvLi1Ac6M+pYKrq+JrsySOr87iuIryw91VnT
         kSJvrugp5NB6lUOXi4WnX6WVCegNeShTK9JfxgqPeCXPDnsiwL9hnF1gygHkKmPX35qL
         D5TDyeObGvalQknLuFxppYNOuMICUyUodD6PQsqDqhSbYrC0ZDNrYIVydoHf3y1YCKyZ
         h7kODLZHthSsLz7/td/RTcbCyiVlysyMQcmcAhOaWxy3/Trm5YcD1jb3SUp0+8fCNB54
         AyNw==
X-Forwarded-Encrypted: i=1; AJvYcCUOjigr3Urn0WiTLk50hTk9ZczTZULeZNMbgultdKcFiZ+nUWW4v/Gfeqg4z8XaN963ymBFtuYQRg==@vger.kernel.org, AJvYcCUQ5211HPRMZCDPvNIqeQaAwdJb8YZtxafIzgOfomu8NNxWBFRkQzwwOatS0C/T3rKHAiOaEejtjuVL2hTi@vger.kernel.org, AJvYcCVJD1uAuIn/mZSeJ5RXRs39NjLiPKz/iZXmH/2Wd2ceXts8ldIBt7h1RrIPLhaIqu0Spom607qPYfy3VRQkwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz1Ac2AmEjHqJ+yz9Ss2b36lBhxOEh18o3emWEY3b/MAHCpH07
	qDIjUzMrisr7C9SRyzgVu3GsQPq2vrT/rtRscThhj2332Dqg4BIJ
X-Gm-Gg: ASbGnctcNc85Yy4tDtSQzIq2MSxYM/OulNdZxgYOdvVT2Dg2MtPmyVubNAuk59maagL
	0nkXHN25KynhB2q0tnqON3srSx21GeMP2PrfqZkn3eRhOx8CfD6hNvZ0vmnNWcp5kWwwXiRDpyd
	bo+pq5M2g0YC29fbiJxwvrGFSDQyA1pUF5mHR0tuSQTD+zmwVG4qZGSBAHOcOnXCgOucmC5j9Ib
	76m4Ye1EfEtfwCdJh+UvPSvOowlhNlVgtmzBRXK6GHNWMANFN+DPlzQP4KRy/A+ama78JQsLRI6
	96oKWIlLMtweX3KmnwhBHPUb5cTD3zWjDvgOdRa1PH8Ok0h7naK5GsFwwcnkOTUgfi2NWU9eLJN
	rFMJEe5HBzD/gLK5r+OKAx4zzNuTahhga088KggIEfIKeUv4l/a8XinOE6CBbHVTKwqadye9dSV
	E/3A9X2Hlgm1Omysw=
X-Google-Smtp-Source: AGHT+IEqm/DNI3N1N8dhJ0Fxva3uN96gL/QRNLBQRrVtNPBP7fWK3AnIAn74ryqa0MNY4U0+zJHsUg==
X-Received: by 2002:a17:90b:2810:b0:2fa:f8d:65de with SMTP id 98e67ed59e1d1-3087bbc2abfmr18128646a91.22.1745318771409;
        Tue, 22 Apr 2025 03:46:11 -0700 (PDT)
Received: from linux-devops-jiangzhiwei-1.asia-southeast1-a.c.monica-ops.internal (92.206.124.34.bc.googleusercontent.com. [34.124.206.92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3087e05e90bsm8276853a91.45.2025.04.22.03.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 03:46:11 -0700 (PDT)
From: Zhiwei Jiang <qq282012236@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	peterx@redhat.com,
	axboe@kernel.dk,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Zhiwei Jiang <qq282012236@gmail.com>
Subject: [PATCH 1/2] io_uring: Add new functions to handle user fault scenarios
Date: Tue, 22 Apr 2025 10:45:44 +0000
Message-Id: <20250422104545.1199433-2-qq282012236@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250422104545.1199433-1-qq282012236@gmail.com>
References: <20250422104545.1199433-1-qq282012236@gmail.com>
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


