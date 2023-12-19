Return-Path: <io-uring+bounces-306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C85DC8191F0
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FE4E283CD8
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E361D3D0D1;
	Tue, 19 Dec 2023 21:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="XU3UrHve"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954183C495
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6d946beebe6so11810b3a.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019851; x=1703624651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+cD0HBbDXg6qDTaNdwjQlMiJRw8SP72E8bqAxbhE8s=;
        b=XU3UrHveKv4FykWM7gzm1lTiTMjIf1IVo3agLeyjanCt/YfMUVoKkNEPoIHjH4CWBc
         ON7vzJatilRqbTDbgzRRaFh6EEfNREm6exksKwMSUd5LUNcrhHAHG320J67t6hj8IzZM
         NfqwqZs4x/tuiknuCCs8651Qm574gwikysic7I+hJzslQ32+eQDQLo2lBhwJUjkD63JC
         d4Api9Lt0/aPDq2Fe6HtQg6q9XBotdQcLm3EWMCZZ4NBRdapyyE90VN/faJhhE4Qkbl8
         OLVd5aZ2DNgmj9/13mW1OPHsdnCLu1M9EcaVyX7ZnxrNyA925Xfr6NovNhGEpFIl7pWB
         AgFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019851; x=1703624651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X+cD0HBbDXg6qDTaNdwjQlMiJRw8SP72E8bqAxbhE8s=;
        b=v5ZIKlMO3KQS4q6toXlDQCKLcxeNAqCHaQSblWhKOGDrXcMmwQk36YK3feK098LKDA
         kyIGUegjr6IPk3R/60kzOZBUtAyzG3iomxHvXNtA0cdzksqkz72fnvQirKqEL9u2ecZh
         IlL3U53sk3CkcY72Lgi/PoFUplqyoKnzv2Tu8xAS8X1yyyYdfG/D2DS6S0XXWne5M08b
         FWoN/X/Rm3HQz8+9HuesG7+vEkwAd7o9qCoWk5qdLxXLbW9Cv+4Zh0jUb/GY0gQHKNUZ
         56xZquBIgulJFtesC3NzmXLnomc7EC/QvfEHwJ3t+t1z5MyesEo/kJFvdrtNy+JUjGv6
         bAVg==
X-Gm-Message-State: AOJu0YzN/8rmCjRuQBBczROSpo5IuxSy9KKNBmLDkO9LSkBhGXLIwUdE
	GSZWdwsHjZYA3NtkXJWUaZdjxnl3AYoE2iumKaGfdQ==
X-Google-Smtp-Source: AGHT+IF4yzEdIL3OE2Yk+EqkDNUGNs1PJkGmtMabu00W7UcjeuqOC098z2oc+B7EWH+cuRRVUfcEhg==
X-Received: by 2002:a05:6a00:4c18:b0:6d9:4598:d1f7 with SMTP id ea24-20020a056a004c1800b006d94598d1f7mr172961pfb.52.1703019851574;
        Tue, 19 Dec 2023 13:04:11 -0800 (PST)
