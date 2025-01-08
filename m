Return-Path: <io-uring+bounces-5766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 380E3A067E2
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 216D87A27CA
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBEFF2054F9;
	Wed,  8 Jan 2025 22:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="tom2Jp/c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2337B2046A3
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374040; cv=none; b=HFzssKyyXiSFMfUN7rpNv+ssHwqfnJC2KzC0pq5ztccPUPrWZaKndDwekMLuv3ZW4TXEJndSkUi1XUTXgT3LiP9ATpNfjzqC9FLHs5x9QMVrLBrVToHPT8fYeljAb2YKebL0luBetFIqmm68FOWo9VcpCsoGSSfP7FYPb0mBZkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374040; c=relaxed/simple;
	bh=naGHykPCFniyVspq3/qrf1hb5UiMHZZj43LEdVC/S7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkLiWUXs+TW/r13Kdcj/VSU81BEzGt/v9oYRQ+oeyoICh9RkAQO1+wlWTnV7SOiTrfWVpoFCpkGi9shI9pPpq1cgGF/KOrExB4F3xoT17KzlAKkCFImoSlhad56uwdZUEekfRoNx741hY7t14/fFesXF+ysmD7TwBklTiqaZJlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=tom2Jp/c; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-216728b1836so3518335ad.0
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374038; x=1736978838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QFeVztGJ0Opek7DCa1BcFSjSzFZpJHDDY/O4Y65sHAo=;
        b=tom2Jp/cv7tv1LICAbbYjvSoDSy57Sfgtlcp1HetAH0SHuBzsGmSkZjurkdBBJdatg
         NHDnaAYzdth7Dnwn6jlkrPYKoKItDXf6YNfkrAmKdsA2++A1bQjgZfb4Uovk145JcH3e
         CEX1wxYcUCVMdBNEDDwvVnlrzt50dzGWlOZKVIGn5dWqdXEWU2SsPxxLRV2bKDtxE/Wp
         qFz0boR1EtDJF35sUx6TQdTwA/uqkFABXgcgGECzNOi++bFqn5ogkmmnTMRi9mjMCM1g
         REGDr8WZBjklT4ioj54Gn0FMN3xPqoESeppmN2fvW8B9B1rXrwPvwmuDEJUaRJ8VVrTX
         KySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374038; x=1736978838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFeVztGJ0Opek7DCa1BcFSjSzFZpJHDDY/O4Y65sHAo=;
        b=d+Ya3glLcc6qm/pJVKwrf/wJNXpSy2AtU8elKf4r6w4LwcBCqboUtoHmiB/viRYMDl
         1N+xSvFkVF0hp+DWNfgT/DQT2nME0QdBCfoZNTUWroFiH43NHc3qBMhQfm9nEJ21V7jX
         K8mLNtf0bq3l8M/ZXFn2eK633iBW0cAStpAOKfbqCmFcmCIE8E/SUEM9oXQP6vWcia64
         CRTurCghGzmu+UxWvRNE7UO/hWthDoXNlBa4HQkuJBSU5/t7hG/D4sjY4xmW5PeZfap2
         Ha2dulewzE5UruEnnFRCQ3m5dOA/+TaWHXW7L2ZRkL+JgTgHwbbf45hg8rBox/Cfw2dJ
         LZbg==
X-Gm-Message-State: AOJu0YwBNI8yNJ4vwc9Y4o09mRpSXOctHFVjU/mRcQPv8jbvrdqKuPNl
	a4FLpo45SlXY2CpJ1u8wxWWFIFBR5YLp2vs5l3a0rI7oQpFvphCZHMjCa79TmTVKgPPcXea/ftt
	/
X-Gm-Gg: ASbGnct7At9YW5wJpzrJOY2W3U5ZtzqK+q37micv0QYoidRd0P3aD/Ld8aUsVDKXKvu
	NFX6jGMdQhBvtmSNQ39FZnu+C4nsuxybWsvr6zq9e5jAXhyXHY2nKzFifnGfza43bTJQAdprmze
	0kU3BZofXqM48wXzlZYgHud/tj/EvN1geZtNrrD/VBp55s3yCFuPDMiV70r6JeF2Y81uFsXuiFU
	iZXZrBn5z0skyGi5v8tRTS7YvnILvXI0t5jE16C
