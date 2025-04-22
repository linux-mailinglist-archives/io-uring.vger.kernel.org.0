Return-Path: <io-uring+bounces-7629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8B1A972BC
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 18:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95FB6188717B
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9C52900A2;
	Tue, 22 Apr 2025 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hfoKYgLN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C282A14BFA2;
	Tue, 22 Apr 2025 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745339378; cv=none; b=GCIv+DufM6Pm1NIJOsLHhAWeRcnlLAK7UCHruoiZaOKsLu7woF6fpgItmOuEACqfnxa8RpcLXrEYcx5FiLTXKTFIN+NsDKVgWpN0GLpHRw5Ey4LXKpssbqRwRAQH2eJSMgG6FLmM8R2t8t/Sd4Lsyvdn+qzE+BQXe8tQHP3cUz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745339378; c=relaxed/simple;
	bh=dhxu5LR1UmF1TPg70+vcukV/gUPUQPs6MmejTOLIgPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HYkxK1CACQaoSrZsnFW2t4lv5MFvRCdaPwynRLT2dOtGG6/VC+0GYijYiPJg1nc1JzCHSvvGtYX7xfBZ171/cIew/x6jAq4XuRRnbdip1TSsJBrQkd+CvpanFnJD7CNWuw/HXowJB1k2OeXKHimFbsL/ajQ7x0q20i/5rhSHeKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hfoKYgLN; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-223fd89d036so66534255ad.1;
        Tue, 22 Apr 2025 09:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745339376; x=1745944176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGWcwKQmaZiYdj1a1V7uIYMMhxfylLN6zGwOKb4RBME=;
        b=hfoKYgLNNKjgjyrUIcxYCAapzLVvq6+0+KR0y3ukv1C6dmSxJNX4q6GDqRDf8ptKip
         EHPhFzEvdn3HWmTpgbinlIC3ExUaX5cy0dZwSuFyXk0AYT+M1gXWLxErcO6kM2QnB486
         VB6GEvnPD4iFHapEhZlndknfEOxjTLCl5WjON0o45gFlmMty8GEDl38tkW38w8cGVCVS
         Bw/vrY3NTinxeK5LKZR3+uosfiv6XStLr0VGN4cKdzKDU+ha5jqDGyTZJLtxiRlfqNeg
         64ePwrM0ASt+kKBawH4DDfDWzgjaiBNk/fkgKFKM619shacNhqAj/mUB1lHflpXO4Hg9
         /WdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745339376; x=1745944176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZGWcwKQmaZiYdj1a1V7uIYMMhxfylLN6zGwOKb4RBME=;
        b=Zq5ipDiNOhNTmjw65H757DPOJzETasX6inqQs/qdRzgcHrBIvrfKd3EFbqB1NLn450
         gBCCA7bJD2YbnfC97VyPkHLsyvvWY1XSVSXfp31aV3KXHAT/TVORt8LFAnwMNW80PPsO
         /Nta96t8iyK7jj3iH27pMdrrVpPtiy9Zg4w5QcKhVJbbOVbEqj/eTqZHREsp/v9p8mo1
         7ajjJPxg/3mZ4cRlsbV2rvGv9lHGbGbzczSTI+odN9X9NxgKhMn9BCDXL8D557XC8AFE
         isWAvPeUhHCnRd9utMDoCruT7nZG5iHO+L/4E1E6lvMlui2Vm0pvLuIc8QcZhgee2sXJ
         H1oA==
X-Forwarded-Encrypted: i=1; AJvYcCV/gt/QIyMpDVemGWaNpHvBx7FTC1obbUWQuR/AlRg0keZPSAcojGp3P/sqfgVS6b3nBqvlqcpQz0dFg84Ypg==@vger.kernel.org, AJvYcCWbxzLr+g6K29952jhJMZBju3flZBNSNua7t/8pKkdFj2KIcDI9Eka817WS1ELFaZZ8gd1b8IPYx6xxUvV1@vger.kernel.org, AJvYcCXGt5+R8KTqtZMdNC5Jw3WVZH2CtgQz8Fi+y19WEKQ/Vgq/0y59kv7jInEcjVKlkztfXdT4JQUkNw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa4XWBp90JzhD1Zi98btN2cAeQ4BeN2vRNaNruN7+Nr8ifXCRA
	3emw5zouAXV+8YChkmM0zzmte7U+H3+yQq9b+ZkRNhsNTXitejOF