Received: from localhost (fwdproxy-prn-120.fbsv.net. [2a03:2880:ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id ei22-20020a056a0080d600b006ce75e0ef83sm3671250pfb.179.2023.12.19.13.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:11 -0800 (PST)
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
Subject: [RFC PATCH v3 07/20] io_uring: add interface queue
Date: Tue, 19 Dec 2023 13:03:44 -0800
Message-Id: <20231219210357.4029713-8-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
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
  Rx data is written to.
* A net device and one specific Rx queue in it that will be configured
  for ZC Rx.
* A pair of shared ringbuffers w/ userspace, dubbed registered buf
  (rbuf) rings. Each entry contains a pool region id and an offset + len
  within that region. The kernel writes entries into the completion ring
  to tell userspace where RX data is relative to the start of a region.
  Userspace writes entries into the refill ring to tell the kernel when
  it is done with the data.

For now, each io_uring instance has a single ifq, and each ifq has a
single pool region associated with one Rx queue.

Add a new opcode to io_uring_register that sets up an ifq. Size and
offsets of shared ringbuffers are returned to userspace for it to mmap.
The implementation will be added in a later patch.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring_types.h |   8 +++
 include/uapi/linux/io_uring.h  |  51 +++++++++++++++
 io_uring/Makefile              |   2 +-
 io_uring/io_uring.c            |  13 ++++
 io_uring/zc_rx.c               | 116 +++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h               |  37 +++++++++++
 6 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/zc_rx.c
 create mode 100644 io_uring/zc_rx.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index bebab36abce8..e87053b200f2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -38,6 +38,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPAT		= (1 << 12),
 };
 
+struct io_zc_rx_ifq;
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -182,6 +184,10 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
+struct io_rbuf_ring {
+	struct io_uring		rq, cq;
+};
+
 struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
@@ -383,6 +389,8 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
+	struct io_zc_rx_ifq		*ifq;
+
 	/* protected by ->uring_lock */
 	struct list_head		rsrc_ref_list;
 	struct io_alloc_cache		rsrc_node_cache;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1c16f817742..024a6f79323b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -558,6 +558,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* register a network interface queue for zerocopy */
+	IORING_REGISTER_ZC_RX_IFQ		= 26,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -750,6 +753,54 @@ enum {
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
+	__u8	sock;
+	__u8	flags;
+	__u8	__pad[2];
+};
+
+struct io_rbuf_rqring_offsets {
+	__u32	head;
+	__u32	tail;
+	__u32	rqes;
+	__u8	__pad[4];
+};
+
+struct io_rbuf_cqring_offsets {
+	__u32	head;
+	__u32	tail;
+	__u32	cqes;
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
+	__u32	cq_entries;
+	__u32	flags;
+	__u16	cpu;
+
+	__u32	mmap_sz;
+	struct io_rbuf_rqring_offsets rq_off;
+	struct io_rbuf_cqring_offsets cq_off;
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/Makefile b/io_uring/Makefile
index e5be47e4fc3b..6c4b4ed37a1f 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -8,6 +8,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
 					cancel.o kbuf.o rsrc.o rw.o opdef.o \
-					notif.o waitid.o
+					notif.o waitid.o zc_rx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1d254f2c997d..7fff01d57e9e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "notif.h"
 #include "waitid.h"
 #include "futex.h"
+#include "zc_rx.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2919,6 +2920,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
+	io_unregister_zc_rx_ifqs(ctx);
 	if (ctx->buf_data)
 		__io_sqe_buffers_unregister(ctx);
 	if (ctx->file_data)
@@ -3109,6 +3111,11 @@ static __cold void io_ring_exit_work(struct work_struct *work)
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
@@ -4609,6 +4616,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_file_alloc_range(ctx, arg);
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
index 000000000000..5fc94cad5e3a
--- /dev/null
+++ b/io_uring/zc_rx.c
@@ -0,0 +1,116 @@
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
+	size_t off, size, rq_size, cq_size;
+	void *ptr;
+
+	off = sizeof(struct io_rbuf_ring);
+	rq_size = reg->rq_entries * sizeof(struct io_uring_rbuf_rqe);
+	cq_size = reg->cq_entries * sizeof(struct io_uring_rbuf_cqe);
+	size = off + rq_size + cq_size;
+	ptr = (void *) __get_free_pages(gfp, get_order(size));
+	if (!ptr)
+		return -ENOMEM;
+	ifq->ring = (struct io_rbuf_ring *)ptr;
+	ifq->rqes = (struct io_uring_rbuf_rqe *)((char *)ptr + off);
+	ifq->cqes = (struct io_uring_rbuf_cqe *)((char *)ifq->rqes + rq_size);
+	return 0;
+}
+
+static void io_free_rbuf_ring(struct io_zc_rx_ifq *ifq)
+{
+	if (ifq->ring)
+		folio_put(virt_to_folio(ifq->ring));
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
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
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
+	/* TODO: initialise network interface */
+
+	ret = io_allocate_rbuf_ring(ifq, &reg);
+	if (ret)
+		goto err;
+
+	/* TODO: map zc region and initialise zc pool */
+
+	ifq->rq_entries = reg.rq_entries;
+	ifq->cq_entries = reg.cq_entries;
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
index 000000000000..aab57c1a4c5d
--- /dev/null
+++ b/io_uring/zc_rx.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_ZC_RX_H
+#define IOU_ZC_RX_H
+
+struct io_zc_rx_ifq {
+	struct io_ring_ctx		*ctx;
+	struct net_device		*dev;
+	struct io_rbuf_ring		*ring;
+	struct io_uring_rbuf_rqe 	*rqes;
+	struct io_uring_rbuf_cqe 	*cqes;
+	u32				rq_entries;
+	u32				cq_entries;
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
2.39.3