X-Google-Smtp-Source: AGHT+IE24RQ1Amv7nnBmH3HgiSU3yV/dUGMhCv1HUvCrpIA2mBoka9jrITV3xG42JlN1o/OEhFKPEA==
X-Received: by 2002:a05:6a00:3a01:b0:71d:eb7d:20d5 with SMTP id d2e1a72fcca58-72d21f31848mr6897797b3a.8.1736374038361;
        Wed, 08 Jan 2025 14:07:18 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad81644csm35639178b3a.33.2025.01.08.14.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:17 -0800 (PST)
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
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v10 12/22] io_uring/zcrx: add interface queue and refill queue
Date: Wed,  8 Jan 2025 14:06:33 -0800
Message-ID: <20250108220644.3528845-13-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new object called an interface queue (ifq) that represents a net
rx queue that has been configured for zero copy. Each ifq is registered
using a new registration opcode IORING_REGISTER_ZCRX_IFQ.

The refill queue is allocated by the kernel and mapped by userspace
using a new offset IORING_OFF_RQ_RING, in a similar fashion to the main
SQ/CQ. It is used by userspace to return buffers that it is done with,
which will then be re-used by the netdev again.

The main CQ ring is used to notify userspace of received data by using
the upper 16 bytes of a big CQE as a new struct io_uring_zcrx_cqe. Each
entry contains the offset + len to the data.

For now, each io_uring instance only has a single ifq.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 Kconfig                        |   2 +
 include/linux/io_uring_types.h |   6 ++
 include/uapi/linux/io_uring.h  |  43 +++++++++-
 io_uring/KConfig               |  10 +++
 io_uring/Makefile              |   1 +
 io_uring/io_uring.c            |   7 ++
 io_uring/memmap.h              |   1 +
 io_uring/register.c            |   7 ++
 io_uring/zcrx.c                | 149 +++++++++++++++++++++++++++++++++
 io_uring/zcrx.h                |  35 ++++++++
 10 files changed, 260 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/KConfig
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h

diff --git a/Kconfig b/Kconfig
index 745bc773f567..529ea7694ba9 100644
--- a/Kconfig
+++ b/Kconfig
@@ -30,3 +30,5 @@ source "lib/Kconfig"
 source "lib/Kconfig.debug"
 
 source "Documentation/Kconfig"
