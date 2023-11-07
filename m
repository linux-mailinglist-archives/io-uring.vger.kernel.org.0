Return-Path: <io-uring+bounces-52-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF2E7E4ADB
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64741B21084
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FF82A8C3;
	Tue,  7 Nov 2023 21:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="zURq9TFY"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE75436B1
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:40:58 +0000 (UTC)
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3173710E2
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:40:58 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cc53d0030fso1099285ad.0
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393257; x=1699998057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbHxJpOeuHDOYo11oQCQ4dzaD+AelcYGpMtLC1wBtjE=;
        b=zURq9TFYQb2cBk0FJUhcVT4dVMUD1VfaATRGl+jjvUpZ5iD6Zaps3qD3OpMP2nw3t3
         +b7Dw/DFNmlTTuZ55gf7puapaSMXLGLgBDbX4zZnnNZNOcgbP50uRLUehuMyNQRbpFgI
         cikaeBJThSUutYXABQFIcvmhsYH2zbfUN5IsS2Mu0JWS7WhJbr25eFvo7CNsBJ50RtHb
         1vJe6v/wWnW6lTn4Tx9xrYs8KIQ4hpyn+YO5igtA2VpB52Sd8GGUsXoF1JFeisoTWPzS
         cpVnimw/tLqqdPywysJ6WX3WFmB2urMLUe5hZFSXQqLY9SApvA4yLwRVJUkVJWIfESHy
         U/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393257; x=1699998057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LbHxJpOeuHDOYo11oQCQ4dzaD+AelcYGpMtLC1wBtjE=;
        b=iBdOP1nzH0v/+8ZwaffyROJbc3GmsiISvYK4d/k0Uizhs8n/3UisPWF6705C9YqZKd
         kWZpQ/D5T5QWxgO72oyJA6hDAP8O6/8cD/idTb5l3zT16H9VIVPBkyGxFWM7e8sphTnq
         Z2QXZsDzp5Fz7WurvEE85NS+tr/tBSlW46sM3gY7oo50XyBdmYnGp9HSUyDKHU8VlKUv
         zbk4m0zAimwZW825jCqssl7OLb3OWW2bihDrA271XpCq/sH//PL8sWxAvAIU39GXyH3U
         5xx0HEFJPd3ga9K2668Ti+9aDanXcsS2e3BQ0QtbeOdplWXv9XsDe7MJ0Eo08Xa5ziAL
         xGEw==
X-Gm-Message-State: AOJu0YwAPnyPfGGTTk+7Yca15Us9oRsDG2mueGvp3PUVsz4mPbx3j/jK
	PpDgnUmSJ8MBw+tqy34Dkebw/2R5iWlAQMEcMFW/lw==
X-Google-Smtp-Source: AGHT+IFcZmC6BQsd2AGq4KJb4oTyCPww1Yk63L0EhdNUL2eJjnTiZEo9JXoLvZFlPH3arwmsV2pE9w==
X-Received: by 2002:a17:903:2282:b0:1cc:5671:8d9 with SMTP id b2-20020a170903228200b001cc567108d9mr6359515plh.27.1699393257307;
        Tue, 07 Nov 2023 13:40:57 -0800 (PST)
