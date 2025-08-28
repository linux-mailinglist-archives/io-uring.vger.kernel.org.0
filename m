Return-Path: <io-uring+bounces-9389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C4AB3986E
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 11:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3631D1C2737A
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B65283FD0;
	Thu, 28 Aug 2025 09:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1w91ItT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525C828AAE6
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 09:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373900; cv=none; b=G29IS3VMglO/t7xycimndBc6xdI2PvzYMllMgzyadKOAAEBks8rZMl6WIYAW2qY+sF40xbVCyxsdt4DgO6jo775RlNanJbFhBj9ZeZBlHGlipGltqcWRosuPF5bHhW/zlVluAbSiff8SSaX9XIU5fFb3LI2uw/BaAX3cm9h+NAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373900; c=relaxed/simple;
	bh=a3KcDdXGQ7N9u9/9TjEOSpFSUJDCoWfGMEbcsUGVUlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oskVoC71znVWQNZ0jNUFDZKTIANoUKH/otTj15okkNXfKFyAtv1cX7elZNGLq4Ugmcja4Ol54RErjREXQB8U1oa6XNu7RKYcQ/4V/OeLf1Ooe8y6QGJl2xSJcsFI4DE3XXiuzw4ChL52fkSjNRjPBvHUpneKO3RiWcvpKHdOiyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W1w91ItT; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3cbb0df3981so322522f8f.3
        for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 02:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756373896; x=1756978696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=reuCo27KF9jUtvc9/V0bW4P3wo+cNzsgcu0HAVid6f4=;
        b=W1w91ItT8MWsjkRgeuDrgJCjRPRj8W1I9EoYarWp4z+wcpoK65zVwnhj+/JzvvndNt
         xvYRYRGIXhX4j/mSUAOngHCmn9ZtmBKNRvxN+KdhcfgXz7Jf/zn5/c4UDBz20LLya++W
         71ZeFXDRd79gLlAUD2MD5qdQFL8PQVm/1qE3r1DXtpqQB1VtA915Iw2SqVLAw+paCCx0
         JK963zjuZc1uaBBPZvxeURVr0XZYrzi1JQTRme2CEkn9/BaDK8eF68vUArgPWq+T//tF
         gZp+3a2Hpi49SQ/rGGq9NsO25cIrM9mFZ72c81raRia8amlAq9xgkhwwtFYKQkwxKoYN
         OnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756373896; x=1756978696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=reuCo27KF9jUtvc9/V0bW4P3wo+cNzsgcu0HAVid6f4=;
        b=BU2dLGu4nzrarTyHXfhJZ/7wBbpNjLeI94rgpXJLQHucVUKhTmHGphnJTPDPGaUQI3
         iaPlctgS3ZMIzQSwdEHyQOnHY9z1YQ/VJ8cIN182JDBtrRGxt+RFzLRPCxMa3dXl5iIy
         ijFOEQeWD5YVH0qGL/K/Kc+vJ7ywqACf4pv5gAOGWjIzD+ZHZEpwVurtT/5gxYYRof6U
         AImFnavNgLyvg8j8H496OLAX9uVtmS+tKwR4tNp7Wnk7xjZEKZt6Qm8JQRt8wrxZMvB0
         0zcHog0QoRsYEJhdhw+lEvtL55W3KjENudW0n10sORcG6GJlLQ2RVCjGNfZoczMmLdKH
         9rnw==
X-Gm-Message-State: AOJu0YxKPnPxgt084EEFwsQJjFzlCGBCOeuw8OBtaN9KJRX17NuuAICN
	6OwqeA+h0U1BGzrswY6CGhAiv8IFpdh29EC5zF/YmzM3oeHzeDHhMkuraOD7Ow==
