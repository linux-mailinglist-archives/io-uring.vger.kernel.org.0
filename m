Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF152C7702
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgK2Auu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729979AbgK2Aus (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:48 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31737C061A49;
        Sat, 28 Nov 2020 16:50:07 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w16so7364796pga.9;
        Sat, 28 Nov 2020 16:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=59KWJ3/vJ6HvjVKPPNnRXw2pLzvj6jPJhqf+PHsK5Lk=;
        b=chVcc+RpWELrdHQJX2hhDn+8PahEbwgiDiSXx20aZXuf2vwweeyvQsVqF3iGR8DfL1
         flZOboyW8fvAK96YKsrOIp/mQbHi6+IapaGz213Q765F25rS71WgumelVtRDsOZsZepS
         DciB0vTY3vQDe9CkU1T/CrRFGbnKK4C7FBn8qExI5wuat6Wh/wfDurQrI4m5EXnyjLjv
         3ETHzqUR4ywd33HwE7d2SLOw5jjwpmOUI+1/jJuJKO3woWIR+/HcCMt8dKXjLGtX9CWs
         vC0kKUd3PEe7tvDkDQD9iDp7/l792lBgAlVajXVNcnUug0xhWpieS5R8FZIUauJVWSVX
         OwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=59KWJ3/vJ6HvjVKPPNnRXw2pLzvj6jPJhqf+PHsK5Lk=;
        b=IKvlfNV3yhAuVH8jiMFF8hUTMtRQqeoSfyrTuPTq8Q/X8B91o9Ejb8ha5hY/lX+RKk
         JyfnAShF/HX1X8+mS5JupYWjQH9GwM3ccORURNk0mSyhzXtZwIMb5TpB8sTi4jsiY3Ac
         YMC5oNKmBFQj4ZHkRo0OXXcCg+AcDuYoKSohaKdXE7fqNkC6AA8hqDPYBCpls6EAI5La
         dZx87YwqWa2c6gI/swdgZkQZRDDGkm94+oNqTqSfLO0PGF8F1aXAgyRK8JTkf6GR8o4e
         eYczFcVVLJpXdSd16n0iYFe4vC0JKTyS5lJBUwvvv2VyAopD3AkH+2arjuozJ7Pj32x0
         WTNw==
X-Gm-Message-State: AOAM5311mBkeY1wqaTQdhmL1FLiV8tN7kcEoDJDwUo5K7OqsheMYJp6k
        rfnZ0Z0i9qD7rr4eIXG2ycAg6syph8588w==
X-Google-Smtp-Source: ABdhPJyWiKvysa3Yocv9eCzmz/ID0fXaV6ox++urR807pZiDVfoy48giSjx/iyE9N0Gfs7uI/Rzs5g==
X-Received: by 2002:a17:90b:4595:: with SMTP id hd21mr18568326pjb.127.1606611006164;
        Sat, 28 Nov 2020 16:50:06 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:05 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 08/13] fs/userfaultfd: complete reads asynchronously
Date:   Sat, 28 Nov 2020 16:45:43 -0800
Message-Id: <20201129004548.1619714-9-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Complete reads asynchronously to allow io_uring to complete reads
asynchronously.

Reads, which report page-faults and events, can only be performed
asynchronously if the read is performed into a kernel buffer, and
therefore guarantee that no page-fault would occur during the completion
of the read. Otherwise, we would have needed to handle nested
page-faults or do expensive pinning/unpinning of the pages into which
the read is performed.

Userfaultfd holds in its context the kiocb and iov_iter that would be
used for the next asynchronous read (can be extended later into a list
to hold more than a single enqueued read).  If such a buffer is
available and a fault occurs, the fault is reported to the user and the
fault is added to the fault workqueue instead of the pending-fault
workqueue.

