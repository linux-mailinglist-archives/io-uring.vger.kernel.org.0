Return-Path: <io-uring+bounces-4589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 785CD9C3642
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 02:50:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92B531C21613
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 01:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E083A1B6;
	Mon, 11 Nov 2024 01:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I8rEg6oo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA531250F8
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 01:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731289810; cv=none; b=b+lL/nixRjtKtA7OPn26p4sjHmT7sk5SwrgNUEjTl1apnCyq1rAZ2ZpdbSrla6CfZE0xN2icRvh6aN/59osmB6gUghBzMQCLPbiRhVQngcKIfYwZqHNhupEG20o7Y6DnMENq3b3pRX+gmn37NCM8ANV0vHWbg7eeC2Q6B6n5u3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731289810; c=relaxed/simple;
	bh=jvbIrsiF5aXfGP9grQIq8ERPXnt0zJUL365wHEj2yyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpoVIP7NAsB70Zep+v7y+y61VC+8ePcRoOsrMNq6A647SXckwIU7jmrdq/O6FE8/lJCEe4egZX8So71eQhV5M0Fqs5WEF1G7tKBzWkfokfVg5ryueejYjhyr3YfzbSMX2ZLoQmEfd9TViEUBukO880/YZff9G2wUINbaLNDD0xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I8rEg6oo; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4315839a7c9so38090515e9.3
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 17:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731289807; x=1731894607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=77w6NopLgeZ4XUkJxQUmUmdzyiKjbX9yzh81+v5A00E=;
        b=I8rEg6oo//SWxxaX9gK/p1LQddjH5yBAoKHdGfdpLm8WDFNNQlePtI6y/mNAcBLbCb
         ECUzz8zITvhZUXs7A1dcgBtJE3jgn0U43deHX85BQxeWPj7ouxs6/vnHQOIzDFbt/4NM
         2hUaBq6JyxzclCOIGW69kQ6BS+hLEjXcSE+CvwtWOqqLAIozmTEA6jdIV5sju5kwOnse
         wwXTHJfmokn4FhxE5y57UbRVzs4f0Hdo0XJ9lZGB7B3eqKx+qQkpRMuTMi6xbGvUJ2yC
         MGExNn6UvJcW+oPmFKGRtxEqj/DIyV7Yr1XtJZ7Qs3pNKi2TtoBUv+5QcQ92IL/W4h6w
         T12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731289807; x=1731894607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=77w6NopLgeZ4XUkJxQUmUmdzyiKjbX9yzh81+v5A00E=;
        b=wcW8FLRc6f5B2k98sSqJ8a0NScNJN5NdJ52rKZYWPOfDdhSzXkvAQrGmj8DwQyEup5
         zmGQjs6evzZjEbF5qeH3i5+01Qb94dMA0wefviqcGJyJ6MBs6/+qtBTBfP7JbnAyna0W
         uK8avnpCWC/lk2DtXu3oqL1cNCF/m15lDywBqgOPKR0q5kwVNpe7SZlUIJO85tRrcVVR
         onKuVZSxCI5VOlTUM9ptHpbK+nzoq2lcDxi9L0yFdEenzirCJsWLGW/zKF7DkPpwYxzu
         Oh4igGCuhd3My9avgmw9/N1f03sV1PqOiAyJt9ULFnCcNF+UowsPMbnSMy44PlZm5Y1U
         oH7g==
X-Gm-Message-State: AOJu0YyghCjKbvQVCqfN16gC1cxCTpNMLo6tJJSkoQS3pQNtv5uM71PW
	fkpp661mYgANJ1fq3chxWY5Od0nIFj7e+GMtJglnXfuN9KS60Ooa29fmBA==
X-Google-Smtp-Source: AGHT+IFiLHGGI1Kt4DqGkB6SUar8Y+UlQRdQVDTQNwyxKcVixS/RnNDAFv0ps2hRaLXLaIRfRqrPlA==
X-Received: by 2002:a05:600c:3b82:b0:42c:bb10:7292 with SMTP id 5b1f17b1804b1-432b74fc98cmr95180895e9.1.1731289806824;
        Sun, 10 Nov 2024 17:50:06 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c18e0sm161494685e9.28.2024.11.10.17.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 17:50:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 3/3] io_uring/bpf: add kfuncs for BPF programs
Date: Mon, 11 Nov 2024 01:50:46 +0000
Message-ID: <e4c5bc9551109bef91c53be43a4296f3d317f19a.1731285516.git.asml.silence@gmail.com>
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

Add a way for io_uring BPF programs to look at CQEs and submit new
requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf.c      | 118 ++++++++++++++++++++++++++++++++++++++++++++
 io_uring/bpf.h      |   2 +
 io_uring/io_uring.c |   1 +
 3 files changed, 121 insertions(+)

diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 8b7c74761c63..d413c3712612 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -4,6 +4,123 @@
 #include <linux/filter.h>
 
 #include "bpf.h"
