Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA57342350
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhCSR1I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhCSR1C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:27:02 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9D5C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:02 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so8721297wmq.1
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=joCjYqcWgT0/zLx6VjbSVEPZQFSMgHd6o0TFR/cIIzk=;
        b=F6Tf5kFnl1KtyzwHHj1Lcpr9Iemspoj89VhmpW1WdT3C9TBVBTbaOuY+8xZLEhRp6u
         YYfXasM004r8db8AplFHRx5g6F/hoDM+mQw8HPTPxDMjpbobXVf95uPoaU7QaL/sN0ER
         CrcF5BYvg+rPpPjnO1zk/b2EWSZhKOmgQF5wxfgO9Ni3qeGqA/y2yTkFMr3vQPS1EdDK
         vtwBGQ4SaaN0CAon6t5UUmi2da1CftyyhN7NofoJi4PoOJL4iw/78lTzrNKkIfl7iL12
         VZRDYa53VWCqYQGxe5nibOXpa1J6xg/+u8gcLe5LqjF8X+FqBSwXhK9SMHPRfr5YS1KP
         mLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=joCjYqcWgT0/zLx6VjbSVEPZQFSMgHd6o0TFR/cIIzk=;
        b=RiU2nb8LUpBzsRV77IuZdwGzW6C4eGYoIxvfPP8X2gaLIc5Raaj77+NDfH5ImSpqQw
         4Hki9idl0GnhYcVShVtS5lfY6e12cj/E2x4CspFj3smlaodANkZVuBdqe4xumujPgEyb
         EetU+bbiPKeWav1PbhVXCrJhsEUCROOCU0PG2+z5Rf1OR6dHMS80UNkyPCvP5NiAjCQq
         eBqr3j8rlJNkczqSeXbdtC2HdD5/ETHTqziba0KlkqXzsWh1YMqf4Ahf66N6peZwWnHQ
         0vE6Tj7yJ7kdIgCuWWqMZTYhCSeWmO/0S22EIJsEqVi52Y8Q70L6wh2kn2sGVFrwrZeF
         /IsA==
X-Gm-Message-State: AOAM532RBrvmBnfwIWJUSXAHadJ9Syjlkxk7vQBqMdNURoGFqg0180Yu
        xRrALxo7erQyFwwnsm/sT04=
X-Google-Smtp-Source: ABdhPJzX/UndVkIruX/D+31njFGl8WxD/Fn2WdXjaJINERF6jOl7vOd+71xHEsZzS90UKv/42Chlug==
X-Received: by 2002:a1c:ddc6:: with SMTP id u189mr4813596wmg.171.1616174821003;
        Fri, 19 Mar 2021 10:27:01 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:27:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/16] io_uring: add helper flushing locked_free_list
Date:   Fri, 19 Mar 2021 17:22:39 +0000
Message-Id: <2ddaf68cd48509fdc0ce38e12185a770498d15ec.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new helper io_flush_cached_locked_reqs() that splices
locked_free_list to free_list, and does it right doing all sync and
invariant reinit.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d081ef54fb02..6a5d712245f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1648,6 +1648,15 @@ static void io_req_complete_failed(struct io_kiocb *req, long res)
 	io_req_complete_post(req, res, 0);
 }
 
+static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
+					struct io_comp_state *cs)
+{
+	spin_lock_irq(&ctx->completion_lock);
+	list_splice_init(&cs->locked_free_list, &cs->free_list);
+	cs->locked_free_nr = 0;
+	spin_unlock_irq(&ctx->completion_lock);
+}
+
 /* Returns true IFF there are requests in the cache */
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
@@ -1660,12 +1669,8 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	 * locked cache, grab the lock and move them over to our submission
 	 * side cache.
 	 */
-	if (READ_ONCE(cs->locked_free_nr) > IO_COMPL_BATCH) {
-		spin_lock_irq(&ctx->completion_lock);
-		list_splice_init(&cs->locked_free_list, &cs->free_list);
-		cs->locked_free_nr = 0;
-		spin_unlock_irq(&ctx->completion_lock);
-	}
+	if (READ_ONCE(cs->locked_free_nr) > IO_COMPL_BATCH)
+		io_flush_cached_locked_reqs(ctx, cs);
 
 	nr = state->free_reqs;
 	while (!list_empty(&cs->free_list)) {
@@ -8425,13 +8430,8 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		submit_state->free_reqs = 0;
 	}
 
-	spin_lock_irq(&ctx->completion_lock);
-	list_splice_init(&cs->locked_free_list, &cs->free_list);
-	cs->locked_free_nr = 0;
-	spin_unlock_irq(&ctx->completion_lock);
-
+	io_flush_cached_locked_reqs(ctx, cs);
 	io_req_cache_free(&cs->free_list, NULL);
-
 	mutex_unlock(&ctx->uring_lock);
 }
 
-- 
2.24.0

