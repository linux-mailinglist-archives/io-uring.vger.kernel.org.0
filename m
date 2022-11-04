Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893C661951A
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKDLDT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiKDLCi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:02:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EE82CDC0
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:02:36 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id y14so12274175ejd.9
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WolyIFn2U5osDC5mnfvXJt+vvPB7uFoWsvLJZrMnIx0=;
        b=S/XGRJ0B0wWarYLlkOOP83iTi+moCOdmuhNiFIb9t9fmGIg996r9KCycRLUx0PmL6q
         eJ9Pekt1e12Odhwz6aY1B45kiPURgvdTf9mAUXfFQ+D6ZV64XsPuUo4+UJxpCnWo2nFG
         l0fYZnPRwv7vdbvrsuG4BXdct136UpWdIVckTDdZfUWUusC87U+FvfNUJq7/LY/8P2jE
         +TtOi9UN0gtbq7CaHWLBTsq873Vcna5r7VYAJiruGw2pJ2IcykuyOn5Sy0fnlZ/LPhlS
         ib1fyGMlM66Z+e8pNdA3kEC71Ua0tOOof8YZ/bRQySTSOTyCjtfyMPy1r9pWRdTJ6a3M
         ey9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WolyIFn2U5osDC5mnfvXJt+vvPB7uFoWsvLJZrMnIx0=;
        b=gbwTI8jVzsIBnBV656niXWd/bja+32WMi6OSuqLWr2ZEb+S0gC5+8EuHaMTmYSsnnN
         cWQyn94+z8LsNBNAL9epnrsmSf6lALOTvqJl25KYZxIe6hHhbuvwfC5qNOSKYw+Fjwdx
         /hz2sye2TocQsYQly2LNDeovmg/Dww3q6kshDgDsbIPNql9owlCkMiY27zKyCnVK352t
         rmJlH9swua3nUETgirfH8QojjsGTmuJBL4JVYFs2W+3iVEiI6Y97lKd2AbtEqjhCQk1a
         OxCgfSshM1jjypo79S7ffC1b4mk/51dmPgkDTvIxZYM+nFZuUDI7RGDLJNMB6DDk8xgs
         onlw==
X-Gm-Message-State: ACrzQf3J7JPxIjNLGs64naJkZdrVABBmHY1tTybGkWAdhNuFSSSgnvwv
        x9a1oqcnYyACVhglygybhLIp6p0uYCM=
X-Google-Smtp-Source: AMsMyM7Kw+AgqGpJ2vdIZjx3rrsGnPpEorpZZAfgAHL5ji6LrzN0c4lQ1aJn2GTUoAckZc0Fs7zyCg==
X-Received: by 2002:a17:906:d96f:b0:7ad:f0af:5c07 with SMTP id rp15-20020a170906d96f00b007adf0af5c07mr17390624ejb.572.1667559754650;
        Fri, 04 Nov 2022 04:02:34 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b00458947539desm1757768edt.78.2022.11.04.04.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:02:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 7/7] io_uring/net: move mm accounting to a slower path
Date:   Fri,  4 Nov 2022 10:59:46 +0000
Message-Id: <1062f270273ad11c1b7b45ec59a6a317533d5e64.1667557923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667557923.git.asml.silence@gmail.com>
References: <cover.1667557923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can also move mm accounting to the extended callbacks. It removes a
few cycles from the hot path including skipping one function call and
setting io_req_task_complete as a callback directly. For user backed I/O
it shouldn't make any difference taking into considering atomic mm
accounting and page pinning.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   |  3 +++
 io_uring/notif.c | 31 +++++++++++++------------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 556a48bcdbe4..b7192e3e4d2d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1099,6 +1099,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			return ret;
 		msg.sg_from_iter = io_sg_from_iter;
 	} else {
+		io_notif_set_extended(zc->notif);
 		ret = import_single_range(WRITE, zc->buf, zc->len, &iov,
 					  &msg.msg_iter);
 		if (unlikely(ret))
@@ -1160,6 +1161,8 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned flags;
 	int ret, min_ret = 0;
 
+	io_notif_set_extended(sr->notif);
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 9864bde3e2ef..c4bb793ebf0e 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,11 +9,14 @@
 #include "notif.h"
 #include "rsrc.h"
 
-static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
+static void io_notif_complete_tw_ext(struct io_kiocb *notif, bool *locked)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 	struct io_ring_ctx *ctx = notif->ctx;
 
+	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
+		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
+
 	if (nd->account_pages && ctx->user) {
 		__io_unaccount_mem(ctx->user, nd->account_pages);
 		nd->account_pages = 0;
@@ -21,16 +24,6 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
 	io_req_task_complete(notif, locked);
 }
 
-static void io_notif_complete_tw_ext(struct io_kiocb *notif, bool *locked)
-{
-	struct io_notif_data *nd = io_notif_to_data(notif);
-
-	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
-		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
-
-	__io_notif_complete_tw(notif, locked);
-}
-
 static void io_tx_ubuf_callback(struct sk_buff *skb, struct ubuf_info *uarg,
 				bool success)
 {
@@ -59,11 +52,14 @@ void io_notif_set_extended(struct io_kiocb *notif)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
-	nd->zc_report = false;
-	nd->zc_used = false;
-	nd->zc_copied = false;
-	notif->io_task_work.func = io_notif_complete_tw_ext;
-	io_notif_to_data(notif)->uarg.callback = io_tx_ubuf_callback_ext;
+	if (nd->uarg.callback != io_tx_ubuf_callback_ext) {
+		nd->account_pages = 0;
+		nd->zc_report = false;
+		nd->zc_used = false;
+		nd->zc_copied = false;
+		nd->uarg.callback = io_tx_ubuf_callback_ext;
+		notif->io_task_work.func = io_notif_complete_tw_ext;
+	}
 }
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
@@ -81,10 +77,9 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->task = current;
 	io_get_task_refs(1);
 	notif->rsrc_node = NULL;
-	notif->io_task_work.func = __io_notif_complete_tw;
+	notif->io_task_work.func = io_req_task_complete;
 
 	nd = io_notif_to_data(notif);
-	nd->account_pages = 0;
 	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	nd->uarg.callback = io_tx_ubuf_callback;
 	refcount_set(&nd->uarg.refcnt, 1);
-- 
2.38.0

