Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925C93198C6
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 04:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBLD2b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 22:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhBLD2b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 22:28:31 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F3EC061786
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:50 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u14so6373378wri.3
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=D3GfJSNGd+imEEGRn3TpK96a66d2t0kq6rrKClucV3Q=;
        b=IYcuzaVT/KRXSZHIXfNpqHljF3S7+mBFaw8E1AJ162snECa08A4PdcRurR28A52KnE
         +Tj9yiWbj7VkLyFtuUW7ZLACKjkSTcnqPzMkG3WfD3oLYwD0uNh/oywcx1C1QlYq4nBh
         haAYlFEZyUHJOZ1F82usrVGgVK/kAR/Hb00TUs9Ln67u0uQXLYGO7GYC1gvY7zak1DGV
         KPgW8AgERLmV0jY3HhoXc5p8MNOyfv3jGHva20WRu19ZpKVCQxD402QLAyxiOg+M62tE
         tAnn2v6PXdi1i5JMAm1IUNZ/9rq9m6n0EqRGOikMXRNgFIL5NCP2n71Nj22W2+wBeqyI
         zEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3GfJSNGd+imEEGRn3TpK96a66d2t0kq6rrKClucV3Q=;
        b=EVfbJPLECTYlM6R/T0XNdNQch2wChAoR+zeDNTPlqQeMnHzbl8AolLbGm6jeeo3BPl
         DxEjfOALijAniIDBNJ+qjRtsRUA3befEzbbuzOFfbwMs/Y4A0oV5+TrNXs6IC5pARGnZ
         9M+bazpDNrAUR9YQ+gtkpg4JdNCjGTueFN5UJ2o4hLsjIBo5k9XFIjijnX0Hf/N75j2g
         FdAU06ZZoAG81dA+Ip1xpXmg2sZ5JmKaki0vhXyFUuh+VBUbGid3LmthOFCTiX16fCxB
         7fuFQZXRqzYvn2nt/YVxYnTLutxJ9XGF5n3kzcR5Vrl/+A1Hr1lChUVOmSVSbPtIRPUD
         sJkw==
X-Gm-Message-State: AOAM531M9v7cPDBoXBjbqpRPGud8kYIDDLXoize3x6RLlj/LZo+jJ7eU
        JdU1V9Hg6mW4WLqlEBJ8mFs=
X-Google-Smtp-Source: ABdhPJzqu8rcdw2n/hu44NZ/TmN9vileb9sk2A8DcTSe/vMgFItKEEiRmmg+4echftmVfCpkPT/IdQ==
X-Received: by 2002:adf:bbca:: with SMTP id z10mr934381wrg.168.1613100469456;
        Thu, 11 Feb 2021 19:27:49 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id c62sm12973479wmd.43.2021.02.11.19.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 19:27:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: optimise SQPOLL mm/files grabbing
Date:   Fri, 12 Feb 2021 03:23:52 +0000
Message-Id: <235e4a1840cbc5c0c28fcf3c1737c82618a6cac9.1613099986.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613099986.git.asml.silence@gmail.com>
References: <cover.1613099986.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two reasons for this. First is to optimise
io_sq_thread_acquire_mm_files() for non-SQPOLL case, which currently do
too many checks and function calls in the hot path, e.g. in
io_init_req().

The second is to not grab mm/files when there are not needed. As
__io_queue_sqe() issues only one request now, we can reuse
io_sq_thread_acquire_mm_files() instead of unconditional acquire
mm/files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 26d1080217e5..813d1ccd7a69 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1145,9 +1145,6 @@ static void io_sq_thread_drop_mm_files(void)
 
 static int __io_sq_thread_acquire_files(struct io_ring_ctx *ctx)
 {
-	if (current->flags & PF_EXITING)
-		return -EFAULT;
-
 	if (!current->files) {
 		struct files_struct *files;
 		struct nsproxy *nsproxy;
@@ -1175,15 +1172,9 @@ static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
 	struct mm_struct *mm;
 
-	if (current->flags & PF_EXITING)
-		return -EFAULT;
 	if (current->mm)
 		return 0;
 
-	/* Should never happen */
-	if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL)))
-		return -EFAULT;
-
 	task_lock(ctx->sqo_task);
 	mm = ctx->sqo_task->mm;
 	if (unlikely(!mm || !mmget_not_zero(mm)))
@@ -1198,8 +1189,8 @@ static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 	return -EFAULT;
 }
 
-static int io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
-					 struct io_kiocb *req)
+static int __io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
+					   struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	int ret;
@@ -1219,6 +1210,16 @@ static int io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static inline int io_sq_thread_acquire_mm_files(struct io_ring_ctx *ctx,
+						struct io_kiocb *req)
+{
+	if (unlikely(current->flags & PF_EXITING))
+		return -EFAULT;
+	if (!(ctx->flags & IORING_SETUP_SQPOLL))
+		return 0;
+	return __io_sq_thread_acquire_mm_files(ctx, req);
+}
+
 static void io_sq_thread_associate_blkcg(struct io_ring_ctx *ctx,
 					 struct cgroup_subsys_state **cur_css)
 
@@ -2336,9 +2337,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	mutex_lock(&ctx->uring_lock);
-	if (!ctx->sqo_dead &&
-	    !__io_sq_thread_acquire_mm(ctx) &&
-	    !__io_sq_thread_acquire_files(ctx))
+	if (!ctx->sqo_dead && !io_sq_thread_acquire_mm_files(ctx, req))
 		__io_queue_sqe(req);
 	else
 		__io_req_task_cancel(req, -EFAULT);
-- 
2.24.0

