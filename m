Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3443E4549
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbhHIMFw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhHIMFs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:48 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D95C061798
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:27 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id x17so10411407wmc.5
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Wbq1+hhcolKgYXRxmi78uxwrVslVmGkoWpCMbS+hLfk=;
        b=hwWWdkfaTK3QJZC3CiTvSDYO5gejEk4fPu04KAnDOhc2iqmyjNSZasv6rIPwSoz/A6
         zi9svzX6bGEBpqdq1PNXZEN4LRJvVpPaAfeNU8kMSB9ZMskdpw2bSzViqKGy4fZSIREV
         1wNf+eZ3JSX5Lx51P2fwwSjwNBW5hamJW6rv0pL/BxrnxyfvSZOFkUi6aalSZImNrVXL
         pc0/OZ6ukCvyk0jnCUcjoEnCy3dAXryF/G7ka/lha/II9MaYQO5EBI9YpUo52kVf5lmE
         Luc/bAXKxyDK7akVfWqPYQK0zBaZ/2mZS0/OUIfUlMQSooz7uJxVSB8Qms1HVGZaM8sg
         ptMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wbq1+hhcolKgYXRxmi78uxwrVslVmGkoWpCMbS+hLfk=;
        b=YGHJSSAHu5G+955EtmjK06iAxGRm9TOq9+VoIMRe68nsnxbo8spT/4HoJZMTKP/eS8
         7X4qwkSmt2nHv8g/qD7h9i/8/jWppQ0E5dq02OEef4TlhGSkV2sZ3cNaiEYCxddsOzDV
         OLo4gt2tGXx3kGHDxzdZoHgL1IvCnRbEqtzoZapxOkC+sctAeZo/SAny3FPeqKaurC9G
         Ep63++GVTTvPk2XK+1p5qBanmtzGIvSZ1MDvP4/I7sKTy8MT4ren+1tydiDhc1rDhZOK
         OVoLyM95YEJnpX8jzN38JGVfwLEbMUgatwiqFqk5x0bhUD9k1+1eHvHukMN1/DjgkdGK
         VSLw==
X-Gm-Message-State: AOAM533Ps1FPyfsta/FbJiaPB+Le2iolpGLlSmMpBNUrFsrsmRMObi42
        AMLSwniuCfDbpIzfpSjg7PU=
X-Google-Smtp-Source: ABdhPJxfyjiOdC0UlaADNZ4Tjipe6q4aXXGeleH4uBqthTRSoZhvBQaK7ikwsE7ux2A93bI++7Q8UA==
X-Received: by 2002:a7b:c94c:: with SMTP id i12mr33749562wml.148.1628510726316;
        Mon, 09 Aug 2021 05:05:26 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 25/28] io_uring: use inflight_entry instead of compl.list
Date:   Mon,  9 Aug 2021 13:04:25 +0100
Message-Id: <aad647119ec4b4048d5137f24519af1c644758ad.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->compl.list is used to cache freed requests, and so can't overlap in
time with req->inflight_entry. So, use inflight_entry to link requests
and remove compl.list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92854f62ee21..aaddbb4ce4ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -670,7 +670,6 @@ struct io_unlink {
 
 struct io_completion {
 	struct file			*file;
-	struct list_head		list;
 	u32				cflags;
 };
 
@@ -1678,7 +1677,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
-		list_add(&req->compl.list, &ctx->locked_free_list);
+		list_add(&req->inflight_entry, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	} else {
 		if (!percpu_ref_tryget(&ctx->refs))
@@ -1769,9 +1768,9 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	nr = state->free_reqs;
 	while (!list_empty(&cs->free_list)) {
 		struct io_kiocb *req = list_first_entry(&cs->free_list,
-						struct io_kiocb, compl.list);
+					struct io_kiocb, inflight_entry);
 
-		list_del(&req->compl.list);
+		list_del(&req->inflight_entry);
 		state->reqs[nr++] = req;
 		if (nr == ARRAY_SIZE(state->reqs))
 			break;
@@ -1841,7 +1840,7 @@ static void __io_free_req(struct io_kiocb *req)
 	io_put_task(req->task, 1);
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	list_add(&req->compl.list, &ctx->locked_free_list);
+	list_add(&req->inflight_entry, &ctx->locked_free_list);
 	ctx->locked_free_nr++;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -2148,7 +2147,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	if (state->free_reqs != ARRAY_SIZE(state->reqs))
 		state->reqs[state->free_reqs++] = req;
 	else
-		list_add(&req->compl.list, &state->comp.free_list);
+		list_add(&req->inflight_entry, &state->comp.free_list);
 }
 
 static void io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -8650,8 +8649,8 @@ static void io_req_cache_free(struct list_head *list)
 {
 	struct io_kiocb *req, *nxt;
 
-	list_for_each_entry_safe(req, nxt, list, compl.list) {
-		list_del(&req->compl.list);
+	list_for_each_entry_safe(req, nxt, list, inflight_entry) {
+		list_del(&req->inflight_entry);
 		kmem_cache_free(req_cachep, req);
 	}
 }
-- 
2.32.0