+#include "io_uring.h"
+
+static inline struct io_bpf_ctx *io_user_to_bpf_ctx(struct io_uring_bpf_ctx *ctx)
+{
+	struct io_bpf_ctx_kern *bc = (struct io_bpf_ctx_kern *)ctx;
+
+	return container_of(bc, struct io_bpf_ctx, kern);
+}
+
+__bpf_kfunc_start_defs();
+
+__bpf_kfunc int bpf_io_uring_queue_sqe(struct io_uring_bpf_ctx *user_ctx,
+					void *bpf_sqe, int mem__sz)
+{
+	struct io_bpf_ctx *bc = io_user_to_bpf_ctx(user_ctx);
+	struct io_ring_ctx *ctx = bc->ctx;
+	unsigned tail = ctx->rings->sq.tail;
+	struct io_uring_sqe *sqe;
+
+	if (mem__sz != sizeof(*sqe))
+		return -EINVAL;
+
+	ctx->rings->sq.tail++;
+	tail &= (ctx->sq_entries - 1);
+	/* double index for 128-byte SQEs, twice as long */
+	if (ctx->flags & IORING_SETUP_SQE128)
+		tail <<= 1;
+	sqe = &ctx->sq_sqes[tail];
+	memcpy(sqe, bpf_sqe, sizeof(*sqe));
+	return 0;
+}
+
+__bpf_kfunc int bpf_io_uring_submit_sqes(struct io_uring_bpf_ctx *user_ctx,
+					 unsigned nr)
+{
+	struct io_bpf_ctx *bc = io_user_to_bpf_ctx(user_ctx);
+	struct io_ring_ctx *ctx = bc->ctx;
+
+	return io_submit_sqes(ctx, nr);
+}
+
+__bpf_kfunc int bpf_io_uring_get_cqe(struct io_uring_bpf_ctx *user_ctx,
+				     struct io_uring_cqe *res__uninit)
+{
+	struct io_bpf_ctx *bc = io_user_to_bpf_ctx(user_ctx);
+	struct io_ring_ctx *ctx = bc->ctx;
+	struct io_rings *rings = ctx->rings;
+	unsigned int mask = ctx->cq_entries - 1;
+	unsigned head = rings->cq.head;
+	struct io_uring_cqe *cqe;
+
+	/* TODO CQE32 */
+	if (head == rings->cq.tail)
+		goto fail;
+
+	cqe = &rings->cqes[head & mask];
+	memcpy(res__uninit, cqe, sizeof(*cqe));
+	rings->cq.head++;
+	return 0;
+fail:
+	memset(res__uninit, 0, sizeof(*res__uninit));
+	return -EINVAL;
+}
+
+__bpf_kfunc
+struct io_uring_cqe *bpf_io_uring_get_cqe2(struct io_uring_bpf_ctx *user_ctx)
+{
+	struct io_bpf_ctx *bc = io_user_to_bpf_ctx(user_ctx);
+	struct io_ring_ctx *ctx = bc->ctx;
+	struct io_rings *rings = ctx->rings;
+	unsigned int mask = ctx->cq_entries - 1;
+	unsigned head = rings->cq.head;
+	struct io_uring_cqe *cqe;
+
+	/* TODO CQE32 */
+	if (head == rings->cq.tail)
+		return NULL;
+
+	cqe = &rings->cqes[head & mask];
+	rings->cq.head++;
+	return cqe;
+}
+
+__bpf_kfunc
+void bpf_io_uring_set_wait_params(struct io_uring_bpf_ctx *user_ctx,
+				  unsigned wait_nr)
+{
+	struct io_bpf_ctx *bc = io_user_to_bpf_ctx(user_ctx);
+	struct io_ring_ctx *ctx = bc->ctx;
+	struct io_wait_queue *wq = bc->waitq;
+
+	wait_nr = min_t(unsigned, wait_nr, ctx->cq_entries);
+	wq->cq_tail = READ_ONCE(ctx->rings->cq.head) + wait_nr;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(io_uring_kfunc_set)
+BTF_ID_FLAGS(func, bpf_io_uring_queue_sqe, KF_SLEEPABLE);
+BTF_ID_FLAGS(func, bpf_io_uring_submit_sqes, KF_SLEEPABLE);
+BTF_ID_FLAGS(func, bpf_io_uring_get_cqe, 0);
+BTF_ID_FLAGS(func, bpf_io_uring_get_cqe2, KF_RET_NULL);
+BTF_ID_FLAGS(func, bpf_io_uring_set_wait_params, 0);
+BTF_KFUNCS_END(io_uring_kfunc_set)
+
+static const struct btf_kfunc_id_set bpf_io_uring_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set = &io_uring_kfunc_set,
+};
+
+static int init_io_uring_bpf(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_IOURING,
+					 &bpf_io_uring_kfunc_set);
+}
+late_initcall(init_io_uring_bpf);
+
 
 static const struct bpf_func_proto *
 io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
@@ -82,6 +199,7 @@ int io_register_bpf(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	bc->prog = prog;
+	bc->ctx = ctx;
 	ctx->bpf_ctx = bc;
 	return 0;
 }
diff --git a/io_uring/bpf.h b/io_uring/bpf.h
index 2b4e555ff07a..9f578a48ce2e 100644
--- a/io_uring/bpf.h
+++ b/io_uring/bpf.h
@@ -9,6 +9,8 @@ struct bpf_prog;
 
 struct io_bpf_ctx {
 	struct io_bpf_ctx_kern kern;
+	struct io_ring_ctx *ctx;
+	struct io_wait_queue *waitq;
 	struct bpf_prog *prog;
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 82599e2a888a..98206e68ce70 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2836,6 +2836,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	io_napi_busy_loop(ctx, &iowq);
 
 	if (io_bpf_enabled(ctx)) {
+		ctx->bpf_ctx->waitq = &iowq;
 		ret = io_run_bpf(ctx);
 		if (ret == IOU_BPF_RET_STOP)
 			return 0;
-- 
2.46.0


