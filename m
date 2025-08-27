Return-Path: <io-uring+bounces-9306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EC93B3839A
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 15:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49E3A463C49
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 13:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11BAF307ACB;
	Wed, 27 Aug 2025 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+WB6h99"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0380E3314A6
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 13:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756300802; cv=none; b=CAN56qMRD0F3b8b0UCnLuotkI2Sqmg36UJFeiswEYkEroMuHvrvaf92jKQ6Pv4ZHYs89NaOu7xRq+5K+G/y7CZxZmoONIKcEjQgrS+pU84hudWqWdgGEwGT4QU7xMwioNUy/TBSEdkN7EQBXiPLo+wA7hvf0tCNEItlSLSE/bAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756300802; c=relaxed/simple;
	bh=sdYotIgX9vrYxmJyANVODx4yJEXLx1S7fXLUl1WMJBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txPZRpbmJf6WgudatykpMAIymyD36jVgRa20zowaYz8TM/ES/T7BDfcEd15RqFm6epN9F02H0t8Nj6vHKHPxeg1T0HeUZ8isR5OGLXxxpgrRjAkzExsEmHu/6HdIitLbR3VhXEoSAIiJcTlKqyre4SRA/oIc4aYtXVIS7UMXfCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+WB6h99; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45a1b001f55so36833845e9.0
        for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 06:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756300798; x=1756905598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cnqX2wl5i5+iAevCrvRiHaNVFV9XjyX7X1VjCAgJ7g4=;
        b=Q+WB6h99mxDJyFlKkFN+ML50TFK4LFl+11VsT80FSVF6RG9Cym4NlHIioz27IHx0Nc
         hTHOQhcbEAiCWHY4hlhm8Ezq8gQ+e/cEZMZu8daE37Im9WrhY9i4hb8rJ2gBVXio1WLs
         Ggwqx9BazuAGJVSPY0v5cwUrfPGBBLl1qtozctlT2KXMC9H14go/umLXViqvr4MlCtkn
         AzyydZn9NL637dtKxbf6PgPx0730UV+y9N+JnlHWHHI/sObO3ZvNUHZOAPmcNIdWc/js
         zKAawmPg81HVjZNQbqRhR6qDx0k/KG1l4J7Bwe9+xqlm0cRHeeO/HHEzZE/6WTsgMLWA
         tXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756300798; x=1756905598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cnqX2wl5i5+iAevCrvRiHaNVFV9XjyX7X1VjCAgJ7g4=;
        b=T9VXal0vs68tGaStQCNG1bA/xte9tRlgnQKZIKKQnqAKSfSqda7yieC8ymnT4LSI/X
         U30z1fuIadOGDxyrslL7iFB/D2SsrURsBVtA+RyhytgTj08J/D3zHG047OonKDcJiJoA
         YzSO/TwI4/P408/V5sGREES2UJTiSAw9PCuPwPEsGyhZ7c2p75TfMbI76q70jDmTJid5
         sIax+RsqdtAqGoT/+BL1txx2/FpCNwtnC1X7xXhE56oLlrm9RYZH+tgeBlj90yQfCVOz
         vwYyPQLb/mrVsLf2dCzQdtj3zJgMEAmbi4W36W02eomfmaWU5BU63TSvdr6lC/bZn6Z9
         Wm0w==
X-Gm-Message-State: AOJu0YyLeV7jO005yFwuWcUK1WHhyyicQTCqvnQN1BHkRMdpaNqfr5ZR
	jhAs09NfwmlhKgaAfSt/jSTnWBGAW5dXzIDyLWTq40ICQpm0lJEV2Zs6xbbHwg==
X-Gm-Gg: ASbGncvSISOrbVxbYhpylD+vfwXaCjrZldxzYDOOboC4jn8PxYcY+dQ77/A7qmEBfCj
	SK7bS/mjaFIvddRV3qP1wkOJEoTiyGYcdjAfp0B9b+yj/xHYghsQtPifhzglWctt5ClFEL6NcSG
	v4tZsezMJtG38422Xuo96ziV+V6jPTcmfKjY9//yDWql4tGdw0XLACIDjPOHnYeJjRE05dS/P7W
	3f2IjwDZR2RvWcpW9dWo9iXCq0BTJ1TDeZQHZ+vSuKaCdGolTvG79XdYiWwbnMHvuf/wrVDn2lK
	7kfV0fX3cM1pR8R0md3TEvwi0UU4j7BA3TyMl9D7mM5RbHu4MneX8ak6gyDXmYCKj1p2CFv1PKT
	1+4SWUux5UJ7mXOp/
