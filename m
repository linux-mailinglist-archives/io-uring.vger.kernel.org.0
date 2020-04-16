Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11631AB762
	for <lists+io-uring@lfdr.de>; Thu, 16 Apr 2020 07:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406659AbgDPFcR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Apr 2020 01:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406392AbgDPFcM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Apr 2020 01:32:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147FBC061A10;
        Wed, 15 Apr 2020 22:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hjp14iUZlRKTsu3uiFZgsg/rZSgDThHclQfpO/jd+7A=; b=NW+cnTIKfLE8yZDKQxf0Vg0THe
        5H5KzRETI5QOYIlFyPmeCgPjtkaUhqXHeZZZGR/B+w8PXjfEd3lNa9Mj4/QGOn9tRUvEyT/HP9ZIp
        cKEl09X0/SbpZcRbE1Mh7Vb8zgGIkzoVR64uw8oNvPmVn2QsTvA69pwSJU2Q9bz6jt8JwGUEha4a3
        nEyjxcyILK4jFRfqVPEF9h3TFLMWpf06HDpQ10he4+pJSYC72xrIKSlVdJSFZ2mOVmnJ/zSW+Wkkg
        up4NceVeglq0unxoki79IiA560yjgT195Q5ZMkbfrmRVZHPrxLQzMKmwpSM4G7LUPJzX6NE+e8U3J
        03vtijDA==;
Received: from [2001:4bb8:184:4aa1:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOx89-0003dI-PY; Thu, 16 Apr 2020 05:32:06 +0000
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
Subject: [PATCH 2/3] kernel: better document the use_mm/unuse_mm API contract
Date:   Thu, 16 Apr 2020 07:31:57 +0200
Message-Id: <20200416053158.586887-3-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200416053158.586887-1-hch@lst.de>
References: <20200416053158.586887-1-hch@lst.de>
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
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  4 +--
 drivers/gpu/drm/i915/gvt/kvmgt.c           |  4 +--
 drivers/usb/gadget/function/f_fs.c         |  4 +--
 drivers/usb/gadget/legacy/inode.c          |  4 +--
 drivers/vfio/vfio_iommu_type1.c            |  4 +--
 drivers/vhost/vhost.c                      |  4 +--
 fs/io-wq.c                                 |  6 ++--
 fs/io_uring.c                              |  6 ++--
 include/linux/kthread.h                    |  4 +--
 kernel/kthread.c                           | 33 +++++++++++-----------
 mm/oom_kill.c                              |  6 ++--
 mm/vmacache.c                              |  4 +--
 12 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index b820c8fc689f..b063bd7f41d8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -192,9 +192,9 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct kgd_dev *dst, struct kgd_dev *s
 			if ((mmptr) == current->mm) {			\
 				valid = !get_user((dst), (wptr));	\
 			} else if (current->mm == NULL) {		\
-				use_mm(mmptr);				\
+				kthread_use_mm(mmptr);			\
 				valid = !get_user((dst), (wptr));	\
-				unuse_mm(mmptr);			\
+				kthread_unuse_mm(mmptr);		\
 			}						\
 			pagefault_enable();				\
 		}							\
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index ca1dd6e6f395..f2927575b793 100644
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
 
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5f50866a8b01..2eb105aa9723 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2333,7 +2333,7 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 		return -EPERM;
 
 	if (kthread)
-		use_mm(mm);
+		kthread_use_mm(mm);
 	else if (current->mm != mm)
 		goto out;
 
@@ -2351,7 +2351,7 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 		*copied = __copy_from_user(data, (void __user *)vaddr,
 					   count) ? 0 : count;
 	if (kthread)
-		unuse_mm(mm);
+		kthread_unuse_mm(mm);
 out:
 	mmput(mm);
 	return *copied ? 0 : -EFAULT;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ead1deed80d3..17d598e74780 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -332,7 +332,7 @@ static int vhost_worker(void *data)
 	mm_segment_t oldfs = get_fs();
 
 	set_fs(USER_DS);
-	use_mm(dev->mm);
+	kthread_use_mm(dev->mm);
 
 	for (;;) {
 		/* mb paired w/ kthread_stop */
@@ -360,7 +360,7 @@ static int vhost_worker(void *data)
 				schedule();
 		}
 	}
-	unuse_mm(dev->mm);
+	kthread_unuse_mm(dev->mm);
 	set_fs(oldfs);
 	return 0;
 }
diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5f590bf27bff..748621f7391e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -170,7 +170,7 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 		}
 		__set_current_state(TASK_RUNNING);
 		set_fs(KERNEL_DS);
-		unuse_mm(worker->mm);
+		kthread_unuse_mm(worker->mm);
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
@@ -417,7 +417,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 {
 	if (worker->mm) {
-		unuse_mm(worker->mm);
+		kthread_unuse_mm(worker->mm);
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
@@ -426,7 +426,7 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 		return;
 	}
 	if (mmget_not_zero(work->mm)) {
-		use_mm(work->mm);
+		kthread_use_mm(work->mm);
 		if (!worker->mm)
 			set_fs(USER_DS);
 		worker->mm = work->mm;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f5a80f6f28f5..8a8148512da7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5876,7 +5876,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 				err = -EFAULT;
 				goto fail_req;
 			}
-			use_mm(ctx->sqo_mm);
+			kthread_use_mm(ctx->sqo_mm);
 			*mm = ctx->sqo_mm;
 		}
 
@@ -5948,7 +5948,7 @@ static int io_sq_thread(void *data)
 			 * may sleep.
 			 */
 			if (cur_mm) {
-				unuse_mm(cur_mm);
+				kthread_unuse_mm(cur_mm);
 				mmput(cur_mm);
 				cur_mm = NULL;
 			}
@@ -6025,7 +6025,7 @@ static int io_sq_thread(void *data)
 
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
index ce4610316377..8ed4b4fbec7c 100644
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
+ * kthread_unuse_mm - reverse the effect of kthread_use_mm()
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

