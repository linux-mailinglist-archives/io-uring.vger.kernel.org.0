Return-Path: <io-uring+bounces-3451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 584D7993A01
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8C6EB226D4
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBAD019306A;
	Mon,  7 Oct 2024 22:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="HuA2RRM9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200E81925BC
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339400; cv=none; b=uxjbnwP0cNnTCNw7lSzkINoJD6RMFSt4vx7DJLEXnRnFTIlMdPokeXHgDlgZ3GOqmbGh3Feoo1/IG02WYxPatsJQdkHlh+VT89+1o31hHat76IOtTzebW1SR7Rj9S3+UT0xRoTE305e4pyB+r918nAntnMrdR+Hit/6vfYOSATo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339400; c=relaxed/simple;
	bh=l0oLc5E/lEQH9b3nvawvtmwXlGXpKj5cniZ95/KQh2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sm5euO59nUEgZgRa+C/7Dt5ywbctQlGMUmNHQPiq+6m+kSqAQ/HO9UTvMnBPunKAv4qO77YjUREFXy3xv61+BD4E5aysIwydLVR8C5qRVmH6wU5G6Z8GYbfSnVM+cPA+Ag/pLOBh4sWGdfHtRme/6rcSTeYRexlsGaGM7fu7jXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=HuA2RRM9; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20b7259be6fso54296735ad.0
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339398; x=1728944198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aGVWFZtH3nHvxILpOEkPzZeQKwzNT6cGzSV/XKDlHs=;
        b=HuA2RRM9hi2P3JXHZER/Ba14FrZwzemnSWyuwBvjFq+fdgMHcuPrvifHXGc984yVTC
         5sGdlAUcQ2RJ9FqzePWzedXVGmq04YyxproVnSjo285rZx2wdpNufpdS9XkxlhZUdAh6
         gbSWnz28XvIdzb4ITQpOB/YznzsTOv1F1ymspbG62vt/+7IYYVhyyaXV4GqFCy8nhAqz
         y7G49MqBW/8LfmwezlTgG//0p1yelKMaI2eIuVLVGZVxVYv6weFREtFdwRlrBxwAzgFa
         sWiLAk8ECGi4ENP6gLT0hhzshYpqolZaOwdb4tKEVIZjkoJGEiHV8quzkEFU6FvboZV8
         KouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339398; x=1728944198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aGVWFZtH3nHvxILpOEkPzZeQKwzNT6cGzSV/XKDlHs=;
        b=HuyoTCzIY4n4XKKtKQ26+ZuPf1m/rbzxNrU4djq5vh4d5bhEbQzVCPCt7F/JwZosTx
         LA/Ii/zD5xzDXB2OFhyhYADj8VZ+9jYDxT1y/lY0cUU7rT0F18G97pn3m6l7279aDmCv
         r+SaPgQjehLWdyUTfLlXhreuM86l+gBWhlzDqKMtmprlv98wexoVL75EB/BRYhgxDRAV
         Y13IPh41Hu1U1GiEpFzNXe0EyTQmIm/D4UPTDkHboASfEvZqf2bMKjhvUbPUGKYBzbwJ
         3TH9pkLly3F9zGgojdp9QfEA8ddu3ppNBtS47AWHpwbM0mSAEtxJjI5BExCIfTifxio1
         r3PQ==
X-Gm-Message-State: AOJu0YwuB6FNyodQrju/vjigQgoiJacU/N0mHgk5enh4C9H6qyK8bz2Z
	lEhlsnxAo716AHyH85oIGXNGbmou0yrdk9WB2bO/QfkCDsh5KzNfLZiNeFH8iT2zK6ADIZfuiF8
	+
X-Google-Smtp-Source: AGHT+IGmivCZIXUNtcCa1XuWCwElfZavkxmodB33xiReOy9o7hDvGzETtwtWPSKrtBGAiIn2/8XhvQ==
X-Received: by 2002:a17:902:e84d:b0:20b:b26e:c149 with SMTP id d9443c01a7336-20bfe01d3c9mr199425915ad.29.1728339398451;
        Mon, 07 Oct 2024 15:16:38 -0700 (PDT)
