Return-Path: <io-uring+bounces-11733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9AAD25E16
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2D083043A56
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 16:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36E23B9619;
	Thu, 15 Jan 2026 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B2Ejt6NN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBE13624C4
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495979; cv=none; b=WdRQ3k21VuFtZNUx9mrxdPdZc3qKcKlUnSFfkAH0mCNrJExHUelT3NPSr9srpjarJKmAxrPKoQVmifI0lHCgs5d3K95KTwCfjv1vlD4anQQ9sgNIRB5dMf/FQOMZBIWZuC1hlx3Ob9o7TG25ra06tBtpFMFmFP5GZeb6YBMGdxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495979; c=relaxed/simple;
	bh=Zte5o30bmMdZvmX+E9AX19YHwa7F9g14CrcJcA2hAEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXd6UybMsb+H8+IalhGlDvVSyrBGo/ZXAgNNFVZSYtJ6WV0C6R8Q8LqfSAXcuOKRKfc0kM7/S06q2iTxlb6s11QYFF63i4Wrw1JdV899fWCP4JwI9G92h1TyowpCP3PGQvAj1k/Ny96UlVqSxs1JZbOP9UEqFqg6AzljiJhGlP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B2Ejt6NN; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7cfd7d33b88so312464a34.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 08:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768495976; x=1769100776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SANCR+V2La/aNHCgFsMQavZAf4IGpY8kjK7GuZm0RFM=;
        b=B2Ejt6NNydoxRFFZf9GWpDXY9y8bXPRWsY1qIUWJLZsKS0CaToY4rjVSRvnaRIjJ/E
         31rcDs0aDJLPEs8fhUejQiocORp0zvILKhQbR2+OIeqQHmG3MIzvRokDw5NiPUBAf6N1
         gTHX7DrIWl3ImMdEfjIizQOzwLJkdOKa2JT5WA6US3ccnvKEXEVDPGEHc++qgyqZp5j4
         hhxKA7Z86HRRvxaAEVCPHkZu7cuBmbqs0fkFk4wTx/xHYQS3qDz10pB2PU1RW4WfOFA4
         Oe1l4ppkc8jLHGk3ZvY/XX5PEpZOg2vGrAfuw58Wacw6Bo97YCydT50+38wFQ60RjDZD
         nvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768495976; x=1769100776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SANCR+V2La/aNHCgFsMQavZAf4IGpY8kjK7GuZm0RFM=;
        b=rWYAKlB60+CIiW6NTJ3ZD1zjIvBi3a4vv6h1thKIZfjW9YjtpiMIVuMHF3aYNltn+M
         45wh1ZKjCA75mxtWbjiXA/C539sFkP2Yb8gTPse7C/fBstgQSAPDkT5xSbDB93pinOTA
         YwcyG15+dgFqsPk6X8zKQgWHLxZmszyI7bTmxT7sbRIRHGlnpIcXHwlunfzgfwn60xsw
         ze9XqfHbN3G4geebAIAhjrczMWr1azDOj8H9nirg295g1NfkvsdWI5JfezFm1U5DNE1f
         bJT7DagZ+AJ9yEFiMRqb87Tan14I+YXQ9I3y+9cGL5eek0IlnYrV4g1lOCUzlFbFMbGQ
         1fjQ==
X-Gm-Message-State: AOJu0YyYaDcs9nq8+KApn0oo4MgIssw5B2Dm0fnfrDaUL5aTjNUlMJBa
	YZhJwdM0rNLBwC5VGBTs7b3rxYaWuEogn++UM34g2NYkbnVSao+mCayIOfzu67gCYGLCJC5cFsP
	qMtS4
X-Gm-Gg: AY/fxX4wrwvCqQBspwOBnztxvT1Do4Rqy+yrYpcYrCJLPnRhf2Dp8U8BYFjAKbezpvY
	vpjXnJeXU4atiPjstxyRnDGtgYInQItOHr1/j6NEPGJ7CJJtlfjmJhMwNohcu96RG2SAwNm0EQ1
	+YOxwkSwysRwrO/WB+vPxFAi4ILflGYoG5dJB6ZlO1Vzo/5E1obmAIOBd2tAcfQAy2ngc2WAAx5
	2+6B3eMtSHtes8lohZU2zwsD6XH6FvarzUTDhuzevwLAlTUiGqflsBj69f0v2wHy/+Uw877FsGU
	Vk7679Wt1W0KtAuCtGCaCEimRzTM8dzTp6bm6GesX2eJTIYObsY7lA5JbWFv3sHgNeh9p3x8+7L
	hiY916Cgp9QSmIko+p4LxkLCaCJnYfOrDgqACrcSi+GKT/pHx+KjXFMPbyw5Zqu/luvtJhw==
