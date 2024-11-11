Return-Path: <io-uring+bounces-4588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D3B9C3641
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 02:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 348CD1F21E56
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 01:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 871C22BD11;
	Mon, 11 Nov 2024 01:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMQP8jJt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917CD191
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 01:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731289809; cv=none; b=r0Nwh/DMCQfzwarzv4lup9iRF8rtdSpi79yFb+lfNvGhD2OWkRiulMU/lKGSIlJ+n3W5K4WIU5dRPBT4d9y/JihBnlo69N96txkfLQAc7YLr7U3AqARNIfdEYZXk6JwZOSk38teJ7z5rvzoPSnNU5eGS+gNkRXWjsqzpEQ7jNPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731289809; c=relaxed/simple;
	bh=iH6qTgZ44UH25t0wCGPZLsz3M4EypapHwV/Mp50Tt/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHu1m54lvVYj936C84XBaObA1iaF629cBuJxW8ma/PUr/+yQSCEQLGL+OxrfwPsXoks6fugOo+iqMo5d8iHEOp6HJXE/DaHScY9d5q5PNi/dEO0zUEF02kW4P0QSh+0eaPRCcYL5F/ajOnbf+p+7GssYCRso7fRAGaxysYZiYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMQP8jJt; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4314fa33a35so31927555e9.1
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 17:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731289806; x=1731894606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6L78z4Hh26abEH1CPBN8l+aYUegXdN+Rj7ZXyVTb2I=;
        b=MMQP8jJtprCcKDMUBdzgjlz/dXZBj+gM2wHD5PINUzOZzalxg+dcbVY7t8r64nhred
         D4c/Zi5Qx9nPYxOsxBYGxyn61UPZBfKwT9riLmgZzBYZg+1eFXUZ+m20FXPusFJoe7pD
         qCmmdggD45MXZLdeCCEKAKyCt3ia6bOOlvvbmWxRhh3fXmWuGz5wJYOm7UvQwFUcLSU2
         E088PMAbf3yvrc8Sl65muaRlfUYcJupoPBy0xCDMaGjpedjB59AlMUh3kScEpaqce7dU
         Eg4xzi5nF758PddZzOBp6t9lNvk2vMxZt2BjU31jyHn1kZcO+83sjwLhrvYaXCRPIByM
         j7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731289806; x=1731894606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j6L78z4Hh26abEH1CPBN8l+aYUegXdN+Rj7ZXyVTb2I=;
        b=q8N6XlcepWiL6kAl4JfsBiz6UWURtti6b8boPZ6l3v+wKjWO1jmNHRMbwwKo8Q6Wx6
         TEYrTsQXmvB55oMnL1OOnAnpEdJ3OyCyC/gcyM3VyI56OBoi85+i9IB4w9dEpIAWRXLu
         BK657jWUC5NXv6a0G2sMw32NXYujB5ODmOp7BOuS+REVWNeeaLhGuYXPVOGMmpISSVNN
         GDZwBqW0vWVdv2q6WVqaf1KEm9+6NGPaf5cn/B1i/eYfIx4Pl5lQSVToA9LvmdQWKPn5
         ZnT+2Aki1KiyaXOKDROpo+wmpFyCGCRgYnZI8yjeyvWJMUj9AiqPx1G0RNNsc/ywAwwg
         dslA==
X-Gm-Message-State: AOJu0YyFMHC882aSqz2Gy03YhyWYdGxp8Kudd1nbbla61FgKGJZSSYP2
	1N3Stds3hpIx3EGhBSEgAS2+NGBozFbUfiQGnQBzl1dH3Dqg2/OfmzJbpA==
X-Google-Smtp-Source: AGHT+IGBh4erGzcw5Ev2sh8F/HfTNh3A0/jAguGsWgNvecyw6dVWeyh92MG/FgDc/ZzSPFBn9/xIBQ==
X-Received: by 2002:a05:600c:3c9c:b0:431:588a:4498 with SMTP id 5b1f17b1804b1-432b7501d07mr94307345e9.14.1731289805485;
        Sun, 10 Nov 2024 17:50:05 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c18e0sm161494685e9.28.2024.11.10.17.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 17:50:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 2/3] io_uring/bpf: allow to register and run BPF programs
Date: Mon, 11 Nov 2024 01:50:45 +0000
Message-ID: <cffec449e9f6a37b0701f2a8fdd37688db25be55.1731285516.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731285516.git.asml.silence@gmail.com>
References: <cover.1731285516.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let the user to register a BPF_PROG_TYPE_IOURING BPF program to a ring.
The progrma will be run in the waiting loop every time something
happens, i.e. the task was woken up by a task_work / signal / etc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  4 +++
 include/uapi/linux/io_uring.h  |  9 +++++
 io_uring/bpf.c                 | 63 ++++++++++++++++++++++++++++++++++
 io_uring/bpf.h                 | 41 ++++++++++++++++++++++
 io_uring/io_uring.c            | 15 ++++++++
 io_uring/register.c            |  7 ++++
 6 files changed, 139 insertions(+)
 create mode 100644 io_uring/bpf.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ad5001102c86..50cee0d3622e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -8,6 +8,8 @@
 #include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
+struct io_bpf_ctx;
+
 enum {
 	/*
 	 * A hint to not wake right away but delay until there are enough of
@@ -246,6 +248,8 @@ struct io_ring_ctx {
 
 		enum task_work_notify_mode	notify_method;
 		unsigned			sq_thread_idle;
+
+		struct io_bpf_ctx		*bpf_ctx;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ba373deb8406..f2c2fefc8514 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -634,6 +634,8 @@ enum io_uring_register_op {
 	/* register fixed io_uring_reg_wait arguments */
 	IORING_REGISTER_CQWAIT_REG		= 34,
 
+	IORING_REGISTER_BPF			= 35,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -905,6 +907,13 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SETSOCKOPT,
 };
 
