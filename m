Return-Path: <io-uring+bounces-2030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 872C58D5928
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 05:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1228B1F245C0
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 03:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4F03B79C;
	Fri, 31 May 2024 03:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fx3C8QP4"
X-Original-To: io-uring@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A90FD51E
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 03:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717127640; cv=none; b=T4N6MXOBsEQZn4EOydZVJPwHwN6FzPmm1afA0LMCbtgig5oUUyWKXOiQuCyjHTfcLk+Qp+mtgrXWHEkm9nW6b9/nfn2fVqKI7Lzck8spAnvvq9I9IbPOTexNDx1k99saA8FD+ufvOvXTmwikAoEUxW90bCHx0b4Am4tzNmGk5n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717127640; c=relaxed/simple;
	bh=gnks7OwAzc91drebCgibduBU0KOaUdki7hsFWSlPw4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGwvDWbzFghDyEyYmohe3oJUIcri1SbqKvHv/JflfsUHMDupq6ElYzXqISYb74a5NguWCgrSd6jydQMLiEmnPrm7MvdSXJwurW1KHkj6x9tCSsST/krzQKXYEuu6cLaCR17QN7zgF6pQMGFlbWd2Da93rmJeQW2ipH27CCMTDsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fx3C8QP4; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: bernd.schubert@fastmail.fm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717127634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Q5205RitZvtxxsySDbK6v2N+MvxOAuX2elEr7D8Pgg=;
	b=fx3C8QP4DxT3YGDf7on+LqNmyRSLIkR24ZrZ1Jxy8RgukWonrmxOjb9aUzvcaYu8IpF1OD
	MIl4yUg1VcUROZQUfmxZc5o51LeZmka3RtmcqCSJLr5R/8aLe/4vADdGXLcKHHw8dpTcD8
	v338HVajJdaBEvrdRuF0GDUClb0mlXE=
X-Envelope-To: bschubert@ddn.com
X-Envelope-To: miklos@szeredi.hu
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: avagin@google.com
X-Envelope-To: io-uring@vger.kernel.org
X-Envelope-To: axboe@kernel.dk
X-Envelope-To: ming.lei@redhat.com
X-Envelope-To: asml.silence@gmail.com
X-Envelope-To: josef@toxicpanda.com
Date: Thu, 30 May 2024 23:53:49 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	Pavel Begunkov <asml.silence@gmail.com>, Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH] fs: sys_ringbuffer() (WIP)
Message-ID: <ytprj7mx37dna3n3kbiskgvris4nfvv63u3v7wogdrlzbikkmt@chgq5hw3ny3r>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <5mimjjxul2sc2g7x6pttnit46pbw3astwj2giqfr4xayp63el2@fb5bgtiavwgv>
 <8c3548a9-3b15-49c4-9e38-68d81433144a@fastmail.fm>
 <owccqrazlyfo2zcsprxr7bhpgjrh4km3xlc4ku2aqhqhlqhtyj@djlwwccmlwhw>
 <fe874c55-a26f-413f-9719-9cf59b1a3d28@fastmail.fm>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe874c55-a26f-413f-9719-9cf59b1a3d28@fastmail.fm>
X-Migadu-Flow: FLOW_OUT

