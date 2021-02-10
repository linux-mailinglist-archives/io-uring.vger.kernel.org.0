Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B727315AFD
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhBJATU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbhBJAKh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:10:37 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4565DC061794
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id z6so385803wrq.10
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CBPe2QVkpoFJlPceE6q2Te0mqdyEU9UBWarRLTGKLM0=;
        b=DMVDk3Ojz/EL6mW3bgQRfyEMtMIf3OQRHn0o0+IOYl+LgQOss3nvczslXMrT2vpPkN
         qOUs9dR8O7rZmVbOMvrOEUfW3u0w0dLP7W8/emWpDHxLNDZJXp4bsRZ+kjnSifcbK4kl
         sEAaTc0LTLAiA9iDNU/c2wblC5yYP/BQwnjnHC/nT/w1cFN3/Q0ze9QBSSC1FYYqDkO4
         Ex7e7kdeoyTKCHr9t0YqCmom7selNuTnLiBDjXDb+NjLk+QXhlmeXeGsxug6yy47EiKJ
         82Y9uuVUi4jlMgjFiyE/PHOykZKgPD0H7Eqe9eqc5Cg1RJAS+WU10Av3dyhU9xBwiqbq
         S+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CBPe2QVkpoFJlPceE6q2Te0mqdyEU9UBWarRLTGKLM0=;
        b=lMuaChQ94g5seQfzbarRcd8KqqrZM9oYXRY/1G3mkYRBmiOQO0Pj2baxoR9SXlIGHt
         EF8uezr1AFvIpa/HvL03aEf9SvYYsTUqarmpIibekaIWdbR/iXoVrGgRGmUdLIPPYY+t
         uarC932zaN9nLOjqGiC5L6OLMKY4s0L9ca6EXsLDvzomgFB5vuyevCJ+UfSIgoxSuWfq
         SiLSSWUOoPRHW+BUiiXcgCno0BpF3EjzoWVf0pjBoSCzcLW9guVTRVARTjxdej4oQibW
         lcS6YEhqWZC0OcziXXPKmaRANziY3AgKdwSkh1NYZv6yD9acVK4scnc26d16G0CU3z3p
         3KRw==
X-Gm-Message-State: AOAM5302hLWrjYAZkVJstVqTXLZVoKMsWnlXzi+iPtdRjg/BmXi8dziD
        IbkymbTaiWTyJo3l/+TzSRs=
X-Google-Smtp-Source: ABdhPJzDm/3TnP8yezMiJlimPTCLUAcG3a3eR49sPAooBrYE5KjaNrn9tFFMpbXeHSiOg5+z3pQ9Ow==
X-Received: by 2002:a5d:4386:: with SMTP id i6mr504648wrq.411.1612915643003;
        Tue, 09 Feb 2021 16:07:23 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/17] io_uring: submit-completion free batching
Date:   Wed, 10 Feb 2021 00:03:14 +0000
Message-Id: <7b87800d74ccbaed1945ed035df3ee2e98782430.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_submit_flush_completions() does completion batching, but may also use
free batching as iopoll does. The main beneficiaries should be buffered
reads/writes and send/recv.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8c5fd348cac5..ed4c92f64d96 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1930,26 +1930,6 @@ static inline void io_req_complete_nostate(struct io_kiocb *req, long res,
 	io_put_req(req);
 }
 
-static void io_submit_flush_completions(struct io_comp_state *cs,
-					struct io_ring_ctx *ctx)
-{
-	int i, nr = cs->nr;
-
-	spin_lock_irq(&ctx->completion_lock);
-	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = cs->reqs[i];
-
-		__io_cqring_fill_event(req, req->result, req->compl.cflags);
-	}
-	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-	for (i = 0; i < nr; i++)
-		io_double_put_req(cs->reqs[i]);
-	cs->nr = 0;
-}
-
 static void io_req_complete_state(struct io_kiocb *req, long res,
 				  unsigned int cflags)
 {
@@ -2335,6 +2315,35 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		__io_req_free_batch_flush(req->ctx, rb);
 }
 
+static void io_submit_flush_completions(struct io_comp_state *cs,
+					struct io_ring_ctx *ctx)
+{
+	int i, nr = cs->nr;
+	struct io_kiocb *req;
+	struct req_batch rb;
+
+	io_init_req_batch(&rb);
+	spin_lock_irq(&ctx->completion_lock);
+	for (i = 0; i < nr; i++) {
+		req = cs->reqs[i];
+		__io_cqring_fill_event(req, req->result, req->compl.cflags);
+	}
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	for (i = 0; i < nr; i++) {
+		req = cs->reqs[i];
+
+		/* submission and completion refs */
+		if (refcount_sub_and_test(2, &req->refs))
+			io_req_free_batch(&rb, req);
+	}
+
+	io_req_free_batch_finish(ctx, &rb);
+	cs->nr = 0;
+}
+
 /*
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
-- 
2.24.0

