Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A0320D241
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 20:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgF2Sr6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 14:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgF2Srp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 14:47:45 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1299BC030F0F
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:32 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so17095116wrw.12
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=S4HBBZkEIcA/sFst4TGxG6vqCOWMpeZR0DuTXirfEUk=;
        b=br6lgHXz9GV8gLH30l5achlu5lKIpSAABbUgbRyZHUinkFnOxDIc9djvm5xO5uPdTP
         DZp2D2RXcl8qoYsB5inlWN4lCRgj1+5XMjhptGchTJswkX1IXMBEXyP1oep1gGVVlKfA
         Do6v6Ff486ZL8wuRHjNYNilWZiTwvnuN1PUfEDjK/PgHCzTBk34ZV2sxePua9maYSUCZ
         Tq+LqFxPe/okeGTsovCVBseIJEYoM3oqIb59n+UiN0r1yz0v2tByreG1tbcvvTwjVY4b
         2ReasyScQiQeig4qhCO2RngkfICK/KK2L64maJeN+Abd5/+WWYLg/f30F7JGu3U634RS
         6FVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S4HBBZkEIcA/sFst4TGxG6vqCOWMpeZR0DuTXirfEUk=;
        b=FB3qfEj0rsR56ZjRTVJyawWm7E9zpfLaxIo9GLZd+JzaBJ41ODOPjhHK38JkIFzqkX
         u2Zt0vDQ/ayvcJKQDGjsyH/e6YY7prnUI8TZ9J3VKw6Uupl7A3yF3mzM5tOmpC9Njh4o
         rt9iPnhZ8DoG70picmeud1mTMA01PwedzWdYoRsHvyCgLNE7kzU76YWhy8agsfkeA1TM
         /NBpaewOE7ZTu40LD7Rv5ybyUHgZ+7MmEi2KNauHkE6p8kboGneJAOg1JwhB2rxPJZXJ
         +S3Cr7GNQLmmWZ4oyD2Jmyr9QF99rJTxlIJEbnvNDJSagwD5OIlrSxoGeXde/15Rft4C
         m7Fw==
X-Gm-Message-State: AOAM532CnUKW8B/OnFj5B7iy7T9varzMqFzU/TXR6nig89WC24SncsRT
        V9WqfPu5ITCI2vrwBdtuDV/f6m9l
X-Google-Smtp-Source: ABdhPJwTYQZT0/5VlSGDszsDvslnVVY9Airdku5ANKenvnBRjB+9G9VOjxQIS9Zh4vmXLMvq4y5fIg==
X-Received: by 2002:adf:e7c2:: with SMTP id e2mr18816428wrn.179.1593447630823;
        Mon, 29 Jun 2020 09:20:30 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 2sm282333wmo.44.2020.06.29.09.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 09:20:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: do grab_env() just before punting
Date:   Mon, 29 Jun 2020 19:18:43 +0300
Message-Id: <d5917c977d682436fe630fded52ed7e51fd17d12.1593446892.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593446892.git.asml.silence@gmail.com>
References: <cover.1593446892.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently io_steal_work() is disabled, and every linked request should
go through task_work for initialisation. Do io_req_work_grab_env()
just before io-wq punting and for the whole link, so any request
reachable by io_steal_work() is prepared.

This is also interesting for another reason -- it localises
io_req_work_grab_env() into one place just before io-wq punting, helping
to to better manage req->work lifetime and add some neat
cleanup/optimisations later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2dcdc2c09e8c..5928404acb17 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1101,7 +1101,7 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-static inline void io_req_work_grab_env(struct io_kiocb *req)
+static void io_req_work_grab_env(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 
@@ -1150,8 +1150,7 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
-static inline void io_prep_async_work(struct io_kiocb *req,
-				      struct io_kiocb **link)
+static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 
@@ -1164,15 +1163,22 @@ static inline void io_prep_async_work(struct io_kiocb *req,
 	}
 
 	io_req_work_grab_env(req);
-	*link = io_prep_linked_timeout(req);
 }
 
-static inline void io_queue_async_work(struct io_kiocb *req)
+static void io_prep_async_link(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *link;
+	struct io_kiocb *cur;
 
-	io_prep_async_work(req, &link);
+	io_prep_async_work(req);
+	if (req->flags & REQ_F_LINK_HEAD)
+		list_for_each_entry(cur, &req->link_list, link_list)
+			io_prep_async_work(cur);
+}
+
+static void __io_queue_async_work(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *link = io_prep_linked_timeout(req);
 
 	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
 					&req->work, req->flags);
@@ -1182,6 +1188,13 @@ static inline void io_queue_async_work(struct io_kiocb *req)
 		io_queue_linked_timeout(link);
 }
 
+static void io_queue_async_work(struct io_kiocb *req)
+{
+	/* init ->work of the whole link before punting */
+	io_prep_async_link(req);
+	__io_queue_async_work(req);
+}
+
 static void io_kill_timeout(struct io_kiocb *req)
 {
 	int ret;
@@ -1215,7 +1228,8 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 		if (req_need_defer(req))
 			break;
 		list_del_init(&req->list);
-		io_queue_async_work(req);
+		/* punt-init is done before queueing for defer */
+		__io_queue_async_work(req);
 	} while (!list_empty(&ctx->defer_list));
 }
 
@@ -1774,7 +1788,7 @@ static void io_put_req(struct io_kiocb *req)
 
 static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 {
-	struct io_kiocb *nxt = NULL;
+	struct io_kiocb *timeout, *nxt = NULL;
 
 	/*
 	 * A ref is owned by io-wq in which context we're. So, if that's the
@@ -1788,18 +1802,10 @@ static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 	if (!nxt)
 		return NULL;
 
-	if ((nxt->flags & REQ_F_ISREG) && io_op_defs[nxt->opcode].hash_reg_file)
-		io_wq_hash_work(&nxt->work, file_inode(nxt->file));
-
-	io_req_task_queue(nxt);
-	/*
-	 * If we're going to return actual work, here should be timeout prep:
-	 *
-	 * link = io_prep_linked_timeout(nxt);
-	 * if (link)
-	 *	nxt->flags |= REQ_F_QUEUE_TIMEOUT;
-	 */
-	return NULL;
+	timeout = io_prep_linked_timeout(nxt);
+	if (timeout)
+		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
+	return &nxt->work;
 }
 
 /*
@@ -5346,8 +5352,8 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		ret = io_req_defer_prep(req, sqe);
 		if (ret < 0)
 			return ret;
-		io_req_work_grab_env(req);
 	}
+	io_prep_async_link(req);
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (!req_need_defer(req) && list_empty(&ctx->defer_list)) {
@@ -5961,7 +5967,6 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = io_req_defer_prep(req, sqe);
 			if (unlikely(ret < 0))
 				goto fail_req;
-			io_req_work_grab_env(req);
 		}
 
 		/*
-- 
2.24.0

