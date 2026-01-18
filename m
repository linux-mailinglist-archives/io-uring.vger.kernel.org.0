Return-Path: <io-uring+bounces-11798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 69465D3986A
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 06FFB3002860
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 17:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA256A33B;
	Sun, 18 Jan 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NrIV5tiS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98F97260A
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 17:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768757016; cv=none; b=lcHgx8jj4KaGSJ9r9lGH78W9yxEmTq+A+2y6sW1ezBl49W+iYLWMhqXllIZAcUWbwVa8rWUU6Er1CzESN0UM3qnb6khpPwV0mA3cvODm/u1RvyGXEhnz8eS15lvKbrqo4kqGAIGAlDocpFzJnwmh+23pcIQLf0yZwpwoK4owNNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768757016; c=relaxed/simple;
	bh=NxULrLUGCSWi4An8MTmV7swYy5aUheBNgjTROvvW9jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGxcaebDh/8atx2Go2LvOvdnX2a7h/96Z47VDf23uSr5A3Q7pO88UZXn9CIgxdbt6MJ0VG+rQVEf0KL4RZhgvHEtSi67q/szb+0dDWhA3WigTwpguYKzEmyyTSdN9bCBeZMYcJm4YEU64lxtXo+sKKZSgLZtWJ57X9lf9p9w348=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NrIV5tiS; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfd9b898cdso1996825a34.2
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 09:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768757012; x=1769361812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fAolqw8ZDEOOyBAS3dhlCRdKQvDu4ur6I5Vf8A+AZmA=;
        b=NrIV5tiSxY7sYcmW7NZgFxdD1uNK4BLb7iyIGM/EDR3YaXqJh2OkXEWHe9LSXOcXyT
         tJDJEV2+CzZY7EWk+ZnVaCTlYZA1WmfuQOIDsvgXn/3SAlCklXIgHUxJmDIYLshharKE
         jqF7Y+paBYLxEQF7R/FXEzJaQ31KhDzFVBKfKfO1ApPsRvswyWq47fNG7ELqG2nh/cts
         0YGZO8joxg/qYVW1PRbMmwpE4WqnV8+9GAM3j8f3vUt+ssyapHqT9SBMXmrbSlZm/plA
         5o6xGpeVVlObKzLUtM5u1I2IFZ6rlJpSjkfHuUy+xdVzJ4RV4vn4kh+TGwSzFpPgqxEy
         JagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768757012; x=1769361812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fAolqw8ZDEOOyBAS3dhlCRdKQvDu4ur6I5Vf8A+AZmA=;
        b=pnDdGF56JZYW8OgSxck1eEWGxeQDxS6ygCkFAynyF4lNexAxJwuZ7gtNkc7ysF8XK8
         4PK3ROjm7IODU5+VQEb2TgfymtQrodAqtfb3/nP51qVmHuBGX3ELlC/oPEif1ZnS+dJB
         KZSx31VUoNqiR1E9KHobnUkyQsWGPO4Y6fjuNad+FSi2ncLfrjer0HIck6+KpJEbt6om
         uMe8qLyjfmP88hpxo4PT6zCu3fYDrBHw0C1wYCUWBC4iM8nwda3RLjtdpvy+9Ird6WEm
         PIX8ukc27gazFSgBrGUX6K1v3mIWwC1iWERfTdDDSk+7bELDgFYV3LNGO+/iD1rMalkS
         02kA==
X-Gm-Message-State: AOJu0YyNb2sT8wVA+Yn1GP1AqoLEp7nQg4tOQpG1ejywHQoVMRo6XO2P
	zXWy8xUeDqEyiI8F29/DLXbVGDo5j6JutdB+nQDbXmxWrNwARLxlDrTx8xW7HRsX9t3Za9vjtKI
	J77Mi
X-Gm-Gg: AY/fxX5vXb+ht8186PoOduE7opT9zfDLiGMKyoFzcpjXFAAF6SgZPnNl2/pjpf4xfkR
	U4j4htQd7mJwmyHRYt1wHy8kh2AqDoCs/t4ELOmYaRRWXDnG1b/opsc+t7FOQzbz3Vu3AkPn//i
	01+OaWAyeP2WiXjyreF97LoKl4ekZFbuAsSAxdDDpe8ahsQuNM2tAwc36i8t1QEMd5f+/LlXhjm
	URWoH9Kg7MzplKMV0L4Wnz8fCKoI6zcxW5KeJ5htNC70Z8T6cNHvGzD5edOBgNrmeRaEF4cy/pz
	4ksh5rjcijXWynSo0NU/+CEf0FCQ82A2VUR3g43hQi5F0KQzN7hYY6pNwX1UAPTDDPETb87sv3Q
	sXBUgz7DYzZSqGYdfJlBjGGBWYc1RbiDfy4UBwS2dj5sHPdpKwP1bWRLVUL4UPnvzwB4WnniY/n
	RqFm90hv3aHsO2UhofpTOIL/TTPvz55o3Sv8mOjtqUTWMkNfXMv4Wo6kmH