Received: from localhost (fwdproxy-prn-060.fbsv.net. [2a03:2880:ff:3c::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139391e5sm44394065ad.133.2024.10.07.15.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:38 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 09/15] io_uring/zcrx: add interface queue and refill queue
Date: Mon,  7 Oct 2024 15:15:57 -0700
Message-ID: <20241007221603.1703699-10-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

Add a new object called an interface queue (ifq) that represents a net rx queue
that has been configured for zero copy. Each ifq is registered using a new
registration opcode IORING_REGISTER_ZCRX_IFQ.

The refill queue is allocated by the kernel and mapped by userspace using a new
offset IORING_OFF_RQ_RING, in a similar fashion to the main SQ/CQ. It is used
by userspace to return buffers that it is done with, which will then be re-used
by the netdev again.

The main CQ ring is used to notify userspace of received data by using the
upper 16 bytes of a big CQE as a new struct io_uring_zcrx_cqe. Each entry
contains the offset + len to the data.

For now, each io_uring instance only has a single ifq.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring_types.h |   3 +
 include/uapi/linux/io_uring.h  |  43 ++++++++++
 io_uring/Makefile              |   1 +
 io_uring/io_uring.c            |   7 ++
 io_uring/memmap.c              |   8 ++
 io_uring/register.c            |   7 ++
 io_uring/zcrx.c                | 147 +++++++++++++++++++++++++++++++++
 io_uring/zcrx.h                |  39 +++++++++
 8 files changed, 255 insertions(+)
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3315005df117..ace7ac056d51 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -39,6 +39,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+struct io_zcrx_ifq;
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -372,6 +374,7 @@ struct io_ring_ctx {
 	struct io_alloc_cache		rsrc_node_cache;
 	struct wait_queue_head		rsrc_quiesce_wq;
 	unsigned			rsrc_quiesce;
+	struct io_zcrx_ifq		*ifq;
 
 	u32			pers_next;
 	struct xarray		personalities;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index adc2524fd8e3..567cdb89711e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -457,6 +457,8 @@ struct io_uring_cqe {
 #define IORING_OFF_PBUF_RING		0x80000000ULL
 #define IORING_OFF_PBUF_SHIFT		16
 #define IORING_OFF_MMAP_MASK		0xf8000000ULL
+#define IORING_OFF_RQ_RING		0x20000000ULL
+#define IORING_OFF_RQ_SHIFT		16
 
 /*
  * Filled with the offset for mmap(2)
@@ -595,6 +597,9 @@ enum io_uring_register_op {
 	IORING_REGISTER_NAPI			= 27,
 	IORING_UNREGISTER_NAPI			= 28,
 
+	/* register a netdev hw rx queue for zerocopy */
+	IORING_REGISTER_ZCRX_IFQ		= 29,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -802,6 +807,44 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SETSOCKOPT,
 };
 
+/* Zero copy receive refill queue entry */
+struct io_uring_zcrx_rqe {
+	__u64	off;
+	__u32	len;
+	__u32	__pad;
+};
+
+struct io_uring_zcrx_cqe {
+	__u64	off;
+	__u64	__pad;
+};
+
+/* The bit from which area id is encoded into offsets */
+#define IORING_ZCRX_AREA_SHIFT	48
+#define IORING_ZCRX_AREA_MASK	(~(((__u64)1 << IORING_ZCRX_AREA_SHIFT) - 1))
+
+struct io_uring_zcrx_offsets {
+	__u32	head;
+	__u32	tail;
+	__u32	rqes;
+	__u32	mmap_sz;
+	__u64	__resv[2];
+};
+
+/*
+ * Argument for IORING_REGISTER_ZCRX_IFQ
+ */
+struct io_uring_zcrx_ifq_reg {
+	__u32	if_idx;
+	__u32	if_rxq;
+	__u32	rq_entries;
+	__u32	flags;
+
+	__u64	area_ptr; /* pointer to struct io_uring_zcrx_area_reg */
+	struct io_uring_zcrx_offsets offsets;
+	__u64	__resv[3];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 61923e11c767..1a1184f3946a 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					epoll.o statx.o timeout.o fdinfo.o \
 					cancel.o waitid.o register.o \
 					truncate.o memmap.o
+obj-$(CONFIG_PAGE_POOL)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3942db160f18..02856245af3c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -97,6 +97,7 @@
 #include "uring_cmd.h"
 #include "msg_ring.h"
 #include "memmap.h"
+#include "zcrx.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2600,6 +2601,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
+	io_unregister_zcrx_ifqs(ctx);
 	if (ctx->buf_data)
 		__io_sqe_buffers_unregister(ctx);
 	if (ctx->file_data)
@@ -2772,6 +2774,11 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			io_cqring_overflow_kill(ctx);
 			mutex_unlock(&ctx->uring_lock);
 		}
+		if (ctx->ifq) {
+			mutex_lock(&ctx->uring_lock);
+			io_shutdown_zcrx_ifqs(ctx);
+			mutex_unlock(&ctx->uring_lock);
+		}
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index a0f32a255fd1..4c384e8615f6 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -12,6 +12,7 @@
 
 #include "memmap.h"
 #include "kbuf.h"
+#include "zcrx.h"
 
 static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
 				   size_t size, gfp_t gfp)
@@ -223,6 +224,10 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 		io_put_bl(ctx, bl);
 		return ptr;
 		}
+	case IORING_OFF_RQ_RING:
+		if (!ctx->ifq)
+			return ERR_PTR(-EINVAL);
+		return ctx->ifq->rq_ring;
 	}
 
 	return ERR_PTR(-EINVAL);
@@ -261,6 +266,9 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 						ctx->n_sqe_pages);
 	case IORING_OFF_PBUF_RING:
 		return io_pbuf_mmap(file, vma);
+	case IORING_OFF_RQ_RING:
+		return io_uring_mmap_pages(ctx, vma, ctx->ifq->rqe_pages,
+						ctx->ifq->n_rqe_pages);
 	}
 
 	return -EINVAL;
