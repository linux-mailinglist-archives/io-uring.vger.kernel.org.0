Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445D031D9AA
	for <lists+io-uring@lfdr.de>; Wed, 17 Feb 2021 13:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhBQMmz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 07:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbhBQMmy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Feb 2021 07:42:54 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C92C061786
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:42:13 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v15so17255751wrx.4
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rVgINE9+2XqaMOucWOivnn8FlQ0rJ0Zbjy7AzDSrz9Q=;
        b=izVwSIzT7se4mrQGf/OY6vcXiyzh4FZDsjnWRvA6F9cXtFmgQmeOmNAfz91IIQyuzG
         HeqpV04jutuSglLIIYJ2qRXfqEQ8L3xGjY2NRm5kkp5MPqpV7pNPwNms2WzhaO+wyjmg
         qoFGaA9LjzTwaJWOY3akJ01w0E/ueOkMEqsTxQ/BlT2Q2qHBVSnKzkrw5s2UeQc6aVjV
         TT6IPg12SfhsqEuYgTH4UJkDE7w/VtNNTeWOxGcMwSJdyqUWupdvZBi2U/TjbwlDijLc
         b/by19GmORehmv9inNrYCfSEx7CVsiuG+sGbNmzwuycroyPymKo+qs0CNkl3ooh9Mnfp
         9qDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rVgINE9+2XqaMOucWOivnn8FlQ0rJ0Zbjy7AzDSrz9Q=;
        b=tBT95V2a3M3IzZU2V13aKcux7dr95+y+ISVBJPrgji1QfwDbMOFIDuEw335xu6llHL
         bSvaq5kTfYveBKyn8l8CWPE+rKylo/3GlFbZ8j/EQUTqajFPJJChJ/Grs6iyro+VfwmY
         KgvG2WKmPEm+Hw+j24gc9YHFV4ZE1IE2BBi4ypsdvjoVQpRbD8eUW0Il/pie1nazRf3k
         n9F3pOYMTr1k3SZkEGm+Jv0O7jc+3lxnwDJsHMn6uL+6f71HW9fEh0EcJB0t+P1I4JX4
         5Smps9a+B8UEefM3y+3Xtf160iLpsQVnmERv06Wd8dyyawNglUQ2FGYGC8+zknffnJx4
         Hn1A==
X-Gm-Message-State: AOAM5320Knut/7cbpqdrHJ7k5H6jY/KHlGJz5HECjgSnpbPFfUIfcYfB
        IeRj6sCa4PXD8MpIDUgdAl4=
X-Google-Smtp-Source: ABdhPJzPDhriotuPsSgs3gOku6NcTZmnsXBVYQq/SKxsut1yJCdnmArCFwnsJpvIQM3kYcIQ+8V69Q==
X-Received: by 2002:a5d:47ae:: with SMTP id 14mr28553967wrb.378.1613565732023;
        Wed, 17 Feb 2021 04:42:12 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.13])
        by smtp.gmail.com with ESMTPSA id t9sm3589979wrw.76.2021.02.17.04.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 04:42:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: enable BPF to submit SQEs
Date:   Wed, 17 Feb 2021 12:38:06 +0000
Message-Id: <9afcb448b11633b82a910d36d981b97f36781632.1613563964.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613563964.git.asml.silence@gmail.com>
References: <cover.1613563964.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a BPF_FUNC_iouring_queue_sqe BPF function as a demonstration of
submmiting a new request by a BPF request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c            | 79 ++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/bpf.h |  1 +
 2 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 716881ca0b48..2c63a3e68938 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -845,8 +845,14 @@ struct io_op_def {
 	unsigned		work_flags;
 };
 
+struct io_submit_link {
+	struct io_kiocb *head;
+	struct io_kiocb *last;
+};
 
 struct io_bpf_ctx {
+	struct io_ring_ctx 		*ctx;
+	struct io_submit_link		link;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -6716,11 +6722,6 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 		io_queue_sqe(req, NULL);
 }
 
-struct io_submit_link {
-	struct io_kiocb *head;
-	struct io_kiocb *last;
-};
-
 static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			 struct io_submit_link *link)
 {
@@ -6951,7 +6952,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			ret = -EBADF;
 	}
 
-	state->ios_left--;
+	if (state->ios_left > 1)
+		state->ios_left--;
 	return ret;
 }
 
@@ -10312,10 +10314,63 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	return ret;
 }
 
+static int io_ebpf_prep_req(struct io_bpf_ctx *bpf_ctx,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_ring_ctx *ctx = bpf_ctx->ctx;
+	struct io_kiocb *req = io_alloc_req(ctx);
+	int ret;
+
+	if (unlikely(!req))
+		return -ENOMEM;
+	if (!percpu_ref_tryget_many(&ctx->refs, 1)) {
+		kmem_cache_free(req_cachep, req);
+		return -EAGAIN;
+	}
+	percpu_counter_add(&current->io_uring->inflight, 1);
+	refcount_add(1, &current->usage);
+
+	ret = io_init_req(ctx, req, sqe);
+	if (unlikely(ret))
+		goto fail_req;
+
+	ret = io_submit_sqe(req, sqe, &bpf_ctx->link);
+	if (!ret)
+		return 0;
+fail_req:
+	io_double_put_req(req);
+	return ret;
+}
+
+BPF_CALL_3(bpf_io_uring_queue_sqe, void *, ctx, const void *, psqe, u32, len)
+{
+	const struct io_uring_sqe *sqe = psqe;
+	struct io_bpf_ctx *bpf_ctx = ctx;
+
+	if (len != sizeof(struct io_uring_sqe))
+		return -EINVAL;
+
+	return io_ebpf_prep_req(bpf_ctx, sqe);
+}
+
+const struct bpf_func_proto bpf_io_uring_queue_sqe_proto = {
+	.func = bpf_io_uring_queue_sqe,
+	.gpl_only = false,
+	.ret_type = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_PTR_TO_MEM,
+	.arg3_type = ARG_CONST_SIZE,
+};
+
 static const struct bpf_func_proto *
 io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
-	return bpf_base_func_proto(func_id);
+	switch (func_id) {
+	case BPF_FUNC_iouring_queue_sqe:
+		return &bpf_io_uring_queue_sqe_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
 }
 
 static bool io_bpf_is_valid_access(int off, int size,
@@ -10345,8 +10400,16 @@ static void io_bpf_run(struct io_kiocb *req)
 		return;
 	}
 
-	memset(&bpf_ctx, 0, sizeof(bpf_ctx));
+	io_submit_state_start(&ctx->submit_state, 1);
+	bpf_ctx.ctx = ctx;
+	bpf_ctx.link.head = NULL;
+
 	BPF_PROG_RUN(req->bpf.prog, &bpf_ctx);
+
+	if (bpf_ctx.link.head)
+		io_queue_link_head(bpf_ctx.link.head);
+	io_submit_state_end(&ctx->submit_state, ctx);
+
 	io_req_complete(req, 0);
 }
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2f1c0ab097d8..8c7c8f4ad044 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3996,6 +3996,7 @@ union bpf_attr {
 	FN(ktime_get_coarse_ns),	\
 	FN(ima_inode_hash),		\
 	FN(sock_from_file),		\
+	FN(iouring_queue_sqe),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.24.0

