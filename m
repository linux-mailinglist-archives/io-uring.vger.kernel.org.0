Return-Path: <io-uring+bounces-6369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84835A32F0C
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 19:59:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E2EC3A77D3
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 18:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2373F2627E3;
	Wed, 12 Feb 2025 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="dWiccyI4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5214E261567
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386748; cv=none; b=oVc42CEOlD/U/Cq6zsXSrTzhxsxQItZhsgSCMvKGZjVxiAwOlhQoeLrizjl1e4REdApuc3G0xcHsb406b47KhCRuvET331vZM0TSk19A2JdCS+QYf216aov2dQKIRu7gHQtT68LvhM8nkhqOgunPRZnueEXefSeubw9ZJeuR6aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386748; c=relaxed/simple;
	bh=zj4GIYtz6NKFAa0klaWO1xlf9wkU4S05aJWPNtEFybc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af8IBIceqriDOkyAI6TEcigvuSQ2cOnj6J3f+mClgAq229kTBCy5AQYVxvBAVP6CbJNi01lqk56ZaS5kaa6vLXt91Pt9sWAYl0Aj4h8cTmQ1ml3H3Hk9kXb2jpYNzDFj8FepS+pvwGXGKYmUMsCZ7fV9RDaIDu0Krna3ZyEMchw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=dWiccyI4; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-220c665ef4cso12950965ad.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739386745; x=1739991545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6DdRdY/fbRokL7PssPrbn76GM3fdK2ghRVLK0jFvN2Q=;
        b=dWiccyI4P+EnYGqCUDUdjm/CvpANhgU7Wjemgy8dbRz4Ot0GuGjwkiCSdIXamdsgjS
         /eB+CsAO8dCChHekd7VTkRuI1ERtEJ4HNdvcfSur/fhNFAxwREY/ZBDuoCE4o5MlOQoy
         huPEc6dJ7nYuPN6okCjUjP/hf0y6se/I3QUkNYakyCiERSQuJsmW24dgjvjJsh5aHBzF
         2fv8gFJDYA827We8ekOBeRnIIghZZNkblDEa1cAwbfe9g/yfIFVi38l3Je7aTqLUtHII
         kyIz+GR40FBoUgRATl2NlQ/f16LOEK/M+aTcVgqxCMwyfmxce+Sd8dl4ogAlf4z92tAB
         Nvfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739386745; x=1739991545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6DdRdY/fbRokL7PssPrbn76GM3fdK2ghRVLK0jFvN2Q=;
        b=HwIEW/ACe07Vysi5kd4FQB0gENT3kKOVQtb2ZP/iMHXA3vC296MgCs8k8kywVzLjhb
         YLes0TvDHN48jfUblSmUZxwu2LQpmCOZKoR6gl3zzq+OsWZQOTvyeC+ccPqJvVu/3S6W
         Zn8odDpvo0jguG2rWN5fwrF0J1K9nsrqW+ktD1YviZvq9av+kWSUbG/QAtMjhOmrJf1u
         KyNn0l2fhhucWTuqkbQEh5/WxPyvOzwJmTAKJUkSAw2gTp0oxyW/2XCiOmjWi0p0YsHd
         Fnq/mST+1BNyv2FzHmSI6GqOFE6QVD6TzaRI8zc60IOCc0YwN+wzD/qvOnRlksSIx1h0
         fVbw==
X-Gm-Message-State: AOJu0Yy7UI/D/ifSagQTpe7e5QIKHX4woyh7T/HY67Dq2AN8MHN9A0x8
	qEHCBBs5ZYvKc6Pr1bkro71koeaZrhi6FYaQBVheG/zvNObaLAX+sB22w5BGycaf4AD/qQ81JIQ
	F
X-Gm-Gg: ASbGncusqHQW3xRWrhW58ODSYGG7bqCAJGMdLS6X5CT1A244emYcevzG/qiu1s/4/Q5
	P74c8S/byzTD+py1i2sTH66DyyZufU98ditPFpxgMRYx8/anorZZardODr2M3YvrljKm63BVFUs
	vvJZ4NqM+24Tzs4QaxyI74bn8SaCypJN4WnNkWaCdDJYONRcxREGytP8B0/rKbaconCZOAme6f3
	zey1Wj4xdL8bGSeLImDYUWa6Wu+lD2VRPxNLgYx252uKGOkM2Z6VSP1TZuqW0pzlUEOvAFtORw=
X-Google-Smtp-Source: AGHT+IGPkEJU5Aj6C72amVPbkxHA805WfVy5wffd+lblN9R4Vaj77jpIFOWkMt27zmm0miIstlh9OQ==
X-Received: by 2002:a17:902:d50a:b0:216:60a3:b3fd with SMTP id d9443c01a7336-220bdedcc51mr63357435ad.3.1739386745497;
        Wed, 12 Feb 2025 10:59:05 -0800 (PST)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220c8982d79sm8429185ad.194.2025.02.12.10.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:59:05 -0800 (PST)
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
Subject: [PATCH net-next v13 01/11] io_uring/zcrx: add interface queue and refill queue
Date: Wed, 12 Feb 2025 10:57:51 -0800
Message-ID: <20250212185859.3509616-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
References: <20250212185859.3509616-1-dw@davidwei.uk>
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
index e2fef264ff8b..7bf478727a31 100644
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
@@ -382,6 +384,8 @@ struct io_ring_ctx {
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
 
+	struct io_zcrx_ifq		*ifq;
+
 	u32			pers_next;
 	struct xarray		personalities;
 
@@ -434,6 +438,8 @@ struct io_ring_ctx {
 	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
+	/* just one zcrx per ring for now, will move to io_zcrx_ifq eventually */
+	struct io_mapped_region		zcrx_region;
 };
 
 struct io_tw_state {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e11c82638527..6a1632d0fba1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -639,7 +639,8 @@ enum io_uring_register_op {
 	/* send MSG_RING without having a ring */
 	IORING_REGISTER_SEND_MSG_RING		= 31,
 
-	/* 32 reserved for zc rx */
+	/* register a netdev hw rx queue for zerocopy */
+	IORING_REGISTER_ZCRX_IFQ		= 32,
 
 	/* resize CQ ring */
 	IORING_REGISTER_RESIZE_RINGS		= 33,
@@ -956,6 +957,46 @@ enum io_uring_socket_op {
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
index d695b60dba4f..98e48339d84d 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					epoll.o statx.o timeout.o fdinfo.o \
 					cancel.o waitid.o register.o \
 					truncate.o memmap.o alloc_cache.o
+obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec98a0ec6f34..7c34b5459e2d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -97,6 +97,7 @@
 #include "uring_cmd.h"
 #include "msg_ring.h"
 #include "memmap.h"
+#include "zcrx.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2700,6 +2701,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_lock(&ctx->uring_lock);
 	io_sqe_buffers_unregister(ctx);
 	io_sqe_files_unregister(ctx);
+	io_unregister_zcrx_ifqs(ctx);
 	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
 	io_free_alloc_caches(ctx);
@@ -2859,6 +2861,11 @@ static __cold void io_ring_exit_work(struct work_struct *work)
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
index 9a4d2fbce4ae..cc23a4c205cd 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -30,6 +30,7 @@
 #include "eventfd.h"
 #include "msg_ring.h"
 #include "memmap.h"
+#include "zcrx.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -813,6 +814,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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


