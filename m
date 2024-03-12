Return-Path: <io-uring+bounces-907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6D8879DBF
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBCA11F227E2
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8A21448F2;
	Tue, 12 Mar 2024 21:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Z7F/TmZG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167FB1448D8
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279881; cv=none; b=SsaRXUjfmFLEbG6PZAC4fLnwrZ8RDaRLPs4tXNEQT5xHZ3yKdG2FQFhaOUXRamtSjnrM6j9KQZRBYD1rLffoi5TDGanWLHgxmHDPeTPo/2K4OM4OQ33Ec1NMK19ddnaisdRBe2fwC/6REIdhRW0p0urABizKKeeBCr0EQmAmZnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279881; c=relaxed/simple;
	bh=xDw4xwqYNvzEtsEJkeXp/EDyNctETx7Y/M4UY4XenI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ka/BDTCM/ZPks71w5Cx1ukiDmLQabHOTh67+Flu/HcAuUlVHcrn15wBCBeaz2div/2SVS/DSQuVy+aiwA0L9+3tc8cDZdxyQaend5pbjeFJ/NgxfkfbN7wbuNN+hsFf2H6p/vDbDnBhDkbRwHAiU3TvixOhEu4afN/wB0KJh2+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Z7F/TmZG; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-221e1910c3bso1761173fac.1
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279879; x=1710884679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GaKAi998LkbXWeL8EN5F32Ym68wcxO7wQb8zF1vI+q4=;
        b=Z7F/TmZGgbkjRJLZ9NBFR384kenlH+pGUruI7BwmRJWXJIRWYVA39fckbC3HRcAnMs
         wH7bqAxFYBUvqaCwiBBvEHjdd34/4gWFTmt38KK0rQSe3CytVx0kGFwZQHFD/6KM/xZq
         /jVfXjDYagO/VFem7P6t1ncPyxc1qfVPkDZ9iHc8U+l0xJcNaKQ6FfU0JhveG++9u+9t
         ujlXfDSbkH8gz0X5jeEKFpSbA7Z8qSSn+/ysdEyBRXgDKPNIOGjkKupNq3OQJjNiWsoL
         wr1PGho9xQMtbJ+bXmhCNMG612w1R4V0j18M3Oeo+rLFyUOiiJCU+9x2hiap8Nbxsn4W
         XONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279879; x=1710884679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GaKAi998LkbXWeL8EN5F32Ym68wcxO7wQb8zF1vI+q4=;
        b=JrOa68bF//j4OoV+kPjIb9ESRpHkvFLSldXVeKv3GAZYYeR5KfZSbnE/VjCdjUxams
         I6P90EycuBt8cNAezO8oBcuCP1W1Jpsh5I8SKwdmw7gKyffs2+WouQUvFwB8U+iH8J+h
         rbaYB1gypmyXNObqH6a2gEjufLz/XPHuPR6HcOJkxtcZUkcms658/5/BUfldMQJAr5gT
         U3mc/wYbSlWvF45qyCZV0dkfnI+b7VIYwZbiUseu9Xg2QpiWDYq63B2S5LcxscByLTQ1
         A/H0MJvPJWvwlWcpK3aR3UlIalVbW/oaWwjkK5cKzMeuSy0chipBBK60l5rtrw02KNmV
         6YtA==
X-Gm-Message-State: AOJu0Yxb/6Zu99pmKn4wlI/K5lNVMjXrA4KTvHSnLGXkn56QQFR1NG4p
	/tCZU22Eu76J+sUDnqv84OIQyabOqp2o6KcgSoxFOIfYwhpfvVMUp+JikWik0M+QlZKhOTXIYQ7
	F
X-Google-Smtp-Source: AGHT+IEzXnWfV21NXBOZIFGvF02twSyBteR8js/V5WflDWgKdloxj7LQXfsLPnQTtijYpqDXRcZSTA==
X-Received: by 2002:a05:6870:d6a2:b0:21e:a40e:7465 with SMTP id z34-20020a056870d6a200b0021ea40e7465mr11616026oap.24.1710279878811;
        Tue, 12 Mar 2024 14:44:38 -0700 (PDT)
