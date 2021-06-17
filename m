Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B323ABA5C
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhFQRQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhFQRQq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:46 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB75BC061574
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:36 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n7so7638357wri.3
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ux1bkyqsosYicNSBMvTHq2Nif10tcnAo2drp2wY4Cfw=;
        b=MaVyrOPxB5VaiclzlK+uayoLq6KYyTSqAU0LfjyN+pVancaHixYCie/Kz7z0HiFj4p
         wqxM12syeq2/Cr70wG/XRHtjM64kGKwoKqucsRclK8l0yy9XZYQdV6iGeLwco0fMut31
         Xq+4Mhrrpyt5PTnw/mwps+HMPPDIpSuc2+tJc6fjvvPbiH8I0DNOU6UnN5cpZPNEwiNu
         WNDPh2+2SuiYDuut5jGfXfRrU/fxQg8OxKnBVxs2+ahZ9b++V3J5DNxRPvuN/4Tj3PSy
         AmcODyg8Zgu20JkX9mNhb2cZBIWPiVsTyhdxIk3Ez7sEPKuGP8hgVyOq7avAjl2fEotP
         w+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ux1bkyqsosYicNSBMvTHq2Nif10tcnAo2drp2wY4Cfw=;
        b=CvlpdcH2LOjkaKWtISkY8iL2PLHUMi5l9KcWR+HzEr4baeZ6LOAD0GqXbKgAGoBIb6
         oTpXMhXZ6abpTirgHXXvahLJLXUYuRPBeQhRvenJEgt1ggtKHqDd01Cn76xxGzTwjKz1
         VdTuGUEPXETKZsZoZyllkPy2t7GlgH9VCKqaYzOCYxkuTIrqnCQY7jbFTBlgbvdadRfD
         pIQ5yWjzTv1JnEWDkx/4SPWMFF9pbA+DdHlkI2cyjCF17yHSxZXLtfLoYEh/OWX72LLk
         BWPAgXt/5Mt8eec4El8jKoMo29OZJOlD8y6WtBcR43FzB+wZT7uHsIrKQ0A1K40xOGxP
         y8Hw==
X-Gm-Message-State: AOAM530eAY/0auWCE7Oyfzd/CAq26m9+si9DZSgT4M7YbVtbXvnLuwWO
        +1+Kgy9m412rK6Se0RYN5XZ/dKyzDP/N9g==
X-Google-Smtp-Source: ABdhPJzSkKub9aanBflVUX76kClA6m1nKFWnopmLBb7VF6PNz2oEb9pFhnmu06+yiNYB87vDSEQEUQ==
X-Received: by 2002:a5d:6849:: with SMTP id o9mr6902828wrw.44.1623950075473;
        Thu, 17 Jun 2021 10:14:35 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/12] io_uring: move creds from io-wq work to io_kiocb
Date:   Thu, 17 Jun 2021 18:14:01 +0100
Message-Id: <8520c72ab8b8f4b96db12a228a2ab4c094ae64e1.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq now doesn't have anything to do with creds now, so move ->creds
from struct io_wq_work into request (aka struct io_kiocb).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h    |  1 -
 fs/io_uring.c | 24 +++++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index af2df0680ee2..32c7b4e82484 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -87,7 +87,6 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	const struct cred *creds;
 	unsigned flags;
 };
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5935df64b153..2bac5cd4dc91 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -851,6 +851,8 @@ struct io_kiocb {
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
+	const struct cred 		*creds;
+
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 };
@@ -1234,8 +1236,8 @@ static void io_prep_async_work(struct io_kiocb *req)
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->work.creds)
-		req->work.creds = get_current_cred();
+	if (!req->creds)
+		req->creds = get_current_cred();
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
@@ -1745,9 +1747,9 @@ static void io_dismantle_req(struct io_kiocb *req)
 		percpu_ref_put(req->fixed_rsrc_refs);
 	if (req->async_data)
 		kfree(req->async_data);
-	if (req->work.creds) {
-		put_cred(req->work.creds);
-		req->work.creds = NULL;
+	if (req->creds) {
+		put_cred(req->creds);
+		req->creds = NULL;
 	}
 }
 
@@ -6139,8 +6141,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
-	if (req->work.creds && req->work.creds != current_cred())
-		creds = override_creds(req->work.creds);
+	if (req->creds && req->creds != current_cred())
+		creds = override_creds(req->creds);
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
@@ -6532,7 +6534,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	atomic_set(&req->refs, 2);
 	req->task = current;
 	req->result = 0;
-	req->work.creds = NULL;
+	req->creds = NULL;
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
@@ -6550,10 +6552,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
-		req->work.creds = xa_load(&ctx->personalities, personality);
-		if (!req->work.creds)
+		req->creds = xa_load(&ctx->personalities, personality);
+		if (!req->creds)
 			return -EINVAL;
-		get_cred(req->work.creds);
+		get_cred(req->creds);
 	}
 	state = &ctx->submit_state;
 
-- 
2.31.1

