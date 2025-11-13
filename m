Return-Path: <io-uring+bounces-10595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E043C5753D
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id ED69A354798
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF79934F246;
	Thu, 13 Nov 2025 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Go9mk+Dd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A1F34DB67
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035210; cv=none; b=KLx9+cmyu4A9NE1xeGa8ygdlUNMZriRA3JFF2RQnmMRUVtVpyHnwOcRUloTlMIJdc+ker5Xi0YQK9Ze+jHVVP347rg0Dcj+IT/HLp/+nnz6JVlqWrekbCypVABwAUagaOtQymcZOG0ZDwndfguREcUs4HlpKg7Vogc7vIsgLWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035210; c=relaxed/simple;
	bh=lsZ95rRxhme6Odz4JMPD0exmBCBT+MaAetYyoUtPI/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOh3vTKhEdZWM2Zb/O8kR/CqjcWO21TuiYhR+F7anT2P9HNJ3NydozW6w+/r5DcyLF1BRjw3xI51zc5oXCEb8Sa3z6EbFkE8UCojEM7VpiIX/fmFDehKjIFgUhCJc4Hxs+UGpWCWDgpuSKXCB0pTuvLrPwodYwg/uN4JBqvt3F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Go9mk+Dd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47774d3536dso6293295e9.0
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035206; x=1763640006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4TriZ2Ff7Ir7frshl6TrxPdJqNruS1HTTigg87lJ6Dw=;
        b=Go9mk+DdQRMEh5oHJdyRxEzw+uVRH//UbkK7r5KWL8gqnXKQW9EwVtp9jdD+nTmNxw
         5yG1yrj0pr1wKXhec0jN6GZAOPWP2QUc64FE12E/Hl+3gIXhoNXNoWAbCZKxKkKo9q1b
         zuzSASQlHWPQmH0yZcBqUBe2e9up75exw6NmxNXOcfWmWWcsNuEF/Vp8YZFIiUD3+xVk
         E2PpNllpqLOPdIXTdjDML00zCfm1/sVN3sCZ57JcrMSWA9Dwf39pqXAbrJ7cbCbjkL+7
         v6YFAdh0nb9THRcoUUd7OdXE7uedRV+Rjntjghfo0U9tA7aCsm/QkNqVzYhJrudGEctc
         v2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035206; x=1763640006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4TriZ2Ff7Ir7frshl6TrxPdJqNruS1HTTigg87lJ6Dw=;
        b=pdpFBH65O31tfIJxpuajv1/LqszrZ6ZvY9vKVzAhevY3Vo7r4Oop/Wopvx0cNvDhSg
         I3PypF17yuyZLPfTYWrsUtShw4BejT7DEMTGpfnbOKqICl7mzw8yBeQrBPksLoKoqN04
         5ZwpGWs3OiRnPjCivp/XZVi6DcQthFpDEelpcMkR+J0waZetX9Nwl6VxJu14Fhpii3oJ
         Loy1y2wZfJ+V106+HKYDxa+sZs3bIt1Nt8SlIqZGI9uY1vP7esRRTSvtLCUOcrQMT0aF
         1jgPpUQjrbnvIUyW2ogIpadXUXLouRDqmWpYytGMetmbqtjNA89gPS/sEfhfpcXM+HZm
         t0Ng==
X-Gm-Message-State: AOJu0Yx+q9ySMq+SahkoJt3H3OrPwAvfeq6DZIfR8xKIPxPmT7fO3r3k
	pitJEMpXVrCjGFGczsBn418ihte7I0Ye0XRgP+OaWi8+CrKNjDDAnSW0oLrD7g==
X-Gm-Gg: ASbGncv8RT2+H3Asutaj13LZpz8Mv5rO82hCDSKuIm/aV/UyFbiUUExB/2Cp9tu6nHa
	xUFDArnjT9Xzaex7cOO8N8RKsDtLiLdgyn1FzJTZBxhQIGTuorHA+KIjKmJy9vtAqavyvOrcvR2
	9xwxh2xE2aS/dqf34AWGIXST1Q6TeNpewMhZfkfJHFWx47NlXi191JDXRlb6FJQQ6XvfLT+ENDN
	oOMBjDO1qpDtnD67lMk7mtoIk6KXnp9k2k8M3cyvaP1yQBTnR8eCCjeJbfHpOuK7Zu7L/S4FtAv
	2ETbnW/nOdoJpiy+7p3F7KRflH9Uw9VyoRLe8RrJw+vOoRThD7pcTYcw5dJB6p7RFM6cPvJoAmI
	H7UAhVVRKFq0Gd1lSUZ5YAH+yslX1cnA5FIe1gRm+T0W6/D+yy2x1pfRe/ilNgV8OEPzFwA==
X-Google-Smtp-Source: AGHT+IHP1Fd0sGLkQ/k1ehygW1U/2rX+co7VWYgKenbKobZj/JodEA4OGanXLHtBl1UX89G860zP0w==
X-Received: by 2002:a05:600c:2153:b0:475:d278:1ab8 with SMTP id 5b1f17b1804b1-4778bcb3702mr18584015e9.2.1763035205717;
        Thu, 13 Nov 2025 04:00:05 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.04.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 05/10] io_uring/bpf: add stubs for bpf struct_ops
