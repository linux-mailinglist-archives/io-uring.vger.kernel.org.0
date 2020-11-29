Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304572C7711
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgK2AvL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730049AbgK2Auu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:50 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA84C061A4C;
        Sat, 28 Nov 2020 16:50:11 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id x15so4513267pll.2;
        Sat, 28 Nov 2020 16:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xqX7ZWv7N0o6d8T7ArFqBDvDLs/vhVsNNfcfh2sV6d4=;
        b=Bqu6PfmdYpAwLOI36dJGWuALJ8poPGDVLzvx6sF7LNUCet79TXUNGiwJHjE3bcM/7X
         ZhFLzP+AxBQYX4Xw8V9aN7tvFIA2z8QABFsb1Pqjb5g9y1cc4iSmiEsuESLK1vpZAWrE
         3AiuUuKRQ3rOMgUUU0kEGY6cS/+7HBUrka8E3TyHRpb0k18Qg4zJkewQsYfW+xSF9RaR
         +A6WtTfELdgs4fv3IpvriktBCCUFL1L6kvG1nXMWrDJ64nQ0sgZjJOFJC9Ry/iKvCoOi
         kBHiK2AzjXrHyLVruG5mgURdCEW/mgvu5K1z9IuZ+lDe3uS1DQutVJVy/T9jrzR0dF7B
         Kjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xqX7ZWv7N0o6d8T7ArFqBDvDLs/vhVsNNfcfh2sV6d4=;
        b=XSJ4i0S5Ka6KShjGs6DIw0kZ5tzRagtiFgEjtCCABafUyAd5lWXavkpZueNSpmqTjQ
         IRwiYqPTnxQ1XR65cAvFjUqoX+PmyAVEt08A2mb0F8HhA+Z5gfe8SBcTeLGg1Lj/Bm7f
         +2FZsOUszZWLklGgRO0fs8c6YK9eLmQNWjJ2kFLcFFUeX6mgEuzn++xn8w4LmcRl2K0e
         n3ubNfVnAdBk+eSLjJPCKAj4twwR7Jc8cS4voWRQLv7V3fx6dRy2JR9YZhPuzmJ6KrMh
         PzxgVQ0uT8DMqArUSCEppJVAI1hJr/Jv3z37Uajm976g3BZR4qbokutThRSpVwahdb+2
         2ppg==
X-Gm-Message-State: AOAM532o4NNIbtexCzkfU4P18ivg+z9mE2pfSh4x4BpVbTumeHPLYZ/K
        OGqR1tf280+OL4uD01MJWHMcQZ7TC7+9bw==
X-Google-Smtp-Source: ABdhPJyT8I5dTLwv/3QSl7Rx+wXOtsCXJJY3CfRg+hLftJlxcMOI6HlkMPUp+e+RDj7OSIEegdvkfQ==
X-Received: by 2002:a17:902:bd98:b029:d9:7b0:e1e5 with SMTP id q24-20020a170902bd98b02900d907b0e1e5mr12728725pls.77.1606611010840;
        Sat, 28 Nov 2020 16:50:10 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:10 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 11/13] fs/userfaultfd: complete write asynchronously
Date:   Sat, 28 Nov 2020 16:45:46 -0800
Message-Id: <20201129004548.1619714-12-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Userfaultfd writes can now be used for copy/zeroing. When using iouring
with userfaultfd, performing the copying/zeroing on the faulting thread
instead of the handler/iouring thread has several advantages:

(1) The data of the faulting thread will be available on the local
caches, which would make subsequent memory accesses faster.

(2) find_vma() would be able to use the vma-cache, which cannot be done
from a different process or io-uring kernel thread.

(3) The page is more likely to be allocated on the correct NUMA node.

To do so, userfaultfd work queue structs are extended to hold the
information that is required for the faulting thread to copy/zero. The
handler wakes one of the faulting threads to perform the copy/zero and
that thread wakes the other threads after the zero/copy is done.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c | 241 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 178 insertions(+), 63 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index eae6ac303951..5c22170544e3 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -105,58 +105,71 @@ struct userfaultfd_unmap_ctx {
 	struct list_head list;
 };
 