On Thu, May 30, 2024 at 06:17:29PM +0200, Bernd Schubert wrote:
> 
> 
> On 5/30/24 18:10, Kent Overstreet wrote:
> > On Thu, May 30, 2024 at 06:02:21PM +0200, Bernd Schubert wrote:
> >> Hmm, initially I had thought about writing my own ring buffer, but then 
> >> io-uring got IORING_OP_URING_CMD, which seems to have exactly what we
> >> need? From interface point of view, io-uring seems easy to use here, 
> >> has everything we need and kind of the same thing is used for ublk - 
> >> what speaks against io-uring? And what other suggestion do you have?
> >>
> >> I guess the same concern would also apply to ublk_drv. 
> >>
> >> Well, decoupling from io-uring might help to get for zero-copy, as there
> >> doesn't seem to be an agreement with Mings approaches (sorry I'm only
> >> silently following for now).
> >>
> >> From our side, a customer has pointed out security concerns for io-uring. 
> >> My thinking so far was to implemented the required io-uring pieces into 
> >> an module and access it with ioctls... Which would also allow to
> >> backport it to RHEL8/RHEL9.
> > 
> > Well, I've been starting to sketch out a ringbuffer() syscall, which
> > would work on any (supported) file descriptor and give you a ringbuffer
> > for reading or writing (or call it twice for both).
> > 
> > That seems to be what fuse really wants, no? You're already using a file
> > descriptor and your own RPC format, you just want a faster
> > communications channel.
> 
> Fine with me, if you have something better/simpler with less security
> concerns - why not. We just need a community agreement on that.
> 
> Do you have something I could look at?

Here you go. Not tested yet, but all the essentials should be there.

there's something else _really_ slick we should be able to do with this:
add support to pipes, and then - if both ends of a pipe ask for a
ringbuffer, map them the _same_ ringbuffer, zero copy and completely
bypassing the kernel and neither end has to know if the other end
supports ringbuffers or just normal pipes.

-- >8 --
Add new syscalls for generic ringbuffers that can be attached to
arbitrary (supporting) file descriptors.

A ringbuffer consists of:
 - a single page for head/tail pointers, size/mask, and other ancilliary
   metadata, described by 'struct ringbuffer_ptrs'
 - a data buffer, consisting of one or more pages mapped at
   'ringbuffer_ptrs.data_offset' above the address of 'ringbuffer_ptrs'

The data buffer is always a power of two size. Head and tail pointers
are u32 byte offsets, and they are stored unmasked (i.e., they use the
full 32 bit range) - they must be masked for reading.

- ringbuffer(int fd, int rw, u32 size, ulong *addr)

Create or get address of an existing ringbuffer for either reads or
writes, of at least size bytes, and attach it to the given file
descriptor; the address of the ringbuffer is returned via addr.

Since files can be shared between processes in different address spaces
a ringbuffer may be mapped into multiple address spaces via this
syscall.

- ringbuffer_wait(int fd, int rw)

Wait for space to be availaable (on a ringbuffer for writing), or data
to be available (on a ringbuffer for writing).

todo: add parameters for timeout, minimum amount of data/space to wait for

- ringbuffer_wakeup(int fd, int rw)

Required after writing to a previously empty ringbuffer, or reading from
a previously full ringbuffer to notify waiters on the other end

todo - investigate integrating with futexes?
todo - add extra fields to ringbuffer_ptrs for waiting on a minimum
amount of data/space, i.e. to signal when a wakeup is required

Kernel interfaces:
 - To indicate that ringbuffers are supported on a file, set
   FOP_RINGBUFFER_READ and/or FOP_RINGBUFFER_WRITE in your
   file_operations.
 - To read or write to a file's associated ringbuffers
   (file->f_ringbuffer), use ringbuffer_read() or ringbuffer_write().

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 arch/x86/entry/syscalls/syscall_32.tbl |   3 +
 arch/x86/entry/syscalls/syscall_64.tbl |   3 +
 fs/Makefile                            |   1 +
 fs/file_table.c                        |   2 +
 fs/ringbuffer.c                        | 478 +++++++++++++++++++++++++
 include/linux/fs.h                     |  14 +
 include/linux/mm_types.h               |   4 +
 include/linux/ringbuffer_sys.h         |  15 +
 include/uapi/linux/ringbuffer_sys.h    |  38 ++
 init/Kconfig                           |   8 +
 kernel/fork.c                          |   1 +
 11 files changed, 567 insertions(+)
 create mode 100644 fs/ringbuffer.c
 create mode 100644 include/linux/ringbuffer_sys.h
 create mode 100644 include/uapi/linux/ringbuffer_sys.h

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 7fd1f57ad3d3..2385359eaf75 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -467,3 +467,6 @@
 460	i386	lsm_set_self_attr	sys_lsm_set_self_attr
 461	i386	lsm_list_modules	sys_lsm_list_modules
 462	i386	mseal 			sys_mseal
