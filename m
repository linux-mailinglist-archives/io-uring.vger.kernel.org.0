Return-Path: <io-uring+bounces-8249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13496AD0398
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 15:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7024418925AC
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 13:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DB2289816;
	Fri,  6 Jun 2025 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GF/KB77s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93409288C81;
	Fri,  6 Jun 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749218209; cv=none; b=nCwDkRTcx7l5C7diEN4TujVmhr0QDbMpHLoQ7waVYYwYgaRUsbn1GvRRsoTFk3vzwd52eKoPs80VTiB5WVnDcrjBKF6tg1w8AYaIeNm373I9C++rMM6RwQOguCtZSF5HqB6jAtgTfnKBdBYgAx5mVaF6dzVfLA/WxrI1rMIV4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749218209; c=relaxed/simple;
	bh=ViC3IbHgyZt8fGF8lVTF8z4dPU4ffOy+7hz/L+RoQG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icHSxpy/GXOSJU+hwBIzbtEF/57XUiL3FjjFOYesa6Eq+JpUADHryfS21Q+WL/eaioh+2SZJdVwGmW1Asa6hd8J0w7F9hxkLX9USUvdFvY6j2/cyXSb7oquhbOMcGxQp/t5YBI+MQiR3TaOmqv0NrVFy9qDyFLBaMUIw9uYHBpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GF/KB77s; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-60497d07279so3980611a12.3;
        Fri, 06 Jun 2025 06:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749218205; x=1749823005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WR0oSDemJ8McuKWbT8yQkZjejC+oeGCjvdBXaJShshE=;
        b=GF/KB77s810NczF6lb0xLkLkJn/E3qDQ1KuH8phAYUInIAhexh+6QNlYMjybl3Q5kS
         GZRkPzzO+nqHRJ7DpdwLrrBK6HxQnbM4Q2EExc16HJ7/K0gxSWRWFHvOQbwCO0HzZeqm
         +hgMHeQKoqgb7wmxHgyXHYSpcn0dnaEbgpw1bZIGMNq+PpQ/Tl7NJHMX3V/1TRueJvCa
         RkjRs5+nWh/Y6Pnr+quD7UWmUi7mB2zsVR6VFBm0ieWAiHbJnbwh0g6ssSA7DHYkelHQ
         XCsCIOYDjHZDM2yNN1r+NR/rAHeG3wB4H30Myru16OUpDtT4PZpCbY3OOwCJn7xR0WVj
         Hq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749218205; x=1749823005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WR0oSDemJ8McuKWbT8yQkZjejC+oeGCjvdBXaJShshE=;
        b=Dqq/DJ0gZiLIJ/UDLkQwHfa31RFdji0wpVUJKmh29hoyRzqrPeyy1HjHLRb0PdYgAp
         +v+8PI+0f1//hj0pmFhFphXvUuqZwDXOEexJg8LrB/u4mC34RAf5XQ8fmKhauswA4TLE
         BphNoPm6PV0t6y6/5OlYa9W0HsQW2YUFtXB+i6+6F8UAOU3Wo2Jk/WE8rsUrJJIpKmEv
         T0WuQbHP2oUIv+qNVlXBCN3m7tHuimsiEDPkimQQFXImYdkoyW6DWuqkjvBNw7ovIKL3
         /biv3fvXwSVQRNAs0PGO8xgy1r+CBfkFfOKxGVmqDbzUuGJKGGG1DbPFKrupShNCO7jc
         C5Ig==
X-Forwarded-Encrypted: i=1; AJvYcCVlV9BySdA22FYoYYYJo2GOjRi6WJnQl3w0otbbJC4osKfr7ga6tcpsBGByV6Potp2SQ8K3iRTGHsYnFKR+@vger.kernel.org, AJvYcCXBywf826u3s4xNyr5pGutz5AcL8CGxxEQEG39ZNH0nkSD3izqyzyPt5LzL6HjH4s4GGp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyllAm/kpVxg1sX8VljGgfnXF6GRoMJywquD4AKXzmCROs7pL9S
	XYlUCpQVQV2ZRsBM87jkf1SbO02xFibATRNlE0Paxgg2MLPrLS6rFG3qugUzFg==
