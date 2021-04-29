Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E140F36EE44
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhD2QkO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 12:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhD2QkH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 12:40:07 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA629C06138C
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 09:39:19 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso474740wmh.0
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 09:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=afTnP62qb92jH5uIvHL0LOvP3JYGeVL9jzQRaetWkGk=;
        b=vAhvylkMUgMB75E9E76GEUP6NOCEA3C+FAGQk+ntWG9JqqLXzuZdtKHfdBQ0ULddNw
         6jd5qUW9Zim6nTzSd1rZwFNiThEvNATfv2QlJZ0XOtlGeJLKb8HFaaq4meBnBjCGqBz6
         Xcp2JMQIgrGGNuzLNduJR5O1lic/JCHGKYP9854YlwoOvnS9W1tUY2eEQ4VHYgYC1L5H
         AYmzWASJEZed5eFsL5mkzlqXvZACqFHs/ezk6FXsJEVVWxDpFCaBsosQOaVBXZmpD6SS
         9HO9xRNZ9LGI0UMlaTeIf13GCuXuwNX12nA19/M+D5H/CTXYxmlEHNNSEKtkAdCwAG2x
         9D2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afTnP62qb92jH5uIvHL0LOvP3JYGeVL9jzQRaetWkGk=;
        b=dlJDIlxsE5QLw/QLhSpENqRPTTh7fjbRxtXqzu7YCDC9trM9drm2qfIw1Pm+lMz422
         RSZgOVpUSBkaf+TDcIZwuTjOh2dkxyiGrNsKYocHNgIQeHNiAlb0KVO9RNrx8Q4/fD41
         1GHXyb0J1u4VWhewraDsOPe7/5r4C64U+NVWLyIHg7KwnzyYnTM2j1PJHQzqWwozkuxL
         81nCZeh95kmbn/f1MRVj3YktrRc0uX0oLgnbince2x2/I/q0dKS7ijflLXxVHP/ZjS4U
         aqUGLNUNg/+/AxjNsoY6AjmueGUZPxc2K0UbmLiDLuqkYCgRAkAwVEUvO/p6VJwLd6gb
         Ph2A==
X-Gm-Message-State: AOAM5322BIE2ID84R2oFH8uUB/SaHqIa8JJoE4bWbHSZ33nXr1t9Jcjh
        iPL8LccshX0grmIf0lQAhZU=
X-Google-Smtp-Source: ABdhPJyfnv2Gs/AvFo0GUUb5hdSVKlrYu0uWQTIgkxunftTaJsDJB3twylA4nBhnDQK6kOQw8i5JOw==
X-Received: by 2002:a1c:f618:: with SMTP id w24mr996307wmc.93.1619714358485;
        Thu, 29 Apr 2021 09:39:18 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id 6sm13578191wmg.9.2021.04.29.09.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 09:39:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: defer submission ref put
Date:   Thu, 29 Apr 2021 17:39:04 +0100
Message-Id: <702e726ec0dedb97513ac4819f4ce6aea8cfc848.1619714335.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619714335.git.asml.silence@gmail.com>
References: <cover.1619714335.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 43b00077dbd3..9c8e1e773a34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2124,7 +2124,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 static void io_submit_flush_completions(struct io_comp_state *cs,
 					struct io_ring_ctx *ctx)
 {
-	int i, nr = cs->nr;
+	int refs, i, nr = cs->nr;
 	struct io_kiocb *req;
 	struct req_batch rb;
 
@@ -2132,8 +2132,9 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->compl.cflags);
+		if (req->flags & REQ_F_COMPLETE_INLINE)
+			__io_cqring_fill_event(ctx, req->user_data, req->result,
+						req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
@@ -2141,9 +2142,10 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	io_cqring_ev_posted(ctx);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
+		refs = 1 + !!(req->flags & REQ_F_COMPLETE_INLINE);
 
 		/* submission and completion refs */
-		if (req_ref_sub_and_test(req, 2))
+		if (req_ref_sub_and_test(req, refs))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
@@ -6417,17 +6419,12 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (likely(!ret)) {
-		/* drop submission reference */
-		if (req->flags & REQ_F_COMPLETE_INLINE) {
-			struct io_ring_ctx *ctx = req->ctx;
-			struct io_comp_state *cs = &ctx->submit_state.comp;
-
-			cs->reqs[cs->nr++] = req;
-			if (cs->nr == ARRAY_SIZE(cs->reqs))
-				io_submit_flush_completions(cs, ctx);
-		} else {
-			io_put_req(req);
-		}
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_comp_state *cs = &ctx->submit_state.comp;
+
+		cs->reqs[cs->nr++] = req;
+		if (cs->nr == ARRAY_SIZE(cs->reqs))
+			io_submit_flush_completions(cs, ctx);
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		if (!io_arm_poll_handler(req)) {
 			/*
-- 
2.31.1

