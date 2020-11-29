Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8922C76FC
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbgK2Auq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgK2Aup (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:45 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97081C061A04;
        Sat, 28 Nov 2020 16:50:02 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 131so7732415pfb.9;
        Sat, 28 Nov 2020 16:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gF437dYZ7jdLwMEZ7tinhd91PTaHOyGZ1bS4Ys+9sbE=;
        b=lsz3W7Eo6rNaH9lJHydIzJMFNyroHGWOYBcGBrThiveADagHW1sODxWZKkeaSi1VC7
         zLQZB+Ua3lMMfGNhgBXE4MzHHfya8W0dlJgtLfLZa0WZZDqH7VSucoOi7I3mktfr1TVk
         V1IbKNnHF5YIZtjZM0NFkJ4iYvTZ1W17FJZ1z89/Q4E17kk3XyPI2hW3dh9Ekuv8VlFV
         xNjcWGBA3WiziRHvYQu275NQjRrlQAnRRFD/qQ11Vl9/L59G+sp+i3WgSMLiTuU1Yn1X
         zWljhsVdOMGwRMqTk+DbE5nMO7w004wAWe6dZs/QSEmC1uKuT0Mdy5htd4XQ9D4odrjk
         HTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gF437dYZ7jdLwMEZ7tinhd91PTaHOyGZ1bS4Ys+9sbE=;
        b=dkt6YZq6BOv7qmbBSGmSzWqCDS5iWpU82TFkpGBDCYdcxtdfxkKoIdwBQXVBGzVDQw
         eknzGc2oYBqAezlvFVnNhpHTeTi9lKujiR8798+DiHD6k4+u4PQ4jgJXocWnvce1S4uw
         hQ9J2y94yJl6PJlsddiCw0loUeppj3qjB4M2DQ+njMYKAXarYUkpHvnBMNbTa3Z7/kxH
         7lwrA3CX2ouw/ClGa7m+nmy3vv7yAlVAw+IvYbEq1KkIlhDnj+i9oB+IKwbdekV9A0az
         i59xb2/OXUGb+gauMJf96rBGtzYQejaqiWlUPro848dgsoc3H3Gh4AYC++hC5OAniwbe
         5SdQ==
X-Gm-Message-State: AOAM533kxGUz8NiMFfNLoWhkpiwa32Tnsp7odUZJia0Iesis5Y34Aej7
        76K8nFkMDI/NCysnspGg8HMe3W1H7E7/2Q==
X-Google-Smtp-Source: ABdhPJyVHHI5kxSoiEdetWfo5TY0LHVXJyWXpUXKSK5uyIxAkcnig+Tzt6Rc0pwKm2cocbCFg6qDig==
X-Received: by 2002:a63:68f:: with SMTP id 137mr923738pgg.361.1606611001687;
        Sat, 28 Nov 2020 16:50:01 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:01 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 05/13] fs/userfaultfd: introduce UFFD_FEATURE_POLL
Date:   Sat, 28 Nov 2020 16:45:40 -0800
Message-Id: <20201129004548.1619714-6-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Add a feature UFFD_FEATURE_POLL that makes the faulting thread spin
while waiting for the page-fault to be handled.

Users of this feature should be wise by setting the page-fault handling
thread on another physical CPU and to potentially ensure that there are
available cores to run the handler, as otherwise they will see
performance degradation.

We can later enhance it by setting one or two timeouts: one timeout
until the page-fault is handled and another until the handler was
woken.

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
 fs/userfaultfd.c                 | 24 ++++++++++++++++++++----
 include/uapi/linux/userfaultfd.h |  9 ++++++++-
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index fedf7c1615d5..b6a04e526025 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -122,7 +122,9 @@ static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 	if (len && (start > uwq->msg.arg.pagefault.address ||
 		    start + len <= uwq->msg.arg.pagefault.address))
 		goto out;
-	WRITE_ONCE(uwq->waken, true);
+
+	smp_store_mb(uwq->waken, true);
+
 	/*
 	 * The Program-Order guarantees provided by the scheduler
 	 * ensure uwq->waken is visible before the task is woken.
@@ -377,6 +379,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	bool must_wait;
 	long blocking_state;
+	bool poll;
 
 	/*
 	 * We don't do userfault handling for the final child pid update.
@@ -410,6 +413,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	if (ctx->features & UFFD_FEATURE_SIGBUS)
 		goto out;
 
+	poll = ctx->features & UFFD_FEATURE_POLL;
+
 	/*
 	 * If it's already released don't get it. This avoids to loop
 	 * in __get_user_pages if userfaultfd_release waits on the
@@ -495,7 +500,10 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	 * following the spin_unlock to happen before the list_add in
 	 * __add_wait_queue.
 	 */
-	set_current_state(blocking_state);
+
+	if (!poll)
+		set_current_state(blocking_state);
+
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
 	if (!is_vm_hugetlb_page(vmf->vma))
@@ -509,10 +517,18 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	if (likely(must_wait && !READ_ONCE(ctx->released))) {
 		wake_up_poll(&ctx->fd_wqh, EPOLLIN);
-		schedule();
+		if (poll) {
+			while (!READ_ONCE(uwq.waken) && !READ_ONCE(ctx->released) &&
+			       !signal_pending(current)) {
+				cpu_relax();
+				cond_resched();
+			}
+		} else
+			schedule();
 	}
 
-	__set_current_state(TASK_RUNNING);
+	if (!poll)
+		__set_current_state(TASK_RUNNING);
 
 	/*
 	 * Here we race with the list_del; list_add in
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index e7e98bde221f..4eeba4235afe 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -27,7 +27,9 @@
 			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
 			   UFFD_FEATURE_MISSING_SHMEM |		\
 			   UFFD_FEATURE_SIGBUS |		\
-			   UFFD_FEATURE_THREAD_ID)
+			   UFFD_FEATURE_THREAD_ID |		\
+			   UFFD_FEATURE_POLL)
+
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -171,6 +173,10 @@ struct uffdio_api {
 	 *
 	 * UFFD_FEATURE_THREAD_ID pid of the page faulted task_struct will
 	 * be returned, if feature is not requested 0 will be returned.
+	 *
+	 * UFFD_FEATURE_POLL polls upon page-fault if the feature is requested
+	 * instead of descheduling. This feature should only be enabled for
+	 * low-latency handlers and when CPUs are not overcomitted.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -181,6 +187,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
 #define UFFD_FEATURE_SIGBUS			(1<<7)
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
+#define UFFD_FEATURE_POLL			(1<<9)
 	__u64 features;
 
 	__u64 ioctls;
-- 
2.25.1