X-Google-Smtp-Source: AGHT+IEiEweZTRYxv3sK/wtSw9+Wn7aTpqwZHxxNnN4vdNJd0x3yG4izQetcXext4kuho3bSSiXorw==
X-Received: by 2002:a05:600c:3149:b0:45b:47e1:ef79 with SMTP id 5b1f17b1804b1-45b517ddbedmr164675355e9.36.1756300797777;
        Wed, 27 Aug 2025 06:19:57 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm30170305e9.14.2025.08.27.06.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 06:19:56 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC v1 3/3] io_uring: introduce io_uring querying
Date: Wed, 27 Aug 2025 14:21:14 +0100
Message-ID: <6adf4bd06950d999f127595fe4d24d048ce03f5f.1756300192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756300192.git.asml.silence@gmail.com>
References: <cover.1756300192.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are many characteristics of a ring or the io_uring subsystem the
user wants to query. Sometimes it's needed to be done before there is a
created ring, and sometimes it's needed at runtime in a slow path.
Introduce a querying interface to achieve that.

It was written with several requirements in mind:
- Can be used with or without an io_uring instance.
- Can query multiple attributes in one syscall.
- Backward and forward compatible.
- Should be reasobably easy to use.
- Reduce the kernel code size for introducing new query types.

API: it's implemented as a new registration op IORING_REGISTER_QUERY.
The user passes one or more query strutctures, each represented by
struct io_uring_query_hdr. The header stores common control fields for
query processing and expected to be wrapped into a larger structure
that has opcode specific fields.

The header contains
- The query opcode
- The result field, which on return contains the error code for the query
- The size of the query structure. The kernel will only populate up to
  the size, which helps with backward compatibility. The kernel can also
  reduce the size, so if the current kernel is older than the inteface
  the user tries to use, it'll get only the supported bits.
- next_entry field is used to chain multiple queries.

The patch adds a single query type for now, i.e. IO_URING_QUERY_OPCODES,
which tells what register / request / etc. opcodes are supported, but
there are particular plans to extend it.

