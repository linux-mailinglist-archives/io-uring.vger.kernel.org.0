Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6B819E44A
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2020 11:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgDDJlY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Apr 2020 05:41:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37262 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDJlX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Apr 2020 05:41:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yiF0lZnKKv5ku7aLqgztTZhdcRHfig0kbM0LbrrrVUs=; b=r5h07XmTUWMIn1VNnYBovE9lNf
        xZ4CnmUBMqRf+9UeWNFMQo+mo9ZhaQ/Co7wR7SUBEGTJxM0pTeKhip4AxCLvSXHjjz5eh0/gAStU5
        KIX3zjjTe5O60momreJHkws8KltSYQL9Ge/hWtyewr9K9WmMKpJeG2lXgQpp9UfvWuelEuXkdj/GD
        HgXp3FYx4GRy1fU2zRSuJfyspAui1jOY3yE2FoHG5tBMDp+gCayf+ZVqqvSNmSNxHnJ6Z7khVB0FA
        sjzUa+e1ldZt9D7pfySqoMzGeChxJOCmNYlrzUFGHdo/7d5vWUDXaCmOmA4XlGrfhvK5tnLIx899w
        VbIF+6AA==;
Received: from [2001:4bb8:180:7914:2ca6:9476:bbfa:a4d0] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jKfIl-0002du-Da; Sat, 04 Apr 2020 09:41:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 5/6] kernel: better document the use_mm/unuse_mm API contract
Date:   Sat,  4 Apr 2020 11:41:00 +0200
Message-Id: <20200404094101.672954-6-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200404094101.672954-1-hch@lst.de>
References: <20200404094101.672954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Switch the function documentation to kerneldoc comments, and add
WARN_ON_ONCE asserts that the calling thread is a kernel thread and
does not have ->mm set (or has ->mm set in the case of unuse_mm).

Also give the functions a kthread_ prefix to better document the
use case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  4 +--
 drivers/gpu/drm/i915/gvt/kvmgt.c           |  4 +--
 drivers/usb/gadget/function/f_fs.c         |  4 +--
 drivers/usb/gadget/legacy/inode.c          |  4 +--
 drivers/vhost/vhost.c                      |  4 +--
 fs/io-wq.c                                 |  6 ++--
 fs/io_uring.c                              |  6 ++--
 include/linux/kthread.h                    |  4 +--
 kernel/kthread.c                           | 33 +++++++++++-----------
 mm/oom_kill.c                              |  6 ++--
 mm/vmacache.c                              |  4 +--
 11 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index bce5e93fefc8..63db84e09408 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -192,9 +192,9 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct kgd_dev *dst, struct kgd_dev *s
 			if ((mmptr) == current->mm) {			\
 				valid = !get_user((dst), (wptr));	\
 			} else if (current->flags & PF_KTHREAD) {	\
-				use_mm(mmptr);				\
+				kthread_use_mm(mmptr);			\
 				valid = !get_user((dst), (wptr));	\
-				unuse_mm(mmptr);			\
+				kthread_unuse_mm(mmptr);		\
 			}						\
 			pagefault_enable();				\
 		}							\
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index dee01c371bf5..92e9b340dbc2 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -2048,7 +2048,7 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
 	if (kthread) {
 		if (!mmget_not_zero(kvm->mm))
 			return -EFAULT;
-		use_mm(kvm->mm);
+		kthread_use_mm(kvm->mm);
 	}
 
 	idx = srcu_read_lock(&kvm->srcu);
@@ -2057,7 +2057,7 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (kthread) {
-		unuse_mm(kvm->mm);
+		kthread_unuse_mm(kvm->mm);
 		mmput(kvm->mm);
 	}
 
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c57b1b2507c6..d9e48bd7c692 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -827,9 +827,9 @@ static void ffs_user_copy_worker(struct work_struct *work)
 		mm_segment_t oldfs = get_fs();
 
 		set_fs(USER_DS);
-		use_mm(io_data->mm);
+		kthread_use_mm(io_data->mm);
 		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
-		unuse_mm(io_data->mm);
+		kthread_unuse_mm(io_data->mm);
 		set_fs(oldfs);
 	}
 
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 8b5233888bf8..a05552bc2ff8 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -462,9 +462,9 @@ static void ep_user_copy_worker(struct work_struct *work)
 	struct kiocb *iocb = priv->iocb;
 	size_t ret;
 
-	use_mm(mm);
+	kthread_use_mm(mm);
 	ret = copy_to_iter(priv->buf, priv->actual, &priv->to);
-	unuse_mm(mm);
+	kthread_unuse_mm(mm);
 	if (!ret)
 		ret = -EFAULT;
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 4e9ce54869af..1787d426a956 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -336,7 +336,7 @@ static int vhost_worker(void *data)
 	mm_segment_t oldfs = get_fs();
 
 	set_fs(USER_DS);
-	use_mm(dev->mm);
+	kthread_use_mm(dev->mm);
 
 	for (;;) {
 		/* mb paired w/ kthread_stop */
@@ -364,7 +364,7 @@ static int vhost_worker(void *data)
 				schedule();
 		}
 	}
-	unuse_mm(dev->mm);
+	kthread_unuse_mm(dev->mm);
 	set_fs(oldfs);
 	return 0;
 }
diff --git a/fs/io-wq.c b/fs/io-wq.c
index c49c2bdbafb5..83c2868eff2a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -169,7 +169,7 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 		}
 		__set_current_state(TASK_RUNNING);
 		set_fs(KERNEL_DS);