+struct userfaultfd_wake_info {
+	__u64 mode;
+	struct kiocb *iocb_callback;
+	struct iov_iter from;
+	unsigned long start;
+	unsigned long len;
+	bool copied;
+};
+
 struct userfaultfd_wait_queue {
 	struct uffd_msg msg;
 	wait_queue_entry_t wq;
 	struct userfaultfd_ctx *ctx;
+	struct userfaultfd_wake_info wake_info;
 	bool waken;
 };
 
-struct userfaultfd_wake_range {
-	unsigned long start;
-	unsigned long len;
-};
+
 
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 				     int wake_flags, void *key)
 {
-	struct userfaultfd_wake_range *range = key;
-	int ret;
+	struct userfaultfd_wake_info *wake_info = key;
 	struct userfaultfd_wait_queue *uwq;
 	unsigned long start, len;
+	int ret = 0;
 
 	uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
-	ret = 0;
 	/* len == 0 means wake all */
-	start = range->start;
-	len = range->len;
+	start = wake_info->start;
+	len = wake_info->len;
 	if (len && (start > uwq->msg.arg.pagefault.address ||
 		    start + len <= uwq->msg.arg.pagefault.address))
 		goto out;
 
-	smp_store_mb(uwq->waken, true);
+	uwq->wake_info = *wake_info;
+
+	if (wake_info->iocb_callback)
+		wake_info->copied = true;
+
+	/* Ensure uwq->wake_info is visible to handle_userfault() before waken */
+	smp_wmb();
+
+	WRITE_ONCE(uwq->waken, true);
 
 	/*
 	 * The Program-Order guarantees provided by the scheduler
 	 * ensure uwq->waken is visible before the task is woken.
 	 */
 	ret = wake_up_state(wq->private, mode);
-	if (ret) {
-		/*
-		 * Wake only once, autoremove behavior.
-		 *
-		 * After the effect of list_del_init is visible to the other
-		 * CPUs, the waitqueue may disappear from under us, see the
-		 * !list_empty_careful() in handle_userfault().
-		 *
-		 * try_to_wake_up() has an implicit smp_mb(), and the
-		 * wq->private is read before calling the extern function
-		 * "wake_up_state" (which in turns calls try_to_wake_up).
-		 */
-		list_del_init(&wq->entry);
-	}
+
+	/*
+	 * Wake only once, autoremove behavior.
+	 *
+	 * After the effect of list_del_init is visible to the other
+	 * CPUs, the waitqueue may disappear from under us, see the
+	 * !list_empty_careful() in handle_userfault().
+	 *
+	 * try_to_wake_up() has an implicit smp_mb(), and the
+	 * wq->private is read before calling the extern function
+	 * "wake_up_state" (which in turns calls try_to_wake_up).
+	 */
+	list_del_init(&wq->entry);
 out:
-	return ret;
+	return ret || wake_info->copied;
 }
 
 /**
@@ -384,6 +397,9 @@ static bool userfaultfd_get_async_complete_locked(struct userfaultfd_ctx *ctx,
 	return true;
 }
 
+static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
+					   struct userfaultfd_wake_info *wake_info);
+
 static bool userfaultfd_get_async_complete(struct userfaultfd_ctx *ctx,
 				struct kiocb **iocb, struct iov_iter *iter)
 {
@@ -414,6 +430,43 @@ static void userfaultfd_copy_async_msg(struct kiocb *iocb,
 	iter->kvec = NULL;
 }
 
+static void userfaultfd_complete_write(struct userfaultfd_ctx *ctx,
+					       struct userfaultfd_wait_queue *uwq)
+{
+	struct kiocb *iocb = uwq->wake_info.iocb_callback;
+	const struct kvec *kvec = uwq->wake_info.from.kvec;
+	bool zeropage = uwq->wake_info.mode & UFFDIO_WRITE_MODE_ZEROPAGE;
+	u64 mode = uwq->wake_info.mode &
+		(UFFDIO_WRITE_MODE_DONTWAKE | UFFDIO_WRITE_MODE_WP);
+	int r;
+
+	if (zeropage)
+		r = mfill_zeropage(ctx->mm, uwq->wake_info.start,
+			&uwq->wake_info.from, &ctx->mmap_changing);
+	else
+		r = mcopy_atomic(ctx->mm, uwq->wake_info.start,
+			&uwq->wake_info.from, &ctx->mmap_changing, mode);
+
+	/*
+	 * If we failed, do not wake the others, but if there was a partial
+	 * write, still wake others.
+	 */
+	if (r < 0)
+		goto out;
+
+	/* The callees should not do any copying */
+	uwq->wake_info.iocb_callback = NULL;
+	uwq->wake_info.from.kvec = NULL;
+	wake_userfault(ctx, &uwq->wake_info);
+out:
+	/*
+	 * Complete the operation only after waking the other threads as done
+	 * in the synchronous case.
+	 */
+	iocb->ki_complete(iocb, r, 0);
+	kfree(kvec);
+}
+
 /*
  * The locking rules involved in returning VM_FAULT_RETRY depending on
  * FAULT_FLAG_ALLOW_RETRY, FAULT_FLAG_RETRY_NOWAIT and
@@ -548,6 +601,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 			ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
+	uwq.wake_info.iocb_callback = NULL;
 
 	blocking_state = userfaultfd_get_blocking_state(vmf->flags);
 
@@ -569,7 +623,11 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	 */
 	spin_lock(&wqh->lock);
 
