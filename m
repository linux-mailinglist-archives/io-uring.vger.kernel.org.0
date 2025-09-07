Return-Path: <io-uring+bounces-9634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B139EB48129
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 01:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E80C175E2B
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 23:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A8B190477;
	Sun,  7 Sep 2025 23:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QvNNp6vc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C020315D25
	for <io-uring@vger.kernel.org>; Sun,  7 Sep 2025 23:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757286131; cv=none; b=pXc3oy14USFOoTxad0SgAtxbL9TSiCIQgU/jjengGhwqS/w9cwDCSb3udJ3Wo+4T2+T/RAz2OI1VhcwiSqXHoGZUASRp1qJhQN6IyUfFW9PIeQ+jaKpYS4Hn8OZwUG+KM82jhN+WjV4ovAr+mCtYPbuHIIkUeTc/6grkE8CvkVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757286131; c=relaxed/simple;
	bh=QwmjO9GA9ZmRLLeGLmY/HoT2EFtfHFOHt5ixJM9BqWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXRpwVQbAQmc0krzfkGc/qHnvfB+t4T0BKedf1G6V/lapNBXaj7AnsH0FHC1/Qb5KA8VDflHIpiU3YPOS7Zbf9s6Pv9D0I6SXiUrwWxr3nv9pLYFl4Y+KjE72FBMWSqe7ricdjjhKwsUrUkqs1mGyzI4kr3Rj3t7SrKZPlyrPVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QvNNp6vc; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6237202020bso2223022a12.3
        for <io-uring@vger.kernel.org>; Sun, 07 Sep 2025 16:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757286127; x=1757890927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=off6k0vyMUXLgGIElNc84I3uVJv8q2jz1JmlDI9xgv8=;
        b=QvNNp6vcVjDoZ54Jz1MkSCXruaGZSQA2bT6VNxChP3kBSksVvJhFAGEjaEdOKvCEh+
         FU7dMWEHrAtuKwpdSjPC6XW1izvcy4mIKtoJdK5GVNKaWDxvH0pntmX213m2bWM0NsY7
         myh8iGymqPGVmrqU90BhV7hR6kDnMU5lWu0XRt9iQttd5ELWJlL2D1t3s23dkuglw4r4
         Qrjk2NF0tMN0vYDbPvsT2FsvcGFsJWgkYyH2sunL+QvPn3DyCSDra9euCZug8Qcm28I8
         CoTegbFsiHxA5PCB8sx/MnS1gVZ8YbI+wZWtpkO3iimHQIKa4uNR1KHfskhM34w1DTwf
         6jSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757286127; x=1757890927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=off6k0vyMUXLgGIElNc84I3uVJv8q2jz1JmlDI9xgv8=;
        b=K/ngdYC9qM4W8BPqN/FV9fPzDv4eRlcocaEH/UI3Fw0ZK8hakIVSvUUqJk6PpKJlo6
         aS6MGd6t2U5j5N0mlJoD9ihWONePZDq4dQtUUWvgVQBXL+RLph97bPzbccHkoxMVJeSc
         Khv45rCLECr0rk303mVreNu+sx2Nr9MnvEXG4ZXyH9Dy6QioYVqBgvwibou2lD0AH76U
         hVb02MDgrAD4KfWVMeIK0G63MksqGgx1dioXmjtR/Iprr1Msg2l6SnxYv3V9nG3ONlYd
         NxDES0DKXYEkt6PVsr0OoqjJWwzjBse3lDLaJypmsiy6rNYnH/9AU5bBsFWFpw04Gf+N
         UlgQ==
X-Gm-Message-State: AOJu0YwzBrt7J3hKoiRYna9R9jWyCBXxZCyPvH9dDDlXBy33e1mirb+C
	+NqvxXsSbBjjsoPsxbqgwxq5F2YVpYnRvhL/a2HSOrFmLpjtQrJSYCWpgSJm9w==
X-Gm-Gg: ASbGncvIxyfcKoEj/nycDGM126xvNsuCuPK96jZgYXRnnYVSxBPlFH6H9wgS/xhm9C9
	faU+v42D8XMqz49sIfmQVOylVYJhfeS8EZhaW3An+13vFcQysG1oszut7EIKhFwW03wJUfo8mil
	33zWYkEBl8hmV1Eno50IHnDclruSNOPAQiAN2/Jm0qi7Hv+zbufHTvfRr11XcqT4zCrNe1nogHt
	WvzgDwxeR4NtB5UxXDIiJwk4dnHw3aIhS+14NTJHvA+LiRr4MVa9OTF7CF0SCzcHXuM/judZEHh
	uXnIKcDto/c+8bcj3MU3PO1rjzWl7kox6/3QehP6r2KgK97Jkh2yaMkwoFzQ9HatIg1SvdvezyU
	tWfnzU4KqA1ngLJ28yaXVzhLmEuXYIbXXzUvD
X-Google-Smtp-Source: AGHT+IGTPZ/3HjROIOOixqBY0EcuCD2kAYTkFQHaoXLuWNexzoDjaX45jtGP/xO6R/84qZvjupA//A==
X-Received: by 2002:a05:6402:2787:b0:629:8c4d:6a91 with SMTP id 4fb4d7f45d1cf-6298c4d6ce1mr91701a12.3.1757286126875;
        Sun, 07 Sep 2025 16:02:06 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.138])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-625ef80347asm3363570a12.1.2025.09.07.16.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 16:02:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 3/3] io_uring: introduce io_uring querying
Date: Mon,  8 Sep 2025 00:03:00 +0100
Message-ID: <fdfcfef946121c2bb16482866eb2379cc4b7e63e.1757286089.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757286089.git.asml.silence@gmail.com>
References: <cover.1757286089.git.asml.silence@gmail.com>
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

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h       |  3 +
 include/uapi/linux/io_uring/query.h | 41 +++++++++++++
 io_uring/Makefile                   |  2 +-
 io_uring/query.c                    | 93 +++++++++++++++++++++++++++++
 io_uring/query.h                    |  9 +++
 io_uring/register.c                 |  6 ++
 6 files changed, 153 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/io_uring/query.h
 create mode 100644 io_uring/query.c
 create mode 100644 io_uring/query.h

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 04ebff33d0e6..1ce17c535944 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -686,6 +686,9 @@ enum io_uring_register_op {
 
 	IORING_REGISTER_MEM_REGION		= 34,
 
+	/* query various aspects of io_uring, see linux/io_uring/query.h */
+	IORING_REGISTER_QUERY			= 35,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
new file mode 100644
index 000000000000..5d754322a27c
--- /dev/null
+++ b/include/uapi/linux/io_uring/query.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
+/*
+ * Header file for the io_uring query interface.
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
index 50ce87928be0..9c31a8afb83d 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -31,6 +31,7 @@
 #include "msg_ring.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "query.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -832,6 +833,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_mem_region(ctx, arg);
 		break;
+	case IORING_REGISTER_QUERY:
+		ret = io_query(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -901,6 +905,8 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
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