+
+source "io_uring/KConfig"
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 493a8f7fa8e4..f0c6e18d176a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -40,6 +40,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
+struct io_zcrx_ifq;
+
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -384,6 +386,8 @@ struct io_ring_ctx {
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
 
+	struct io_zcrx_ifq		*ifq;
+
 	u32			pers_next;
 	struct xarray		personalities;
 
@@ -436,6 +440,8 @@ struct io_ring_ctx {
 	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
+	/* just one zcrx per ring for now, will move to io_zcrx_ifq eventually */
+	struct io_mapped_region		zcrx_region;
 };
 
 struct io_tw_state {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 38f0d6b10eaf..3af8b7a19824 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -638,7 +638,8 @@ enum io_uring_register_op {
 	/* send MSG_RING without having a ring */
 	IORING_REGISTER_SEND_MSG_RING		= 31,
 
-	/* 32 reserved for zc rx */
+	/* register a netdev hw rx queue for zerocopy */
+	IORING_REGISTER_ZCRX_IFQ		= 32,
 
 	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
@@ -955,6 +956,46 @@ enum io_uring_socket_op {
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
+	__u32	__resv2;
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
+	__u64	region_ptr; /* struct io_uring_region_desc * */
+
+	struct io_uring_zcrx_offsets offsets;
+	__u64	__resv[4];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/KConfig b/io_uring/KConfig
new file mode 100644
index 000000000000..9e2a4beba1ef
--- /dev/null
+++ b/io_uring/KConfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# io_uring configuration
+#
+
+config IO_URING_ZCRX
+	def_bool y
+	depends on PAGE_POOL
+	depends on INET
+	depends on NET_RX_BUSY_POLL
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 53167bef37d7..a95b0b8229c9 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					epoll.o statx.o timeout.o fdinfo.o \
 					cancel.o waitid.o register.o \
 					truncate.o memmap.o
+obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5535a72b0ce1..0c02a2e97f01 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -97,6 +97,7 @@
 #include "uring_cmd.h"
 #include "msg_ring.h"
 #include "memmap.h"
+#include "zcrx.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2686,6 +2687,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_lock(&ctx->uring_lock);
 	io_sqe_buffers_unregister(ctx);
 	io_sqe_files_unregister(ctx);
+	io_unregister_zcrx_ifqs(ctx);
 	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
@@ -2851,6 +2853,11 @@ static __cold void io_ring_exit_work(struct work_struct *work)
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
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index c898dcba2b4e..dad0aa5b1b45 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -2,6 +2,7 @@
 #define IO_URING_MEMMAP_H
 
 #define IORING_MAP_OFF_PARAM_REGION		0x20000000ULL
+#define IORING_MAP_OFF_ZCRX_REGION		0x30000000ULL
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
 
diff --git a/io_uring/register.c b/io_uring/register.c
index f1698c18c7cb..f9dfdca79a80 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -30,6 +30,7 @@
 #include "eventfd.h"
 #include "msg_ring.h"
 #include "memmap.h"
+#include "zcrx.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -798,6 +799,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_clone_buffers(ctx, arg);
 		break;
+	case IORING_REGISTER_ZCRX_IFQ:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_zcrx_ifq(ctx, arg);
+		break;
 	case IORING_REGISTER_RESIZE_RINGS:
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
new file mode 100644
index 000000000000..f3ace7e8264d
--- /dev/null
+++ b/io_uring/zcrx.c
@@ -0,0 +1,149 @@
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
+static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
+				 struct io_uring_zcrx_ifq_reg *reg,
+				 struct io_uring_region_desc *rd)
+{
+	size_t off, size;
+	void *ptr;
+	int ret;
+
+	off = sizeof(struct io_uring);
+	size = off + sizeof(struct io_uring_zcrx_rqe) * reg->rq_entries;
+	if (size > rd->size)
+		return -EINVAL;
+
+	ret = io_create_region_mmap_safe(ifq->ctx, &ifq->ctx->zcrx_region, rd,
+					 IORING_MAP_OFF_ZCRX_REGION);
+	if (ret < 0)
+		return ret;
+
+	ptr = io_region_get_ptr(&ifq->ctx->zcrx_region);
+	ifq->rq_ring = (struct io_uring *)ptr;
+	ifq->rqes = (struct io_uring_zcrx_rqe *)(ptr + off);
+	return 0;
+}
+
+static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
+{
+	io_free_region(ifq->ctx, &ifq->ctx->zcrx_region);
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
+	struct io_uring_region_desc rd;
+	struct io_zcrx_ifq *ifq;
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
+	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
+		return -EFAULT;
+	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
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
+	ret = io_allocate_rbuf_ring(ifq, &reg, &rd);
+	if (ret)
+		goto err;
+
+	ifq->rq_entries = reg.rq_entries;
+	ifq->if_rxq = reg.if_rxq;
+
+	reg.offsets.rqes = sizeof(struct io_uring);
+	reg.offsets.head = offsetof(struct io_uring, head);
+	reg.offsets.tail = offsetof(struct io_uring, tail);
+
+	if (copy_to_user(arg, &reg, sizeof(reg)) ||
+	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd))) {
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
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
new file mode 100644
index 000000000000..58e4ab6c6083
--- /dev/null
+++ b/io_uring/zcrx.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_ZC_RX_H
+#define IOU_ZC_RX_H
+
+#include <linux/io_uring_types.h>
+
+struct io_zcrx_ifq {
+	struct io_ring_ctx		*ctx;
+	struct io_uring			*rq_ring;
+	struct io_uring_zcrx_rqe	*rqes;
+	u32				rq_entries;
+
+	u32				if_rxq;
+};
+
+#if defined(CONFIG_IO_URING_ZCRX)
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