Received: from localhost (fwdproxy-prn-005.fbsv.net. [2a03:2880:ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902690100b001c74df14e6esm284401plk.51.2023.11.07.13.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:40:57 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 01/20] io_uring: add interface queue
Date: Tue,  7 Nov 2023 13:40:26 -0800
Message-Id: <20231107214045.2172393-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring_types.h |  6 +++
 include/uapi/linux/io_uring.h  | 50 +++++++++++++++++++++
 io_uring/Makefile              |  3 +-
 io_uring/io_uring.c            |  8 ++++
 io_uring/kbuf.c                | 27 ++++++++++++
 io_uring/kbuf.h                |  5 +++
 io_uring/zc_rx.c               | 79 ++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h               | 34 +++++++++++++++
 8 files changed, 211 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/zc_rx.c
 create mode 100644 io_uring/zc_rx.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 13d19b9be9f4..4f902e17b9c7 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -151,6 +151,10 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
+struct io_rbuf_ring {
+	struct io_uring		rq, cq;
+};
+
 struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
@@ -336,6 +340,8 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
+	struct io_zc_rx_ifq		*ifq;
+
 	/* protected by ->uring_lock */
 	struct list_head		rsrc_ref_list;
 	struct io_alloc_cache		rsrc_node_cache;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8e61f8b7c2ce..84c82a789543 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -546,6 +546,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* register a network interface queue for zerocopy */
+	IORING_REGISTER_ZC_RX_IFQ		= 26,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -736,6 +739,53 @@ enum {
 	SOCKET_URING_OP_SIOCOUTQ,
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
+	__u8	flags;
+	__u8	__pad[3];
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
index 8cc8e5387a75..7818b015a1f2 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
 					openclose.o uring_cmd.o epoll.o \
 					statx.o net.o msg_ring.o timeout.o \
 					sqpoll.o fdinfo.o tctx.o poll.o \
-					cancel.o kbuf.o rsrc.o rw.o opdef.o notif.o
+					cancel.o kbuf.o rsrc.o rw.o opdef.o \
+					notif.o zc_rx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 783ed0fff71b..ae7f37aabe78 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -92,6 +92,7 @@
 #include "cancel.h"
 #include "net.h"
 #include "notif.h"
+#include "zc_rx.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -3160,6 +3161,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&ctx->refs);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
+	io_unregister_zc_rx_ifq(ctx);
 	if (ctx->rings)
 		io_poll_remove_all(ctx, NULL, true);
 	mutex_unlock(&ctx->uring_lock);
@@ -4536,6 +4538,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 556f4df25b0f..30c3e5b20ab3 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -630,3 +630,30 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 
 	return bl->buf_ring;
 }
+
+int io_allocate_rbuf_ring(struct io_zc_rx_ifq *ifq,
+			  struct io_uring_zc_rx_ifq_reg *reg)
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
+
+	return 0;
+}
+
+void io_free_rbuf_ring(struct io_zc_rx_ifq *ifq)
+{
+	if (ifq->ring)
+		folio_put(virt_to_folio(ifq->ring));
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index d14345ef61fc..6c8afda93646 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -4,6 +4,8 @@
 
 #include <uapi/linux/io_uring.h>
 
+#include "zc_rx.h"
+
 struct io_buffer_list {
 	/*
 	 * If ->buf_nr_pages is set, then buf_pages/buf_ring are used. If not,
@@ -57,6 +59,9 @@ void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
 void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid);
 
+int io_allocate_rbuf_ring(struct io_zc_rx_ifq *ifq, struct io_uring_zc_rx_ifq_reg *reg);
+void io_free_rbuf_ring(struct io_zc_rx_ifq *ifq);
+
 static inline void io_kbuf_recycle_ring(struct io_kiocb *req)
 {
 	/*
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
new file mode 100644
index 000000000000..45dab29fe0ae
--- /dev/null
+++ b/io_uring/zc_rx.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+#if defined(CONFIG_NET)
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
+static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
+{
+	struct io_zc_rx_ifq *ifq;
+
+	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);
+	if (!ifq)
+		return NULL;
+
+	ifq->ctx = ctx;
+
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
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (ctx->ifq)
+		return -EBUSY;
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
+int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx)
+{
+	struct io_zc_rx_ifq *ifq = ctx->ifq;
+
+	if (!ifq)
+		return -EINVAL;
+
+	ctx->ifq = NULL;
+	io_zc_rx_ifq_free(ifq);
+	return 0;
+}
+#endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
new file mode 100644
index 000000000000..5f6d80c1c2b8
--- /dev/null
+++ b/io_uring/zc_rx.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_ZC_RX_H
+#define IOU_ZC_RX_H
+
+struct io_zc_rx_ifq {
+	struct io_ring_ctx	*ctx;
+	struct net_device	*dev;
+	struct io_rbuf_ring	*ring;
+	struct io_uring_rbuf_rqe *rqes;
+	struct io_uring_rbuf_cqe *cqes;
+	u32			rq_entries, cq_entries;
+	void			*pool;
+
+	/* hw rx descriptor ring id */
+	u32			if_rxq_id;
+};
+
+#if defined(CONFIG_NET)
+int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
+			  struct io_uring_zc_rx_ifq_reg __user *arg);
+int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx);
+#else
+static inline int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
+			  struct io_uring_zc_rx_ifq_reg __user *arg)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#endif
-- 
2.39.3