X-Received: by 2002:a05:6830:6d0d:b0:7cf:d119:8d93 with SMTP id 46e09a7af769-7cfdebb4f48mr4609388a34.0.1768757012417;
        Sun, 18 Jan 2026 09:23:32 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf101198sm5489558a34.13.2026.01.18.09.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 09:23:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: add support for BPF filtering for opcode restrictions
Date: Sun, 18 Jan 2026 10:16:51 -0700
Message-ID: <20260118172328.1067592-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260118172328.1067592-1-axboe@kernel.dk>
References: <20260118172328.1067592-1-axboe@kernel.dk>
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
 include/linux/io_uring_types.h           |   9 +
 include/uapi/linux/io_uring.h            |   3 +
 include/uapi/linux/io_uring/bpf_filter.h |  47 ++++
 io_uring/Kconfig                         |   5 +
 io_uring/Makefile                        |   1 +
 io_uring/bpf_filter.c                    | 328 +++++++++++++++++++++++
 io_uring/bpf_filter.h                    |  42 +++
 io_uring/io_uring.c                      |   8 +
 io_uring/register.c                      |   8 +
 9 files changed, 451 insertions(+)
 create mode 100644 include/uapi/linux/io_uring/bpf_filter.h
 create mode 100644 io_uring/bpf_filter.c
 create mode 100644 io_uring/bpf_filter.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 211686ad89fd..37f0a5f7b2f4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -219,9 +219,18 @@ struct io_rings {
 	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..94669b77fee8 100644
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
 
diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
new file mode 100644
index 000000000000..14bd5b7468a7
--- /dev/null
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
+/*
+ * Header file for the io_uring BPF filters.
+ */
+#ifndef LINUX_IO_URING_BPF_FILTER_H
+#define LINUX_IO_URING_BPF_FILTER_H
+
+#include <linux/types.h>
+
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
+	__u32	filter_len;	/* number of BPF instructions */
+	__u32	resv;
+	__u64	filter_ptr;	/* pointer to BPF filter */
+	__u64	resv2[5];
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
+#endif
diff --git a/io_uring/Kconfig b/io_uring/Kconfig
index 4b949c42c0bf..a7ae23cf1035 100644
--- a/io_uring/Kconfig
+++ b/io_uring/Kconfig
@@ -9,3 +9,8 @@ config IO_URING_ZCRX
 	depends on PAGE_POOL
 	depends on INET
 	depends on NET_RX_BUSY_POLL
+
+config IO_URING_BPF
+	def_bool y
+	depends on BPF
+	depends on NET
diff --git a/io_uring/Makefile b/io_uring/Makefile
index bc4e4a3fa0a5..f3c505caa91e 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
+obj-$(CONFIG_IO_URING_BPF) += bpf_filter.o
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
new file mode 100644
index 000000000000..48c7ea6f8d63
--- /dev/null
+++ b/io_uring/bpf_filter.c
@@ -0,0 +1,328 @@
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
+	/* Fast check for existence of filters outside of RCU */
+	if (!rcu_access_pointer(res->bpf_filters->filters[req->opcode]))
+		return 0;
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
+		if (filter == &dummy_filter)
+			ret = 0;
+		else
+			ret = bpf_prog_run(filter->prog, &bpf_ctx);
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
+			bpf_prog_destroy(f->prog);
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
+/*
+ * Validate classic BPF filter instructions. Only allow a safe subset of
+ * operations - no packet data access, just context field loads and basic
+ * ALU/jump operations.
+ */
+static int io_uring_check_cbpf_filter(struct sock_filter *filter,
+				      unsigned int flen)
+{
+	int pc;
+
+	for (pc = 0; pc < flen; pc++) {
+		struct sock_filter *ftest = &filter[pc];
+		u16 code = ftest->code;
+		u32 k = ftest->k;
+
+		switch (code) {
+		case BPF_LD | BPF_W | BPF_ABS:
+			ftest->code = BPF_LDX | BPF_W | BPF_ABS;
+			/* 32-bit aligned and not out of bounds. */
+			if (k >= sizeof(struct io_uring_bpf_ctx) || k & 3)
+				return -EINVAL;
+			continue;
+		case BPF_LD | BPF_W | BPF_LEN:
+			ftest->code = BPF_LD | BPF_IMM;
+			ftest->k = sizeof(struct io_uring_bpf_ctx);
+			continue;
+		case BPF_LDX | BPF_W | BPF_LEN:
+			ftest->code = BPF_LDX | BPF_IMM;
+			ftest->k = sizeof(struct io_uring_bpf_ctx);
+			continue;
+		/* Explicitly include allowed calls. */
+		case BPF_RET | BPF_K:
+		case BPF_RET | BPF_A:
+		case BPF_ALU | BPF_ADD | BPF_K:
+		case BPF_ALU | BPF_ADD | BPF_X:
+		case BPF_ALU | BPF_SUB | BPF_K:
+		case BPF_ALU | BPF_SUB | BPF_X:
+		case BPF_ALU | BPF_MUL | BPF_K:
+		case BPF_ALU | BPF_MUL | BPF_X:
+		case BPF_ALU | BPF_DIV | BPF_K:
+		case BPF_ALU | BPF_DIV | BPF_X:
+		case BPF_ALU | BPF_AND | BPF_K:
+		case BPF_ALU | BPF_AND | BPF_X:
+		case BPF_ALU | BPF_OR | BPF_K:
+		case BPF_ALU | BPF_OR | BPF_X:
+		case BPF_ALU | BPF_XOR | BPF_K:
+		case BPF_ALU | BPF_XOR | BPF_X:
+		case BPF_ALU | BPF_LSH | BPF_K:
+		case BPF_ALU | BPF_LSH | BPF_X:
+		case BPF_ALU | BPF_RSH | BPF_K:
+		case BPF_ALU | BPF_RSH | BPF_X:
+		case BPF_ALU | BPF_NEG:
+		case BPF_LD | BPF_IMM:
+		case BPF_LDX | BPF_IMM:
+		case BPF_MISC | BPF_TAX:
+		case BPF_MISC | BPF_TXA:
+		case BPF_LD | BPF_MEM:
+		case BPF_LDX | BPF_MEM:
+		case BPF_ST:
+		case BPF_STX:
+		case BPF_JMP | BPF_JA:
+		case BPF_JMP | BPF_JEQ | BPF_K:
+		case BPF_JMP | BPF_JEQ | BPF_X:
+		case BPF_JMP | BPF_JGE | BPF_K:
+		case BPF_JMP | BPF_JGE | BPF_X:
+		case BPF_JMP | BPF_JGT | BPF_K:
+		case BPF_JMP | BPF_JGT | BPF_X:
+		case BPF_JMP | BPF_JSET | BPF_K:
+		case BPF_JMP | BPF_JSET | BPF_X:
+			continue;
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+#define IO_URING_BPF_FILTER_FLAGS	IO_URING_BPF_FILTER_DENY_REST
+
+int io_register_bpf_filter(struct io_restriction *res,
+			   struct io_uring_bpf __user *arg)
+{
+	struct io_bpf_filter *filter, *old_filter;
+	struct io_bpf_filters *filters;
+	struct io_uring_bpf reg;
+	struct bpf_prog *prog;
+	struct sock_fprog fprog;
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
+	if (reg.filter.flags & ~IO_URING_BPF_FILTER_FLAGS)
+		return -EINVAL;
+	if (reg.filter.resv)
+		return -EINVAL;
+	if (!mem_is_zero(reg.filter.resv2, sizeof(reg.filter.resv2)))
+		return -EINVAL;
+	if (!reg.filter.filter_len || reg.filter.filter_len > BPF_MAXINSNS)
+		return -EINVAL;
+
+	fprog.len = reg.filter.filter_len;
+	fprog.filter = u64_to_user_ptr(reg.filter.filter_ptr);
+
+	ret = bpf_prog_create_from_user(&prog, &fprog,
+					io_uring_check_cbpf_filter, false);
+	if (ret)
+		return ret;
+
+	/*
+	 * No existing filters, allocate set.
+	 */
+	filters = res->bpf_filters;
+	if (!filters) {
+		filters = io_new_bpf_filters();
+		if (IS_ERR(filters)) {
+			ret = PTR_ERR(filters);
+			goto err_prog;
+		}
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
+err_prog:
+	bpf_prog_destroy(prog);
+	return ret;
+}
diff --git a/io_uring/bpf_filter.h b/io_uring/bpf_filter.h
new file mode 100644
index 000000000000..27eae9705473
--- /dev/null
+++ b/io_uring/bpf_filter.h
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IO_URING_BPF_FILTER_H
+#define IO_URING_BPF_FILTER_H
+
+#include <uapi/linux/io_uring/bpf_filter.h>
+
+#ifdef CONFIG_IO_URING_BPF
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
+#endif /* CONFIG_IO_URING_BPF */
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
-- 
2.51.0


