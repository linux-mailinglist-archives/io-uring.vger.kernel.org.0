Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696D231EF00
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhBRSwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbhBRShU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:37:20 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9C4C061A30
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:56 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v1so4066131wrd.6
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7F8hU8d5AGdfbix8p1s7zuw3LgCaEkXUQg0pNzK96kg=;
        b=sdhYR3TcBmCpNRObInNqE41knO3ClhqzsyWaIvLcuv0hYoTgE1oSiIK8eNU8MrmnZX
         eMTEe66kJ21lb70y13+lEyYNJ11+0n7tMr3FIp/pzkADS4HHXB78otVk4sIRxDdaK0f+
         1rU32Xcf4ZITAhAxAB+AJG72aU+4fgSRqSIpTUOdj4YPnLg+AlFSApDMkgHEKtKiB0Rm
         WJvcnAmHGMIaTJJ8hsznSR2QE8oOw8In0Da98XVJtishZypvXlPaIX5fPOSpliFmDkFU
         z3nNvGBWteQn9jnwl0ZTLeP2ziSkpszdj7L3mOgdr2s+Zb+5Z4/8U+05MiYkPbYdHJO0
         rNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7F8hU8d5AGdfbix8p1s7zuw3LgCaEkXUQg0pNzK96kg=;
        b=StME6ahT0areDokQsd3BblFFFEh3Mvu2wWRWm540yeRovmNWRNeAAfC73caqx7c4yK
         x5AOIPmmswx5bPAQ6cFdSBUKf6RDSaJtBb79R9HTS9O+E5GWT8p3vtD782abA1Zwe3bJ
         Wd6mpn+sarZ0fesh/krMPGtZb8A6F+788FZZH0f4l6LQPU5vWyYFoUrYKt16SrAWIrZX
         If99u9OfV1z9vL5nXp01vF5CBBIe3maJsKQob9ILm8ZlmVvbghStILlg7dcQHEN8plQg
         1F451djw45LInwXYaIOlvOcN+J/nmHE20QFImIytJUPlMZ/Mi4wx12n/te21F77zwWpQ
         1FIw==
X-Gm-Message-State: AOAM533d5TJqPoavu3fn0SPBT+eFwEHD9jSM8wHaoRHtChcr9OAxi6c7
        D+Xjp2l0vuSqDqLbvTbcrN4=
X-Google-Smtp-Source: ABdhPJzlmN7obPXmtHgDypSbCfvyO98/MCwsKu7B2Vc1DzD5g2l3YW4k43xB8fzAYFVsRUVna7zAfg==
X-Received: by 2002:a5d:4952:: with SMTP id r18mr5650742wrs.268.1613673235365;
        Thu, 18 Feb 2021 10:33:55 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/11] io_uring: fail links more in io_submit_sqe()
Date:   Thu, 18 Feb 2021 18:29:47 +0000
Message-Id: <e318becca21122346ef1f702ad8461d472af3728.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of marking a link with REQ_F_FAIL_LINK on an error and delaying
its failing to the caller, do it eagerly right when after getting an
error in io_submit_sqe(). This renders FAIL_LINK checks in
io_queue_link_head() useless and we can skip it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 45f78fd25ce2..2fdfe5fa00b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6645,15 +6645,6 @@ static void io_queue_sqe(struct io_kiocb *req)
 	}
 }
 
-static inline void io_queue_link_head(struct io_kiocb *req)
-{
-	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
-		io_put_req(req);
-		io_req_complete(req, -ECANCELED);
-	} else
-		io_queue_sqe(req);
-}
-
 /*
  * Check SQE restrictions (opcode and flags).
  *
@@ -6768,9 +6759,13 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 fail_req:
 		io_put_req(req);
 		io_req_complete(req, ret);
-		/* fail even hard links since we don't submit */
-		if (link->head)
+		if (link->head) {
+			/* fail even hard links since we don't submit */
 			link->head->flags |= REQ_F_FAIL_LINK;
+			io_put_req(link->head);
+			io_req_complete(link->head, -ECANCELED);
+			link->head = NULL;
+		}
 		return ret;
 	}
 	ret = io_req_prep(req, sqe);
@@ -6811,7 +6806,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 		/* last request of a link, enqueue the link */
 		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			io_queue_link_head(head);
+			io_queue_sqe(head);
 			link->head = NULL;
 		}
 	} else {
@@ -6837,7 +6832,7 @@ static void io_submit_state_end(struct io_submit_state *state,
 				struct io_ring_ctx *ctx)
 {
 	if (state->link.head)
-		io_queue_link_head(state->link.head);
+		io_queue_sqe(state->link.head);
 	if (state->comp.nr)
 		io_submit_flush_completions(&state->comp, ctx);
 	if (state->plug_started)
-- 
2.24.0