-	__add_wait_queue(wqh, &uwq.wq);
+	/* Exclusive on the fault_wqh, not on the fault_pending_wqh */
+	if (async)
+		__add_wait_queue_exclusive(wqh, &uwq.wq);
+	else
+		__add_wait_queue(wqh, &uwq.wq);
 
 	/* Ensure it is queued before userspace is informed. */
 	smp_wmb();
@@ -612,6 +670,11 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 				cpu_relax();
 				cond_resched();
 			}
+			/*
+			 * Ensure writes from userfaultfd_wake_function into uwq
+			 * are visible.
+			 */
+			smp_rmb();
 		} else
 			schedule();
 	}
@@ -650,6 +713,10 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 		local_irq_enable();
 	}
 
+	/* Complete copy/zero after the entry is no longer on the queue. */
+	if (uwq.wake_info.iocb_callback)
+		userfaultfd_complete_write(ctx, &uwq);
+
 	/*
 	 * ctx may go away after this if the userfault pseudo fd is
 	 * already released.
@@ -1004,7 +1071,7 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *vma, *prev;
 	/* len == 0 means wake all */
-	struct userfaultfd_wake_range range = { .len = 0, };
+	struct userfaultfd_wake_info wake_info = { 0 };
 	unsigned long new_flags;
 
 	WRITE_ONCE(ctx->released, true);
@@ -1052,8 +1119,8 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 	 * the fault_*wqh.
 	 */
 	spin_lock_irq(&ctx->fault_pending_wqh.lock);
-	__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL, &range);
-	__wake_up(&ctx->fault_wqh, TASK_NORMAL, 1, &range);
+	__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL, &wake_info);
+	__wake_up(&ctx->fault_wqh, TASK_NORMAL, 0, &wake_info);
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
 	userfaultfd_cancel_async_reads(ctx);
@@ -1294,7 +1361,7 @@ static ssize_t userfaultfd_ctx_read(struct kiocb *iocb,
 			 * anyway.
 			 */
 			list_del(&uwq->wq.entry);
-			add_wait_queue(&ctx->fault_wqh, &uwq->wq);
+			add_wait_queue_exclusive(&ctx->fault_wqh, &uwq->wq);
 
 			write_seqcount_end(&ctx->refile_seq);
 
@@ -1459,20 +1526,20 @@ static ssize_t userfaultfd_read_iter(struct kiocb *iocb, struct iov_iter *to)
 }
 
 static void __wake_userfault(struct userfaultfd_ctx *ctx,
-			     struct userfaultfd_wake_range *range)
+			     struct userfaultfd_wake_info *wake_info)
 {
 	spin_lock_irq(&ctx->fault_pending_wqh.lock);
 	/* wake all in the range and autoremove */
 	if (waitqueue_active(&ctx->fault_pending_wqh))
 		__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL,
-				     range);
+				     wake_info);
 	if (waitqueue_active(&ctx->fault_wqh))
-		__wake_up(&ctx->fault_wqh, TASK_NORMAL, 1, range);
+		__wake_up(&ctx->fault_wqh, TASK_NORMAL, 0, wake_info);
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 }
 
 static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