X-Received: by 2002:a05:6830:3113:b0:7c7:32d:975d with SMTP id 46e09a7af769-7cfdee12cb2mr45472a34.31.1768495975809;
        Thu, 15 Jan 2026 08:52:55 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0db2ddsm14369a34.3.2026.01.15.08.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 08:52:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: add support for BPF filtering for opcode restrictions
Date: Thu, 15 Jan 2026 09:36:33 -0700
Message-ID: <20260115165244.1037465-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260115165244.1037465-1-axboe@kernel.dk>
References: <20260115165244.1037465-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds support for loading BPF programs with io_uring, which can
restrict the opcodes performed. Unlike IORING_REGISTER_RESTRICTIONS,
using BPF programs allow fine grained control over both the opcode
in question, as well as other data associated with the request.
Initially only IORING_OP_SOCKET is supported.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/bpf.h            |   1 +
 include/linux/bpf_types.h      |   4 +
 include/linux/io_uring_types.h |  16 +++
 include/uapi/linux/bpf.h       |   1 +
 include/uapi/linux/io_uring.h  |  37 ++++++
 io_uring/Makefile              |   1 +
 io_uring/bpf_filter.c          | 212 +++++++++++++++++++++++++++++++++
 io_uring/bpf_filter.h          |  41 +++++++
 io_uring/io_uring.c            |   7 ++
 io_uring/net.c                 |   9 ++
 io_uring/net.h                 |   5 +
 io_uring/register.c            |  33 ++++-
 kernel/bpf/syscall.c           |   9 ++
 13 files changed, 375 insertions(+), 1 deletion(-)
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
index c664c84247f1..4b18dfc63764 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -219,6 +219,17 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
+#ifdef CONFIG_BPF
+extern const struct bpf_prog_ops io_uring_filter_prog_ops;
+extern const struct bpf_verifier_ops io_uring_filter_verifier_ops;
+#endif
+
+struct io_bpf_filter;
+struct io_bpf_filters {
+	spinlock_t lock;
+	struct io_bpf_filter __rcu **bpf_filters;
+};
+
 struct io_restriction {
 	refcount_t refs;
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
@@ -229,6 +240,10 @@ struct io_restriction {
 	bool op_registered;
 	/* IORING_REGISTER_* restrictions exist */
 	bool reg_registered;
+	/* BPF filter restrictions exists */
+	bool bpf_registered;
+	struct io_bpf_filters filters;
+	struct rcu_head rcu_head;
 };
 
 struct io_submit_link {
@@ -265,6 +280,7 @@ struct io_ring_ctx {
 		unsigned int		drain_next: 1;
 		unsigned int		op_restricted: 1;
 		unsigned int		reg_restricted: 1;
+		unsigned int		bpf_restricted: 1;
 		unsigned int		off_timeout_used: 1;
 		unsigned int		drain_active: 1;
 		unsigned int		has_evfd: 1;
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
index b5b23c0d5283..0e1b0871fe5e 100644
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
 
@@ -1113,6 +1116,40 @@ struct zcrx_ctrl {
 	};
 };
 
+struct io_uring_bpf_ctx {
+	__u8	opcode;
+	__u8	sqe_flags;
+	__u8	pad[6];
+	__u64	user_data;
+	union {
+		struct {
+			__u32	family;
+			__u32	type;
+			__u32	protocol;
+		} socket;
+	};
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
index 000000000000..d31bff1984b7
--- /dev/null
+++ b/io_uring/bpf_filter.c
@@ -0,0 +1,212 @@
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
+static bool io_uring_filter_is_valid_access(int off, int size,
+                                             enum bpf_access_type type,
+                                             const struct bpf_prog *prog,
+                                             struct bpf_insn_access_aux *info)
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
+/* BTF ID for the context type */
+BTF_ID_LIST_SINGLE(io_uring_filter_btf_ids, struct, io_uring_bpf_ctx)
+
+/* Program operations */
+const struct bpf_prog_ops io_uring_filter_prog_ops = { };
+
+/* Verifier operations */
+const struct bpf_verifier_ops io_uring_filter_verifier_ops = {
+	.get_func_proto		= bpf_base_func_proto,
+	.is_valid_access	= io_uring_filter_is_valid_access,
+	.convert_ctx_access	= io_uring_filter_convert_ctx_access,
+};
+
+/* Populate BPF context from SQE */
+static void io_uring_populate_bpf_ctx(struct io_uring_bpf_ctx *bctx,
+				      struct io_kiocb *req)
+{
+	memset(bctx, 0, sizeof(*bctx));
+	bctx->opcode = req->opcode;
+	bctx->sqe_flags = req->flags & SQE_VALID_FLAGS;
+	bctx->user_data = req->cqe.user_data;
+
+	switch (req->opcode) {
+	case IORING_OP_SOCKET:
+		io_socket_bpf_populate(bctx, req);
+		break;
+	}
+}
+
+/*
+ * Run registered filters for a given opcode. Return of 0 means that the
+ * request should be allowed.
+ */
+int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
+{
+	struct io_bpf_filter *filter;
+	struct io_uring_bpf_ctx bpf_ctx;
+	int ret;
+
+	rcu_read_lock();
+	filter = rcu_dereference(res->filters.bpf_filters[req->opcode]);
+	if (!filter || !filter->prog) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	io_uring_populate_bpf_ctx(&bpf_ctx, req);
+
+	do {
+		ret = bpf_prog_run(filter->prog, &bpf_ctx);
+		if (!ret)
+			break;
+		filter = filter->next;
+	} while (filter);
+
+	rcu_read_unlock();
+	return ret ? 0 : -EACCES;
+}
+
+int io_register_bpf_filter(struct io_restriction *res,
+			   struct io_uring_bpf_filter __user *arg)
+{
+	struct io_bpf_filter *filter, *old_filter;
+	struct io_bpf_filter **filters;
+	struct io_uring_bpf reg;
+	struct bpf_prog *prog;
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
+	if (reg.filter.flags ||
+	    !mem_is_zero(reg.filter.reserved, sizeof(reg.filter.reserved)))
+		return -EINVAL;
+	if (reg.filter.prog_fd < 0)
+		return -EBADF;
+
+	/*
+	 * No existing filters, allocate set.
+	 */
+	filters = res->filters.bpf_filters;
+	if (!filters) {
+		filters = kcalloc(IORING_OP_LAST, sizeof(struct io_bpf_filter *), GFP_KERNEL_ACCOUNT);
+		if (!filters)
+			return -ENOMEM;
+	}
+
+	prog = bpf_prog_get_type(reg.filter.prog_fd, BPF_PROG_TYPE_IO_URING);
+	if (IS_ERR(prog)) {
+		if (filters != res->filters.bpf_filters)
+			kfree(filters);
+		return PTR_ERR(prog);
+	}
+
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL_ACCOUNT);
+	if (!filter) {
+		if (filters != res->filters.bpf_filters)
+			kfree(filters);
+		bpf_prog_put(prog);
+		return -ENOMEM;
+	}
+	filter->prog = prog;
+	res->filters.bpf_filters = filters;
+
+	/*
+	 * Insert filter - if the current opcode already has a filter
+	 * attached, add to the set.
+	 */
+	spin_lock(&res->filters.lock);
+	old_filter = rcu_dereference(filters[reg.filter.opcode]);
+	if (old_filter)
+		filter->next = old_filter;
+	rcu_assign_pointer(filters[reg.filter.opcode], filter);
+	spin_unlock(&res->filters.lock);
+	res->bpf_registered = 1;
+	return 0;
+}
+
+void io_uring_put_bpf_filters(struct io_restriction *res)
+{
+	struct io_bpf_filters *filters = &res->filters;
+	int i;
+
+	if (!filters->bpf_filters)
+		return;
+	if (!res->bpf_registered)
+		return;
+
+	res->bpf_registered = 0;
+	for (i = 0; i < IORING_OP_LAST; i++) {
+		struct io_bpf_filter *filter;
+
+		filter = rcu_dereference(filters->bpf_filters[i]);
+		while (filter) {
+			struct io_bpf_filter *next = filter->next;
+
+			if (filter->prog)
+				bpf_prog_put(filter->prog);
+			kfree(filter);
+			filter = next;
+		}
+	}
+	kfree(filters->bpf_filters);
+	filters->bpf_filters = NULL;
+}
diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
new file mode 100644
index 000000000000..3cc53e0a3789
--- /dev/null
+++ b/io_uring/bpf_filter.h
@@ -0,0 +1,41 @@
+#ifndef IO_URING_BPF_FILTER_H
+#define IO_URING_BPF_FILTER_H
+
+#ifdef CONFIG_BPF
+
+void io_uring_put_bpf_filters(struct io_restriction *res);
+
+int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req);
+
+int io_register_bpf_filter(struct io_restriction *res,
+			   struct io_uring_bpf_filter __user *arg);
+
+static inline int io_uring_run_bpf_filters(struct io_ring_ctx *ctx,
+					   struct io_kiocb *req)
+{
+	struct io_restriction *res = ctx->restrictions;
+
+	if (res && res->filters.bpf_filters)
+		return __io_uring_run_bpf_filters(res, req);
+
+	return 0;
+}
+
+#else
+
+static inline int io_register_bpf_filter(struct io_restriction *res,
+					 struct io_uring_bpf_filter __user *arg)
+{
+	return -EINVAL;
+}
+static inline int io_uring_run_bpf_filters(struct io_ring_ctx *ctx,
+					   struct io_kiocb *req)
+{
+	return 0;
+}
+static inline void io_uring_put_bpf_filters(struct io_restriction *res)
+{
+}
+#endif /* CONFIG_IO_URING */
+
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eec8da38a596..80aeb498ec8a 100644
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
 
+	if (unlikely(ctx->bpf_restricted)) {
+		ret = io_uring_run_bpf_filters(ctx, req);
+		if (ret)
+			return io_submit_fail_init(sqe, req, ret);
+	}
+
 	trace_io_uring_submit_req(req);
 
 	/*
diff --git a/io_uring/net.c b/io_uring/net.c
index 519ea055b761..4fcba36bd0bb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1699,6 +1699,15 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_COMPLETE;
 }
 
+void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req)
+{
+	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
+
+	bctx->socket.family = sock->domain;
+	bctx->socket.type = sock->type;
+	bctx->socket.protocol = sock->protocol;
+}
+
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
diff --git a/io_uring/net.h b/io_uring/net.h
index 43e5ce5416b7..eef6b4272d01 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -44,6 +44,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_socket(struct io_kiocb *req, unsigned int issue_flags);
+void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx, struct io_kiocb *req);
 
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
@@ -64,4 +65,8 @@ void io_netmsg_cache_free(const void *entry);
 static inline void io_netmsg_cache_free(const void *entry)
 {
 }
+static inline void io_socket_bpf_populate(struct io_uring_bpf_ctx *bctx,
+					  struct io_kiocb *req)
+{
+}
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index 6c99b441d886..cb006d53a146 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -33,6 +33,7 @@
 #include "memmap.h"
 #include "zcrx.h"
 #include "query.h"
+#include "bpf_filter.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -163,10 +164,19 @@ static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 	return ret;
 }
 
+static void io_free_restrictions(struct rcu_head *head)
+{
+	struct io_restriction *res;
+
+	res = container_of(head, struct io_restriction, rcu_head);
+	io_uring_put_bpf_filters(res);
+	kfree(res);
+}
+
 void io_put_restrictions(struct io_restriction *res)
 {
 	if (refcount_dec_and_test(&res->refs))
-		kfree(res);
+		call_rcu(&res->rcu_head, io_free_restrictions);
 }
 
 static struct io_restriction *io_alloc_restrictions(void)
@@ -178,6 +188,7 @@ static struct io_restriction *io_alloc_restrictions(void)
 		return ERR_PTR(-ENOMEM);
 
 	refcount_set(&res->refs, 1);
+	spin_lock_init(&res->filters.lock);
 	return res;
 }
 
@@ -853,6 +864,26 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_ZCRX_CTRL:
 		ret = io_zcrx_ctrl(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_BPF_FILTER:
+		ret = -EINVAL;
+		if (nr_args != 1)
+			break;
+#ifdef CONFIG_BPF
+		if (!ctx->restrictions) {
+			struct io_restriction *res;
+
+			res = io_alloc_restrictions();
+			if (IS_ERR(res)) {
+				ret = PTR_ERR(res);
+				break;
+			}
+			ctx->restrictions = res;
+		}
+		ret = io_register_bpf_filter(ctx->restrictions, arg);
+		if (ctx->restrictions->bpf_registered)
+			ctx->bpf_restricted = 1;
+#endif
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