-		unuse_mm(worker->mm);
+		kthread_unuse_mm(worker->mm);
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
@@ -416,7 +416,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 {
 	if (worker->mm) {
-		unuse_mm(worker->mm);
+		kthread_unuse_mm(worker->mm);
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
@@ -425,7 +425,7 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 		return;
 	}
 	if (mmget_not_zero(work->mm)) {
-		use_mm(work->mm);
+		kthread_use_mm(work->mm);
 		if (!worker->mm)
 			set_fs(USER_DS);
 		worker->mm = work->mm;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 27a4ecb724ca..367406381044 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5839,7 +5839,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 				err = -EFAULT;
 				goto fail_req;
 			}
-			use_mm(ctx->sqo_mm);
+			kthread_use_mm(ctx->sqo_mm);
 			*mm = ctx->sqo_mm;
 		}
 
@@ -5911,7 +5911,7 @@ static int io_sq_thread(void *data)
 			 * may sleep.
 			 */
 			if (cur_mm) {
-				unuse_mm(cur_mm);
+				kthread_unuse_mm(cur_mm);
 				mmput(cur_mm);
 				cur_mm = NULL;
 			}
@@ -5987,7 +5987,7 @@ static int io_sq_thread(void *data)
 
 	set_fs(old_fs);
 	if (cur_mm) {
-		unuse_mm(cur_mm);
+		kthread_unuse_mm(cur_mm);
 		mmput(cur_mm);
 	}
 	revert_creds(old_cred);
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index c2d40c9672d6..12258ea077cf 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -200,8 +200,8 @@ bool kthread_cancel_delayed_work_sync(struct kthread_delayed_work *work);
 
 void kthread_destroy_worker(struct kthread_worker *worker);
 
-void use_mm(struct mm_struct *mm);
-void unuse_mm(struct mm_struct *mm);
+void kthread_use_mm(struct mm_struct *mm);
+void kthread_unuse_mm(struct mm_struct *mm);
 
 struct cgroup_subsys_state;
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index ce4610316377..316db17f6b4f 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1208,18 +1208,18 @@ void kthread_destroy_worker(struct kthread_worker *worker)
 }
 EXPORT_SYMBOL(kthread_destroy_worker);
 
-/*
- * use_mm
- *	Makes the calling kernel thread take on the specified
- *	mm context.
- *	(Note: this routine is intended to be called only
- *	from a kernel thread context)
+/**
+ * kthread_use_mm - make the calling kthread operate on an address space
+ * @mm: address space to operate on
  */
-void use_mm(struct mm_struct *mm)
+void kthread_use_mm(struct mm_struct *mm)
 {
 	struct mm_struct *active_mm;
 	struct task_struct *tsk = current;
 
+	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
+	WARN_ON_ONCE(tsk->mm);
+
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
 	if (active_mm != mm) {
@@ -1236,20 +1236,19 @@ void use_mm(struct mm_struct *mm)
 	if (active_mm != mm)
 		mmdrop(active_mm);
 }
-EXPORT_SYMBOL_GPL(use_mm);
+EXPORT_SYMBOL_GPL(kthread_use_mm);
 
-/*
- * unuse_mm
- *	Reverses the effect of use_mm, i.e. releases the
- *	specified mm context which was earlier taken on
- *	by the calling kernel thread
- *	(Note: this routine is intended to be called only
- *	from a kernel thread context)
+/**
+ * kthread_use_mm - reverse the effect of kthread_use_mm()
+ * @mm: address space to operate on
  */
-void unuse_mm(struct mm_struct *mm)
+void kthread_unuse_mm(struct mm_struct *mm)
 {
 	struct task_struct *tsk = current;
 
+	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
+	WARN_ON_ONCE(!tsk->mm);
+
 	task_lock(tsk);
 	sync_mm_rss(mm);
 	tsk->mm = NULL;
@@ -1257,7 +1256,7 @@ void unuse_mm(struct mm_struct *mm)
 	enter_lazy_tlb(mm, tsk);
 	task_unlock(tsk);
 }
-EXPORT_SYMBOL_GPL(unuse_mm);
+EXPORT_SYMBOL_GPL(kthread_unuse_mm);
 
 #ifdef CONFIG_BLK_CGROUP
 /**
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index dfc357614e56..958d2972313f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -126,7 +126,7 @@ static bool oom_cpuset_eligible(struct task_struct *tsk, struct oom_control *oc)
 
 /*
  * The process p may have detached its own ->mm while exiting or through
- * use_mm(), but one or more of its subthreads may still have a valid
+ * kthread_use_mm(), but one or more of its subthreads may still have a valid
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
  * task_lock() held.
  */
@@ -919,8 +919,8 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 			continue;
 		}
 		/*
-		 * No use_mm() user needs to read from the userspace so we are
-		 * ok to reap it.
+		 * No kthead_use_mm() user needs to read from the userspace so
+		 * we are ok to reap it.
 		 */
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
diff --git a/mm/vmacache.c b/mm/vmacache.c
index cdc32a3b02fa..ceedbab82106 100644
--- a/mm/vmacache.c
+++ b/mm/vmacache.c
@@ -25,8 +25,8 @@
  * task's vmacache pertains to a different mm (ie, its own).  There is
  * nothing we can do here.
  *
- * Also handle the case where a kernel thread has adopted this mm via use_mm().
- * That kernel thread's vmacache is not applicable to this mm.
+ * Also handle the case where a kernel thread has adopted this mm via
+ * kthread_use_mm(). That kernel thread's vmacache is not applicable to this mm.
  */
 static inline bool vmacache_valid_mm(struct mm_struct *mm)
 {
-- 
2.25.1