Received: from localhost (fwdproxy-prn-006.fbsv.net. [2a03:2880:ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id g17-20020aa79f11000000b006e6b41511fdsm428082pfr.94.2024.03.12.14.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:38 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v4 05/16] io_uring: introduce interface queue
Date: Tue, 12 Mar 2024 14:44:19 -0700
Message-ID: <20240312214430.2923019-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

This patch introduces a new object in io_uring called an interface queue
(ifq) which contains:

* A pool region allocated by userspace and registered w/ io_uring where
  Rx data is transferred to via DMA.
* A net device and one specific Rx queue in it that will be configured
  for ZC Rx.
* A new shared ringbuf w/ userspace called a refill ring. When userspace
  is done with bufs with Rx packet payloads, it writes entries into this
  ring to tell the kernel that bufs can be re-used by the NIC again.
  Each entry in the refill ring is a struct io_uring_rbuf_rqe.

On the completion side, the main CQ ring is used to notify userspace of
recv()'d packets. Big CQEs (32 bytes) are required to support this, as
the upper 16 bytes are used by ZC Rx to store a feature specific struct
io_uring_rbuf_cqe.

Add two new struct types:

1. io_uring_rbuf_rqe - entry in refill ring
2. io_uring_rbuf_cqe - entry in upper 16 bytes of a big CQE

For now, each io_uring instance has a single ifq, and each ifq has a
single pool region associated with one Rx queue.

Add a new opcode and functions to setup and tear down an ifq. Size and
offsets of the shared refill ring are returned to userspace for it to
mmap in the registration struct io_uring_zc_rx_ifq_reg, similar to the
main SQ/CQ rings.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring_types.h |   4 ++
 include/uapi/linux/io_uring.h  |  40 ++++++++++++
 io_uring/Makefile              |   3 +-
 io_uring/io_uring.c            |   7 +++
 io_uring/register.c            |   7 +++
 io_uring/zc_rx.c               | 109 +++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h               |  35 +++++++++++
 7 files changed, 204 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/zc_rx.c
 create mode 100644 io_uring/zc_rx.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 500772189fee..27e750a02ea5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -39,6 +39,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+struct io_zc_rx_ifq;
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -385,6 +387,8 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
+	struct io_zc_rx_ifq		*ifq;
+
 	/* protected by ->uring_lock */
 	struct list_head		rsrc_ref_list;
 	struct io_alloc_cache		rsrc_node_cache;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..7b643fe420c5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -575,6 +575,9 @@ enum {
 	IORING_REGISTER_NAPI			= 27,
 	IORING_UNREGISTER_NAPI			= 28,
 
+	/* register a network interface queue for zerocopy */
+	IORING_REGISTER_ZC_RX_IFQ		= 29,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -782,6 +785,43 @@ enum {
 	SOCKET_URING_OP_SETSOCKOPT,
 };
 
+struct io_uring_rbuf_rqe {
+	__u32	off;
+	__u32	len;
+	__u16	region;
+	__u8	__pad[6];
+};
+
+struct io_uring_rbuf_cqe {
+	__u32	off;
+	__u32	len;
+	__u16	region;
+	__u8	__pad[6];
+};
+
+struct io_rbuf_rqring_offsets {
+	__u32	head;
+	__u32	tail;
+	__u32	rqes;
+	__u8	__pad[4];
+};
+
+/*
+ * Argument for IORING_REGISTER_ZC_RX_IFQ
+ */
+struct io_uring_zc_rx_ifq_reg {
+	__u32	if_idx;
+	/* hw rx descriptor ring id */
+	__u32	if_rxq_id;
+	__u32	region_id;
+	__u32	rq_entries;
+	__u32	flags;
+	__u16	cpu;
+
+	__u32	mmap_sz;
+	struct io_rbuf_rqring_offsets rq_off;
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 2e1d4e03799c..bb47231c611b 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -8,7 +8,8 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
 					cancel.o kbuf.o rsrc.o rw.o opdef.o \
-					notif.o waitid.o register.o truncate.o
+					notif.o waitid.o register.o truncate.o \
+					zc_rx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e44c2ef271b9..5614c47cecd9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "waitid.h"
 #include "futex.h"
 #include "napi.h"
+#include "zc_rx.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2861,6 +2862,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
+	io_unregister_zc_rx_ifqs(ctx);
 	if (ctx->buf_data)
 		__io_sqe_buffers_unregister(ctx);
 	if (ctx->file_data)
@@ -3032,6 +3034,11 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			io_cqring_overflow_kill(ctx);
 			mutex_unlock(&ctx->uring_lock);
 		}
+		if (ctx->ifq) {
+			mutex_lock(&ctx->uring_lock);
+			io_shutdown_zc_rx_ifqs(ctx);
+			mutex_unlock(&ctx->uring_lock);
+		}
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
diff --git a/io_uring/register.c b/io_uring/register.c
index 99c37775f974..760f0b6a051c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -27,6 +27,7 @@
 #include "cancel.h"
 #include "kbuf.h"
 #include "napi.h"
+#include "zc_rx.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -563,6 +564,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_napi(ctx, arg);
 		break;
+	case IORING_REGISTER_ZC_RX_IFQ:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_zc_rx_ifq(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
new file mode 100644
index 000000000000..e6c33f94c086
--- /dev/null
+++ b/io_uring/zc_rx.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+#if defined(CONFIG_PAGE_POOL)
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/io_uring.h>
+
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "kbuf.h"
+#include "zc_rx.h"
+
+static int io_allocate_rbuf_ring(struct io_zc_rx_ifq *ifq,
+				 struct io_uring_zc_rx_ifq_reg *reg)
+{
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
+	size_t off, rq_size;
+	void *ptr;
+
+	off = sizeof(struct io_uring);
+	rq_size = reg->rq_entries * sizeof(struct io_uring_rbuf_rqe);
+	ptr = (void *) __get_free_pages(gfp, get_order(off + rq_size));
+	if (!ptr)
+		return -ENOMEM;
+	ifq->rq_ring = (struct io_uring *)ptr;
+	ifq->rqes = (struct io_uring_rbuf_rqe *)((char *)ptr + off);
+	return 0;
+}
+
+static void io_free_rbuf_ring(struct io_zc_rx_ifq *ifq)
+{
+	if (ifq->rq_ring)
+		folio_put(virt_to_folio(ifq->rq_ring));
+}
+
+static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
+{
+	struct io_zc_rx_ifq *ifq;
+
+	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
+	if (!ifq)
+		return NULL;
+
+	ifq->if_rxq_id = -1;
+	ifq->ctx = ctx;
+	return ifq;
+}
+
+static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
+{
+	io_free_rbuf_ring(ifq);
+	kfree(ifq);
+}
+
+int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
+			  struct io_uring_zc_rx_ifq_reg __user *arg)
+{
+	struct io_uring_zc_rx_ifq_reg reg;
+	struct io_zc_rx_ifq *ifq;
+	int ret;
+
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
+	      ctx->flags & IORING_SETUP_CQE32))
+		return -EINVAL;
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (ctx->ifq)
+		return -EBUSY;
+	if (reg.if_rxq_id == -1)
+		return -EINVAL;
+
+	ifq = io_zc_rx_ifq_alloc(ctx);
+	if (!ifq)
+		return -ENOMEM;
+
+	ret = io_allocate_rbuf_ring(ifq, &reg);
+	if (ret)
+		goto err;
+
+	ifq->rq_entries = reg.rq_entries;
+	ifq->if_rxq_id = reg.if_rxq_id;
+	ctx->ifq = ifq;
+
+	return 0;
+err:
+	io_zc_rx_ifq_free(ifq);
+	return ret;
+}
+
+void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx)
+{
+	struct io_zc_rx_ifq *ifq = ctx->ifq;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (!ifq)
+		return;
+
+	ctx->ifq = NULL;
+	io_zc_rx_ifq_free(ifq);
+}
+
+void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+}
+
+#endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
new file mode 100644
index 000000000000..35b019b275e0
--- /dev/null
+++ b/io_uring/zc_rx.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_ZC_RX_H
+#define IOU_ZC_RX_H
+
+struct io_zc_rx_ifq {
+	struct io_ring_ctx		*ctx;
+	struct net_device		*dev;
+	struct io_uring			*rq_ring;
+	struct io_uring_rbuf_rqe 	*rqes;
+	u32				rq_entries;
+
+	/* hw rx descriptor ring id */
+	u32				if_rxq_id;
+};
+
+#if defined(CONFIG_PAGE_POOL)
+int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
+			  struct io_uring_zc_rx_ifq_reg __user *arg);
+void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx);
+void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx);
+#else
+static inline int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
+			  struct io_uring_zc_rx_ifq_reg __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+static inline void io_unregister_zc_rx_ifqs(struct io_ring_ctx *ctx)
+{
+}
+static inline void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx)
+{
+}
+#endif
+
+#endif
-- 
2.43.0