+463	i386	ringbuffer		sys_ringbuffer
+464	i386	ringbuffer_wait		sys_ringbuffer_wait
+465	i386	ringbuffer_wakeup	sys_ringbuffer_wakeup
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index a396f6e6ab5b..942602ece075 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -384,6 +384,9 @@
 460	common	lsm_set_self_attr	sys_lsm_set_self_attr
 461	common	lsm_list_modules	sys_lsm_list_modules
 462 	common  mseal			sys_mseal
+463	common	ringbuffer		sys_ringbuffer
+464	common	ringbuffer_wait		sys_ringbuffer_wait
+465	common	ringbuffer_wakeup	sys_ringbuffer_wakeup
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/fs/Makefile b/fs/Makefile
index 6ecc9b0a53f2..48e54ac01fb1 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_USERFAULTFD)	+= userfaultfd.o
 obj-$(CONFIG_AIO)               += aio.o
+obj-$(CONFIG_RINGBUFFER)        += ringbuffer.o
 obj-$(CONFIG_FS_DAX)		+= dax.o
 obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
 obj-$(CONFIG_FS_VERITY)		+= verity/
diff --git a/fs/file_table.c b/fs/file_table.c
index 4f03beed4737..9675f22d6615 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -25,6 +25,7 @@
 #include <linux/sysctl.h>
 #include <linux/percpu_counter.h>
 #include <linux/percpu.h>
+#include <linux/ringbuffer_sys.h>
 #include <linux/task_work.h>
 #include <linux/swap.h>
 #include <linux/kmemleak.h>
@@ -412,6 +413,7 @@ static void __fput(struct file *file)
 	 */
 	eventpoll_release(file);
 	locks_remove_file(file);
