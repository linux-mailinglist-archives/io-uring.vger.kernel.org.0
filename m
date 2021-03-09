Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA789331BCF
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 01:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhCIAma (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 19:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbhCIAmF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 19:42:05 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5CEC06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 16:42:04 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so4890126wmj.1
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 16:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=baJszLHKaZ3rZD2bLMvWzcxOe+f6tkrNTbQAfHeTdGM=;
        b=c1EURPIZQfSXfWV2GKF4sDb4njM5s8PHtz8/X4TjGTkPepRNTLAQjb5Yp7m/nj531W
         QUYjSddN7BKwtO/+9g7x+7jUzKKfWD89kK8znsmqGhSEr/um8E6OKEC4KgnTgVtCNn7/
         rENrgTY7sVO+nhtVD3jND5S766TC+ZgeTD/ABvzVNKufKJcGltcsSEeFMX92RrTfNw1n
         NAYsr4w3ITrlwYWlzpoVnydfEW61LbMJG+r/NDEHCErzlPbY7vPwQW/wNiFmLzB1MIUk
         PaoPZZsh85Be63GxWxBdlmpzyKdo9M7zpJ8npJthSKDEiMvdcU/MzZPR/oDio01buhWV
         d4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=baJszLHKaZ3rZD2bLMvWzcxOe+f6tkrNTbQAfHeTdGM=;
        b=L7kA6zZjRaknorRf29n42PMd+B44FJpX72reUOotwzvsqfSV/Vf46j36OPp8fAGYuj
         RV2AY2exbrPnhc8Ho3ir7qfCpS33fcplMA84ixGsNFAnPbCA9ZYzxYBFSGaA/6MqBQDz
         1qMHpE1161WgT9tqePk8Kajrqfau1y9GpyN8l2xOQIG6vKDvEPlF88OaIv8Iks6JGcKJ
         t3HfdQZ5rfsx7biTu+vb2ssi9kWMJGV5ic1zzLWkzF1VvdnivSSBaetTBemOSurSL6is
         rsRYNKW6e026JvW5F1RaCe/eXmeVYNla+VqkUnd4UNQMGCM/BwyVR1bkDMZCQpY4HePi
         J/1w==
X-Gm-Message-State: AOAM531kikaheYGWQesbuPwxS+r3ah+a7BjwkmKsZQDXNr0fHaZU7E/c
        Z/KWGFcBMklBdnkj8fNmGm2mdLVSCSEy+g==
X-Google-Smtp-Source: ABdhPJxAgGhOK5taRYQE+jji18HrCocCcFa8rKiWupe8eBI7ZfeDSPDp1HQsLQ64x2B2zCOsZrTimw==
X-Received: by 2002:a1c:dc42:: with SMTP id t63mr1181874wmg.153.1615250523504;
        Mon, 08 Mar 2021 16:42:03 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id 3sm23918131wry.72.2021.03.08.16.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 16:42:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: add io_disarm_next() helper
Date:   Tue,  9 Mar 2021 00:37:58 +0000
Message-Id: <44ecff68d6b47e1c4e6b891bdde1ddc08cfc3590.1615250156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615250156.git.asml.silence@gmail.com>
References: <cover.1615250156.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A preparation patch placing all preparations before extracting a next
request into a separate helper io_disarm_next().

Also, don't spuriously do ev_posted in a rare case where REQ_F_FAIL_LINK
is set but there are no requests linked (i.e. after cancelling a linked
timeout or setting IOSQE_IO_LINK on a last request of a submission
batch).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 68 ++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ca3c70e6640..b4fa6fb371c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1706,15 +1706,11 @@ static inline void io_remove_next_linked(struct io_kiocb *req)
 	nxt->link = NULL;
 }
 
-static void io_kill_linked_timeout(struct io_kiocb *req)
+static bool io_kill_linked_timeout(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *link;
+	struct io_kiocb *link = req->link;
 	bool cancelled = false;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->completion_lock, flags);
-	link = req->link;
 
 	/*
 	 * Can happen if a linked timeout fired and link had been like
@@ -1729,50 +1725,48 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 		ret = hrtimer_try_to_cancel(&io->timer);
 		if (ret != -1) {
 			io_cqring_fill_event(link, -ECANCELED);
-			io_commit_cqring(ctx);
+			io_put_req_deferred(link, 1);
 			cancelled = true;
 		}
 	}
 	req->flags &= ~REQ_F_LINK_TIMEOUT;
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-
-	if (cancelled) {
-		io_cqring_ev_posted(ctx);
-		io_put_req(link);
-	}
+	return cancelled;
 }
 
-
 static void io_fail_links(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
 {
-	struct io_kiocb *link, *nxt;
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long flags;
+	struct io_kiocb *nxt, *link = req->link;
 
-	spin_lock_irqsave(&ctx->completion_lock, flags);
-	link = req->link;
 	req->link = NULL;
-
 	while (link) {
 		nxt = link->link;
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link, -ECANCELED);
-
 		io_put_req_deferred(link, 2);
 		link = nxt;
 	}
-	io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+}
 
-	io_cqring_ev_posted(ctx);
+static bool io_disarm_next(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
+{
+	bool posted = false;
+
+	if (likely(req->flags & REQ_F_LINK_TIMEOUT))
+		posted = io_kill_linked_timeout(req);
+	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
+		posted |= (req->link != NULL);
+		io_fail_links(req);
+	}
+	return posted;
 }
 
 static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_LINK_TIMEOUT)
-		io_kill_linked_timeout(req);
+	struct io_kiocb *nxt;
 
 	/*
 	 * If LINK is set, we have dependent requests in this chain. If we
@@ -1780,14 +1774,22 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (likely(!(req->flags & REQ_F_FAIL_LINK))) {
-		struct io_kiocb *nxt = req->link;
+	if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL_LINK)) {
+		struct io_ring_ctx *ctx = req->ctx;
+		unsigned long flags;
+		bool posted;
 
-		req->link = NULL;
-		return nxt;
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		posted = io_disarm_next(req);
+		if (posted)
+			io_commit_cqring(req->ctx);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+		if (posted)
+			io_cqring_ev_posted(ctx);
 	}
-	io_fail_links(req);
-	return NULL;
+	nxt = req->link;
+	req->link = NULL;
+	return nxt;
 }
 
 static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
-- 
2.24.0

