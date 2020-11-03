Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E963B2A3AAF
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 03:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgKCCyu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 21:54:50 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:59605 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725953AbgKCCyu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 21:54:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UE2aQPO_1604372077;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UE2aQPO_1604372077)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Nov 2020 10:54:46 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 RESEND] io_uring: add timeout support for io_uring_enter()
Date:   Tue,  3 Nov 2020 10:54:37 +0800
Message-Id: <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
References: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now users who want to get woken when waiting for events should submit a
timeout command first. It is not safe for applications that split SQ and
CQ handling between two threads, such as mysql. Users should synchronize
the two threads explicitly to protect SQ and that will impact the
performance.

This patch adds support for timeout to existing io_uring_enter(). To
avoid overloading arguments, it introduces a new parameter structure
which contains sigmask and timeout.

I have tested the workloads with one thread submiting nop requests
while the other reaping the cqe with timeout. It shows 1.8~2x faster
when the iodepth is 16.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 48 +++++++++++++++++++++++++++++++++++++------
 include/uapi/linux/io_uring.h |  7 +++++++
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91e2cc8414f9..cd89a7fbaafd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6653,7 +6653,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
  * application must reap them itself, as they reside on the shared cq ring.
  */
 static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
-			  const sigset_t __user *sig, size_t sigsz)
+			  const sigset_t __user *sig, size_t sigsz,
+			  struct __kernel_timespec __user *uts)
 {
 	struct io_wait_queue iowq = {
 		.wq = {
@@ -6665,6 +6666,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		.to_wait	= min_events,
 	};
 	struct io_rings *rings = ctx->rings;
+	struct timespec64 ts;
+	signed long timeout = 0;
 	int ret = 0;
 
 	do {
@@ -6687,6 +6690,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			return ret;
 	}
 
+	if (uts) {
+		if (get_timespec64(&ts, uts))
+			return -EFAULT;
+		timeout = timespec64_to_jiffies(&ts);
+	}
+
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
@@ -6708,7 +6717,15 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		if (io_should_wake(&iowq, false))
 			break;
-		schedule();
+		if (uts) {
+			timeout = schedule_timeout(timeout);
+			if (timeout == 0) {
+				ret = -ETIME;
+				break;
+			}
+		} else {
+			schedule();
+		}
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
@@ -8207,19 +8224,38 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 #endif /* !CONFIG_MMU */
 
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
-		u32, min_complete, u32, flags, const sigset_t __user *, sig,
+		u32, min_complete, u32, flags, const void __user *, argp,
 		size_t, sigsz)
 {
 	struct io_ring_ctx *ctx;
 	long ret = -EBADF;
 	int submitted = 0;
 	struct fd f;
+	const sigset_t __user *sig;
+	struct __kernel_timespec __user *ts;
+	struct io_uring_getevents_arg arg;
 
 	io_run_task_work();
 
-	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
+	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
+		      IORING_ENTER_GETEVENTS_TIMEOUT))
 		return -EINVAL;
 
+	/* deal with IORING_ENTER_GETEVENTS_TIMEOUT */
+	if (flags & IORING_ENTER_GETEVENTS_TIMEOUT) {
+		if (!(flags & IORING_ENTER_GETEVENTS))
+			return -EINVAL;
+		if (sigsz != sizeof(arg))
+			return -EINVAL;
+		if (copy_from_user(&arg, argp, sizeof(arg)))
+			return -EFAULT;
+		sig = arg.sigmask;
+		ts = arg.ts;
+	} else {
+		sig = (const sigset_t __user *)argp;
+		ts = NULL;
+	}
+
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
@@ -8266,7 +8302,7 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
 			ret = io_iopoll_check(ctx, min_complete);
 		} else {
-			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
+			ret = io_cqring_wait(ctx, min_complete, sig, sigsz, ts);
 		}
 	}
 
@@ -8572,7 +8608,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
-			IORING_FEAT_POLL_32BITS;
+			IORING_FEAT_POLL_32BITS | IORING_FEAT_GETEVENTS_TIMEOUT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d65fde732518..68b94617981a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -224,6 +224,7 @@ struct io_cqring_offsets {
  */
 #define IORING_ENTER_GETEVENTS	(1U << 0)
 #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
+#define IORING_ENTER_GETEVENTS_TIMEOUT	(1U << 2)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -251,6 +252,7 @@ struct io_uring_params {
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
 #define IORING_FEAT_FAST_POLL		(1U << 5)
 #define IORING_FEAT_POLL_32BITS 	(1U << 6)
+#define IORING_FEAT_GETEVENTS_TIMEOUT	(1U << 7)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -290,4 +292,9 @@ struct io_uring_probe {
 	struct io_uring_probe_op ops[0];
 };
 
+struct io_uring_getevents_arg {
+	sigset_t *sigmask;
+	struct __kernel_timespec *ts;
+};
+
 #endif
-- 
1.8.3.1