X-Gm-Gg: ASbGncsIMm6AbBK+4Hl2OSjPMD/UwNXJjznwpfAJsSnfEP96YZ2i1jtt76uA0X5lFsc
	enaBpgEB8C3tLlXKBHfmzRi3QJTGrWhd7KbY7t2OQMV+LHQvIF9ajE0v8K0JvevXhCXsZ9JcwvT
	r47z8NdmKF25Qs8onlKVrkNbocMNVutPuUr4+4cCgSCechT20UIjk5QD7THNYYNpr7jOHPLmSn+
	ucHGq+Z5kqfjJLhNcxq94Y+/3ZW23hhXCco+cCgTvrsXOob8Q0CX6+5T7E8Zs7i1qCu/nnaYMNX
	KTIu1cEwRQ/SOSb2F5v4lGrDAK1CSY+b00r4LYo+yBNzbMWUN/+xdxvJnNVRz5JhmEOa93NfZv2
	MjRcpqbQeyhxUi+fn
X-Google-Smtp-Source: AGHT+IFbGIsGw/oxfjoe/J5ni/QcF8c8kiGLGHXAsANiN8ryhH2jJkOzaYVvwxUQWT2xjxMZHy8SZg==
X-Received: by 2002:a05:6000:310b:b0:3a4:f70e:abda with SMTP id ffacd0b85a97d-3c5db8aae86mr16949301f8f.10.1756373895998;
        Thu, 28 Aug 2025 02:38:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:68ae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b797e5499sm24331455e9.21.2025.08.28.02.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 02:38:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 3/3] io_uring: introduce io_uring querying
Date: Thu, 28 Aug 2025 10:39:28 +0100
Message-ID: <11f48101c2e710d1073651be5480a123b28b10d7.1756373946.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756373946.git.asml.silence@gmail.com>
References: <cover.1756373946.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are many parameters users might want to query about io_uring like
available request types or the ring sizes. This patch introduces an
interface for such slow path queries.

It was written with several requirements in mind:
- Can be used with or without an io_uring instance. Asking for supported
  setup flags before creating an instance as well as qeurying info about
  an already created ring are valid use cases.
- Should be moderately fast. For example, users might use it to
  periodically retrieve ring attributes at runtime. As a consequence,
  it should be able to query multiple attributes in a single syscall.
- Backward and forward compatible.
- Should be reasobably easy to use.
- Reduce the kernel code size for introducing new query types.

It's implemented as a new registration opcode IORING_REGISTER_QUERY.
The user passes one or more query strutctures linked together, each
represented by struct io_uring_query_hdr. The header stores common
control fields needed for processing and points to query type specific
information.

The header contains
- The query type
- The result field, which on return contains the error code for the query
- Pointer to the query type specific information
- The size of the query structure. The kernel will only populate up to
  the size, which helps with backward compatibility. The kernel can also
  reduce the size, so if the current kernel is older than the inteface
  the user tries to use, it'll get only the supported bits.
- next_entry field is used to chain multiple queries.

Apart from common registeration syscall failures, it can only immediately
return an error code in case when the headers are incorrect or any
other addresses and invalid. That usually mean that the userspace
doesn't use the API right and should be corrected. All query type
specific errors are returned in the header's result field.

As an example, the patch adds a single query type for now, i.e.
IO_URING_QUERY_OPCODES, which tells what register / request / etc.
opcodes are supported, but there are particular plans to extend it.