diff --git a/io_uring/register.c b/io_uring/register.c
index e3c20be5a198..3b221427e988 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -28,6 +28,7 @@
 #include "kbuf.h"
 #include "napi.h"
 #include "eventfd.h"
+#include "zcrx.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -511,6 +512,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_napi(ctx, arg);
 		break;
+	case IORING_REGISTER_ZCRX_IFQ:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_zcrx_ifq(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
new file mode 100644
index 000000000000..79d79b9b8df8
--- /dev/null
+++ b/io_uring/zcrx.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "kbuf.h"
+#include "memmap.h"
+#include "zcrx.h"
+
+#define IO_RQ_MAX_ENTRIES		32768
+
+#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_INET)
+
+static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
+				 struct io_uring_zcrx_ifq_reg *reg)
+{
+	size_t off, size;
+	void *ptr;
+
+	off = sizeof(struct io_uring);
+	size = off + sizeof(struct io_uring_zcrx_rqe) * reg->rq_entries;
+
+	ptr = io_pages_map(&ifq->rqe_pages, &ifq->n_rqe_pages, size);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	ifq->rq_ring = (struct io_uring *)ptr;
+	ifq->rqes = (struct io_uring_zcrx_rqe *)((char *)ptr + off);
+	return 0;
+}
+
+static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
+{
+	io_pages_unmap(ifq->rq_ring, &ifq->rqe_pages, &ifq->n_rqe_pages, true);
+	ifq->rq_ring = NULL;
+	ifq->rqes = NULL;
+}
+
+static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
+{
+	struct io_zcrx_ifq *ifq;
+
+	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
+	if (!ifq)
+		return NULL;
+
+	ifq->if_rxq = -1;
+	ifq->ctx = ctx;
+	return ifq;
+}
+
+static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
+{
+	io_free_rbuf_ring(ifq);
+	kfree(ifq);
+}
+
+int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
+			  struct io_uring_zcrx_ifq_reg __user *arg)
+{
+	struct io_uring_zcrx_ifq_reg reg;
+	struct io_zcrx_ifq *ifq;
+	size_t ring_sz, rqes_sz;
+	int ret;
+
+	/*
+	 * 1. Interface queue allocation.
+	 * 2. It can observe data destined for sockets of other tasks.
+	 */
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	/* mandatory io_uring features for zc rx */
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
+	      ctx->flags & IORING_SETUP_CQE32))
+		return -EINVAL;
+	if (ctx->ifq)
+		return -EBUSY;
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (reg.__resv[0] || reg.__resv[1] || reg.__resv[2])
+		return -EINVAL;
+	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
+		return -EINVAL;
+	if (reg.rq_entries > IO_RQ_MAX_ENTRIES) {
+		if (!(ctx->flags & IORING_SETUP_CLAMP))
+			return -EINVAL;
+		reg.rq_entries = IO_RQ_MAX_ENTRIES;
+	}
+	reg.rq_entries = roundup_pow_of_two(reg.rq_entries);
+
+	if (!reg.area_ptr)
+		return -EFAULT;
+
+	ifq = io_zcrx_ifq_alloc(ctx);
+	if (!ifq)
+		return -ENOMEM;
+
+	ret = io_allocate_rbuf_ring(ifq, &reg);
+	if (ret)
+		goto err;
+
+	ifq->rq_entries = reg.rq_entries;
+	ifq->if_rxq = reg.if_rxq;
+
+	ring_sz = sizeof(struct io_uring);
+	rqes_sz = sizeof(struct io_uring_zcrx_rqe) * ifq->rq_entries;
+	reg.offsets.mmap_sz = ring_sz + rqes_sz;
+	reg.offsets.rqes = ring_sz;
+	reg.offsets.head = offsetof(struct io_uring, head);
+	reg.offsets.tail = offsetof(struct io_uring, tail);
+
+	if (copy_to_user(arg, &reg, sizeof(reg))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	ctx->ifq = ifq;
+	return 0;
+err:
+	io_zcrx_ifq_free(ifq);
+	return ret;
+}
+
+void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
+{
+	struct io_zcrx_ifq *ifq = ctx->ifq;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (!ifq)
+		return;
+
+	ctx->ifq = NULL;
+	io_zcrx_ifq_free(ifq);
+}
+
+void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+}
+
+#endif
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
new file mode 100644
index 000000000000..4ef94e19d36b
--- /dev/null
+++ b/io_uring/zcrx.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_ZC_RX_H
+#define IOU_ZC_RX_H
+
+#include <linux/io_uring_types.h>
+
+struct io_zcrx_ifq {
+	struct io_ring_ctx		*ctx;
+	struct net_device		*dev;
+	struct io_uring			*rq_ring;
+	struct io_uring_zcrx_rqe 	*rqes;
+	u32				rq_entries;
+
+	unsigned short			n_rqe_pages;
+	struct page			**rqe_pages;
+
+	u32				if_rxq;
+};
+
+#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_INET)
+int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
+			 struct io_uring_zcrx_ifq_reg __user *arg);
+void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
+void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
+#else
+static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
+					struct io_uring_zcrx_ifq_reg __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+static inline void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
+{
+}
+static inline void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
+{
+}
+#endif
+
+#endif
-- 
2.43.5