X-Gm-Gg: ASbGncv6TVSGrqLvgWWqMnL9BBgXrcSZdBb7WcDy208UOFXij+NVA5ITkWjGv/MJK/9
	yjrmDu2OLwN/gcrXbWQ2PDzzcPWR7DSZJ32NHPdpROlrG+oD3/HRRy2DxLGhUUc6X3bn79AW8Qu
	EuG6OGt+RZxKICey36lDbLgXPoMaH0DWo6/cr7fQgzreeKS8nlClybX84M10XSnSSwOLXsCMsDJ
	NKZYXUzFFQFmO4VbyAzEKycGZMvyT1FFeJbRqKFw3KUIjZdsVxFw1IpTi3G8ZiOrnREdKdJyr7L
	ZBCHsYr6undqGHYJH4hs+mEhAbUPe/cv374yXhnN4QMlTw==
X-Google-Smtp-Source: AGHT+IEl038+iTCO65fTXNrf0nnQgWPfEsmuWE98Gk6ylNubF4OzxPQhOmh+mxtWg0ptadhMSYcjSA==
X-Received: by 2002:a17:906:d54e:b0:ad5:1c28:3c4b with SMTP id a640c23a62f3a-ade1a9ee319mr292192966b.52.1749218205205;
        Fri, 06 Jun 2025 06:56:45 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1dc379f6sm118026766b.110.2025.06.06.06.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 06:56:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 2/5] io_uring/bpf: add stubs for bpf struct_ops
Date: Fri,  6 Jun 2025 14:57:59 +0100
Message-ID: <e2cd83fa47ed6e7e6c4e9207e66204e97371a37c.1749214572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749214572.git.asml.silence@gmail.com>
References: <cover.1749214572.git.asml.silence@gmail.com>
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
 io_uring/bpf.h                 | 26 ++++++++++
 io_uring/io_uring.c            |  3 ++
 6 files changed, 132 insertions(+)
 create mode 100644 io_uring/bpf.c
 create mode 100644 io_uring/bpf.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 2922635986f5..26ee1a6f52e7 100644
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
@@ -344,6 +346,8 @@ struct io_ring_ctx {
 
 		void			*cq_wait_arg;
 		size_t			cq_wait_size;
+
+		struct io_uring_ops	*bpf_ops;
 	} ____cacheline_aligned_in_smp;
 
 	/*
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
index d97c6b51d584..58f46c0f9895 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_EPOLL)		+= epoll.o
 obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
 obj-$(CONFIG_NET) += net.o cmd_net.o
 obj-$(CONFIG_PROC_FS) += fdinfo.o
+obj-$(CONFIG_IO_URING_BPF)	+= bpf.o
diff --git a/io_uring/bpf.c b/io_uring/bpf.c
new file mode 100644
index 000000000000..3096c54e4fb3
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
+void io_unregister_bpf_ops(struct io_ring_ctx *ctx)
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
index 000000000000..a61c489d306b
--- /dev/null
+++ b/io_uring/bpf.h
@@ -0,0 +1,26 @@
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
+static inline bool io_bpf_attached(struct io_ring_ctx *ctx)
+{
+	return IS_ENABLED(CONFIG_BPF) && ctx->bpf_ops != NULL;
+}
+
+#ifdef CONFIG_BPF
+void io_unregister_bpf_ops(struct io_ring_ctx *ctx);
+#else
+static inline void io_unregister_bpf_ops(struct io_ring_ctx *ctx)
+{
+}
+#endif
+
+#endif
\ No newline at end of file
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9cc4d8f335a1..8f68e898d60c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -98,6 +98,7 @@
 #include "msg_ring.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "bpf.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2870,6 +2871,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	struct io_tctx_node *node;
 	int ret;
 
+	io_unregister_bpf_ops(ctx);
+
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while
-- 
2.49.0


