Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BA1231C57
	for <lists+io-uring@lfdr.de>; Wed, 29 Jul 2020 11:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgG2JzD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jul 2020 05:55:03 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:34543 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbgG2JzD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jul 2020 05:55:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07425;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U48nllf_1596016490;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U48nllf_1596016490)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Jul 2020 17:54:50 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: [PATCH] io_uring: add timeout support for io_uring_enter()
Date:   Wed, 29 Jul 2020 17:54:49 +0800
Message-Id: <1596016489-25231-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
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
---
 fs/io_uring.c                 | 49 +++++++++++++++++++++++++++++++++++++------
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 32b0064..c65fd0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6191,7 +6191,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
  * application must reap them itself, as they reside on the shared cq ring.
  */
 static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
-			  const sigset_t __user *sig, size_t sigsz)
+			  const sigset_t __user *sig, size_t sigsz,
+			  struct __kernel_timespec __user *uts)
 {
 	struct io_wait_queue iowq = {
 		.wq = {
@@ -6203,6 +6204,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		.to_wait	= min_events,
 	};
 	struct io_rings *rings = ctx->rings;
+	struct timespec64 ts;
+	signed long timeout = 0;
 	int ret = 0;
 
 	do {
@@ -6226,6 +6229,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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
@@ -6247,7 +6256,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		if (io_should_wake(&iowq, false))
 			break;
-		schedule();
+		if (uts) {
+			if ((timeout = schedule_timeout(timeout)) == 0) {
+				ret = -ETIME;
+				break;
+			}
+		} else {
+			schedule();
+		}
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
@@ -7644,20 +7660,40 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
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
+	struct {
+		sigset_t __user *sigmask;
+		struct __kernel_timespec __user *ts;
+	} arg;
 
 	if (current->task_works)
 		task_work_run();
 
-	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
+	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
+		      IORING_ENTER_GETEVENTS_TIMEOUT))
 		return -EINVAL;
 
+	/* deal with IORING_ENTER_GETEVENTS_TIMEOUT */
+	if (flags & IORING_ENTER_GETEVENTS_TIMEOUT) {
+		if (!(flags & IORING_ENTER_GETEVENTS))
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
@@ -7706,7 +7742,7 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
 			ret = io_iopoll_check(ctx, &nr_events, min_complete);
 		} else {
-			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
+			ret = io_cqring_wait(ctx, min_complete, sig, sigsz, ts);
 		}
 	}
 
@@ -8000,7 +8036,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
+			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
+			IORING_FEAT_GETEVENTS_TIMEOUT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7843742..1bf31bf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,7 @@ struct io_cqring_offsets {
  */
 #define IORING_ENTER_GETEVENTS	(1U << 0)
 #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
+#define IORING_ENTER_GETEVENTS_TIMEOUT	(1U << 2)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -249,6 +250,7 @@ struct io_uring_params {
 #define IORING_FEAT_RW_CUR_POS		(1U << 3)
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
 #define IORING_FEAT_FAST_POLL		(1U << 5)
+#define IORING_FEAT_GETEVENTS_TIMEOUT	(1U << 7)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
1.8.3.1

