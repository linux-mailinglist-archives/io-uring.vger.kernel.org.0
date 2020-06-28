Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E2020C750
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgF1JyY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1JyY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:24 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E43C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i14so13363945ejr.9
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UWhRbvDJkSXNHR2BRl9ZNqFQ2Mh8OwSuZ7VlrAPrdGU=;
        b=VpC5siY7+K2J/56CBQBSE/vDSK9ph5xAfqFwgcnl9azuELMpZY/zlmhS4xTCE3yCvu
         a2UevtVF+2Wxy2MSBlxoY0clU22cOk3w2GxcE78vNbqmE5igm1rKeG19th7eSzZ/oTSJ
         ghHqOShfXJZ71FissCLCNIsBqTg6o4iYkRRBTR7Ioii0PBodVABYjhX1Q5VdqTB20mzG
         2Nsij5rVFpefi2otzWiN9Y2m/8kMR0zNMDbp4FD6ib8SnNuLHGhOt7zmO8V6OZr0ct2E
         3GkiC8eu7F2WZ39n+djXtIu6q3k07tVfmZZh6bltnX0VX+gSJhnCl3q2bt0dGGK5dkaT
         xw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UWhRbvDJkSXNHR2BRl9ZNqFQ2Mh8OwSuZ7VlrAPrdGU=;
        b=RWTbr9WYAoyHS0chT7Goq0EjF799AbXXbLxjeBqidDjdIE/bsMg7D7RIdgoeP8f9r+
         uwompiqyTRFwEl/Dhu2M41OfUFLR38+sUJEJrhUDeE9he24v2PKky5uzA2tKimcvfxVF
         ObXVsThUwkpUTasZkU2hiWze5/GmspReCnHf2nEaBgVU4kyrw7D6xtflYHyxNzdL8y09
         wtpt4GwdEC3a7Eywdu9u3JPUQ3QVmSsM7Y68anhi+qoYfsAYEOI4fMJWmLR6LMsEu6Tf
         DzjEDNwTOYp2wRhpr2zPzS7sBAVBiMSE7eW0iv6o6+ouYddAR7XAxoae1/3s80oEEzFw
         YFfw==
X-Gm-Message-State: AOAM530Qu2Ac7pj2Kl9gEET/mCkpLnZEG+MbLUhuQZGUamKeejgCY177
        hyCn9r8CLjC7ZJT/Vfo97Ag=
X-Google-Smtp-Source: ABdhPJwYp3+KkPXnPOvuC9nduzNvgESGIJTKI3y4n4WBKX8SHesot572u403EynELZiwkqByZm8zAw==
X-Received: by 2002:a17:906:17c8:: with SMTP id u8mr9771382eje.129.1593338062592;
        Sun, 28 Jun 2020 02:54:22 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/10] io_uring: batch-free linked reqs as well
Date:   Sun, 28 Jun 2020 12:52:32 +0300
Message-Id: <fbcedd89d9936f16cfc2eaeab43d206d85330f78.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no reason to not batch deallocation of linked requests. Take
away its next req first and handle it as everything else in
io_req_multi_free().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3c6506e9df1..d9dd445e4e57 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1728,17 +1728,21 @@ static void io_req_task_queue(struct io_kiocb *req)
 	wake_up_process(tsk);
 }
 
-static void io_free_req(struct io_kiocb *req)
+static void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = NULL;
 
 	io_req_find_next(req, &nxt);
-	__io_free_req(req);
-
 	if (nxt)
 		io_req_task_queue(nxt);
 }
 
+static void io_free_req(struct io_kiocb *req)
+{
+	io_queue_next(req);
+	__io_free_req(req);
+}
+
 /*
  * Drop reference to request, return next in chain (if there is one) if this
  * was the last reference to this request.
@@ -1835,16 +1839,19 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
 
-static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
+static inline void io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 {
-	if ((req->flags & REQ_F_LINK_HEAD) || io_is_fallback_req(req))
-		return false;
+	if (unlikely(io_is_fallback_req(req))) {
+		io_free_req(req);
+		return;
+	}
+	if (req->flags & REQ_F_LINK_HEAD)
+		io_queue_next(req);
 
 	io_dismantle_req(req);
 	rb->reqs[rb->to_free++] = req;
 	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
 		io_free_req_many(req->ctx, rb);
-	return true;
 }
 
 static int io_put_kbuf(struct io_kiocb *req)
@@ -1910,9 +1917,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		__io_cqring_fill_event(req, req->result, cflags);
 		(*nr_events)++;
 
-		if (refcount_dec_and_test(&req->refs) &&
-		    !io_req_multi_free(&rb, req))
-			io_free_req(req);
+		if (refcount_dec_and_test(&req->refs))
+			io_req_multi_free(&rb, req);
 	}
 
 	io_commit_cqring(ctx);
-- 
2.24.0