+	ringbuffer_file_exit(file);
 
 	security_file_release(file);
 	if (unlikely(file->f_flags & FASYNC)) {
diff --git a/fs/ringbuffer.c b/fs/ringbuffer.c
new file mode 100644
index 000000000000..cef8ca8b9416
--- /dev/null
+++ b/fs/ringbuffer.c
@@ -0,0 +1,478 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/darray.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/mman.h>
+#include <linux/mount.h>
+#include <linux/mutex.h>
+#include <linux/pagemap.h>
+#include <linux/pseudo_fs.h>
+#include <linux/ringbuffer_sys.h>
+#include <uapi/linux/ringbuffer_sys.h>
+#include <linux/syscalls.h>
+
+#define RINGBUFFER_FS_MAGIC			0xa10a10a2
+
+static DEFINE_MUTEX(ringbuffer_lock);
+
+static struct vfsmount *ringbuffer_mnt;
+
+struct ringbuffer_mapping {
+	ulong			addr;
+	struct mm_struct	*mm;
+};
+
+struct ringbuffer {
+	wait_queue_head_t	wait[2];
+	spinlock_t		lock;
+	int			rw;
+	u32			size;	/* always a power of two */
+	u32			mask;	/* size - 1 */
+	struct file		*io_file;
+	/* hidden internal file for the mmap */
+	struct file		*rb_file;
+	struct ringbuffer_ptrs	*ptrs;
+	void			*data;
+	DARRAY(struct ringbuffer_mapping) mms;
+};
+
+static const struct address_space_operations ringbuffer_aops = {
+	.dirty_folio	= noop_dirty_folio,
+#if 0
+	.migrate_folio	= ringbuffer_migrate_folio,
+#endif
+};
+
+#if 0
+static int ringbuffer_mremap(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct mm_struct *mm = vma->vm_mm;
+	struct kioctx_table *table;
+	int i, res = -EINVAL;
+
+	spin_lock(&mm->ioctx_lock);
+	rcu_read_lock();
+	table = rcu_dereference(mm->ioctx_table);
+	if (!table)
+		goto out_unlock;
+
+	for (i = 0; i < table->nr; i++) {
+		struct kioctx *ctx;
+
+		ctx = rcu_dereference(table->table[i]);
+		if (ctx && ctx->ringbuffer_file == file) {
+			if (!atomic_read(&ctx->dead)) {
+				ctx->user_id = ctx->mmap_base = vma->vm_start;
+				res = 0;
+			}
+			break;
+		}
+	}
+
+out_unlock:
+	rcu_read_unlock();
+	spin_unlock(&mm->ioctx_lock);
+	return res;
+}
+#endif
+
+static const struct vm_operations_struct ringbuffer_vm_ops = {
+#if 0
+	.mremap		= ringbuffer_mremap,
+#endif
+#if IS_ENABLED(CONFIG_MMU)
+	.fault		= filemap_fault,
+	.map_pages	= filemap_map_pages,
+	.page_mkwrite	= filemap_page_mkwrite,
+#endif
+};
+
+static int ringbuffer_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	vm_flags_set(vma, VM_DONTEXPAND);
+	vma->vm_ops = &ringbuffer_vm_ops;
+	return 0;
+}
+
+static const struct file_operations ringbuffer_fops = {
+	.mmap = ringbuffer_mmap,
+};
+
+static void ringbuffer_free(struct ringbuffer *rb)
+{
+	rb->io_file->f_ringbuffers[rb->rw] = NULL;
+
+	darray_for_each(rb->mms, map)
+		darray_for_each_reverse(map->mm->ringbuffers, rb2)
+			if (rb == *rb2)
+				darray_remove_item(&map->mm->ringbuffers, rb2);
+
+	if (rb->rb_file) {
+		/* Kills mapping: */
+		truncate_setsize(file_inode(rb->rb_file), 0);
+
+		/* Prevent further access to the kioctx from migratepages */
+		struct address_space *mapping = rb->rb_file->f_mapping;
+		spin_lock(&mapping->i_private_lock);
+		mapping->i_private_data = NULL;
+		spin_unlock(&mapping->i_private_lock);
+
+		fput(rb->rb_file);
+	}
+
+	free_pages((ulong) rb->data, get_order(rb->size));
+	free_page((ulong) rb->ptrs);
+	kfree(rb);
+}
+
+static int ringbuffer_map(struct ringbuffer *rb, ulong *addr)
+{
+	struct mm_struct *mm = current->mm;
+
+	int ret = darray_make_room(&rb->mms, 1) ?:
+		darray_make_room(&mm->ringbuffers, 1);
+	if (ret)
+		return ret;
+
+	ret = mmap_write_lock_killable(mm);
+	if (ret)
+		return ret;
+
+	ulong unused;
+	struct ringbuffer_mapping map = {
+		.addr = do_mmap(rb->rb_file, 0, rb->size + PAGE_SIZE,
+				PROT_READ|PROT_WRITE,
+				MAP_SHARED, 0, 0, &unused, NULL),
+		.mm = mm,
+	};
+	mmap_write_unlock(mm);
+
+	ret = PTR_ERR_OR_ZERO((void *) map.addr);
+	if (ret)
+		return ret;
+
+	ret =   darray_push(&mm->ringbuffers, rb) ?:
+		darray_push(&rb->mms, map);
+	BUG_ON(ret); /* we preallocated */
+
+	*addr = map.addr;
+	return 0;
+}
+
+static int ringbuffer_get_addr_or_map(struct ringbuffer *rb, ulong *addr)
+{
+	struct mm_struct *mm = current->mm;
+
+	darray_for_each(rb->mms, map)
+		if (map->mm == mm) {
+			*addr = map->addr;
+			return 0;
+		}
+
+	return ringbuffer_map(rb, addr);
+}
+
+static struct ringbuffer *ringbuffer_alloc(struct file *file, int rw, u32 size,
+					   ulong *addr)
+{
+	unsigned order = get_order(size);
+	size = PAGE_SIZE << order;
+
+	struct ringbuffer *rb = kzalloc(sizeof(*rb), GFP_KERNEL);
+	if (!rb)
+		return ERR_PTR(-ENOMEM);
+
+	init_waitqueue_head(&rb->wait[READ]);
+	init_waitqueue_head(&rb->wait[WRITE]);
+	spin_lock_init(&rb->lock);
+	rb->rw		= rw;
+	rb->size	= size;
+	rb->mask	= size - 1;
+	rb->io_file	= file;
+
+	rb->ptrs = (void *) __get_free_page(GFP_KERNEL|__GFP_ZERO);
+	rb->data = (void *) __get_free_pages(GFP_KERNEL|__GFP_ZERO, order);
+	if (!rb->ptrs || !rb->data)
+		goto err;
+
+	rb->ptrs->size	= size;
+	rb->ptrs->mask	= size - 1;
+	rb->ptrs->data_offset = PAGE_SIZE;
+
+	struct inode *inode = alloc_anon_inode(ringbuffer_mnt->mnt_sb);
+	int ret = PTR_ERR_OR_ZERO(inode);
+	if (ret)
+		goto err;
+
+	inode->i_mapping->a_ops = &ringbuffer_aops;
+	inode->i_mapping->i_private_data = rb;
+	inode->i_size = size;
+
+	rb->rb_file = alloc_file_pseudo(inode, ringbuffer_mnt, "[ringbuffer]",
+				     O_RDWR, &ringbuffer_fops);
+	ret = PTR_ERR_OR_ZERO(rb->rb_file);
+	if (ret)
+		goto err_iput;
+
+	ret = filemap_add_folio(rb->rb_file->f_mapping,
+				page_folio(virt_to_page(rb->ptrs)),
+				0, GFP_KERNEL);
+	if (ret)
+		goto err;
+
+	/* todo - implement a fallback when high order allocation fails */
+	ret = filemap_add_folio(rb->rb_file->f_mapping,
+				page_folio(virt_to_page(rb->data)),
+				1, GFP_KERNEL);
+	if (ret)
+		goto err;
+
+	ret = ringbuffer_map(rb, addr);
+	if (ret)
+		goto err;
+
+	return rb;
+err_iput:
+	iput(inode);
+err:
+	ringbuffer_free(rb);
+	return ERR_PTR(ret);
+}
+
+/* file is going away, tear down ringbuffers: */
+void ringbuffer_file_exit(struct file *file)
+{
+	mutex_lock(&ringbuffer_lock);
+	for (unsigned i = 0; i < ARRAY_SIZE(file->f_ringbuffers); i++)
+		if (file->f_ringbuffers[i])
+			ringbuffer_free(file->f_ringbuffers[i]);
+	mutex_unlock(&ringbuffer_lock);
+}
+
+/*
+ * XXX: we require synchronization when killing a ringbuffer (because no longer
+ * mapped anywhere) to a file that is still open (and in use)
+ */
+static void ringbuffer_mm_drop(struct mm_struct *mm, struct ringbuffer *rb)
+{
+	darray_for_each_reverse(rb->mms, map)
+		if (mm == map->mm)
+			darray_remove_item(&rb->mms, map);
+
+	if (!rb->mms.nr)
+		ringbuffer_free(rb);
+}
+
+void ringbuffer_mm_exit(struct mm_struct *mm)
+{
+	mutex_lock(&ringbuffer_lock);
+	darray_for_each_reverse(mm->ringbuffers, rb)
+		ringbuffer_mm_drop(mm, *rb);
+	mutex_unlock(&ringbuffer_lock);
+
+	darray_exit(&mm->ringbuffers);
+}
+
+SYSCALL_DEFINE4(ringbuffer, unsigned, fd, int, rw, u32, size, ulong __user *, ringbufferp)
+{
+	ulong rb_addr;
+
+	int ret = get_user(rb_addr, ringbufferp);
+	if (unlikely(ret))
+		return ret;
+
+	if (unlikely(rb_addr || !size || rw > WRITE))
+		return -EINVAL;
+
+	struct fd f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	if (!(f.file->f_op->fop_flags & (rw == READ ? FOP_RINGBUFFER_READ : FOP_RINGBUFFER_WRITE))) {
+		ret = -EOPNOTSUPP;
+		goto err;
+	}
+
+	mutex_lock(&ringbuffer_lock);
+	struct ringbuffer *rb = f.file->f_ringbuffers[rw];
+	if (rb) {
+		ret = ringbuffer_get_addr_or_map(rb, &rb_addr);
+		if (ret)
+			goto err_unlock;
+
+		ret = put_user(rb_addr, ringbufferp);
+	} else {
+		rb = ringbuffer_alloc(f.file, rw, size, &rb_addr);
+		ret = PTR_ERR_OR_ZERO(rb);
+		if (ret)
+			goto err_unlock;
+
+		ret = put_user(rb_addr, ringbufferp);
+		if (ret) {
+			ringbuffer_free(rb);
+			goto err_unlock;
+		}
+
+		f.file->f_ringbuffers[rw] = rb;
+	}
+err_unlock:
+	mutex_unlock(&ringbuffer_lock);
+err:
+	fdput(f);
+	return ret;
+}
+
+static bool __ringbuffer_read(struct ringbuffer *rb, void **data, size_t *len,
+			       bool nonblocking, size_t *ret)
+{
+	u32 head = rb->ptrs->head;
+	u32 tail = rb->ptrs->tail;
+
+	if (head == tail)
+		return 0;
+
+	ulong flags;
+	spin_lock_irqsave(&rb->lock, flags);
+	/* Multiple consumers - recheck under lock: */
+	tail = rb->ptrs->tail;
+
+	while (*len && tail != head) {
+		u32 tail_masked = tail & rb->mask;
+		u32 b = min(*len,
+			min(head - tail,
+			    rb->size - tail_masked));
+
+		memcpy(*data, rb->data + tail_masked, b);
+		tail	+= b;
+		*data	+= b;
+		*len	-= b;
+		*ret	+= b;
+	}
+
+	smp_store_release(&rb->ptrs->tail, tail);
+	spin_unlock_irqrestore(&rb->lock, flags);
+
+	return !*len || nonblocking;
+}
+
+size_t ringbuffer_read(struct ringbuffer *rb, void *data, size_t len, bool nonblocking)
+{
+	size_t ret = 0;
+	wait_event(rb->wait[READ], __ringbuffer_read(rb, &data, &len, nonblocking, &ret));
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ringbuffer_read);
+
+static bool __ringbuffer_write(struct ringbuffer *rb, void **data, size_t *len,
+			       bool nonblocking, size_t *ret)
+{
+	u32 head = rb->ptrs->head;
+	u32 tail = rb->ptrs->tail;
+
+	if (head - tail >= rb->size)
+		return 0;
+
+	ulong flags;
+	spin_lock_irqsave(&rb->lock, flags);
+	/* Multiple producers - recheck under lock: */
+	head = rb->ptrs->head;
+
+	while (*len && head - tail < rb->size) {
+		u32 head_masked = head & rb->mask;
+		u32 b = min(*len,
+			min(tail + rb->size - head,
+			    rb->size - head_masked));
+
+		memcpy(rb->data + head_masked, *data, b);
+		head	+= b;
+		*data	+= b;
+		*len	-= b;
+		*ret	+= b;
+	}
+
+	smp_store_release(&rb->ptrs->head, head);
+	spin_unlock_irqrestore(&rb->lock, flags);
+
+	return !*len || nonblocking;
+}
+
+size_t ringbuffer_write(struct ringbuffer *rb, void *data, size_t len, bool nonblocking)
+{
+	size_t ret = 0;
+	wait_event(rb->wait[WRITE], __ringbuffer_write(rb, &data, &len, nonblocking, &ret));
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ringbuffer_write);
+
+SYSCALL_DEFINE2(ringbuffer_wait, unsigned, fd, int, rw)
+{
+	int ret = 0;
+
+	if (rw > WRITE)
+		return -EINVAL;
+
+	struct fd f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	struct ringbuffer *rb = f.file->f_ringbuffers[rw];
+	if (!rb) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	struct ringbuffer_ptrs *rp = rb->ptrs;
+	wait_event(rb->wait[rw], rw == READ
+		   ? rp->head != rp->tail
+		   : rp->head - rp->tail < rb->size);
+err:
+	fdput(f);
+	return ret;
+}
+
+SYSCALL_DEFINE2(ringbuffer_wakeup, unsigned, fd, int, rw)
+{
+	int ret = 0;
+
+	if (rw > WRITE)
+		return -EINVAL;
+
+	struct fd f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	struct ringbuffer *rb = f.file->f_ringbuffers[rw];
+	if (!rb) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	wake_up(&rb->wait[rw]);
+err:
+	fdput(f);
+	return ret;
+}
+
+static int ringbuffer_init_fs_context(struct fs_context *fc)
+{
+	if (!init_pseudo(fc, RINGBUFFER_FS_MAGIC))
+		return -ENOMEM;
+	fc->s_iflags |= SB_I_NOEXEC;
+	return 0;
+}
+
+static int __init ringbuffer_setup(void)
+{
+	static struct file_system_type ringbuffer_fs = {
+		.name		= "ringbuffer",
+		.init_fs_context = ringbuffer_init_fs_context,
+		.kill_sb	= kill_anon_super,
+	};
+	ringbuffer_mnt = kern_mount(&ringbuffer_fs);
+	if (IS_ERR(ringbuffer_mnt))
+		panic("Failed to create ringbuffer fs mount.");
+	return 0;
+}
+__initcall(ringbuffer_setup);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0283cf366c2a..ba30fdfff5cb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -978,6 +978,8 @@ static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
 		index <  ra->start + ra->size);
 }
 
