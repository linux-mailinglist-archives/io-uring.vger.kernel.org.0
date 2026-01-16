Return-Path: <io-uring+bounces-11764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECB7D3896A
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:44:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 25044302FA2E
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 22:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84BE2F5485;
	Fri, 16 Jan 2026 22:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Y9ep4x3a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05C82F0C7A
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 22:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768603443; cv=none; b=lbqAloeDqOWxblBdrewhcnv/t/V07zLEt2qvEYrGF1w5UIwCOcFmTkUtrVT73HyxXtuj3AofdN12hzyjKFoZyuOpbxRjNr1yoDWEP5qUCzEXoVX5yJ/m1f48GsEq6u1c17nnu86TgXW7+UExEyq5zx4oGBAQGZsJRTuvx8dH5WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768603443; c=relaxed/simple;
	bh=ghT2zNKV+HmGbFMQiZDUPBcfHXUMjQ+4hXh5KF6XDvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaD1ern6ze5mndc1vj2XvUStO9u2OgI4bSBBlvOk+E8G0R4A0O1E6B7kji8PxRtusIYa1qmunVFFnyHdyvscBvh2MdGJ9gmcSZCMxkvweeoiccXydVCnzIxZ3stK6bGr7drqJseSshHOZ4etjPK3cKrfyGYMYjBP0hpKQu3woh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Y9ep4x3a; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-45c733ccc32so1590727b6e.0
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 14:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768603440; x=1769208240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BSMLBrVGmQwmMBzyEMDyRdebFYrf80Je1Zh1LXldz0w=;
        b=Y9ep4x3al2wO4gv0DUfsy4w9pVzulTDmRDNMzWqqQrad6Q5eLW8+5rC6giwfhMPICa
         jsiMOwMk7padybzXRhnXGp27r4ZdihPFX0KqCOoMwYI557PQk29JG3c0mnNEHTrQ1RQ4
         pEb1kKKKBPvnW7ZUnRLebMQeR9zkle2G/VHFYEr7vYrzJtS26lFjR9+P5MWb0u7tq+Wg
         h4ZokhMY7azX8weUcWX/AqBwaaAXLdCppScrHG+epmszQACr/PEM7o6dN79hM4G0wQbs
         1cegOcItaEaF9OcHkz7nGUJNzE5mn4BEiP7DbRo/Dkw4sUoR0Up3DzsT/gcl7jfzXYpV
         CRzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768603440; x=1769208240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BSMLBrVGmQwmMBzyEMDyRdebFYrf80Je1Zh1LXldz0w=;
        b=N8Df3JKWs09kj0z12xHnwqiHhweEUxGYCsnjBne7cPbpcRiIkGgM4MU8xH2yIhFzCy
         F41me1yLM7CbRP44Iex0IDWTS1OQXaPZOkZBX4d+CD3CDTWit+VvjI3FuYXtgT2ytrWP
         D8iZpWPkmuvQOyej60mPRfZqhmh4ffwRiKClNPsKu1s8Q9G4feMEXsc6/uGcgapQABTJ
         8/J9azWZgqSgI25ZElR4z01xoSCsZNAuiHFRUWW18sIcaFdPR3TEp8YNbUt4ur0j6Ocz
         0772KgbXJO1lBhhrOFX7DVbZARW1PSE3RceR/fgdQegPeZxneNc5a4cow8PALzDOH/XW
         QFFA==
X-Gm-Message-State: AOJu0Yxyf824G5FgHAqx9q1DHcK+8p5vNDhKDcNy0iLH2OW12fMr2kZ8
	lNBZFxY/j/34DUojinvEC5hQDmjA0WvZ4lMG1xe8SMEdObyE0A9qR1JN/pYGSSvF37Ez6AZ8Tg+
	wr7ok
X-Gm-Gg: AY/fxX4/kw3B9sMsZ0NGmrl5uLHDh+UhSMO7kLlZMFIWvkw6TLDnDG+SD1COvyAK/yv
	DEhZ5xx89HFXJ3DxpXrgLdPpoiNNW+qmtexToPzNwceMEcWWt6N5ei4wwAjn2khgMAPnFU3nJy0
	Pl4wzIVkGLYH9t7e4M0O8wRV4PtPvJOGu+tRUe5u0t/5cWc7qIDYLpf12/4obig0DY+tP+qQl/A
	/Jr+pwTfg9AWt1JzwYT5s1u8vbrln6FMaDOC0lQ/KUeNOWhRfln5nl7D8MS7J0XUl1xwoxIuATr
	4fs1Y7XL7mGIui+B2nA/rWekFvMCfVsEIbpDmJO3rPtCTM27OqlD7IiFh838GFQ6CERZiiZ0GG4
	vptSRNbJMXNC11QmhsC34modD2iCuzsT1UF6YZRtm3zSxw2HIHgZVMLE1l6YS5e2Xxj+ro3eHHX
	5M0jF67qGLxN4WcrSXbGZrCyR8kjuLM9XpFkoLSkGhRW+Qc23/gm+X/LDf