+struct io_uring_bpf_reg {
+	__u64		prog_fd;
+	__u32		flags;
+	__u32		resv1;
+	__u64		resv2[2];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 6eb0c47b4aa9..8b7c74761c63 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/bpf.h>
+#include <linux/filter.h>
+
+#include "bpf.h"
 
 static const struct bpf_func_proto *
 io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
@@ -22,3 +25,63 @@ const struct bpf_verifier_ops bpf_io_uring_verifier_ops = {
 	.get_func_proto			= io_bpf_func_proto,
 	.is_valid_access		= io_bpf_is_valid_access,
 };
+
+int io_run_bpf(struct io_ring_ctx *ctx)
+{
+	struct io_bpf_ctx *bc = ctx->bpf_ctx;
+	int ret;
+
+	mutex_lock(&ctx->uring_lock);
+	ret = bpf_prog_run_pin_on_cpu(bc->prog, bc);
+	mutex_unlock(&ctx->uring_lock);
+	return ret;
+}
+
+int io_unregister_bpf(struct io_ring_ctx *ctx)
+{
+	struct io_bpf_ctx *bc = ctx->bpf_ctx;
+
+	if (!bc)
+		return -ENXIO;
+	bpf_prog_put(bc->prog);
+	kfree(bc);
+	ctx->bpf_ctx = NULL;
+	return 0;
+}
+
+int io_register_bpf(struct io_ring_ctx *ctx, void __user *arg,
+		    unsigned int nr_args)
+{
+	struct __user io_uring_bpf_reg *bpf_reg_usr = arg;
+	struct io_uring_bpf_reg bpf_reg;
+	struct io_bpf_ctx *bc;
+	struct bpf_prog *prog;
+
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EOPNOTSUPP;
+
+	if (nr_args != 1)
+		return -EINVAL;
+	if (copy_from_user(&bpf_reg, bpf_reg_usr, sizeof(bpf_reg)))
+		return -EFAULT;
+	if (bpf_reg.flags || bpf_reg.resv1 ||
+	    bpf_reg.resv2[0] || bpf_reg.resv2[1])
+		return -EINVAL;
+
+	if (ctx->bpf_ctx)
+		return -ENXIO;
+
+	bc = kzalloc(sizeof(*bc), GFP_KERNEL);
+	if (!bc)
+		return -ENOMEM;
+
+	prog = bpf_prog_get_type(bpf_reg.prog_fd, BPF_PROG_TYPE_IOURING);
+	if (IS_ERR(prog)) {
+		kfree(bc);
+		return PTR_ERR(prog);
+	}
+
+	bc->prog = prog;
+	ctx->bpf_ctx = bc;
+	return 0;
+}
diff --git a/io_uring/bpf.h b/io_uring/bpf.h
new file mode 100644
index 000000000000..2b4e555ff07a
--- /dev/null
+++ b/io_uring/bpf.h
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_BPF_H
+#define IOU_BPF_H
+
+#include <linux/io_uring/bpf.h>
+#include <linux/io_uring_types.h>
+
+struct bpf_prog;
+
+struct io_bpf_ctx {
+	struct io_bpf_ctx_kern kern;
+	struct bpf_prog *prog;
+};
+
+static inline bool io_bpf_enabled(struct io_ring_ctx *ctx)
+{
+	return IS_ENABLED(CONFIG_BPF) && ctx->bpf_ctx != NULL;
+}
+
+#ifdef CONFIG_BPF
+int io_register_bpf(struct io_ring_ctx *ctx, void __user *arg,
+		    unsigned int nr_args);
+int io_unregister_bpf(struct io_ring_ctx *ctx);
+int io_run_bpf(struct io_ring_ctx *ctx);
+
+#else
+static inline int io_register_bpf(struct io_ring_ctx *ctx, void __user *arg,
+				  unsigned int nr_args)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_unregister_bpf(struct io_ring_ctx *ctx)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_run_bpf(struct io_ring_ctx *ctx)
+{
+}
+#endif
+
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f34fa1ead2cf..82599e2a888a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -104,6 +104,7 @@
 #include "rw.h"
 #include "alloc_cache.h"
 #include "eventfd.h"
+#include "bpf.h"
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
@@ -2834,6 +2835,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 	io_napi_busy_loop(ctx, &iowq);
 
+	if (io_bpf_enabled(ctx)) {
+		ret = io_run_bpf(ctx);
+		if (ret == IOU_BPF_RET_STOP)
+			return 0;
+	}
+
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		unsigned long check_cq;
@@ -2879,6 +2886,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		if (ret < 0)
 			break;
 
+		if (io_bpf_enabled(ctx)) {
+			ret = io_run_bpf(ctx);
+			if (ret == IOU_BPF_RET_STOP)
+				break;
+			continue;
+		}
+
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
 			/* let the caller flush overflows, retry */
@@ -3009,6 +3023,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	io_unregister_cqwait_reg(ctx);
+	io_unregister_bpf(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
diff --git a/io_uring/register.c b/io_uring/register.c
index 45edfc57963a..2a8efeacf2db 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -30,6 +30,7 @@
 #include "eventfd.h"
 #include "msg_ring.h"
 #include "memmap.h"
+#include "bpf.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -846,6 +847,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_cqwait_reg(ctx, arg);
 		break;
+	case IORING_REGISTER_BPF:
+		ret = -EINVAL;
+		if (!arg)
+			break;
+		ret = io_register_bpf(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.46.0