X-Gm-Gg: ASbGncsygR6LAB49R7LMceBmP7Hu7eYWFLlnz9b4jvz/Oa27W5EDUzLWJHclk9SQmF3
	AAt2tlW8khFak4cBO4L7g/Qa65iFKne1g9GcergmE9SxM2bRX0dApZFCyFQ1eyZtWsO486Evwit
	f29QKj46iN2LMaJXD0M3bUGgeWOXH/cpgGr7lIo5L2cU5MofTrJtgmfBuNNlJrnMokIMV2UVEnU
	+Z2qbfsYeZPmQnQbwIKhZ3BwdtF0xxvsWHJI7WrL8EV0btRl2AN9wiOj2+wKooF+kPA0kDj7Hkf
	gI6pBjKiep+sVyfvahgyg4fU5nKxWSN2ehSzK6VvvVpSAfeWhNBZjc35DKFlG9LW9Qi3Uj5Cb+J
	dbLwLe9e1bZaknpw7fAQjw0RBdeRRTi6p5hecqVrwJR/iLYluEBwLTAWLWwYtYOpJM0eigsSuAE
	QdStZ7
X-Google-Smtp-Source: AGHT+IElm/lh7VyfuLradDvOYg4VHePKck6v5HX980zzUVwjtUOMYXTrCjwOUmx6CbuBc8VgW4RtPw==
X-Received: by 2002:a17:903:3bad:b0:223:4341:a994 with SMTP id d9443c01a7336-22c53285c80mr214749845ad.9.1745339375912;
        Tue, 22 Apr 2025 09:29:35 -0700 (PDT)
Received: from linux-devops-jiangzhiwei-1.asia-southeast1-a.c.monica-ops.internal (92.206.124.34.bc.googleusercontent.com. [34.124.206.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50fe20b0sm87481695ad.243.2025.04.22.09.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:29:35 -0700 (PDT)
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
Subject: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
Date: Tue, 22 Apr 2025 16:29:12 +0000
Message-Id: <20250422162913.1242057-2-qq282012236@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250422162913.1242057-1-qq282012236@gmail.com>
References: <20250422162913.1242057-1-qq282012236@gmail.com>
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
 io_uring/io-wq.c | 35 +++++++++++++++++++++++++++++------
 io_uring/io-wq.h | 12 ++++++++++--
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 04a75d666195..4a4f65de6699 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -30,6 +30,7 @@ enum {
 	IO_WORKER_F_UP		= 0,	/* up and active */
 	IO_WORKER_F_RUNNING	= 1,	/* account as running */
 	IO_WORKER_F_FREE	= 2,	/* worker on free list */
+	IO_WORKER_F_FAULT   = 3,    /* used for userfault */
 };
 
 enum {
@@ -706,6 +707,26 @@ static int io_wq_worker(void *data)
 	return 0;
 }
 
+void set_userfault_flag_for_ioworker(void)
+{
+	struct io_worker *worker;
+
+	if (!(current->flags & PF_IO_WORKER))
+		return;
+	worker = current->worker_private;
+	set_bit(IO_WORKER_F_FAULT, &worker->flags);
+}
+
+void clear_userfault_flag_for_ioworker(void)
+{
+	struct io_worker *worker;
+
+	if (!(current->flags & PF_IO_WORKER))
+		return;
+	worker = current->worker_private;
+	clear_bit(IO_WORKER_F_FAULT, &worker->flags);
+}
+
 /*
  * Called when a worker is scheduled in. Mark us as currently running.
  */
@@ -715,12 +736,14 @@ void io_wq_worker_running(struct task_struct *tsk)
 
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
index d4fb2940e435..8567a9c819db 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -70,8 +70,10 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 					void *data, bool cancel_all);
 
 #if defined(CONFIG_IO_WQ)
-extern void io_wq_worker_sleeping(struct task_struct *);
-extern void io_wq_worker_running(struct task_struct *);
+extern void io_wq_worker_sleeping(struct task_struct *tsk);
+extern void io_wq_worker_running(struct task_struct *tsk);
+extern void set_userfault_flag_for_ioworker(void);
+extern void clear_userfault_flag_for_ioworker(void);
 #else
 static inline void io_wq_worker_sleeping(struct task_struct *tsk)
 {
@@ -79,6 +81,12 @@ static inline void io_wq_worker_sleeping(struct task_struct *tsk)
 static inline void io_wq_worker_running(struct task_struct *tsk)
 {
 }
+static inline void set_userfault_flag_for_ioworker(void)
+{
+}
+static inline void clear_userfault_flag_for_ioworker(void)
+{
+}
 #endif
 
 static inline bool io_wq_current_is_worker(void)
-- 
2.34.1