-					   struct userfaultfd_wake_range *range)
+					   struct userfaultfd_wake_info *wake_info)
 {
 	unsigned seq;
 	bool need_wakeup;
@@ -1499,7 +1566,7 @@ static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
 		cond_resched();
 	} while (read_seqcount_retry(&ctx->refile_seq, seq));
 	if (need_wakeup)
-		__wake_userfault(ctx, range);
+		__wake_userfault(ctx, wake_info);
 }
 
 static __always_inline int validate_range(struct mm_struct *mm,
@@ -1524,14 +1591,57 @@ static __always_inline int validate_range(struct mm_struct *mm,
 	return 0;
 }
 
+static int userfaultfd_remote_mcopy(struct kiocb *iocb, __u64 dst,
+				    struct iov_iter *from, __u64 mode)
+{
+	struct file *file = iocb->ki_filp;
+	struct userfaultfd_ctx *ctx = file->private_data;
+	struct userfaultfd_wake_info wake_info = {
+		.iocb_callback = iocb,
+		.mode = mode,
+		.start = dst,
+		.len = iov_iter_count(from),
+		.copied = false,
+	};
+	int ret = -EAGAIN;
+
+	if (mode & UFFDIO_COPY_MODE_DONTWAKE)
+		goto out;
+
+	if (!iov_iter_is_bvec(from) && !iov_iter_is_kvec(from))
+		goto out;
+
+	/*
+	 * Check without a lock. If we are mistaken, the mcopy would be
+	 * performed locally.
+	 */
+	if (!waitqueue_active(&ctx->fault_wqh))
+		goto out;
+
+	dup_iter(&wake_info.from, from, GFP_KERNEL);
+
+	/* wake one in the range and autoremove */
+	__wake_up(&ctx->fault_wqh, TASK_NORMAL, 1, &wake_info);
+
+	if (!wake_info.copied) {
+		kfree(wake_info.from.kvec);
+		goto out;
+	}
+
+	ret = -EIOCBQUEUED;
+out:
+	return ret;
+}
+
 ssize_t userfaultfd_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
-	struct userfaultfd_wake_range range;
+	struct userfaultfd_wake_info wake_info = { 0 };
 	struct userfaultfd_ctx *ctx = file->private_data;
 	size_t len = iov_iter_count(from);
 	__u64 dst = iocb->ki_pos & PAGE_MASK;
 	unsigned long mode = iocb->ki_pos & ~PAGE_MASK;
+	int no_wait = file->f_flags & O_NONBLOCK;
 	bool zeropage;
 	__s64 ret;
 
@@ -1563,25 +1673,30 @@ ssize_t userfaultfd_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret)
 		goto out;
 