+struct ringbuffer;
+
 /*
  * f_{lock,count,pos_lock} members can be highly contended and share
  * the same cacheline. f_{lock,mode} are very frequently used together
@@ -1024,6 +1026,14 @@ struct file {
 	struct address_space	*f_mapping;
 	errseq_t		f_wb_err;
 	errseq_t		f_sb_err; /* for syncfs */
+
+#ifdef CONFIG_RINGBUFFER
+	/*
+	 * Ringbuffers for reading/writing without syncall overhead, created by
+	 * ringbuffer(2)
+	 */
+	struct ringbuffer	*f_ringbuffers[2];
+#endif
 } __randomize_layout
   __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
@@ -2051,6 +2061,10 @@ struct file_operations {
 #define FOP_DIO_PARALLEL_WRITE	((__force fop_flags_t)(1 << 3))
 /* Contains huge pages */
 #define FOP_HUGE_PAGES		((__force fop_flags_t)(1 << 4))
+/* Supports read ringbuffers */
+#define FOP_RINGBUFFER_READ	((__force fop_flags_t)(1 << 5))
+/* Supports write ringbuffers */
+#define FOP_RINGBUFFER_WRITE	((__force fop_flags_t)(1 << 6))
 
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 24323c7d0bd4..6e412718ce7e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -5,6 +5,7 @@
 #include <linux/mm_types_task.h>
 
 #include <linux/auxvec.h>
+#include <linux/darray_types.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -911,6 +912,9 @@ struct mm_struct {
 		spinlock_t			ioctx_lock;
 		struct kioctx_table __rcu	*ioctx_table;
 #endif
+#ifdef CONFIG_RINGBUFFER
+		DARRAY(struct ringbuffer *)	ringbuffers;
+#endif
 #ifdef CONFIG_MEMCG
 		/*
 		 * "owner" points to a task that is regarded as the canonical
diff --git a/include/linux/ringbuffer_sys.h b/include/linux/ringbuffer_sys.h
new file mode 100644
index 000000000000..e9b3d0a0910f
--- /dev/null
+++ b/include/linux/ringbuffer_sys.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_RINGBUFFER_SYS_H
+#define _LINUX_RINGBUFFER_SYS_H
+
+struct file;
+void ringbuffer_file_exit(struct file *file);
+
+struct mm_struct;
+void ringbuffer_mm_exit(struct mm_struct *mm);
+
+struct ringbuffer;
+size_t ringbuffer_read(struct ringbuffer *rb, void *data, size_t len, bool nonblocking);
+size_t ringbuffer_write(struct ringbuffer *rb, void *data, size_t len, bool nonblocking);
+
+#endif /* _LINUX_RINGBUFFER_SYS_H */
diff --git a/include/uapi/linux/ringbuffer_sys.h b/include/uapi/linux/ringbuffer_sys.h
new file mode 100644
index 000000000000..d7a3af42da91
--- /dev/null
+++ b/include/uapi/linux/ringbuffer_sys.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_RINGBUFFER_SYS_H
+#define _UAPI_LINUX_RINGBUFFER_SYS_H
+
+/*
+ * ringbuffer_ptrs - head and tail pointers for a ringbuffer, mappped to
+ * userspace:
+ */
+struct ringbuffer_ptrs {
+	/*
+	 * We use u32s because this type is shared between the kernel and
+	 * userspace - ulong/size_t won't work here, we might be 32bit userland
+	 * and 64 bit kernel, and u64 would be preferable (reduced probability
+	 * of ABA) but not all architectures can atomically read/write to a u64;
+	 * we need to avoid torn reads/writes.
+	 *
+	 * head and tail pointers are incremented and stored without masking;
+	 * this is to avoid ABA and differentiate between a full and empty
+	 * buffer - they must be masked with @mask to get an actual offset into
+	 * the data buffer.
+	 *
+	 * All units are in bytes.
+	 *
+	 * Data is emitted at head, consumed from tail.
+	 */
+	u32		head;
+	u32		tail;
+	u32		size;	/* always a power of two */
+	u32		mask;	/* size - 1 */
+
+	/*
+	 * Starting offset of data buffer, from the start of this struct - will
+	 * always be PAGE_SIZE.
+	 */
+	u32		data_offset;
+};
+
+#endif /* _UAPI_LINUX_RINGBUFFER_SYS_H */
diff --git a/init/Kconfig b/init/Kconfig
index 72404c1f2157..1ff8eaa43e2f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1673,6 +1673,14 @@ config IO_URING
 	  applications to submit and complete IO through submission and
 	  completion rings that are shared between the kernel and application.
 
+config RINGBUFFER
+	bool "Enable ringbuffer() syscall" if EXPERT
+	default y
+	help
+	  This option adds support for generic ringbuffers, which can be
+	  attached to any (supported) file descriptor, allowing for reading and
+	  writing without syscall overhead.
+
 config ADVISE_SYSCALLS
 	bool "Enable madvise/fadvise syscalls" if EXPERT
 	default y
diff --git a/kernel/fork.c b/kernel/fork.c
index 99076dbe27d8..ea160a9abd60 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1340,6 +1340,7 @@ static inline void __mmput(struct mm_struct *mm)
 	VM_BUG_ON(atomic_read(&mm->mm_users));
 
 	uprobe_clear_state(mm);
+	ringbuffer_mm_exit(mm);
 	exit_aio(mm);
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
-- 
2.45.1