Note: there is a request probing interface via IORING_REGISTER_PROBE,
but it's a mess. It requires the user to create a ring first, it only
works for requests, and requires dynamic allocations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h       |  3 ++
 include/uapi/linux/io_uring/query.h | 40 ++++++++++++++
 io_uring/Makefile                   |  2 +-
 io_uring/query.c                    | 84 +++++++++++++++++++++++++++++
 io_uring/query.h                    |  9 ++++
 io_uring/register.c                 |  6 +++
 6 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/io_uring/query.h
 create mode 100644 io_uring/query.c
 create mode 100644 io_uring/query.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6957dc539d83..7a06da49e2cd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -665,6 +665,9 @@ enum io_uring_register_op {
 
 	IORING_REGISTER_MEM_REGION		= 34,
 
+	/* query various aspects of io_uring, see linux/io_uring/query.h */
+	IORING_REGISTER_QUERY			= 35,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
new file mode 100644
index 000000000000..ca58e88095ed
--- /dev/null
+++ b/include/uapi/linux/io_uring/query.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
+/*
+ * Header file for the io_uring query interface.
+ *
+ * Copyright (C) 2025 Pavel Begunkov
+ */
+#ifndef LINUX_IO_URING_QUERY_H
+#define LINUX_IO_URING_QUERY_H
+
+#include <linux/types.h>
+
+struct io_uring_query_hdr {
+	__u64 next_entry;
+	__u32 query_op;
+	__u32 size;
+	__s32 result;
+	__u32 __resv[3];
+};
+
+enum {
+	IO_URING_QUERY_OPCODES			= 0,
+
+	__IO_URING_QUERY_MAX,
+};
+
+/* Doesn't require a ring */
+struct io_uring_query_opcode {
+	struct io_uring_query_hdr hdr;
+
+	/* The number of supported IORING_OP_* opcodes */
+	__u32	nr_request_opcodes;
+	/* The number of supported IORING_[UN]REGISTER_* opcodes */
+	__u32	nr_register_opcodes;
+	/* Bitmask of all supported IORING_FEAT_* flags */
+	__u64	features;
+	/* Bitmask of all supported IORING_SETUP_* flags */
+	__u64	ring_flags;
+};
+
+#endif
diff --git a/io_uring/Makefile b/io_uring/Makefile
index b3f1bd492804..bc4e4a3fa0a5 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					sync.o msg_ring.o advise.o openclose.o \
 					statx.o timeout.o cancel.o \
 					waitid.o register.o truncate.o \
-					memmap.o alloc_cache.o
+					memmap.o alloc_cache.o query.o
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/query.c b/io_uring/query.c
new file mode 100644
index 000000000000..0ae9192f5a57
--- /dev/null
+++ b/io_uring/query.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "linux/io_uring/query.h"
+
+#include "query.h"
+#include "io_uring.h"
+
+#define IO_MAX_QUERY_SIZE		512
+
+static int io_query_ops(void *buffer)
+{
+	struct io_uring_query_opcode *e = buffer;
+
+	BUILD_BUG_ON(sizeof(struct io_uring_query_opcode) > IO_MAX_QUERY_SIZE);
+
+	e->hdr.size = min(e->hdr.size, sizeof(*e));
+	e->nr_request_opcodes = IORING_OP_LAST;
+	e->nr_register_opcodes = IORING_REGISTER_LAST;
+	e->features = IORING_FEATURES;
+	e->ring_flags = IORING_VALID_SETUP_FLAGS;
+	return 0;
+}
+
+static int io_handle_query_entry(struct io_ring_ctx *ctx,
+				 void *buffer,
+				 void __user *uentry, u64 *next_entry)
+{
+	struct io_uring_query_hdr *hdr = buffer;
+	size_t entry_size = sizeof(*hdr);
+	int ret = -EINVAL;
+
+	if (copy_from_user(hdr, uentry, sizeof(*hdr)) ||
+	    hdr->size <= sizeof(*hdr))
+		return -EFAULT;
+
+	if (hdr->query_op >= __IO_URING_QUERY_MAX) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+	if (!mem_is_zero(hdr->__resv, sizeof(hdr->__resv)) || hdr->result)
+		goto out;
+
+	hdr->size = min(hdr->size, IO_MAX_QUERY_SIZE);
+	if (copy_from_user(buffer + sizeof(*hdr), uentry + sizeof(*hdr),
+			   hdr->size - sizeof(*hdr)))
+		return -EFAULT;
+
+	switch (hdr->query_op) {
+	case IO_URING_QUERY_OPCODES:
+		ret = io_query_ops(buffer);
+		break;
+	}
+	if (!ret)
+		entry_size = hdr->size;
+out:
+	hdr->result = ret;
+	hdr->size = entry_size;
+	if (copy_to_user(uentry, buffer, entry_size))
+		return -EFAULT;
+	*next_entry = hdr->next_entry;
+	return 0;
+}
+
+int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
+{
+	char entry_buffer[IO_MAX_QUERY_SIZE];
+	void __user *uentry = arg;
+	int ret;
+
+	memset(entry_buffer, 0, sizeof(entry_buffer));
+
+	if (nr_args)
+		return -EINVAL;
+
+	while (uentry) {
+		u64 next;
+
+		ret = io_handle_query_entry(ctx, entry_buffer, uentry, &next);
+		if (ret)
+			return ret;
+		uentry = u64_to_user_ptr(next);
+	}
+	return 0;
+}
diff --git a/io_uring/query.h b/io_uring/query.h
new file mode 100644
index 000000000000..171d47ccaaba
--- /dev/null
+++ b/io_uring/query.h
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IORING_QUERY_H
+#define IORING_QUERY_H
+
+#include <linux/io_uring_types.h>
+
+int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args);
+
+#endif
diff --git a/io_uring/register.c b/io_uring/register.c
index 046dcb7ba4d1..6777bfe616ea 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -31,6 +31,7 @@
 #include "msg_ring.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "query.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -835,6 +836,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_mem_region(ctx, arg);
 		break;
+	case IORING_REGISTER_QUERY:
+		ret = io_query(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -904,6 +908,8 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 	switch (opcode) {
 	case IORING_REGISTER_SEND_MSG_RING:
 		return io_uring_register_send_msg_ring(arg, nr_args);
+	case IORING_REGISTER_QUERY:
+		return io_query(NULL, arg, nr_args);
 	}
 	return -EINVAL;
 }
-- 
2.49.0


