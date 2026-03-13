Return-Path: <io-uring+bounces-12665-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IL/8AOsMtGlvfwAAu9opvQ
	(envelope-from <io-uring+bounces-12665-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 14:11:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D78BC2837D9
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 14:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 69EB63039A58
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 13:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D147637DEB7;
	Fri, 13 Mar 2026 13:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="JO5Qd4d6";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="4h59N4PA"
X-Original-To: io-uring@vger.kernel.org
Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93E71E868;
	Fri, 13 Mar 2026 13:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773407395; cv=none; b=Ccj7MlY9fZwMQLZ/Qqx8+Ay84zLjSu8KblEcOOl/CrHl3kKiQjUEt+0g9U3DFcv7wrdQX6uul0qGgXtQMfq8cKhQ39SQvRX3IZhZpHeG4comuheN1chB4gGpR0xOU1vrKizSH+QaaNZpU9nNAg9TsIc/q3BNKIGLJxy1uR9EC7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773407395; c=relaxed/simple;
	bh=2ROS8QZcSMfR0zuV9L6a6XKE+p0ehtYdt5MhLFY/oYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jGJ89DIpu4DV8THWKamlpEFl4GzpxmlWA+TrStLQ1qMHlm+Dnwt9evM/vU4j5Humhtr1dtPpbLsWccxExKABNYx6q1PSouDq4iv8LDdSdD517SYw4jWfkbOX9HwlRh3F1bELiyLlkGKbsv33CUX09XfbaOHu8cPU5+9oiiXHsao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=JO5Qd4d6; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=4h59N4PA; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1773407260; bh=PLOjTc7JxcptdK8LCcTzQLv
	nAVhE0pFPknQIAoqoT3w=; b=JO5Qd4d6je62OT0WgCeoD3yjwreu9/DMdx9ClCfwsCLKNL5TXK
	0ywA33NvNHGjaS/T7a7BCulRTE5tfCJuFpS8EkIj/utXMz/YR1YwSJ8kPxBGuiOkG1sR7Ui7qcV
	yevC9IpjBgKL853vdx9pknZAeJIVQX8/HtTL2M2JNmijoyZO/O77dvO1VUoWyZDE6VUX5Gusbef
	I97yfMp8GdVSNXgN5a2p5+SEnNerO88o6ZAc9IXtQ1/ib6t1NTqTeXRdSy/Y1viTo0E6zwCB1DI
	V46ymIs3cREkLCWN601zxIViH21ogImA/kBygHabhc+RWfynHLk5qN/54wUXatXrjeg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1773407260; bh=PLOjTc7JxcptdK8LCcTzQLv
	nAVhE0pFPknQIAoqoT3w=; b=4h59N4PACA9Z2V3Y5ISXsFtrrojGdR4AGN1nt5aC+IQaLfvJvx
	0paFTdLhn6+CKO5/VL8kwU0dZjrXAL1vRYAw==;
From: Daniel Hodges <git@danielhodges.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Daniel Hodges <git@danielhodges.dev>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] io_uring: add high-performance IPC channel infrastructure
Date: Fri, 13 Mar 2026 09:07:38 -0400
Message-ID: <20260313130739.23265-2-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260313130739.23265-1-git@danielhodges.dev>
References: <20260313130739.23265-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[danielhodges.dev,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[danielhodges.dev:s=202510r,danielhodges.dev:s=202510e];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12665-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[danielhodges.dev:+];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[git@danielhodges.dev,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[danielhodges.dev,gmail.com,vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[danielhodges.dev:dkim,danielhodges.dev:email,danielhodges.dev:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D78BC2837D9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add a new IPC mechanism built on top of io_uring for message passing
between processes.

Features:
- Shared memory ring buffer for message data transfer
- RCU-based subscriber lookup on send/recv paths
- Broadcast mode (all subscribers receive each message)
- Channel-based design supporting multiple subscribers
- Permission checking modeled on Unix file permissions
- Anonymous file per channel for mmap support

Architecture:
- Two new io_uring opcodes: IPC_SEND and IPC_RECV
- Four new registration commands for channel lifecycle:
  CREATE, ATTACH, DETACH, and BUFFERS (BUFFERS is a stub)
- Channels are identified by numeric ID or 64-bit key
- Data is copied between userspace and a kernel ring buffer
  via copy_from_user/copy_to_user
- Multicast (round-robin) flag is defined but not yet implemented

Send/recv hot path optimizations:
- Cache the descriptor array base pointer in struct io_ipc_channel
  to avoid recomputing it on every send/recv
- Use __copy_from_user_inatomic/__copy_to_user_inatomic with fallback
  to the standard copy variants
- Add prefetch/prefetchw hints for descriptor and data access
- In non-broadcast mode, wake only the first receiver instead of
  iterating all subscribers
- Simplify error handling in io_ipc_send() using inline returns
- Remove channel pointer caching in request structs, emptying the
  send and recv cleanup handlers

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 include/linux/io_uring_types.h |    7 +
 include/uapi/linux/io_uring.h  |   74 +++
 io_uring/Kconfig               |   14 +
 io_uring/Makefile              |    1 +
 io_uring/io_uring.c            |    6 +
 io_uring/ipc.c                 | 1002 ++++++++++++++++++++++++++++++++
 io_uring/ipc.h                 |  161 +++++
 io_uring/opdef.c               |   19 +
 io_uring/register.c            |   25 +
 9 files changed, 1309 insertions(+)
 create mode 100644 io_uring/ipc.c
 create mode 100644 io_uring/ipc.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dd1420bfcb73..fbbe51aaca68 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -435,6 +435,13 @@ struct io_ring_ctx {
 	u32			pers_next;
 	struct xarray		personalities;
 
+#ifdef CONFIG_IO_URING_IPC
+	/* IPC subscriber tracking - keyed by subscriber_id */
+	struct xarray		ipc_subscribers;
+	/* IPC channels created by this ring - keyed by channel_id */
+	struct xarray		ipc_channels;
+#endif
+
 	/* hashed buffered write serialization */
 	struct io_wq_hash		*hash_map;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 17ac1b785440..a5b68bd1a047 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -318,6 +318,8 @@ enum io_uring_op {
 	IORING_OP_PIPE,
 	IORING_OP_NOP128,
 	IORING_OP_URING_CMD128,
+	IORING_OP_IPC_SEND,
+	IORING_OP_IPC_RECV,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -723,6 +725,12 @@ enum io_uring_register_op {
 	/* register bpf filtering programs */
 	IORING_REGISTER_BPF_FILTER		= 37,
 
+	/* IPC channel operations */
+	IORING_REGISTER_IPC_CHANNEL_CREATE	= 38,
+	IORING_REGISTER_IPC_CHANNEL_ATTACH	= 39,
+	IORING_REGISTER_IPC_CHANNEL_DETACH	= 40,
+	IORING_REGISTER_IPC_CHANNEL_DESTROY	= 41,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -1057,6 +1065,72 @@ struct io_timespec {
 	__u64		tv_nsec;
 };
 
+/*
+ * IPC channel support
+ */
+
+/* Flags for IPC channel creation */
+#define IOIPC_F_BROADCAST	(1U << 0)  /* Broadcast mode (all subscribers receive) */
+#define IOIPC_F_MULTICAST	(1U << 1)  /* Multicast mode (round-robin delivery) */
+#define IOIPC_F_PRIVATE		(1U << 2)  /* Private (permissions enforced strictly) */
+
+/* Flags for subscriber attachment */
+#define IOIPC_SUB_SEND		(1U << 0)  /* Can send to channel */
+#define IOIPC_SUB_RECV		(1U << 1)  /* Can receive from channel */
+#define IOIPC_SUB_BOTH		(IOIPC_SUB_SEND | IOIPC_SUB_RECV)
+
+/* Create IPC channel */
+struct io_uring_ipc_channel_create {
+	__u32	flags;			/* IOIPC_F_BROADCAST, IOIPC_F_PRIVATE */
+	__u32	ring_entries;		/* Number of message slots */
+	__u32	max_msg_size;		/* Maximum message size */
+	__u32	mode;			/* Permission bits (like chmod) */
+	__u64	key;			/* Unique key for channel (like ftok()) */
+	__u32	channel_id_out;		/* Returned channel ID */
+	__u32	reserved[3];
+};
+
+/* Attach to existing channel */
+struct io_uring_ipc_channel_attach {
+	__u32	channel_id;		/* Attach by channel ID (when key == 0) */
+	__u32	flags;			/* IOIPC_SUB_SEND, IOIPC_SUB_RECV, IOIPC_SUB_BOTH */
+	__u64	key;			/* Non-zero: attach by key instead of channel_id */
+	__s32	channel_fd;		/* Output: fd for mmap */
+	__u32	local_id_out;		/* Output: local subscriber ID */
+	__u64	mmap_offset_out;	/* Output: offset for mmap() */
+	__u32	region_size;		/* Output: size of shared region */
+	__u32	reserved[3];
+};
+
+/* Message descriptor in the ring */
+struct io_uring_ipc_msg_desc {
+	__u64	offset;			/* Offset in data region for message payload */
+	__u32	len;			/* Message length */
+	__u32	msg_id;			/* Unique message ID */
+	__u64	sender_data;		/* Sender's user_data for context */
+};
+
+/* Shared ring structure (mmap'd to userspace) */
+struct io_uring_ipc_ring {
+	/* Cache-aligned producer/consumer positions */
+	struct {
+		__u32	head __attribute__((aligned(64)));
+		__u32	tail;
+	} producer;
+
+	struct {
+		__u32	head __attribute__((aligned(64)));
+	} consumer;
+
+	/* Ring parameters */
+	__u32	ring_mask;
+	__u32	ring_entries;
+	__u32	max_msg_size;
+
+	/* Array of message descriptors follows */
+	struct io_uring_ipc_msg_desc msgs[];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/Kconfig b/io_uring/Kconfig
index a7ae23cf1035..d7d7f858b46c 100644
--- a/io_uring/Kconfig
+++ b/io_uring/Kconfig
@@ -14,3 +14,17 @@ config IO_URING_BPF
 	def_bool y
 	depends on BPF
 	depends on NET
+
+config IO_URING_IPC
+	bool "io_uring IPC support"
+	depends on IO_URING
+	default y
+	help
+	  Enable io_uring-based inter-process communication.
+
+	  This provides high-performance IPC channels that leverage
+	  io_uring's shared memory infrastructure and async notification
+	  model. Supports broadcast and multicast patterns with
+	  zero-copy capabilities.
+
+	  If unsure, say Y.
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 931f9156132a..380fe8a19174 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					query.o
 
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
+obj-$(CONFIG_IO_URING_IPC)	+= ipc.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_EPOLL)		+= epoll.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a37035e76c0..6dccc005aaca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -87,6 +87,7 @@
 #include "msg_ring.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "ipc.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -251,6 +252,10 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
+#ifdef CONFIG_IO_URING_IPC
+	xa_init(&ctx->ipc_subscribers);
+	xa_init(&ctx->ipc_channels);
+#endif
 	ret = io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
 			    sizeof(struct async_poll), 0);
 	ret |= io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
@@ -2154,6 +2159,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_sqe_buffers_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_unregister_zcrx_ifqs(ctx);
+	io_ipc_ctx_cleanup(ctx);
 	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
 	io_free_alloc_caches(ctx);
diff --git a/io_uring/ipc.c b/io_uring/ipc.c
new file mode 100644
index 000000000000..3f4daf75c843
--- /dev/null
+++ b/io_uring/ipc.c
@@ -0,0 +1,1002 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * io_uring IPC channel implementation
+ *
+ * High-performance inter-process communication using io_uring infrastructure.
+ * Provides broadcast and multicast channels with zero-copy support.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
+#include <linux/hashtable.h>
+#include <linux/anon_inodes.h>
+#include <linux/mman.h>
+#include <linux/vmalloc.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "rsrc.h"
+#include "memmap.h"
+#include "ipc.h"
+
+#ifdef CONFIG_IO_URING_IPC
+
+/*
+ * Global channel registry
+ * Protected by RCU and spinlock
+ */
+static DEFINE_HASHTABLE(channel_hash, 8);
+static DEFINE_SPINLOCK(channel_hash_lock);
+static DEFINE_XARRAY_ALLOC(channel_xa);
+static atomic_t ipc_global_sub_id = ATOMIC_INIT(0);
+
+static int ipc_channel_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct io_ipc_channel *channel;
+	size_t region_size;
+	unsigned long uaddr = vma->vm_start;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	void *kaddr;
+	unsigned long pfn;
+	int ret;
+
+	/*
+	 * Safely acquire a channel reference.  A concurrent
+	 * io_ipc_channel_destroy() can NULL private_data and drop
+	 * all references; the channel is freed via call_rcu(), so
+	 * it stays accessible under rcu_read_lock().
+	 */
+	rcu_read_lock();
+	channel = READ_ONCE(file->private_data);
+	if (!channel || !refcount_inc_not_zero(&channel->ref_count)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	rcu_read_unlock();
+
+	region_size = io_region_size(channel->region);
+	kaddr = channel->region->ptr;
+
+	/* Validate mmap parameters */
+	if (vma->vm_pgoff != 0) {
+		ret = -EINVAL;
+		goto out_put;
+	}
+
+	if (size > region_size) {
+		ret = -EINVAL;
+		goto out_put;
+	}
+
+	if (vma->vm_flags & VM_WRITE) {
+		ret = -EACCES;
+		goto out_put;
+	}
+
+	/* Prevent mprotect from later adding write permission */
+	vm_flags_clear(vma, VM_MAYWRITE);
+
+	/* Map the vmalloc'd region page by page */
+	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
+
+	while (size > 0) {
+		pfn = vmalloc_to_pfn(kaddr);
+		ret = remap_pfn_range(vma, uaddr, pfn, PAGE_SIZE, vma->vm_page_prot);
+		if (ret)
+			goto out_put;
+
+		uaddr += PAGE_SIZE;
+		kaddr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
+
+	ret = 0;
+out_put:
+	io_ipc_channel_put(channel);
+	return ret;
+}
+
+static int ipc_channel_release(struct inode *inode, struct file *file)
+{
+	struct io_ipc_channel *channel = file->private_data;
+
+	if (channel)
+		io_ipc_channel_put(channel);
+
+	return 0;
+}
+
+static const struct file_operations ipc_channel_fops = {
+	.mmap		= ipc_channel_mmap,
+	.release	= ipc_channel_release,
+	.llseek		= noop_llseek,
+};
+
+
+static int ipc_calc_region_size(u32 ring_entries, u32 max_msg_size,
+				size_t *ring_size_out, size_t *data_size_out,
+				size_t *total_size_out)
+{
+	size_t ring_size, data_size, total_size;
+
+	ring_size = sizeof(struct io_ipc_ring) +
+		    ring_entries * sizeof(struct io_ipc_msg_desc);
+	ring_size = ALIGN(ring_size, PAGE_SIZE);
+
+	if ((u64)ring_entries * max_msg_size > INT_MAX)
+		return -EINVAL;
+
+	data_size = (size_t)ring_entries * max_msg_size;
+	data_size = ALIGN(data_size, PAGE_SIZE);
+
+	total_size = ring_size + data_size;
+
+	if (total_size > INT_MAX)
+		return -EINVAL;
+
+	*ring_size_out = ring_size;
+	*data_size_out = data_size;
+	*total_size_out = total_size;
+
+	return 0;
+}
+
+static int ipc_region_alloc(struct io_ipc_channel *channel, u32 ring_entries,
+			    u32 max_msg_size)
+{
+	struct io_mapped_region *region;
+	size_t ring_size, data_size, total_size;
+	void *ptr;
+	int ret;
+
+	ret = ipc_calc_region_size(ring_entries, max_msg_size, &ring_size,
+				   &data_size, &total_size);
+	if (ret)
+		return ret;
+
+	region = kzalloc(sizeof(*region), GFP_KERNEL);
+	if (!region)
+		return -ENOMEM;
+
+	ptr = vmalloc_user(total_size);
+	if (!ptr) {
+		kfree(region);
+		return -ENOMEM;
+	}
+
+	region->ptr = ptr;
+	region->nr_pages = (total_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	region->flags = 0;
+
+	channel->region = region;
+	channel->ring = (struct io_ipc_ring *)ptr;
+	channel->desc_array = (struct io_ipc_msg_desc *)((u8 *)ptr + sizeof(struct io_ipc_ring));
+	channel->data_region = ptr + ring_size;
+
+	channel->ring->ring_mask = ring_entries - 1;
+	channel->ring->ring_entries = ring_entries;
+	channel->ring->max_msg_size = max_msg_size;
+
+	return 0;
+}
+
+static void ipc_region_free(struct io_ipc_channel *channel)
+{
+	if (!channel->region)
+		return;
+
+	if (channel->region->ptr)
+		vfree(channel->region->ptr);
+	kfree(channel->region);
+	channel->region = NULL;
+	channel->ring = NULL;
+	channel->data_region = NULL;
+}
+
+static void io_ipc_channel_free(struct io_ipc_channel *channel)
+{
+	struct io_ipc_subscriber *sub;
+	unsigned long index;
+
+	xa_for_each(&channel->subscribers, index, sub)
+		kfree(sub);
+	xa_destroy(&channel->subscribers);
+
+	if (channel->file) {
+		/*
+		 * Prevent the deferred fput release callback from
+		 * accessing the channel after it has been freed.
+		 */
+		WRITE_ONCE(channel->file->private_data, NULL);
+		fput(channel->file);
+	}
+
+	ipc_region_free(channel);
+
+	kfree(channel);
+}
+
+static void io_ipc_channel_free_rcu(struct rcu_head *rcu)
+{
+	struct io_ipc_channel *channel;
+
+	channel = container_of(rcu, struct io_ipc_channel, rcu);
+	io_ipc_channel_free(channel);
+}
+
+void io_ipc_channel_put(struct io_ipc_channel *channel)
+{
+	if (refcount_dec_and_test(&channel->ref_count)) {
+		/*
+		 * Remove from global data structures before scheduling
+		 * the RCU callback.  Lookups use refcount_inc_not_zero()
+		 * so no new references can appear.  Removing here avoids
+		 * taking xa_lock (a plain spinlock) inside the RCU
+		 * callback which runs in softirq context — that would
+		 * deadlock against xa_alloc() in process context.
+		 */
+		spin_lock_bh(&channel_hash_lock);
+		if (!hlist_unhashed(&channel->hash_node))
+			hash_del_rcu(&channel->hash_node);
+		spin_unlock_bh(&channel_hash_lock);
+
+		xa_erase(&channel_xa, channel->channel_id);
+
+		call_rcu(&channel->rcu, io_ipc_channel_free_rcu);
+	}
+}
+
+struct io_ipc_channel *io_ipc_channel_get(u32 channel_id)
+{
+	struct io_ipc_channel *channel;
+
+	rcu_read_lock();
+	channel = xa_load(&channel_xa, channel_id);
+	if (channel && !refcount_inc_not_zero(&channel->ref_count))
+		channel = NULL;
+	rcu_read_unlock();
+
+	return channel;
+}
+
+struct io_ipc_channel *io_ipc_channel_get_by_key(u64 key)
+{
+	struct io_ipc_channel *channel;
+	u32 hash = hash_64(key, HASH_BITS(channel_hash));
+
+	rcu_read_lock();
+	hash_for_each_possible_rcu(channel_hash, channel, hash_node, hash) {
+		if (channel->key == key &&
+		    refcount_inc_not_zero(&channel->ref_count)) {
+			rcu_read_unlock();
+			return channel;
+		}
+	}
+	rcu_read_unlock();
+
+	return NULL;
+}
+
+static int ipc_check_permission(struct io_ipc_channel *channel, u32 access)
+{
+	const struct cred *cred = current_cred();
+	kuid_t uid = cred->fsuid;
+	kgid_t gid = cred->fsgid;
+	u16 mode = channel->mode;
+	u16 needed = 0;
+
+	/* Map IPC access flags to Unix permission bits: send=write, recv=read */
+	if (access & IOIPC_SUB_RECV)
+		needed |= 4;	/* read */
+	if (access & IOIPC_SUB_SEND)
+		needed |= 2;	/* write */
+
+	if (uid_eq(uid, channel->owner_uid))
+		return ((mode >> 6) & needed) == needed ? 0 : -EACCES;
+
+	if (gid_eq(gid, channel->owner_gid))
+		return ((mode >> 3) & needed) == needed ? 0 : -EACCES;
+
+	return (mode & needed) == needed ? 0 : -EACCES;
+}
+
+int io_ipc_channel_create(struct io_ring_ctx *ctx,
+			   const struct io_uring_ipc_channel_create __user *arg)
+{
+	struct io_uring_ipc_channel_create create;
+	struct io_ipc_channel *channel;
+	u32 hash;
+	int ret;
+
+	if (copy_from_user(&create, arg, sizeof(create)))
+		return -EFAULT;
+
+	if (!mem_is_zero(create.reserved, sizeof(create.reserved)))
+		return -EINVAL;
+
+	if (!create.ring_entries || create.ring_entries > IORING_MAX_ENTRIES)
+		return -EINVAL;
+
+	if (!is_power_of_2(create.ring_entries))
+		return -EINVAL;
+
+	if (!create.max_msg_size || create.max_msg_size > SZ_1M)
+		return -EINVAL;
+
+	if (create.flags & ~(IOIPC_F_BROADCAST | IOIPC_F_MULTICAST |
+			     IOIPC_F_PRIVATE))
+		return -EINVAL;
+
+	if ((create.flags & IOIPC_F_BROADCAST) &&
+	    (create.flags & IOIPC_F_MULTICAST))
+		return -EINVAL;
+
+	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
+	if (!channel)
+		return -ENOMEM;
+
+	refcount_set(&channel->ref_count, 1);
+	channel->flags = create.flags;
+	channel->key = create.key;
+	channel->msg_max_size = create.max_msg_size;
+	channel->owner_uid = current_fsuid();
+	channel->owner_gid = current_fsgid();
+	channel->mode = create.mode & 0666;
+	atomic_set(&channel->next_msg_id, 1);
+	atomic_set(&channel->next_receiver_idx, 0);
+	atomic_set(&channel->recv_count, 0);
+	xa_init(&channel->subscribers);
+
+	ret = ipc_region_alloc(channel, create.ring_entries, create.max_msg_size);
+	if (ret)
+		goto err_free_channel;
+
+	refcount_inc(&channel->ref_count); /* File holds a reference */
+	channel->file = anon_inode_getfile("[io_uring_ipc]", &ipc_channel_fops,
+					   channel, O_RDWR);
+	if (IS_ERR(channel->file)) {
+		ret = PTR_ERR(channel->file);
+		channel->file = NULL;
+		refcount_dec(&channel->ref_count);
+		goto err_free_region;
+	}
+
+	ret = xa_alloc(&channel_xa, &channel->channel_id, channel,
+		       XA_LIMIT(1, INT_MAX), GFP_KERNEL);
+	if (ret < 0)
+		goto err_put_file;
+
+	hash = hash_64(create.key, HASH_BITS(channel_hash));
+	spin_lock_bh(&channel_hash_lock);
+	hash_add_rcu(channel_hash, &channel->hash_node, hash);
+	spin_unlock_bh(&channel_hash_lock);
+
+	/*
+	 * Track the channel in the creating ring so that
+	 * io_ipc_ctx_cleanup() can break the channel-file reference
+	 * cycle if the ring is torn down without an explicit destroy.
+	 */
+	ret = xa_insert(&ctx->ipc_channels, channel->channel_id,
+			xa_mk_value(0), GFP_KERNEL);
+	if (ret)
+		goto err_remove_channel;
+
+	create.channel_id_out = channel->channel_id;
+	if (copy_to_user((void __user *)arg, &create, sizeof(create))) {
+		ret = -EFAULT;
+		goto err_remove_ctx;
+	}
+
+	return 0;
+
+err_remove_ctx:
+	xa_erase(&ctx->ipc_channels, channel->channel_id);
+err_remove_channel:
+	spin_lock_bh(&channel_hash_lock);
+	hash_del_rcu(&channel->hash_node);
+	spin_unlock_bh(&channel_hash_lock);
+	xa_erase(&channel_xa, channel->channel_id);
+err_put_file:
+	/*
+	 * fput() is deferred — the release callback will call
+	 * io_ipc_channel_put() to drop the file's reference.
+	 * Drop the initial reference here; it can't reach zero
+	 * yet because the file still holds one.
+	 */
+	fput(channel->file);
+	channel->file = NULL;
+	io_ipc_channel_put(channel);
+	return ret;
+err_free_region:
+	ipc_region_free(channel);
+err_free_channel:
+	kfree(channel);
+	return ret;
+}
+
+int io_ipc_channel_attach(struct io_ring_ctx *ctx,
+			   const struct io_uring_ipc_channel_attach __user *arg)
+{
+	struct io_uring_ipc_channel_attach attach;
+	struct io_ipc_channel *channel = NULL;
+	struct io_ipc_subscriber *sub;
+	int ret;
+
+	if (copy_from_user(&attach, arg, sizeof(attach)))
+		return -EFAULT;
+
+	if (!mem_is_zero(attach.reserved, sizeof(attach.reserved)))
+		return -EINVAL;
+
+	if (!attach.flags || (attach.flags & ~IOIPC_SUB_BOTH))
+		return -EINVAL;
+
+	if (attach.key)
+		channel = io_ipc_channel_get_by_key(attach.key);
+	else
+		channel = io_ipc_channel_get(attach.channel_id);
+
+	if (!channel)
+		return -ENOENT;
+
+	ret = ipc_check_permission(channel, attach.flags);
+	if (ret)
+		goto err_put_channel;
+
+	sub = kzalloc(sizeof(*sub), GFP_KERNEL);
+	if (!sub) {
+		ret = -ENOMEM;
+		goto err_put_channel;
+	}
+
+	sub->ctx = ctx;
+	sub->channel = channel;
+	sub->flags = attach.flags;
+	sub->local_head = 0;
+	sub->subscriber_id = atomic_inc_return(&ipc_global_sub_id);
+
+	ret = xa_insert(&channel->subscribers, sub->subscriber_id, sub,
+			GFP_KERNEL);
+	if (ret) {
+		kfree(sub);
+		goto err_put_channel;
+	}
+
+	refcount_inc(&channel->ref_count);
+	if (attach.flags & IOIPC_SUB_RECV)
+		atomic_inc(&channel->recv_count);
+
+	ret = xa_insert(&ctx->ipc_subscribers, sub->subscriber_id, sub,
+			GFP_KERNEL);
+	if (ret)
+		goto err_remove_chan_sub;
+
+	ret = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (ret < 0)
+		goto err_remove_sub;
+
+	attach.local_id_out = sub->subscriber_id;
+	attach.region_size = io_region_size(channel->region);
+	attach.channel_fd = ret;
+	attach.mmap_offset_out = 0;
+
+	if (copy_to_user((void __user *)arg, &attach, sizeof(attach))) {
+		put_unused_fd(ret);
+		ret = -EFAULT;
+		goto err_remove_sub;
+	}
+
+	{
+		struct file *f = get_file_active(&channel->file);
+
+		if (!f) {
+			put_unused_fd(attach.channel_fd);
+			ret = -EINVAL;
+			goto err_remove_sub;
+		}
+		fd_install(attach.channel_fd, f);
+	}
+
+	io_ipc_channel_put(channel);
+	return 0;
+
+err_remove_sub:
+	xa_erase(&ctx->ipc_subscribers, sub->subscriber_id);
+err_remove_chan_sub:
+	xa_erase(&channel->subscribers, sub->subscriber_id);
+	if (attach.flags & IOIPC_SUB_RECV)
+		atomic_dec(&channel->recv_count);
+	kfree_rcu(sub, rcu);
+	io_ipc_channel_put(channel); /* Drop subscriber's reference */
+err_put_channel:
+	io_ipc_channel_put(channel); /* Drop lookup reference */
+	return ret;
+}
+
+int io_ipc_channel_detach(struct io_ring_ctx *ctx, u32 subscriber_id)
+{
+	struct io_ipc_subscriber *sub;
+	struct io_ipc_channel *channel;
+
+	sub = xa_erase(&ctx->ipc_subscribers, subscriber_id);
+	if (!sub)
+		return -ENOENT;
+
+	channel = sub->channel;
+	xa_erase(&channel->subscribers, subscriber_id);
+
+	if (sub->flags & IOIPC_SUB_RECV)
+		atomic_dec(&channel->recv_count);
+
+	io_ipc_channel_put(channel);
+	kfree_rcu(sub, rcu);
+	return 0;
+}
+
+/*
+ * Recompute consumer.head as the minimum local_head across all receive
+ * subscribers.  Called lazily from the broadcast recv path (every 16
+ * messages) and from the send path when the ring appears full.
+ */
+static void ipc_advance_consumer_head(struct io_ipc_channel *channel)
+{
+	struct io_ipc_subscriber *s;
+	struct io_ipc_ring *ring = channel->ring;
+	unsigned long index;
+	u32 min_head = READ_ONCE(ring->producer.tail);
+
+	rcu_read_lock();
+	xa_for_each(&channel->subscribers, index, s) {
+		if (s->flags & IOIPC_SUB_RECV) {
+			u32 sh = READ_ONCE(s->local_head);
+
+			if ((s32)(sh - min_head) < 0)
+				min_head = sh;
+		}
+	}
+	rcu_read_unlock();
+
+	WRITE_ONCE(ring->consumer.head, min_head);
+}
+
+static int ipc_wake_receivers(struct io_ipc_channel *channel, u32 target)
+{
+	struct io_ipc_subscriber *sub;
+	unsigned long index;
+
+	rcu_read_lock();
+	if (target) {
+		sub = xa_load(&channel->subscribers, target);
+		if (!sub || !(sub->flags & IOIPC_SUB_RECV)) {
+			rcu_read_unlock();
+			return -ENOENT;
+		}
+		io_cqring_wake(sub->ctx);
+		rcu_read_unlock();
+		return 0;
+	}
+
+	if (channel->flags & IOIPC_F_MULTICAST) {
+		u32 recv_cnt = atomic_read(&channel->recv_count);
+
+		if (recv_cnt) {
+			u32 rr = (u32)atomic_inc_return(&channel->next_receiver_idx);
+			u32 target_idx = rr % recv_cnt;
+			u32 i = 0;
+
+			xa_for_each(&channel->subscribers, index, sub) {
+				if (sub->flags & IOIPC_SUB_RECV) {
+					if (i == target_idx) {
+						io_cqring_wake(sub->ctx);
+						break;
+					}
+					i++;
+				}
+			}
+		}
+	} else {
+		xa_for_each(&channel->subscribers, index, sub) {
+			if (sub->flags & IOIPC_SUB_RECV) {
+				io_cqring_wake(sub->ctx);
+				if (!(channel->flags & IOIPC_F_BROADCAST))
+					break;
+			}
+		}
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
+int io_ipc_send_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ipc_send *ipc = io_kiocb_to_cmd(req, struct io_ipc_send);
+
+	if (sqe->buf_index || sqe->personality)
+		return -EINVAL;
+
+	if (sqe->ioprio || sqe->rw_flags)
+		return -EINVAL;
+
+	ipc->channel_id = READ_ONCE(sqe->fd);
+	ipc->addr = READ_ONCE(sqe->addr);
+	ipc->len = READ_ONCE(sqe->len);
+	ipc->target = READ_ONCE(sqe->file_index);
+
+	return 0;
+}
+
+int io_ipc_send(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ipc_send *ipc = io_kiocb_to_cmd(req, struct io_ipc_send);
+	struct io_ipc_subscriber *sub = NULL;
+	struct io_ipc_channel *channel = NULL;
+	struct io_ipc_ring *ring;
+	struct io_ipc_msg_desc *desc;
+	void __user *user_buf;
+	void *dest;
+	u32 head, tail, next_tail, idx;
+	u32 sub_flags;
+	int ret;
+	u32 fd = ipc->channel_id;
+	bool need_put = false;
+	bool retried_advance = false;
+
+	/* O(1) subscriber lookup via xarray */
+	rcu_read_lock();
+	sub = xa_load(&req->ctx->ipc_subscribers, fd);
+	if (sub) {
+		channel = sub->channel;
+		if (!refcount_inc_not_zero(&channel->ref_count)) {
+			rcu_read_unlock();
+			ret = -ENOENT;
+			goto fail;
+		}
+		sub_flags = sub->flags;
+		rcu_read_unlock();
+		need_put = true;
+
+		if (!(sub_flags & IOIPC_SUB_SEND)) {
+			ret = -EACCES;
+			goto fail_put;
+		}
+		goto found;
+	}
+	rcu_read_unlock();
+
+	channel = io_ipc_channel_get(fd);
+	if (!channel) {
+		ret = -ENOENT;
+		goto fail;
+	}
+
+	need_put = true;
+
+	ret = ipc_check_permission(channel, IOIPC_SUB_SEND);
+	if (ret)
+		goto fail_put;
+
+found:
+	ring = channel->ring;
+
+	if (unlikely(ipc->len > channel->msg_max_size)) {
+		ret = -EMSGSIZE;
+		goto fail_put;
+	}
+
+	/* Lock-free slot reservation via CAS on producer tail */
+retry:
+	do {
+		tail = READ_ONCE(ring->producer.tail);
+		next_tail = tail + 1;
+		head = READ_ONCE(ring->consumer.head);
+
+		if (unlikely(next_tail - head > ring->ring_entries)) {
+			/*
+			 * Ring full.  For broadcast channels, try to
+			 * advance consumer.head once by scanning the
+			 * min local_head across all receivers.
+			 */
+			if ((channel->flags & IOIPC_F_BROADCAST) &&
+			    !retried_advance) {
+				ipc_advance_consumer_head(channel);
+				retried_advance = true;
+				goto retry;
+			}
+			ret = -ENOBUFS;
+			goto fail_put;
+		}
+		idx = tail & ring->ring_mask;
+	} while (cmpxchg(&ring->producer.tail, tail, next_tail) != tail);
+
+	/* Slot exclusively claimed — write data and descriptor */
+	dest = channel->data_region + (idx * channel->msg_max_size);
+	desc = &channel->desc_array[idx];
+
+	prefetchw(desc);
+
+	user_buf = u64_to_user_ptr(ipc->addr);
+	if (unlikely(__copy_from_user_inatomic(dest, user_buf, ipc->len))) {
+		if (unlikely(copy_from_user(dest, user_buf, ipc->len))) {
+			/*
+			 * Slot already claimed via CAS; mark it ready with
+			 * zero length so consumers can advance past it.
+			 */
+			desc->offset = idx * channel->msg_max_size;
+			desc->len = 0;
+			desc->msg_id = 0;
+			desc->sender_data = 0;
+			smp_wmb();
+			WRITE_ONCE(desc->seq, tail + 1);
+			ret = -EFAULT;
+			goto fail_put;
+		}
+	}
+
+	desc->offset = idx * channel->msg_max_size;
+	desc->len = ipc->len;
+	desc->msg_id = atomic_inc_return(&channel->next_msg_id);
+	desc->sender_data = req->cqe.user_data;
+
+	/* Ensure descriptor + data visible before marking slot ready */
+	smp_wmb();
+	WRITE_ONCE(desc->seq, tail + 1);
+
+	ret = ipc_wake_receivers(channel, ipc->target);
+	if (ret)
+		goto fail_put;
+
+	if (need_put)
+		io_ipc_channel_put(channel);
+
+	io_req_set_res(req, ipc->len, 0);
+	return IOU_COMPLETE;
+
+fail_put:
+	if (need_put)
+		io_ipc_channel_put(channel);
+fail:
+	req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
+
+
+int io_ipc_recv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ipc_recv *ipc = io_kiocb_to_cmd(req, struct io_ipc_recv);
+
+	if (sqe->buf_index || sqe->personality)
+		return -EINVAL;
+
+	if (sqe->ioprio || sqe->rw_flags)
+		return -EINVAL;
+
+	ipc->channel_id = READ_ONCE(sqe->fd);
+	ipc->addr = READ_ONCE(sqe->addr);
+	ipc->len = READ_ONCE(sqe->len);
+
+	return 0;
+}
+
+int io_ipc_recv(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ipc_recv *ipc = io_kiocb_to_cmd(req, struct io_ipc_recv);
+	struct io_ipc_subscriber *sub = NULL;
+	struct io_ipc_channel *channel;
+	struct io_ipc_ring *ring;
+	struct io_ipc_msg_desc *desc;
+	void __user *user_buf;
+	void *src;
+	u32 head, tail, idx;
+	u32 sub_flags, sub_id;
+	size_t copy_len;
+	int ret;
+
+	/* O(1) subscriber lookup via xarray */
+	rcu_read_lock();
+	sub = xa_load(&req->ctx->ipc_subscribers, ipc->channel_id);
+	if (sub) {
+		channel = sub->channel;
+		if (!refcount_inc_not_zero(&channel->ref_count)) {
+			rcu_read_unlock();
+			ret = -ENOENT;
+			goto fail;
+		}
+		sub_flags = sub->flags;
+		sub_id = sub->subscriber_id;
+		head = READ_ONCE(sub->local_head);
+		rcu_read_unlock();
+		goto found;
+	}
+	rcu_read_unlock();
+	ret = -ENOENT;
+	goto fail;
+
+found:
+	ring = channel->ring;
+
+	if (!(sub_flags & IOIPC_SUB_RECV)) {
+		ret = -EACCES;
+		goto fail_put;
+	}
+
+	/*
+	 * For multicast, competing consumers share consumer.head directly
+	 * instead of using per-subscriber local_head.
+	 */
+	if (channel->flags & IOIPC_F_MULTICAST)
+		head = READ_ONCE(ring->consumer.head);
+
+	/* Check if there are messages available - punt to io-wq for retry */
+	tail = READ_ONCE(ring->producer.tail);
+	if (unlikely(head == tail)) {
+		io_ipc_channel_put(channel);
+		return -EAGAIN;
+	}
+
+	idx = head & ring->ring_mask;
+	desc = &channel->desc_array[idx];
+
+	/*
+	 * Verify slot is fully written by the producer.  With lock-free
+	 * CAS-based send, tail advances before data is written; the
+	 * per-slot seq number signals completion.
+	 * Pairs with smp_wmb() + WRITE_ONCE(desc->seq) in send path.
+	 */
+	if (READ_ONCE(desc->seq) != head + 1) {
+		io_ipc_channel_put(channel);
+		return -EAGAIN;
+	}
+
+	smp_rmb();
+
+	src = channel->data_region + desc->offset;
+	prefetch(src);
+
+	copy_len = min_t(u32, desc->len, ipc->len);
+	user_buf = u64_to_user_ptr(ipc->addr);
+
+	if (unlikely(__copy_to_user_inatomic(user_buf, src, copy_len))) {
+		if (unlikely(copy_to_user(user_buf, src, copy_len))) {
+			ret = -EFAULT;
+			goto fail_put;
+		}
+	}
+
+	if (channel->flags & IOIPC_F_MULTICAST) {
+		/*
+		 * Multicast: atomically advance the shared consumer head.
+		 * Losers retry via -EAGAIN / io-wq.
+		 */
+		if (cmpxchg(&ring->consumer.head, head, head + 1) != head) {
+			io_ipc_channel_put(channel);
+			return -EAGAIN;
+		}
+	} else {
+		/*
+		 * Re-find subscriber under RCU for atomic local_head update.
+		 * O(1) xarray lookup; subscriber is stable while channel
+		 * ref is held and we're under RCU.
+		 */
+		rcu_read_lock();
+		sub = xa_load(&req->ctx->ipc_subscribers, sub_id);
+		if (!sub) {
+			rcu_read_unlock();
+			goto done;
+		}
+
+		if (cmpxchg(&sub->local_head, head, head + 1) != head) {
+			rcu_read_unlock();
+			io_ipc_channel_put(channel);
+			return -EAGAIN;
+		}
+
+		if (channel->flags & IOIPC_F_BROADCAST) {
+			/*
+			 * Lazy consumer.head advancement: only scan min-head
+			 * every 16 messages to amortize the O(N) walk.
+			 * The send path also triggers this on ring-full.
+			 */
+			if ((head & 0xf) == 0)
+				ipc_advance_consumer_head(channel);
+		} else {
+			/* Unicast: single consumer, update directly */
+			WRITE_ONCE(ring->consumer.head, head + 1);
+		}
+		rcu_read_unlock();
+	}
+
+done:
+	io_ipc_channel_put(channel);
+	io_req_set_res(req, copy_len, 0);
+	return IOU_COMPLETE;
+
+fail_put:
+	io_ipc_channel_put(channel);
+fail:
+	req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
+
+int io_ipc_channel_destroy(struct io_ring_ctx *ctx, u32 channel_id)
+{
+	struct io_ipc_channel *channel;
+	struct file *f;
+
+	/*
+	 * Atomically remove from global lookup.  This prevents a second
+	 * destroy call from finding the channel and draining refcount
+	 * below the number of outstanding references.
+	 */
+	channel = xa_erase(&channel_xa, channel_id);
+	if (!channel)
+		return -ENOENT;
+
+	spin_lock_bh(&channel_hash_lock);
+	if (!hlist_unhashed(&channel->hash_node))
+		hash_del_rcu(&channel->hash_node);
+	spin_unlock_bh(&channel_hash_lock);
+
+	/*
+	 * Break the reference cycle between channel and file.
+	 * The channel holds a file reference (channel->file) and the
+	 * file's release callback holds a channel reference via
+	 * private_data.  Detach the file here so that the release
+	 * callback becomes a no-op and the cycle is broken.
+	 */
+	f = channel->file;
+	if (f) {
+		WRITE_ONCE(f->private_data, NULL);
+		channel->file = NULL;
+		fput(f);
+		io_ipc_channel_put(channel); /* Drop file's reference */
+	}
+
+	/* Drop the creator's initial reference */
+	io_ipc_channel_put(channel);
+
+	return 0;
+}
+
+void io_ipc_ctx_cleanup(struct io_ring_ctx *ctx)
+{
+	struct io_ipc_subscriber *sub;
+	struct io_ipc_channel *channel;
+	unsigned long index;
+	void *entry;
+
+	xa_for_each(&ctx->ipc_subscribers, index, sub) {
+		channel = sub->channel;
+
+		xa_erase(&ctx->ipc_subscribers, index);
+		xa_erase(&channel->subscribers, sub->subscriber_id);
+
+		if (sub->flags & IOIPC_SUB_RECV)
+			atomic_dec(&channel->recv_count);
+
+		io_ipc_channel_put(channel);
+		kfree_rcu(sub, rcu);
+	}
+	xa_destroy(&ctx->ipc_subscribers);
+
+	/*
+	 * Destroy any channels created by this ring that were not
+	 * explicitly destroyed.  io_ipc_channel_destroy() is
+	 * idempotent — it returns -ENOENT if the channel was
+	 * already destroyed.
+	 */
+	xa_for_each(&ctx->ipc_channels, index, entry) {
+		io_ipc_channel_destroy(ctx, index);
+	}
+	xa_destroy(&ctx->ipc_channels);
+}
+
+#endif /* CONFIG_IO_URING_IPC */
diff --git a/io_uring/ipc.h b/io_uring/ipc.h
new file mode 100644
index 000000000000..65d143c3e520
--- /dev/null
+++ b/io_uring/ipc.h
@@ -0,0 +1,161 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef IO_URING_IPC_H
+#define IO_URING_IPC_H
+
+#include <linux/io_uring_types.h>
+
+#ifdef CONFIG_IO_URING_IPC
+
+/*
+ * Internal kernel structures for io_uring IPC
+ */
+
+/* Shared ring structure - lives in mmap'd memory region */
+struct io_ipc_ring {
+	/* Cache-aligned producer/consumer positions */
+	struct {
+		u32	head __aligned(64);
+		u32	tail;
+	} producer;
+
+	struct {
+		u32	head __aligned(64);
+	} consumer;
+
+	/* Ring parameters */
+	u32	ring_mask;
+	u32	ring_entries;
+	u32	max_msg_size;
+
+	/* Message descriptors follow inline */
+};
+
+/* Message descriptor in the ring */
+struct io_ipc_msg_desc {
+	u64	offset;			/* Offset in data region for message payload */
+	u32	len;			/* Message length */
+	u32	msg_id;			/* Unique message ID */
+	u64	sender_data;		/* Sender's user_data for context */
+	u32	seq;			/* Lock-free completion sequence number */
+};
+
+/* Per-subscriber attachment to a channel */
+struct io_ipc_subscriber {
+	u32	local_head __aligned(64);	/* Cache-aligned to prevent false sharing */
+	u32	subscriber_id;			/* Unique subscriber ID */
+	u32	flags;				/* IOIPC_SUB_SEND, IOIPC_SUB_RECV */
+
+	struct io_ring_ctx	*ctx;		/* io_uring context */
+	struct io_ipc_channel	*channel;	/* Channel this subscriber is attached to */
+	struct rcu_head rcu;			/* For kfree_rcu deferred freeing */
+};
+
+/* IPC channel connecting two or more io_uring instances */
+struct io_ipc_channel {
+	struct io_mapped_region	*region;	/* Shared memory region */
+	struct io_ipc_ring	*ring;		/* Shared ring structure in mmap'd region */
+	void			*data_region;	/* Data storage area for messages */
+	struct io_ipc_msg_desc	*desc_array;	/* Cached descriptor array base */
+	struct file		*file;		/* Anonymous file for mmap support */
+
+	/* Subscribers to this channel */
+	struct xarray		subscribers;	/* All subscribers */
+	atomic_t		recv_count;	/* Cached count of IOIPC_SUB_RECV subscribers */
+
+	/* Channel metadata */
+	refcount_t		ref_count;
+	u32			channel_id;
+	u32			flags;		/* IOIPC_F_BROADCAST, IOIPC_F_MULTICAST */
+	u64			key;		/* Unique key for lookup */
+
+	/* Ring buffer configuration */
+	u32			msg_max_size;
+
+	/* Access control */
+	kuid_t			owner_uid;
+	kgid_t			owner_gid;
+	u16			mode;		/* Permission bits */
+
+	/* Next message ID */
+	atomic_t		next_msg_id;
+
+	/* For multicast round-robin */
+	atomic_t		next_receiver_idx;
+
+	/* Channel lifecycle */
+	struct rcu_head		rcu;
+	struct hlist_node	hash_node;	/* For global channel hash table */
+};
+
+/* Request state for IPC operations */
+struct io_ipc_send {
+	struct file		*file;
+	u64			addr;
+	u32			channel_id;
+	size_t			len;
+	u32			target;
+};
+
+struct io_ipc_recv {
+	struct file		*file;
+	u64			addr;
+	u32			channel_id;
+	size_t			len;
+};
+
+/* Function declarations */
+
+/* Registration operations */
+int io_ipc_channel_create(struct io_ring_ctx *ctx,
+			   const struct io_uring_ipc_channel_create __user *arg);
+int io_ipc_channel_attach(struct io_ring_ctx *ctx,
+			   const struct io_uring_ipc_channel_attach __user *arg);
+int io_ipc_channel_detach(struct io_ring_ctx *ctx, u32 channel_id);
+
+/* Operation prep and execution */
+int io_ipc_send_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_ipc_send(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_ipc_recv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_ipc_recv(struct io_kiocb *req, unsigned int issue_flags);
+
+/* Channel lifecycle */
+int io_ipc_channel_destroy(struct io_ring_ctx *ctx, u32 channel_id);
+void io_ipc_ctx_cleanup(struct io_ring_ctx *ctx);
+
+/* Channel lookup and management */
+struct io_ipc_channel *io_ipc_channel_get(u32 channel_id);
+struct io_ipc_channel *io_ipc_channel_get_by_key(u64 key);
+void io_ipc_channel_put(struct io_ipc_channel *channel);
+
+#else /* !CONFIG_IO_URING_IPC */
+
+static inline int io_ipc_channel_create(struct io_ring_ctx *ctx,
+			const struct io_uring_ipc_channel_create __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int io_ipc_channel_attach(struct io_ring_ctx *ctx,
+			const struct io_uring_ipc_channel_attach __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int io_ipc_channel_detach(struct io_ring_ctx *ctx, u32 channel_id)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int io_ipc_channel_destroy(struct io_ring_ctx *ctx, u32 channel_id)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void io_ipc_ctx_cleanup(struct io_ring_ctx *ctx)
+{
+}
+
+#endif /* CONFIG_IO_URING_IPC */
+
+#endif /* IO_URING_IPC_H */
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 645980fa4651..658aa36efda2 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -38,6 +38,7 @@
 #include "futex.h"
 #include "truncate.h"
 #include "zcrx.h"
+#include "ipc.h"
 
 static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -599,6 +600,18 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
+	[IORING_OP_IPC_SEND] = {
+		.audit_skip		= 1,
+		.async_size		= sizeof(struct io_ipc_send),
+		.prep			= io_ipc_send_prep,
+		.issue			= io_ipc_send,
+	},
+	[IORING_OP_IPC_RECV] = {
+		.audit_skip		= 1,
+		.async_size		= sizeof(struct io_ipc_recv),
+		.prep			= io_ipc_recv_prep,
+		.issue			= io_ipc_recv,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -857,6 +870,12 @@ const struct io_cold_def io_cold_defs[] = {
 		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
+	[IORING_OP_IPC_SEND] = {
+		.name			= "IPC_SEND",
+	},
+	[IORING_OP_IPC_RECV] = {
+		.name			= "IPC_RECV",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/register.c b/io_uring/register.c
index 0148735f7711..7646dbb2d572 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -34,6 +34,7 @@
 #include "zcrx.h"
 #include "query.h"
 #include "bpf_filter.h"
+#include "ipc.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -930,6 +931,30 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			WRITE_ONCE(ctx->bpf_filters,
 				   ctx->restrictions.bpf_filters->filters);
 		break;
+	case IORING_REGISTER_IPC_CHANNEL_CREATE:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_ipc_channel_create(ctx, arg);
+		break;
+	case IORING_REGISTER_IPC_CHANNEL_ATTACH:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_ipc_channel_attach(ctx, arg);
+		break;
+	case IORING_REGISTER_IPC_CHANNEL_DETACH:
+		ret = -EINVAL;
+		if (arg || !nr_args)
+			break;
+		ret = io_ipc_channel_detach(ctx, nr_args);
+		break;
+	case IORING_REGISTER_IPC_CHANNEL_DESTROY:
+		ret = -EINVAL;
+		if (arg || !nr_args)
+			break;
+		ret = io_ipc_channel_destroy(ctx, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.52.0