There is a need to prevent a race between synchronous and asynchronous
reads, so reads will first use buffers that were previous enqueued and
only later pending-faults and events. For this matter a new
"notification" lock is introduced that is held while enqueuing new
events and pending faults and during event reads. It may be possible to
use the fd_wqh.lock instead, but having a separate lock for the matter
seems cleaner.

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
 fs/userfaultfd.c | 265 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 235 insertions(+), 30 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 6333b4632742..db1a963f6ae2 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -44,9 +44,10 @@ enum userfaultfd_state {
  *
  * Locking order:
  *	fd_wqh.lock
- *		fault_pending_wqh.lock
- *			fault_wqh.lock
- *		event_wqh.lock
+ *		notification_lock
+ *			fault_pending_wqh.lock
+ *				fault_wqh.lock
+ *			event_wqh.lock
  *
  * To avoid deadlocks, IRQs must be disabled when taking any of the above locks,
  * since fd_wqh.lock is taken by aio_poll() while it's holding a lock that's
@@ -79,6 +80,16 @@ struct userfaultfd_ctx {
 	struct mm_struct *mm;
 	/* controlling process files as they might be different than current */
 	struct files_struct *files;
+	/*
+	 * lock for sync and async userfaultfd reads, which must be held when
+	 * enqueueing into fault_pending_wqh or event_wqh, upon userfaultfd
+	 * reads and on accesses of iocb_callback and to.
+	 */
+	spinlock_t notification_lock;
+	/* kiocb struct that is used for the next asynchronous read */
+	struct kiocb *iocb_callback;
+	/* the iterator that is used for the next asynchronous read */
+	struct iov_iter to;
 };
 
 struct userfaultfd_fork_ctx {
@@ -356,6 +367,53 @@ static inline long userfaultfd_get_blocking_state(unsigned int flags)
 	return TASK_UNINTERRUPTIBLE;
 }
 
+static bool userfaultfd_get_async_complete_locked(struct userfaultfd_ctx *ctx,
+				struct kiocb **iocb, struct iov_iter *iter)
+{
+	if (!ctx->released)
+		lockdep_assert_held(&ctx->notification_lock);
+
+	if (ctx->iocb_callback == NULL)
+		return false;
+
+	*iocb = ctx->iocb_callback;
+	*iter = ctx->to;
+
+	ctx->iocb_callback = NULL;
+	ctx->to.kvec = NULL;
+	return true;
+}
+
+static bool userfaultfd_get_async_complete(struct userfaultfd_ctx *ctx,
+				struct kiocb **iocb, struct iov_iter *iter)
+{
+	bool r;
+
+	spin_lock_irq(&ctx->notification_lock);
+	r = userfaultfd_get_async_complete_locked(ctx, iocb, iter);
+	spin_unlock_irq(&ctx->notification_lock);
+	return r;
+}
+
+static void userfaultfd_copy_async_msg(struct kiocb *iocb,
+				       struct iov_iter *iter,
+				       struct uffd_msg *msg,
+				       int ret)
+{
+
+	const struct kvec *kvec = iter->kvec;
+
+	if (ret == 0)
+		ret = copy_to_iter(msg, sizeof(*msg), iter);
+
+	/* Should never fail as we guarantee that we use a kernel buffer */
+	WARN_ON_ONCE(ret != sizeof(*msg));
+	iocb->ki_complete(iocb, ret, 0);
+
+	kfree(kvec);
+	iter->kvec = NULL;
+}
+
 /*
  * The locking rules involved in returning VM_FAULT_RETRY depending on
  * FAULT_FLAG_ALLOW_RETRY, FAULT_FLAG_RETRY_NOWAIT and
@@ -380,6 +438,10 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	bool must_wait;
 	long blocking_state;
 	bool poll;
+	bool async = false;
+	struct kiocb *iocb;
+	struct iov_iter iter;
+	wait_queue_head_t *wqh;
 
 	/*
 	 * We don't do userfault handling for the final child pid update.
@@ -489,12 +551,29 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	blocking_state = userfaultfd_get_blocking_state(vmf->flags);
 
-	spin_lock_irq(&ctx->fault_pending_wqh.lock);
+	/*
+	 * Abuse fd_wqh.lock to protect against concurrent reads to avoid a
+	 * scenario in which a fault/event is queued, and read returns
+	 * -EIOCBQUEUED.
+	 */
+	spin_lock_irq(&ctx->notification_lock);
+	async = userfaultfd_get_async_complete_locked(ctx, &iocb, &iter);
+	wqh = &ctx->fault_pending_wqh;
+
+	if (async)
+		wqh = &ctx->fault_wqh;
+
 	/*
 	 * After the __add_wait_queue the uwq is visible to userland
 	 * through poll/read().
 	 */
-	__add_wait_queue(&ctx->fault_pending_wqh, &uwq.wq);
+	spin_lock(&wqh->lock);
+
+	__add_wait_queue(wqh, &uwq.wq);
+
+	/* Ensure it is queued before userspace is informed. */
+	smp_wmb();
+
 	/*
 	 * The smp_mb() after __set_current_state prevents the reads
 	 * following the spin_unlock to happen before the list_add in
@@ -504,7 +583,15 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	if (!poll)
 		set_current_state(blocking_state);
 
-	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
+	spin_unlock(&wqh->lock);
+	spin_unlock_irq(&ctx->notification_lock);
+
+	/*
+	 * Do the copy after the lock is relinquished to avoid circular lock
+	 * dependencies.
+	 */
+	if (async)
+		userfaultfd_copy_async_msg(iocb, &iter, &uwq.msg, 0);
 
 	if (!is_vm_hugetlb_page(vmf->vma))
 		must_wait = userfaultfd_must_wait(ctx, vmf->address, vmf->flags,
@@ -516,7 +603,9 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	mmap_read_unlock(mm);
 
 	if (likely(must_wait && !READ_ONCE(ctx->released))) {
-		wake_up_poll(&ctx->fd_wqh, EPOLLIN);
+		if (!async)
+			wake_up_poll(&ctx->fd_wqh, EPOLLIN);
+
 		if (poll) {
 			while (!READ_ONCE(uwq.waken) && !READ_ONCE(ctx->released) &&
 			       !signal_pending(current)) {
@@ -544,13 +633,21 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	 * kernel stack can be released after the list_del_init.
 	 */
 	if (!list_empty_careful(&uwq.wq.entry)) {
-		spin_lock_irq(&ctx->fault_pending_wqh.lock);
+		local_irq_disable();
+		if (!async)
+			spin_lock(&ctx->fault_pending_wqh.lock);
+		spin_lock(&ctx->fault_wqh.lock);
+
 		/*
 		 * No need of list_del_init(), the uwq on the stack
 		 * will be freed shortly anyway.
 		 */
 		list_del(&uwq.wq.entry);
-		spin_unlock_irq(&ctx->fault_pending_wqh.lock);
+
+		spin_unlock(&ctx->fault_wqh.lock);
+		if (!async)
+			spin_unlock(&ctx->fault_pending_wqh.lock);
+		local_irq_enable();
 	}
 
 	/*
@@ -563,10 +660,17 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	return ret;
 }
 
+
+static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
+				  struct userfaultfd_ctx *new,
+				  struct uffd_msg *msg);
+
 static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 					      struct userfaultfd_wait_queue *ewq)
 {
 	struct userfaultfd_ctx *release_new_ctx;
+	struct iov_iter iter;
+	struct kiocb *iocb;
 
 	if (WARN_ON_ONCE(current->flags & PF_EXITING))
 		goto out;
@@ -575,12 +679,42 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 	init_waitqueue_entry(&ewq->wq, current);
 	release_new_ctx = NULL;
 
-	spin_lock_irq(&ctx->event_wqh.lock);
+retry:
+	spin_lock_irq(&ctx->notification_lock);
+
 	/*
-	 * After the __add_wait_queue the uwq is visible to userland
-	 * through poll/read().
+	 * Submit asynchronously when needed, and release the notification lock
+	 * as soon as the event is either queued on the work queue or an entry
+	 * is taken.
+	 */
+	if (userfaultfd_get_async_complete_locked(ctx, &iocb, &iter)) {
+		int r = 0;
+
+		spin_unlock_irq(&ctx->notification_lock);
+		if (ewq->msg.event == UFFD_EVENT_FORK) {
+			struct userfaultfd_ctx *new =
+				(struct userfaultfd_ctx *)(unsigned long)
+					ewq->msg.arg.reserved.reserved1;
+
+			r = resolve_userfault_fork(ctx, new, &ewq->msg);
+		}
+		userfaultfd_copy_async_msg(iocb, &iter, &ewq->msg, r);
+
+		if (r != 0)
+			goto retry;
+
+		goto out;
+	}
+
+	spin_lock(&ctx->event_wqh.lock);
+	/*
+	 * After the __add_wait_queue or the call to ki_complete the uwq is
+	 * visible to userland through poll/read().
 	 */
 	__add_wait_queue(&ctx->event_wqh, &ewq->wq);
+
+	spin_unlock(&ctx->notification_lock);
+
 	for (;;) {
 		set_current_state(TASK_KILLABLE);
 		if (ewq->msg.event == 0)
@@ -683,6 +817,7 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
 		ctx->features = octx->features;
 		ctx->released = false;
 		ctx->mmap_changing = false;
+		ctx->iocb_callback = NULL;
 		ctx->mm = vma->vm_mm;
 		mmgrab(ctx->mm);
 
@@ -854,6 +989,15 @@ void userfaultfd_unmap_complete(struct mm_struct *mm, struct list_head *uf)
 	}
 }
 
+static void userfaultfd_cancel_async_reads(struct userfaultfd_ctx *ctx)
+{
+	struct iov_iter iter;
+	struct kiocb *iocb;
+
+	while (userfaultfd_get_async_complete(ctx, &iocb, &iter))
+		userfaultfd_copy_async_msg(iocb, &iter, NULL, -EBADF);
+}
+
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
@@ -912,6 +1056,8 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 	__wake_up(&ctx->fault_wqh, TASK_NORMAL, 1, &range);
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
+	userfaultfd_cancel_async_reads(ctx);
+
 	/* Flush pending events that may still wait on event_wqh */
 	wake_up_all(&ctx->event_wqh);
 
@@ -1032,8 +1178,39 @@ static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
 	return 0;
 }
 
-static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
-				    struct uffd_msg *msg)
+static ssize_t userfaultfd_enqueue(struct kiocb *iocb,
+				   struct userfaultfd_ctx *ctx,
+				   struct iov_iter *to)
+{
+	lockdep_assert_irqs_disabled();
+
+	if (!to)
+		return -EAGAIN;
+
+	if (is_sync_kiocb(iocb) ||
+	    (!iov_iter_is_bvec(to) && !iov_iter_is_kvec(to)))
+		return -EAGAIN;
+
+	/* Check again if there are pending events */
+	if (waitqueue_active(&ctx->fault_pending_wqh) ||
+	    waitqueue_active(&ctx->event_wqh))
+		return -EAGAIN;
+
+	/*
+	 * Check that there is no other callback already registered, as
+	 * we only support one at the moment.
+	 */
+	if (ctx->iocb_callback)
+		return -EAGAIN;
+
+	ctx->iocb_callback = iocb;
+	ctx->to = *to;
+	return -EIOCBQUEUED;
+}
+
+static ssize_t userfaultfd_ctx_read(struct kiocb *iocb,
+				    struct userfaultfd_ctx *ctx, int no_wait,
+				    struct uffd_msg *msg, struct iov_iter *to)
 {
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
@@ -1051,6 +1228,7 @@ static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
 	/* always take the fd_wqh lock before the fault_pending_wqh lock */
 	spin_lock_irq(&ctx->fd_wqh.lock);
 	__add_wait_queue(&ctx->fd_wqh, &wait);
+	spin_lock(&ctx->notification_lock);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_lock(&ctx->fault_pending_wqh.lock);
@@ -1122,21 +1300,23 @@ static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
 			ret = 0;
 		}
 		spin_unlock(&ctx->event_wqh.lock);
-		if (!ret)
-			break;
 
-		if (signal_pending(current)) {
+		if (ret == -EAGAIN && signal_pending(current))
 			ret = -ERESTARTSYS;
+
+		if (ret == -EAGAIN && no_wait)
+			ret = userfaultfd_enqueue(iocb, ctx, to);
+
+		if (no_wait || ret != -EAGAIN)
 			break;
-		}
-		if (no_wait) {
-			ret = -EAGAIN;
-			break;
-		}
+
+		spin_unlock(&ctx->notification_lock);
 		spin_unlock_irq(&ctx->fd_wqh.lock);
 		schedule();
 		spin_lock_irq(&ctx->fd_wqh.lock);
+		spin_lock(&ctx->notification_lock);
 	}
+	spin_unlock(&ctx->notification_lock);
 	__remove_wait_queue(&ctx->fd_wqh, &wait);
 	__set_current_state(TASK_RUNNING);
 	spin_unlock_irq(&ctx->fd_wqh.lock);
@@ -1202,20 +1382,38 @@ static ssize_t userfaultfd_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t _ret, ret = 0;
 	struct uffd_msg msg;
 	int no_wait = file->f_flags & O_NONBLOCK;
+	struct iov_iter _to, *async_to = NULL;
 
-	if (ctx->state == UFFD_STATE_WAIT_API)
+	if (ctx->state == UFFD_STATE_WAIT_API || READ_ONCE(ctx->released))
 		return -EINVAL;
 
+	/* Duplicate before taking the lock */
+	if (no_wait && !is_sync_kiocb(iocb) &&
+	    (iov_iter_is_bvec(to) || iov_iter_is_kvec(to))) {
+		async_to = &_to;
+		dup_iter(async_to, to, GFP_KERNEL);
+	}
+
 	for (;;) {
-		if (iov_iter_count(to) < sizeof(msg))
-			return ret ? ret : -EINVAL;
-		_ret = userfaultfd_ctx_read(ctx, no_wait, &msg);
-		if (_ret < 0)
-			return ret ? ret : _ret;
+		if (iov_iter_count(to) < sizeof(msg)) {
+			if (!ret)
+				ret = -EINVAL;
+			break;
+		}
+		_ret = userfaultfd_ctx_read(iocb, ctx, no_wait, &msg, async_to);
+		if (_ret < 0) {
+			if (ret == 0)
+				ret = _ret;
+			break;
+		}
+		async_to = NULL;
 
 		_ret = copy_to_iter(&msg, sizeof(msg), to);
-		if (_ret != sizeof(msg))
-			return ret ? ret : -EINVAL;
+		if (_ret != sizeof(msg)) {
+			if (ret == 0)
+				ret = -EINVAL;
+			break;
+		}
 
 		ret += sizeof(msg);
 
@@ -1225,6 +1423,11 @@ static ssize_t userfaultfd_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		 */
 		no_wait = O_NONBLOCK;
 	}
+
+	if (ret != -EIOCBQUEUED && async_to != NULL)
+		kfree(async_to->kvec);
+
+	return ret;
 }
 
 static void __wake_userfault(struct userfaultfd_ctx *ctx,
@@ -1997,6 +2200,7 @@ static void init_once_userfaultfd_ctx(void *mem)
 	init_waitqueue_head(&ctx->event_wqh);
 	init_waitqueue_head(&ctx->fd_wqh);
 	seqcount_spinlock_init(&ctx->refile_seq, &ctx->fault_pending_wqh.lock);
+	spin_lock_init(&ctx->notification_lock);
 }
 
 SYSCALL_DEFINE1(userfaultfd, int, flags)
@@ -2027,6 +2231,7 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	ctx->released = false;
 	ctx->mmap_changing = false;
 	ctx->mm = current->mm;
+	ctx->iocb_callback = NULL;
 	/* prevent the mm struct to be freed */
 	mmgrab(ctx->mm);
 
-- 
2.25.1