X-Received: by 2002:a05:6808:1495:b0:455:eba2:9eca with SMTP id 5614622812f47-45c9c009241mr2174522b6e.26.1768603439635;
        Fri, 16 Jan 2026 14:43:59 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dec9ebcsm1945098b6e.2.2026.01.16.14.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:43:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: add support for BPF filtering for opcode restrictions
Date: Fri, 16 Jan 2026 15:38:38 -0700
Message-ID: <20260116224356.399361-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260116224356.399361-1-axboe@kernel.dk>
References: <20260116224356.399361-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds support for loading BPF programs with io_uring, which can
restrict the opcodes executed. Unlike IORING_REGISTER_RESTRICTIONS,
using BPF programs allow fine grained control over both the opcode in
question, as well as other data associated with the request. This
initial patch just supports whatever is in the io_kiocb for filtering,
but shortly opcode specific support will be added.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/bpf.h            |   1 +
 include/linux/bpf_types.h      |   4 +
 include/linux/io_uring_types.h |  14 ++
 include/uapi/linux/bpf.h       |   1 +
 include/uapi/linux/io_uring.h  |  38 +++++
 io_uring/Makefile              |   1 +
 io_uring/bpf_filter.c          | 285 +++++++++++++++++++++++++++++++++
 io_uring/bpf_filter.h          |  40 +++++
 io_uring/io_uring.c            |   8 +
 io_uring/register.c            |   8 +
 kernel/bpf/syscall.c           |   9 ++
 11 files changed, 409 insertions(+)
 create mode 100644 io_uring/bpf_filter.c
 create mode 100644 io_uring/bpf_filter.h

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e5be698256d1..9b4435452458 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -31,6 +31,7 @@
 #include <linux/static_call.h>
 #include <linux/memcontrol.h>
 #include <linux/cfi.h>
+#include <linux/io_uring_types.h>
 #include <asm/rqspinlock.h>
 
 struct bpf_verifier_env;
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index b13de31e163f..c5d58806a1cf 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -83,6 +83,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
 BPF_PROG_TYPE(BPF_PROG_TYPE_NETFILTER, netfilter,
 	      struct bpf_nf_ctx, struct bpf_nf_ctx)
 #endif
+#ifdef CONFIG_IO_URING
+BPF_PROG_TYPE(BPF_PROG_TYPE_IO_URING, io_uring_filter,
+	      struct io_uring_bpf_ctx, struct io_uring_bpf_ctx)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 211686ad89fd..1e91fa7ecbaf 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -219,9 +219,23 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
+#ifdef CONFIG_BPF
+extern const struct bpf_prog_ops io_uring_filter_prog_ops;
+extern const struct bpf_verifier_ops io_uring_filter_verifier_ops;
+#endif
+
+struct io_bpf_filter;
+struct io_bpf_filters {
+	refcount_t refs;	/* ref for ->bpf_filters */
+	spinlock_t lock;	/* protects ->bpf_filters modifications */
+	struct io_bpf_filter __rcu **filters;
+	struct rcu_head rcu_head;
+};
+
 struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	struct io_bpf_filters *bpf_filters;
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
 	/* IORING_OP_* restrictions exist */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f8d8513eda27..4d43ec003887 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1072,6 +1072,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
 	BPF_PROG_TYPE_NETFILTER,
+	BPF_PROG_TYPE_IO_URING,
 	__MAX_BPF_PROG_TYPE
 };
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..768b0e7c0b57 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -700,6 +700,9 @@ enum io_uring_register_op {
 	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
 	IORING_REGISTER_ZCRX_CTRL		= 36,
 
+	/* register bpf filtering programs */
+	IORING_REGISTER_BPF_FILTER		= 37,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -1113,6 +1116,41 @@ struct zcrx_ctrl {
 	};
 };
 
