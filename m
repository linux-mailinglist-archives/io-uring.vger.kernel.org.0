Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B03403CAF
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347271AbhIHPmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 11:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbhIHPmp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 11:42:45 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDEAC061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 08:41:36 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v10so3981591wrd.4
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 08:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FxQB238f0njCAJlkYapN8u/Z14rPHCNAXGmoNjBn9Yw=;
        b=fHbtRfQLVesvO1mtgu08nb789JD1me/E8n7h36FrJ8U2/g8M60u5f1f2K2W56gUpT5
         d5YrX21Pa3nWAUNvGYrqrO4fm9I5hhEuOk0fEDtOun5n1RgR1Lw4r5VCLRmORIflRBPZ
         9B5jbFE1r+YLhAy7XE8WvT/pDUpXKmWTv8OjzgPLHiZoG3biilyV55JkzYcXpZF+mLGK
         FIEyut/rFqPl17Tz28guEe9k++fLQqRfQsRTzA5hvEhFx8TE1BgqB2rNkTIXgs47YYk1
         chlk1Mve2hlDAcLqfEi0G+lsqMlSXGKrnM450jIeBsZPD3ysp/gsiWzdr5lZZrUDoOo1
         fSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FxQB238f0njCAJlkYapN8u/Z14rPHCNAXGmoNjBn9Yw=;
        b=XEQbkOG0iSFO1vuOpYV3Hr5yvm02sPPda7/94zNRPkVZGkX74e7sV2y3zmrn4VsLQB
         GgnK8gtKuq1FiIGFCq+2ivdscR0qVt7ozi/ZN+pHQa8KntapGAY4vAiUvnX977Okwdyh
         DMOKGQ2SsaeLGsbOQVfege4ybHLqN2CDChd2sm9X3ySjq4+Y5mv6gyd4dpQ8wLvZ6vrd
         z/yrpF76YnK899eMl3rXdncAGkjMK8x8V3EKamuCBMVHCpIWF4yz1+ce5Z4KpdnTpQDa
         wMjS61whN48Kr0YZnROfgOdhnSH1QgXzJ+473VygGjrM5h9Wfn9HC60ki2sapRYZasoL
         y0TQ==
X-Gm-Message-State: AOAM532LX2D/R5e9Dj1c8606fm9skX2Nh4R0s7eZa7g20xWIMminuJ+M
        88Vm23xUzHl0jTsQz3nduuzktcSt180=
X-Google-Smtp-Source: ABdhPJx/Etk0HXXKqMuwpyd0h1xJyriFpDBgwxTecVlfZh8307npH597Wn+QNVfl0fzGnnmTVadSog==
X-Received: by 2002:adf:eb02:: with SMTP id s2mr4961729wrn.294.1631115695587;
        Wed, 08 Sep 2021 08:41:35 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id s10sm2580979wrg.42.2021.09.08.08.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:41:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: inline linked part of io_req_find_next
Date:   Wed,  8 Sep 2021 16:40:51 +0100
Message-Id: <4126d13f23d0e91b39b3558e16bd86cafa7fcef2.1631115443.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631115443.git.asml.silence@gmail.com>
References: <cover.1631115443.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline part of __io_req_find_next() that returns a request but doesn't
need io_disarm_next(). It's just two places, but makes links a bit
faster.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1dc21f7ec666..45e9cd1af97a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2073,40 +2073,39 @@ static bool io_disarm_next(struct io_kiocb *req)
 	return posted;
 }
 
-static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
+static void __io_req_find_next_prep(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	bool posted;
+
+	spin_lock(&ctx->completion_lock);
+	posted = io_disarm_next(req);
+	if (posted)
+		io_commit_cqring(req->ctx);
+	spin_unlock(&ctx->completion_lock);
+	if (posted)
+		io_cqring_ev_posted(ctx);
+}
+
+static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt;
 
+	if (likely(!(req->flags & (REQ_F_LINK|REQ_F_HARDLINK))))
+		return NULL;
 	/*
 	 * If LINK is set, we have dependent requests in this chain. If we
 	 * didn't fail this request, queue the first one up, moving any other
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (req->flags & IO_DISARM_MASK) {
-		struct io_ring_ctx *ctx = req->ctx;
-		bool posted;
-
-		spin_lock(&ctx->completion_lock);
-		posted = io_disarm_next(req);
-		if (posted)
-			io_commit_cqring(req->ctx);
-		spin_unlock(&ctx->completion_lock);
-		if (posted)
-			io_cqring_ev_posted(ctx);
-	}
+	if (unlikely(req->flags & IO_DISARM_MASK))
+		__io_req_find_next_prep(req);
 	nxt = req->link;
 	req->link = NULL;
 	return nxt;
 }
 
-static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
-{
-	if (likely(!(req->flags & (REQ_F_LINK|REQ_F_HARDLINK))))
-		return NULL;
-	return __io_req_find_next(req);
-}
-
 static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!ctx)
-- 
2.33.0

