Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6AE3A721A
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhFNWkH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhFNWkH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57480C061280
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:03 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso418847wmg.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Q+ALlRQ3cLlJbd7kUCty8YCwLRUJOFIVamGJyeuYrYc=;
        b=Of2ZJ9Y+9LcLVmlEBe8zzPL0F5N9Hp7PHqx2hZ3n3ia6++CqiZJrH8OlLcnkPGQhwg
         hpFyJbY2siltDjl8mBK9cYiW4tjHq9jdT2KfeX3ijAHkjavwb+dVPz7tAXV9GiKiVogH
         F/lzzZ/wPSkb4KSmHfalNrnf+ZGoh23zcEwfTKsrxOEu3F+RJTdXt54g4cN3O4WF0Bj9
         gbsyJLf5ZPShWOFAH1BdawWByMon/sQP+Av5LTTclrq0AhchhsMguzS8FbuI3Sz81Rwe
         GD5oFWTpR0YiE3rqrvPn2n8QxnUrpzruecPgUi4b6wPDBBXAJAONK+FSQokUJA9/D538
         tjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q+ALlRQ3cLlJbd7kUCty8YCwLRUJOFIVamGJyeuYrYc=;
        b=pLFK4Z6N065Hq8/MhplIE8CskvUWYTkqeWIqKMe+lLnjAmdIcQD5K0TM5EUiXQdv9B
         spT20gYCOwxD407BhnFgvm+Vug5TyPE7VLzc+bR3YWNuOvqYb0wZZ0sy9ZbW5+J6Del/
         26omoLhSX7gkgmPSwv8H5IWwMWFc4yqwPdtocgSbQPJeJbBOZvCcf7MMYbnmfZ0nPqeR
         p/8IXUywzcAprBcfkYs2EDffsHJwyCbxuvWOca10myQtyjatqFcXOf2vt+cpVWEor881
         QkZV8uLs8kQBCfwn+Bo0SNJRYko2Q/ihUZX9OZWeNsQth/6OVJ3efkH3cIyQSBlCM8Sf
         NFoQ==
X-Gm-Message-State: AOAM530KuM2YGekpQhA2yD8yn4VuApG9u5XjXPWj74BRSfHjrzv9zK5k
        MuA8tEPax84mi9wZNr9SGcE=
X-Google-Smtp-Source: ABdhPJwknroTjW/vdSWJY8TCYCfWTYjZLbPSNhSg+02oB2kZ//gaSWtB9CtuPte48NaB4Jerw485RA==
X-Received: by 2002:a05:600c:2dd0:: with SMTP id e16mr18981858wmh.180.1623710281981;
        Mon, 14 Jun 2021 15:38:01 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:38:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/12] io_uring: refactor io_req_defer()
Date:   Mon, 14 Jun 2021 23:37:30 +0100
Message-Id: <4f17dd56e7fbe52d1866f8acd8efe3284d2bebcb.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rename io_req_defer() into io_drain_req() and refactor it uncoupling it
from io_queue_sqe() error handling and preparing for coming
optimisations. Also, prioritise non IOSQE_ASYNC path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1b6cfc6b79c5..29b705201ca3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5998,7 +5998,7 @@ static u32 io_get_sequence(struct io_kiocb *req)
 	return ctx->cached_sq_head - nr_reqs;
 }
 
-static int io_req_defer(struct io_kiocb *req)
+static bool io_drain_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
@@ -6008,27 +6008,29 @@ static int io_req_defer(struct io_kiocb *req)
 	/* Still need defer if there is pending req in defer list. */
 	if (likely(list_empty_careful(&ctx->defer_list) &&
 		!(req->flags & REQ_F_IO_DRAIN)))
-		return 0;
+		return false;
 
 	seq = io_get_sequence(req);
 	/* Still a chance to pass the sequence check */
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
-		return 0;
+		return false;
 
 	ret = io_req_prep_async(req);
 	if (ret)
 		return ret;
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL);
-	if (!de)
-		return -ENOMEM;
+	if (!de) {
+		io_req_complete_failed(req, ret);
+		return true;
+	}
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
 		spin_unlock_irq(&ctx->completion_lock);
 		kfree(de);
 		io_queue_async_work(req);
-		return -EIOCBQUEUED;
+		return true;
 	}
 
 	trace_io_uring_defer(ctx, req, req->user_data);
@@ -6036,7 +6038,7 @@ static int io_req_defer(struct io_kiocb *req)
 	de->seq = seq;
 	list_add_tail(&de->list, &ctx->defer_list);
 	spin_unlock_irq(&ctx->completion_lock);
-	return -EIOCBQUEUED;
+	return true;
 }
 
 static void io_clean_op(struct io_kiocb *req)
@@ -6447,21 +6449,18 @@ static void __io_queue_sqe(struct io_kiocb *req)
 
 static void io_queue_sqe(struct io_kiocb *req)
 {
-	int ret;
+	if (io_drain_req(req))
+		return;
 
-	ret = io_req_defer(req);
-	if (ret) {
-		if (ret != -EIOCBQUEUED) {
-fail_req:
-			io_req_complete_failed(req, ret);
-		}
-	} else if (req->flags & REQ_F_FORCE_ASYNC) {
-		ret = io_req_prep_async(req);
-		if (unlikely(ret))
-			goto fail_req;
-		io_queue_async_work(req);
-	} else {
+	if (likely(!(req->flags & REQ_F_FORCE_ASYNC))) {
 		__io_queue_sqe(req);
+	} else {
+		int ret = io_req_prep_async(req);
+
+		if (unlikely(ret))
+			io_req_complete_failed(req, ret);
+		else
+			io_queue_async_work(req);
 	}
 }
 
-- 
2.31.1

