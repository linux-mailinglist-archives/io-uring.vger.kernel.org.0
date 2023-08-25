Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E6F789215
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjHYW4M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjHYW4F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:05 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A517199F
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:03 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-68bec3a1c0fso1219697b3a.1
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004163; x=1693608963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jTvowOQwcZhVRqOJ6qg2E7pufXaeMTOsQWNawAhB/rk=;
        b=qRETiYB6Gnj+agcJyc7iUP5owlf58Ley2EasX/BNq+/0RSRIwQ5G2MwYfvL5lRHhEC
         +E6oknVoOQQkCVPv7oKyUtjYSRhJgUM9K3kozLarTNw4IsSFUU5CCrPufMj6NwcHb1ys
         sKJE+L9UlyaYoE3JW3Xdzb+oqCYH74v0jpcs9/11krjZ2cY0Cv8KLNj9STPerqlireC7
         m/OwdNc0Hvucq6F/H2v95sCpbI8uop+Odmr2zp55yn4DRzwtw4AIgj0QU9OAjpbuhVE0
         DbYnir4xYk8XucEQ/8i+EAINyMSv01JJL51VFM8jcl/1d7pk/JV7hE/4JxwEFB8JRS/K
         8qag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004163; x=1693608963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jTvowOQwcZhVRqOJ6qg2E7pufXaeMTOsQWNawAhB/rk=;
        b=Xt5p01cNq34Vx/NoB14u46pcPB1ZzdMde3eQ8GWExYf6NDnHE9V0VUlWFxUSzsbSnT
         Y2hJa6xwvYmDK24+CuJIUzOItjLe6myiuNAClg2M+6XV58Jo7kV0iaYZcgsgtMekEflB
         WM5eQfK8t1AwawKuA23SQEvtw/Cgo2wuwTNjgkGHJsiYB+v0NhheScHTVEZs0ZpIkH6W
         e2dhr/fzUi39m0S8E3ByCYSIbhzNt/fv6GeAgHemLmENfxWkoGaNEnNIFmat/jr5E96T
         kmhWfi9nmgfjODyPFYS2EfmxgZyJWX+xSw01u1nPoKpa3SCf6qyUUEHG5KH1Bli/azQ9
         yNuQ==
X-Gm-Message-State: AOJu0YyMfhcovIdf9RnHewgTiBOYb7OWnUSFjMciyoGUxi3lx9ejDE/G
        zym/rXmPFLmmeZkubipNXp21zg==
X-Google-Smtp-Source: AGHT+IEb6WthqB3EcxbwUAv3Sz8RT2HICYRL+UXajWVZd8tgn/unk6lFmCnAQKwapcgYMndeFVgH9w==
X-Received: by 2002:a05:6a00:22cb:b0:68b:c423:fb20 with SMTP id f11-20020a056a0022cb00b0068bc423fb20mr10285809pfj.30.1693004162926;
        Fri, 25 Aug 2023 15:56:02 -0700 (PDT)
Received: from localhost (fwdproxy-prn-011.fbsv.net. [2a03:2880:ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id e21-20020aa78255000000b0066f37665a63sm2068002pfn.73.2023.08.25.15.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:02 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 01/11] io_uring: add interface queue
Date:   Fri, 25 Aug 2023 15:55:40 -0700
Message-Id: <20230825225550.957014-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

This patch introduces a new object in io_uring called an interface queue
(ifq) which contains:

* A pool region allocated by userspace and registered w/ io_uring where
  RX data is written to.
* A net device and one specific RX queue in it that will be configured
  for ZC RX.
* A pair of shared ringbuffers w/ userspace, dubbed registered buf
  (rbuf) rings. Each entry contains a pool region id and an offset + len
  within that region. The kernel writes entries into the completion ring
  to tell userspace where RX data is relative to the start of a region.
  Userspace writes entries into the refill ring to tell the kernel when
  it is done with the data.

For now, each io_uring instance has a single ifq, and each ifq has a
single pool region associated with one RX queue.

Add a new opcode to io_uring_register that sets up an ifq. Size and
offsets of shared ringbuffers are returned to userspace for it to mmap.
The implementation will be added in a later patch.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 include/linux/io_uring_types.h |  6 ++++
 include/uapi/linux/io_uring.h  | 50 ++++++++++++++++++++++++++
 io_uring/Makefile              |  3 +-
 io_uring/io_uring.c            |  7 ++++
 io_uring/kbuf.c                | 30 ++++++++++++++++
 io_uring/kbuf.h                |  5 +++
 io_uring/zc_rx.c               | 65 ++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h               | 21 +++++++++++
 8 files changed, 186 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/zc_rx.c
 create mode 100644 io_uring/zc_rx.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1b2a20a42413..8f6068da185c 100644
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
@@ -330,6 +334,8 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
+	struct io_zc_rx_ifq		*ifq;
+
 	/* protected by ->uring_lock */
 	struct list_head		rsrc_ref_list;
 	struct io_alloc_cache		rsrc_node_cache;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..8f2a1061629b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -523,6 +523,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* register a network interface queue for zerocopy */
+	IORING_REGISTER_ZC_RX_IFQ		= 26,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -703,6 +706,53 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
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
index 3bca7a79efda..7705d18dceff 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -92,6 +92,7 @@
 #include "cancel.h"
 #include "net.h"
 #include "notif.h"
+#include "zc_rx.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -4418,6 +4419,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
index 2f0181521c98..d7499e7b34bd 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -634,3 +634,33 @@ void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 
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
+	struct page *page;
+
+	page = virt_to_head_page(ifq->ring);
+	if (put_page_testzero(page))
+		free_compound_page(page);
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
index 000000000000..63bc6cd7d205
--- /dev/null
+++ b/io_uring/zc_rx.c
@@ -0,0 +1,65 @@
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
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
new file mode 100644
index 000000000000..4363734f3d98
--- /dev/null
+++ b/io_uring/zc_rx.h
@@ -0,0 +1,21 @@
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
+int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
+			  struct io_uring_zc_rx_ifq_reg __user *arg);
+
+#endif
-- 
2.39.3