Date: Thu, 13 Nov 2025 11:59:42 +0000
Message-ID: <081b9eae607501737bfd0e887ef37d6c4d9c77ed.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763031077.git.asml.silence@gmail.com>
References: <cover.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some basic helpers and definitions for implementing bpf struct_ops.
There are no callbaack yet, and registration will always fail.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  4 ++
 io_uring/Kconfig               |  5 ++
 io_uring/Makefile              |  1 +
 io_uring/bpf.c                 | 93 ++++++++++++++++++++++++++++++++++
 io_uring/bpf.h                 | 21 ++++++++
 io_uring/io_uring.c            |  2 +
 6 files changed, 126 insertions(+)
 create mode 100644 io_uring/bpf.c
 create mode 100644 io_uring/bpf.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ef1af730193a..43432a06d177 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -8,6 +8,8 @@
 #include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
+struct io_uring_ops;
+
 enum {
 	/*
 	 * A hint to not wake right away but delay until there are enough of
@@ -276,6 +278,8 @@ struct io_ring_ctx {
 		struct io_rings		*rings;
 		struct percpu_ref	refs;
 
+		struct io_uring_ops	*bpf_ops;
+
 		clockid_t		clockid;
 		enum tk_offsets		clock_offset;
 
diff --git a/io_uring/Kconfig b/io_uring/Kconfig
index 4b949c42c0bf..b4dad9b74544 100644
--- a/io_uring/Kconfig
+++ b/io_uring/Kconfig
@@ -9,3 +9,8 @@ config IO_URING_ZCRX
 	depends on PAGE_POOL
 	depends on INET
 	depends on NET_RX_BUSY_POLL
+
+config IO_URING_BPF
+	def_bool y
+	depends on IO_URING
+	depends on BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
diff --git a/io_uring/Makefile b/io_uring/Makefile
index bc4e4a3fa0a5..35eeeaf64489 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
+obj-$(CONFIG_IO_URING_BPF)	+= bpf.o
diff --git a/io_uring/bpf.c b/io_uring/bpf.c
new file mode 100644
index 000000000000..4cb5d25c9247
--- /dev/null
+++ b/io_uring/bpf.c
@@ -0,0 +1,93 @@
+#include <linux/mutex.h>
+
+#include "bpf.h"
+#include "register.h"
+
+static struct io_uring_ops io_bpf_ops_stubs = {
+};
+
+static bool bpf_io_is_valid_access(int off, int size,
+				    enum bpf_access_type type,
+				    const struct bpf_prog *prog,
+				    struct bpf_insn_access_aux *info)
+{
+	if (type != BPF_READ)
+		return false;
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+		return false;
+	if (off % size != 0)
+		return false;
+
+	return btf_ctx_access(off, size, type, prog, info);
+}
+
+static int bpf_io_btf_struct_access(struct bpf_verifier_log *log,
+				    const struct bpf_reg_state *reg, int off,
+				    int size)
+{
+	return -EACCES;
+}
+
+static const struct bpf_verifier_ops bpf_io_verifier_ops = {
+	.get_func_proto = bpf_base_func_proto,
+	.is_valid_access = bpf_io_is_valid_access,
+	.btf_struct_access = bpf_io_btf_struct_access,
+};
+
+static int bpf_io_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_io_check_member(const struct btf_type *t,
+				const struct btf_member *member,
+				const struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int bpf_io_init_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static int bpf_io_reg(void *kdata, struct bpf_link *link)
+{
+	return -EOPNOTSUPP;
+}
+
+static void bpf_io_unreg(void *kdata, struct bpf_link *link)
+{
+}
+
+void io_unregister_bpf(struct io_ring_ctx *ctx)
+{
+}
+
+static struct bpf_struct_ops bpf_io_uring_ops = {
+	.verifier_ops = &bpf_io_verifier_ops,
+	.reg = bpf_io_reg,
+	.unreg = bpf_io_unreg,
+	.check_member = bpf_io_check_member,
+	.init_member = bpf_io_init_member,
+	.init = bpf_io_init,
+	.cfi_stubs = &io_bpf_ops_stubs,
+	.name = "io_uring_ops",
+	.owner = THIS_MODULE,
+};
+
+static int __init io_uring_bpf_init(void)
+{
+	int ret;
+
+	ret = register_bpf_struct_ops(&bpf_io_uring_ops, io_uring_ops);
+	if (ret) {
+		pr_err("io_uring: Failed to register struct_ops (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+__initcall(io_uring_bpf_init);
diff --git a/io_uring/bpf.h b/io_uring/bpf.h
new file mode 100644
index 000000000000..34a51a57103d
--- /dev/null
+++ b/io_uring/bpf.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_BPF_H
+#define IOU_BPF_H
+
+#include <linux/io_uring_types.h>
+#include <linux/bpf.h>
+
+#include "io_uring.h"
+
+struct io_uring_ops {
+};
+
+#ifdef CONFIG_IO_URING_BPF
+void io_unregister_bpf(struct io_ring_ctx *ctx);
+#else
+static inline void io_unregister_bpf(struct io_ring_ctx *ctx)
+{
+}
+#endif
+
+#endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 29f34fbcbb01..5b80987ebb2c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -99,6 +99,7 @@
 #include "msg_ring.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "bpf.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2830,6 +2831,7 @@ static __cold void io_req_caches_free(struct io_ring_ctx *ctx)
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
+	io_unregister_bpf(ctx);
 
 	mutex_lock(&ctx->uring_lock);
 	io_sqe_buffers_unregister(ctx);
-- 
2.49.0