Note: there is a request probing interface via IORING_REGISTER_PROBE,
but it's a mess. It requires the user to create a ring first, it only
works for requests, and requires dynamic allocations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h       |  3 +
 include/uapi/linux/io_uring/query.h | 44 ++++++++++++++
 io_uring/Makefile                   |  2 +-
 io_uring/query.c                    | 93 +++++++++++++++++++++++++++++
 io_uring/query.h                    |  9 +++
 io_uring/register.c                 |  6 ++
 6 files changed, 156 insertions(+), 1 deletion(-)
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
index 000000000000..e8582314b1fa
--- /dev/null
+++ b/include/uapi/linux/io_uring/query.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
+/*
+ * Header file for the io_uring query interface.
+ *
+ * Copyright (c) 2025 Meta Platforms, Inc. and affiliates.
+ * Copyright (C) 2025 Pavel Begunkov
+ */
+#ifndef LINUX_IO_URING_QUERY_H
+#define LINUX_IO_URING_QUERY_H
+
+#include <linux/types.h>
+
+struct io_uring_query_hdr {
+	__u64 next_entry;
+	__u64 query_data;
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
+	/* The number of supported IORING_OP_* opcodes */
+	__u32	nr_request_opcodes;
+	/* The number of supported IORING_[UN]REGISTER_* opcodes */
+	__u32	nr_register_opcodes;
+	/* Bitmask of all supported IORING_FEAT_* flags */
+	__u64	feature_flags;
+	/* Bitmask of all supported IORING_SETUP_* flags */
+	__u64	ring_setup_flags;
+	/* Bitmask of all supported IORING_ENTER_** flags */
+	__u64	enter_flags;
+	/* Bitmask of all supported IOSQE_* flags */
+	__u64	sqe_flags;
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
index 000000000000..9eed0f371956
--- /dev/null
+++ b/io_uring/query.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "linux/io_uring/query.h"
+
+#include "query.h"
+#include "io_uring.h"
+
+#define IO_MAX_QUERY_SIZE		(sizeof(struct io_uring_query_opcode))
+
+static ssize_t io_query_ops(void *data)
+{
+	struct io_uring_query_opcode *e = data;
+
+	BUILD_BUG_ON(sizeof(*e) > IO_MAX_QUERY_SIZE);
+
+	e->nr_request_opcodes = IORING_OP_LAST;
+	e->nr_register_opcodes = IORING_REGISTER_LAST;
+	e->feature_flags = IORING_FEAT_FLAGS;
+	e->ring_setup_flags = IORING_SETUP_FLAGS;
+	e->enter_flags = IORING_ENTER_FLAGS;
+	e->sqe_flags = SQE_VALID_FLAGS;
+	return sizeof(*e);
+}
+
+static int io_handle_query_entry(struct io_ring_ctx *ctx,
+				 void *data, void __user *uhdr,
+				 u64 *next_entry)
+{
+	struct io_uring_query_hdr hdr;
+	size_t usize, res_size = 0;
+	ssize_t ret = -EINVAL;
+	void __user *udata;
+
+	if (copy_from_user(&hdr, uhdr, sizeof(hdr)))
+		return -EFAULT;
+	usize = hdr.size;
+	hdr.size = min(hdr.size, IO_MAX_QUERY_SIZE);
+	udata = u64_to_user_ptr(hdr.query_data);
+
+	if (hdr.query_op >= __IO_URING_QUERY_MAX) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+	if (!mem_is_zero(hdr.__resv, sizeof(hdr.__resv)) || hdr.result || !hdr.size)
+		goto out;
+	if (copy_from_user(data, udata, hdr.size))
+		return -EFAULT;
+
+	switch (hdr.query_op) {
+	case IO_URING_QUERY_OPCODES:
+		ret = io_query_ops(data);
+		break;
+	}
+
+	if (ret >= 0) {
+		if (WARN_ON_ONCE(ret > IO_MAX_QUERY_SIZE))
+			return -EFAULT;
+		res_size = ret;
+		ret = 0;
+	}
+out:
+	hdr.result = ret;
+	hdr.size = min_t(size_t, usize, res_size);
+
+	if (copy_struct_to_user(udata, usize, data, hdr.size, NULL))
+		return -EFAULT;
+	if (copy_to_user(uhdr, &hdr, sizeof(hdr)))
+		return -EFAULT;
+	*next_entry = hdr.next_entry;
+	return 0;
+}
+
+int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
+{
+	char entry_buffer[IO_MAX_QUERY_SIZE];
+	void __user *uhdr = arg;
+	int ret;
+
+	memset(entry_buffer, 0, sizeof(entry_buffer));
+
+	if (nr_args)
+		return -EINVAL;
+
+	while (uhdr) {
+		u64 next_hdr;
+
+		ret = io_handle_query_entry(ctx, entry_buffer, uhdr, &next_hdr);
+		if (ret)
+			return ret;
+		uhdr = u64_to_user_ptr(next_hdr);
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