+struct io_uring_bpf_ctx {
+	__u8	opcode;
+	__u8	sqe_flags;
+	__u8	pad[6];
+	__u64	user_data;
+	__u64	resv[6];
+};
+
+enum {
+	/*
+	 * If set, any currently unset opcode will have a deny filter attached
+	 */
+	IO_URING_BPF_FILTER_DENY_REST	= 1,
+};
+
+struct io_uring_bpf_filter {
+	__u32	opcode;		/* io_uring opcode to filter */
+	__u32	flags;
+	__s32	prog_fd;	/* BPF program fd */
+	__u32	reserved[3];
+};
+
+enum {
+	IO_URING_BPF_CMD_FILTER	= 1,
+};
+
+struct io_uring_bpf {
+	__u16	cmd_type;	/* IO_URING_BPF_* values */
+	__u16	cmd_flags;	/* none so far */
+	__u32	resv;
+	union {
+		struct io_uring_bpf_filter	filter;
+	};
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/Makefile b/io_uring/Makefile
index bc4e4a3fa0a5..d89bd0cf6363 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
+obj-$(CONFIG_BPF) += bpf_filter.o
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
new file mode 100644
index 000000000000..f63a8e9e85db
--- /dev/null
+++ b/io_uring/bpf_filter.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * BPF filter support for io_uring. Supports SQE opcodes for now.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/io_uring.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
+#include <uapi/linux/io_uring.h>
+
+#include "io_uring.h"
+#include "bpf_filter.h"
+#include "net.h"
+
+struct io_bpf_filter {
+	struct bpf_prog		*prog;
+	struct io_bpf_filter	*next;
+};
+
+/* Deny if this is set as the filter */
+static const struct io_bpf_filter dummy_filter;
+
+static bool io_uring_filter_is_valid_access(int off, int size,
+					    enum bpf_access_type type,
+					    const struct bpf_prog *prog,
+					    struct bpf_insn_access_aux *info)
+{
+	if (type != BPF_READ)
+		return false;
+	if (off < 0 || off >= sizeof(struct io_uring_bpf_ctx))
+		return false;
+	if (off % size != 0)
+		return false;
+
+	return true;
+}
+
+/* Convert context field access if needed */
+static u32 io_uring_filter_convert_ctx_access(enum bpf_access_type type,
+					      const struct bpf_insn *si,
+					      struct bpf_insn *insn_buf,
+					      struct bpf_prog *prog,
+					      u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+	/* Direct access is fine - context is read-only and passed directly */
+	switch (si->off) {
+	case offsetof(struct io_uring_bpf_ctx, opcode):
+	case offsetof(struct io_uring_bpf_ctx, sqe_flags):
+	case offsetof(struct io_uring_bpf_ctx, user_data):
+		*insn++ = BPF_LDX_MEM(BPF_SIZE(si->code), si->dst_reg,
+				      si->src_reg, si->off);
+		break;
+	default:
+		/* Union fields - also direct access */
+		*insn++ = BPF_LDX_MEM(BPF_SIZE(si->code), si->dst_reg,
+				      si->src_reg, si->off);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+const struct bpf_prog_ops io_uring_filter_prog_ops = { };
+
+const struct bpf_verifier_ops io_uring_filter_verifier_ops = {
+	.get_func_proto		= bpf_base_func_proto,
+	.is_valid_access	= io_uring_filter_is_valid_access,
+	.convert_ctx_access	= io_uring_filter_convert_ctx_access,
+};
+
+static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
+				      struct io_kiocb *req)
+{
+	memset(bctx, 0, sizeof(*bctx));
+	bctx->opcode = req->opcode;
+	bctx->sqe_flags = (__force int) req->flags & SQE_VALID_FLAGS;
+	bctx->user_data = req->cqe.user_data;
+}
+
+/*
+ * Run registered filters for a given opcode. For filters, a return of 0 denies
+ * execution of the request, a return of 1 allows it. If any filter for an
+ * opcode returns 0, filter processing is stopped, and the request is denied.
+ * This also stops the processing of filters.
+ *
+ * __io_uring_run_bpf_filters() returns 0 on success, allow running the
+ * request, and -EACCES when a request is denied.
+ */
+int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
+{
+	struct io_bpf_filter *filter;
+	struct io_uring_bpf_ctx bpf_ctx;
+	int ret;
+
+	/*
+	 * req->opcode has already been validated to be within the range
+	 * of what we expect, io_init_req() does this.
+	 */
+	rcu_read_lock();
+	filter = rcu_dereference(res->bpf_filters->filters[req->opcode]);
+	if (!filter) {
+		ret = 1;
+		goto out;
+	} else if (filter == &dummy_filter) {
+		ret = 0;
+		goto out;
+	}
+
+	io_uring_populate_bpf_ctx(&bpf_ctx, req);
+
+	/*
+	 * Iterate registered filters. The opcode is allowed IFF all filters
+	 * return 1. If any filter returns denied, opcode will be denied.
+	 */
+	do {
+		ret = bpf_prog_run(filter->prog, &bpf_ctx);
+		if (!ret)
+			break;
+		filter = filter->next;
+	} while (filter);
+out:
+	rcu_read_unlock();
+	return ret ? 0 : -EACCES;
+}
+
+static void io_free_bpf_filters(struct rcu_head *head)
+{
+	struct io_bpf_filter __rcu **filter;
+	struct io_bpf_filters *filters;
+	int i;
+
+	filters = container_of(head, struct io_bpf_filters, rcu_head);
+	spin_lock(&filters->lock);
+	filter = filters->filters;
+	if (!filter) {
+		spin_unlock(&filters->lock);
+		return;
+	}
+	spin_unlock(&filters->lock);
+
+	for (i = 0; i < IORING_OP_LAST; i++) {
+		struct io_bpf_filter *f;
+
+		rcu_read_lock();
+		f = rcu_dereference(filter[i]);
+		while (f) {
+			struct io_bpf_filter *next = f->next;
+
+			/*
+			 * Even if stacked, dummy filter will always be last
+			 * as it can only get installed into an empty spot.
+			 */
+			if (f == &dummy_filter)
+				break;
+			if (f->prog)
+				bpf_prog_put(f->prog);
+			kfree(f);
+			f = next;
+		}
+		rcu_read_unlock();
+	}
+	kfree(filters->filters);
+	kfree(filters);
+}
+
+static void __io_put_bpf_filters(struct io_bpf_filters *filters)
+{
+	if (refcount_dec_and_test(&filters->refs))
+		call_rcu(&filters->rcu_head, io_free_bpf_filters);
+}
+
+void io_put_bpf_filters(struct io_restriction *res)
+{
+	if (res->bpf_filters)
+		__io_put_bpf_filters(res->bpf_filters);
+}
+
+static struct io_bpf_filters *io_new_bpf_filters(void)
+{
+	struct io_bpf_filters *filters;
+
+	filters = kzalloc(sizeof(*filters), GFP_KERNEL_ACCOUNT);
+	if (!filters)
+		return ERR_PTR(-ENOMEM);
+
+	filters->filters = kcalloc(IORING_OP_LAST,
+				   sizeof(struct io_bpf_filter *),
+				   GFP_KERNEL_ACCOUNT);
+	if (!filters->filters) {
+		kfree(filters);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	refcount_set(&filters->refs, 1);
+	spin_lock_init(&filters->lock);
+	return filters;
+}
+
+int io_register_bpf_filter(struct io_restriction *res,
+			   struct io_uring_bpf __user *arg)
+{
+	struct io_bpf_filter *filter, *old_filter;
+	struct io_bpf_filters *filters;
+	struct io_uring_bpf reg;
+	struct bpf_prog *prog;
+	int ret;
+
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (reg.cmd_type != IO_URING_BPF_CMD_FILTER)
+		return -EINVAL;
+	if (reg.cmd_flags || reg.resv)
+		return -EINVAL;
+
+	if (reg.filter.opcode >= IORING_OP_LAST)
+		return -EINVAL;
+	if ((reg.filter.flags & ~IO_URING_BPF_FILTER_DENY_REST) ||
+	    !mem_is_zero(reg.filter.reserved, sizeof(reg.filter.reserved)))
+		return -EINVAL;
+	if (reg.filter.prog_fd < 0)
+		return -EBADF;
+
+	/*
+	 * No existing filters, allocate set.
+	 */
+	filters = res->bpf_filters;
+	if (!filters) {
+		filters = io_new_bpf_filters();
+		if (IS_ERR(filters))
+			return PTR_ERR(filters);
+	}
+
+	prog = bpf_prog_get_type(reg.filter.prog_fd, BPF_PROG_TYPE_IO_URING);
+	if (IS_ERR(prog)) {
+		ret = PTR_ERR(prog);
+		goto err;
+	}
+
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL_ACCOUNT);
+	if (!filter) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	filter->prog = prog;
+	res->bpf_filters = filters;
+
+	/*
+	 * Insert filter - if the current opcode already has a filter
+	 * attached, add to the set.
+	 */
+	rcu_read_lock();
+	spin_lock_bh(&filters->lock);
+	old_filter = rcu_dereference(filters->filters[reg.filter.opcode]);
+	if (old_filter)
+		filter->next = old_filter;
+	rcu_assign_pointer(filters->filters[reg.filter.opcode], filter);
+
+	/*
+	 * If IO_URING_BPF_FILTER_DENY_REST is set, fill any unregistered
+	 * opcode with the dummy filter. That will cause them to be denied.
+	 */
+	if (reg.filter.flags & IO_URING_BPF_FILTER_DENY_REST) {
+		for (int i = 0; i < IORING_OP_LAST; i++) {
+			if (i == reg.filter.opcode)
+				continue;
+			old_filter = rcu_dereference(filters->filters[i]);
+			if (old_filter)
+				continue;
+			rcu_assign_pointer(filters->filters[i], &dummy_filter);
+		}
+	}
+
+	spin_unlock_bh(&filters->lock);
+	rcu_read_unlock();
+	return 0;
+err:
+	if (filters != res->bpf_filters)
+		__io_put_bpf_filters(filters);
+	if (!IS_ERR(prog))
+		bpf_prog_put(prog);
+	return ret;
+}
diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
new file mode 100644
index 000000000000..a131953ce950
--- /dev/null
+++ b/io_uring/bpf_filter.h
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IO_URING_BPF_FILTER_H
+#define IO_URING_BPF_FILTER_H
+
+#ifdef CONFIG_BPF
+
+int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req);
+
+int io_register_bpf_filter(struct io_restriction *res,
+			   struct io_uring_bpf __user *arg);
+
+void io_put_bpf_filters(struct io_restriction *res);
+
+static inline int io_uring_run_bpf_filters(struct io_restriction *res,
+					   struct io_kiocb *req)
+{
+	if (res->bpf_filters)
+		return __io_uring_run_bpf_filters(res, req);
+
+	return 0;
+}
+
+#else
+
+static inline int io_register_bpf_filter(struct io_restriction *res,
+					 struct io_uring_bpf __user *arg)
+{
+	return -EINVAL;
+}
+static inline int io_uring_run_bpf_filters(struct io_restriction *res,
+					   struct io_kiocb *req)
+{
+	return 0;
+}
+static inline void io_put_bpf_filters(struct io_restriction *res)
+{
+}
+#endif /* CONFIG_IO_URING */
+
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2cde22af78a3..67533e494836 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -93,6 +93,7 @@
 #include "rw.h"
 #include "alloc_cache.h"
 #include "eventfd.h"
+#include "bpf_filter.h"
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
@@ -2261,6 +2262,12 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
+	if (unlikely(ctx->restrictions.bpf_filters)) {
+		ret = io_uring_run_bpf_filters(&ctx->restrictions, req);
+		if (ret)
+			return io_submit_fail_init(sqe, req, ret);
+	}
+
 	trace_io_uring_submit_req(req);
 
 	/*
@@ -2850,6 +2857,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
 	io_req_caches_free(ctx);
+	io_put_bpf_filters(&ctx->restrictions);
 
 	WARN_ON_ONCE(ctx->nr_req_allocated);
 
diff --git a/io_uring/register.c b/io_uring/register.c
index 8551f13920dc..30957c2cb5eb 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -33,6 +33,7 @@
 #include "memmap.h"
 #include "zcrx.h"
 #include "query.h"
+#include "bpf_filter.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -830,6 +831,13 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_ZCRX_CTRL:
 		ret = io_zcrx_ctrl(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_BPF_FILTER:
+		ret = -EINVAL;
+
+		if (nr_args != 1)
+			break;
+		ret = io_register_bpf_filter(&ctx->restrictions, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4ff82144f885..d12537d918f7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2752,6 +2752,10 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		if (expected_attach_type == BPF_NETFILTER)
 			return 0;
 		return -EINVAL;
+	case BPF_PROG_TYPE_IO_URING:
+		if (expected_attach_type)
+			return -EINVAL;
+		return 0;
 	case BPF_PROG_TYPE_SYSCALL:
 	case BPF_PROG_TYPE_EXT:
 		if (expected_attach_type)
@@ -2934,6 +2938,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr, u32 uattr_size)
 	}
 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
 	    type != BPF_PROG_TYPE_CGROUP_SKB &&
+	    type != BPF_PROG_TYPE_IO_URING &&
 	    !bpf_cap)
 		goto put_token;
 
@@ -4403,6 +4408,10 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 		if (attach_type != BPF_NETFILTER)
 			return -EINVAL;
 		return 0;
+	case BPF_PROG_TYPE_IO_URING:
+		if (attach_type != 0)
+			return -EINVAL;
+		return 0;
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_TRACEPOINT:
 		if (attach_type != BPF_PERF_EVENT)
-- 
2.51.0