-	if (mmget_not_zero(ctx->mm)) {
+	if (!mmget_not_zero(ctx->mm))
+		return -ESRCH;
+
+	ret = -EAGAIN;
+	if (no_wait && !is_sync_kiocb(iocb))
+		ret = userfaultfd_remote_mcopy(iocb, dst, from, mode);
+	if (ret == -EAGAIN) {
 		if (zeropage)
 			ret = mfill_zeropage(ctx->mm, dst, from,
 					     &ctx->mmap_changing);
 		else
 			ret = mcopy_atomic(ctx->mm, dst, from,
 					   &ctx->mmap_changing, mode);
-		mmput(ctx->mm);
-	} else {
-		return -ESRCH;
 	}
+	mmput(ctx->mm);
+
 	if (ret < 0)
 		goto out;
 
 	/* len == 0 would wake all */
-	range.len = ret;
+	wake_info.len = ret;
 	if (!(mode & UFFDIO_COPY_MODE_DONTWAKE)) {
-		range.start = dst;
-		wake_userfault(ctx, &range);
+		wake_info.start = dst;
+		wake_userfault(ctx, &wake_info);
 	}
 out:
 	return ret;
@@ -1916,7 +2031,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 			 * permanently and it avoids userland to call
 			 * UFFDIO_WAKE explicitly.
 			 */
-			struct userfaultfd_wake_range range;
+			struct userfaultfd_wake_info range;
 			range.start = start;
 			range.len = vma_end - start;
 			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
@@ -1971,7 +2086,7 @@ static int userfaultfd_wake(struct userfaultfd_ctx *ctx,
 {
 	int ret;
 	struct uffdio_range uffdio_wake;
-	struct userfaultfd_wake_range range;
+	struct userfaultfd_wake_info wake_info = { 0 };
 	const void __user *buf = (void __user *)arg;
 
 	ret = -EFAULT;
@@ -1982,16 +2097,16 @@ static int userfaultfd_wake(struct userfaultfd_ctx *ctx,
 	if (ret)
 		goto out;
 
-	range.start = uffdio_wake.start;
-	range.len = uffdio_wake.len;
+	wake_info.start = uffdio_wake.start;
+	wake_info.len = uffdio_wake.len;
 
 	/*
 	 * len == 0 means wake all and we don't want to wake all here,
 	 * so check it again to be sure.
 	 */
-	VM_BUG_ON(!range.len);
+	VM_BUG_ON(!wake_info.len);
 
-	wake_userfault(ctx, &range);
+	wake_userfault(ctx, &wake_info);
 	ret = 0;
 
 out:
@@ -2004,7 +2119,7 @@ static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
 	__s64 ret;
 	struct uffdio_copy uffdio_copy;
 	struct uffdio_copy __user *user_uffdio_copy;
-	struct userfaultfd_wake_range range;
+	struct userfaultfd_wake_info wake_info = { 0 };
 	struct iov_iter iter;
 	struct iovec iov;
 
@@ -2052,12 +2167,12 @@ static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
 		goto out;
 	BUG_ON(!ret);
 	/* len == 0 would wake all */
-	range.len = ret;
+	wake_info.len = ret;
 	if (!(uffdio_copy.mode & UFFDIO_COPY_MODE_DONTWAKE)) {
-		range.start = uffdio_copy.dst;
-		wake_userfault(ctx, &range);
+		wake_info.start = uffdio_copy.dst;
+		wake_userfault(ctx, &wake_info);
 	}
-	ret = range.len == uffdio_copy.len ? 0 : -EAGAIN;
+	ret = wake_info.len == uffdio_copy.len ? 0 : -EAGAIN;
 out:
 	return ret;
 }
@@ -2068,7 +2183,7 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
 	__s64 ret;
 	struct uffdio_zeropage uffdio_zeropage;
 	struct uffdio_zeropage __user *user_uffdio_zeropage;
-	struct userfaultfd_wake_range range;
+	struct userfaultfd_wake_info wake_info = { 0 };
 	struct iov_iter iter;
 	struct iovec iov;
 
@@ -2108,12 +2223,12 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
 		goto out;
 	/* len == 0 would wake all */
 	BUG_ON(!ret);
-	range.len = ret;
+	wake_info.len = ret;
 	if (!(uffdio_zeropage.mode & UFFDIO_ZEROPAGE_MODE_DONTWAKE)) {
-		range.start = uffdio_zeropage.range.start;
-		wake_userfault(ctx, &range);
+		wake_info.start = uffdio_zeropage.range.start;
+		wake_userfault(ctx, &wake_info);
 	}
-	ret = range.len == uffdio_zeropage.range.len ? 0 : -EAGAIN;
+	ret = wake_info.len == uffdio_zeropage.range.len ? 0 : -EAGAIN;
 out:
 	return ret;
 }
@@ -2124,7 +2239,7 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
 	int ret;
 	struct uffdio_writeprotect uffdio_wp;
 	struct uffdio_writeprotect __user *user_uffdio_wp;
-	struct userfaultfd_wake_range range;
+	struct userfaultfd_wake_info wake_info = { 0 };
 	bool mode_wp, mode_dontwake;
 
 	if (READ_ONCE(ctx->mmap_changing))
@@ -2158,9 +2273,9 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
 		return ret;
 
 	if (!mode_wp && !mode_dontwake) {
-		range.start = uffdio_wp.range.start;
-		range.len = uffdio_wp.range.len;
-		wake_userfault(ctx, &range);
+		wake_info.start = uffdio_wp.range.start;
+		wake_info.len = uffdio_wp.range.len;
+		wake_userfault(ctx, &wake_info);
 	}
 	return ret;
 }
-- 
2.25.1

