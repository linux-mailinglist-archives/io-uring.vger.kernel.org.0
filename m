Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A2547656F
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhLOWJH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhLOWJG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:09:06 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EACC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z7so18378583edc.11
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TxIcCEiMQq3WfP7IG2NVOlanlWrUf4z7d0MU5pelTLI=;
        b=LNEFTr2zeQ+jgFm/nRmHwvHWGUtlZAxeLlPNe8wWjyvC5d+AnaU1heirLRQN7vorNr
         wAvLPG00cQBJ2R+5/6ryGPB0OJpdla+6uOkTmMFPPMThVp/riMwWBRMqzpL3R5jL9xr6
         xhpuS9dLMQZlRZpZKB/AE8WS4dPuEFDqdQOK1GjXChPqmnfvaFqITwLBPjNbFzuXVRtV
         HK/MT80OJlHHGcL+h0dZKeSimbsku+6Qc2YqJRr1Lu51n325ouvWqNAIhXV0VanE7dFZ
         xezyzsooyO7NGZsTUv5FNyDd9PI1Q6MDkyPbD8f18cewRStiEIbt/3yv7XPfU0vIQVTl
         rTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TxIcCEiMQq3WfP7IG2NVOlanlWrUf4z7d0MU5pelTLI=;
        b=5SxhP6g6/yJ1PJNSZekaSm+JGtjgZmHNQxp1thvbb6+FxURZw+mydmkwdBJYGndW7j
         Jaq3hjQsSDKBeJEtcET99xS17WCBtc7Bimst4anexJ8rk37R5pH2eONLGqG9NuGN2RdD
         ufxFA/CdhfitFUw8MzXDX8XKfwWmUUiW8bRJfoVeZFW7fX1aitb/YX6wvTOldd5dafrT
         xhXcBDT3OFkxQ8BBeELJbPSd3PARaEPIun6r+0b+DfcsPLajIGoaTzFYj1jOvsWDHk7U
         p00/nimktsjmHLVpccd+zpb4zJzrF+AUgTAnp0N7l5JC/zXo6tn38W6jAJyGpQt5XT0G
         5NQg==
X-Gm-Message-State: AOAM533J2U/QuHwt2bF57iOkvlb2DUgegKTrFQ+RNSn0VLXBB3h30ume
        qVI3LppWf9m4MzruVHEg6KpqVaajiGg=
X-Google-Smtp-Source: ABdhPJy+tX8OEqAJcM5LfxgCA28erWWF4qSzn/t3eq/Fs2hYUcDPftEKLpasBxB0ExVSspwlx/lmBQ==
X-Received: by 2002:a17:907:961d:: with SMTP id gb29mr12946487ejc.102.1639606144588;
        Wed, 15 Dec 2021 14:09:04 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1572006edb.59.2021.12.15.14.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:09:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 3/7] io_uring: move common poll bits
Date:   Wed, 15 Dec 2021 22:08:46 +0000
Message-Id: <6c5c3dba24c86aad5cd389a54a8c7412e6a0621d.1639605189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
References: <cover.1639605189.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move some poll helpers/etc up, we'll need them there shortly

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 74 +++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 972bc9b40381..c106c0fbaca2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5353,6 +5353,43 @@ struct io_poll_table {
 	int error;
 };
 
+static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
+{
+	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return req->async_data;
+	return req->apoll->double_poll;
+}
+
+static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return &req->poll;
+	return &req->apoll->poll;
+}
+
+static void io_poll_req_insert(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct hlist_head *list;
+
+	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
+	hlist_add_head(&req->hash_node, list);
+}
+
+static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
+			      wait_queue_func_t wake_func)
+{
+	poll->head = NULL;
+	poll->done = false;
+	poll->canceled = false;
+#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
+	/* mask in events that we always want/need */
+	poll->events = events | IO_POLL_UNMASK;
+	INIT_LIST_HEAD(&poll->wait.entry);
+	init_waitqueue_func_entry(&poll->wait, wake_func);
+}
+
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, io_req_tw_func_t func)
 {
@@ -5401,21 +5438,6 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
-static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
-{
-	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
-	if (req->opcode == IORING_OP_POLL_ADD)
-		return req->async_data;
-	return req->apoll->double_poll;
-}
-
-static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
-{
-	if (req->opcode == IORING_OP_POLL_ADD)
-		return &req->poll;
-	return &req->apoll->poll;
-}
-
 static void io_poll_remove_double(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
@@ -5530,19 +5552,6 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 	return 1;
 }
 
-static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
-			      wait_queue_func_t wake_func)
-{
-	poll->head = NULL;
-	poll->done = false;
-	poll->canceled = false;
-#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
-	/* mask in events that we always want/need */
-	poll->events = events | IO_POLL_UNMASK;
-	INIT_LIST_HEAD(&poll->wait.entry);
-	init_waitqueue_func_entry(&poll->wait, wake_func);
-}
-
 static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			    struct wait_queue_head *head,
 			    struct io_poll_iocb **poll_ptr)
@@ -5640,15 +5649,6 @@ static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
 }
 
-static void io_poll_req_insert(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct hlist_head *list;
-
-	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
-	hlist_add_head(&req->hash_node, list);
-}
-
 static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 				      struct io_poll_iocb *poll,
 				      struct io_poll_table *ipt, __poll_t mask,
-- 
2.34.0

