Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324864DBAD1
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 00:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiCPXFV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 19:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiCPXFV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 19:05:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7D413CC0
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 16:04:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so88893pjm.0
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 16:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XJhqFNstFYk6mHz+nwkcW2etqBt3DLlRQ09ChhhKzhY=;
        b=s7hfvtmRx3udzQ089Cq6JPy3AoTRKrrO5tdODloJtoQUHNLZd3jVsu2Q/Ma5CBOXC/
         oTftfe1PiLfQSMc7vDidSlXFXAju22jJes5uwsZU3DPQJHnUF3xkwcG5wbp582Oog/4K
         u+QADg+q+X9WoTV7Lv5Am3uTZkisKpXmLVJ7moU0kjbkQsm8/SVVfjH9DJVcb6bjCS+V
         ndw9FecNd3ic4N38pj395vTYARiXUZj6pE9+WYlDGkMnqNQ0dBDf3SHFu4QPheHbDBun
         pXkW4B99cs2/9FDu/DSqihH1ZplB+IqgjcH0qd/w7m+6q7yx22fRiLtLqwItwdj2wrHP
         JJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJhqFNstFYk6mHz+nwkcW2etqBt3DLlRQ09ChhhKzhY=;
        b=3IRrTwla5Rf+T/aMMMTH5AqDLiwFETYEKAl6d50g6YPAn4EpbIxWe3o56NK1OMNcZN
         5k6t+TraTGA30uiKd3PCjiSbzBN1TqUitY1uX+GOo6pv2nTxLHjBft9eU/h3cZszZJZM
         AJfu182+jH8LvGbUhIUAcD+Gu0X+t7q6ENx4vZuAZEw2vmSmfsmmb+y16EPqO05vrt7e
         47WdLu4RFPN/E9GZZaZheUQaR8Yb+T6UJwq2cvFVN4KoH3r/NbF4p9EE1lE4IqrPuIO5
         FSMjwZTfV/PiD+SzRL4Wfg1ZFyKhRq3Q/AlCegbDr3p5bltX9m68lV4yBbwBPCqMOuCh
         zHfQ==
X-Gm-Message-State: AOAM531lLeQftYX6D3ppSa4Hwlyr8QY0nBKxbWqE9fv17WGE69kkrU2y
        hW01eXa/IRoBx6exD1ZplS7ps1DAibRiUokM
X-Google-Smtp-Source: ABdhPJy/oWOJ4AeZQlkoO6JOpQe2LjsbsttS0nbXeRbEWErYlowKY3TdbkVnRsnflSTA7e0uA8vJtA==
X-Received: by 2002:a17:902:ba8c:b0:14f:d9b7:ab4 with SMTP id k12-20020a170902ba8c00b0014fd9b70ab4mr1875365pls.23.1647471844895;
        Wed, 16 Mar 2022 16:04:04 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q17-20020aa79831000000b004f769d0c323sm4538351pfl.100.2022.03.16.16.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:04:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: cache req->apoll->events in req->cflags
Date:   Wed, 16 Mar 2022 17:03:54 -0600
Message-Id: <20220316230355.300656-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316230355.300656-1-axboe@kernel.dk>
References: <20220316230355.300656-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we arm poll on behalf of a different type of request, like a network
receive, then we allocate req->apoll as our poll entry. Running network
workloads shows io_poll_check_events() as the most expensive part of
io_uring, and it's all due to having to pull in req->apoll instead of
just the request which we have hot already.

Cache poll->events in req->cflags, which isn't used until the request
completes anyway. This isn't strictly needed for regular poll, where
req->poll.events is used and thus already hot, but for the sake of
unification we do it all around.

This saves 3-4% of overhead in certain request workloads.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fa4e2cb47e56..bfddad7a14ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5876,13 +5876,13 @@ static int io_poll_check_events(struct io_kiocb *req)
 			return -ECANCELED;
 
 		if (!req->result) {
-			struct poll_table_struct pt = { ._key = poll->events };
+			struct poll_table_struct pt = { ._key = req->cflags };
 
-			req->result = vfs_poll(req->file, &pt) & poll->events;
+			req->result = vfs_poll(req->file, &pt) & req->cflags;
 		}
 
 		/* multishot, just fill an CQE and proceed */
-		if (req->result && !(poll->events & EPOLLONESHOT)) {
+		if (req->result && !(req->cflags & EPOLLONESHOT)) {
 			__poll_t mask = mangle_poll(req->result & poll->events);
 			bool filled;
 
@@ -5953,9 +5953,16 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, ret);
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask)
+static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
 {
 	req->result = mask;
+	/*
+	 * This is useful for poll that is armed on behalf of another
+	 * request, and where the wakeup path could be on a different
+	 * CPU. We want to avoid pulling in req->apoll->events for that
+	 * case.
+	 */
+	req->cflags = events;
 	if (req->opcode == IORING_OP_POLL_ADD)
 		req->io_task_work.func = io_poll_task_func;
 	else
@@ -5965,17 +5972,17 @@ static void __io_poll_execute(struct io_kiocb *req, int mask)
 	io_req_task_work_add(req, false);
 }
 
-static inline void io_poll_execute(struct io_kiocb *req, int res)
+static inline void io_poll_execute(struct io_kiocb *req, int res, int events)
 {
 	if (io_poll_get_ownership(req))
-		__io_poll_execute(req, res);
+		__io_poll_execute(req, res, events);
 }
 
 static void io_poll_cancel_req(struct io_kiocb *req)
 {
 	io_poll_mark_cancelled(req);
 	/* kick tw, which should complete the request */
-	io_poll_execute(req, 0);
+	io_poll_execute(req, 0, 0);
 }
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -5989,7 +5996,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (unlikely(mask & POLLFREE)) {
 		io_poll_mark_cancelled(req);
 		/* we have to kick tw in case it's not already */
-		io_poll_execute(req, 0);
+		io_poll_execute(req, 0, poll->events);
 
 		/*
 		 * If the waitqueue is being freed early but someone is already
@@ -6020,7 +6027,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			list_del_init(&poll->wait.entry);
 			poll->head = NULL;
 		}
-		__io_poll_execute(req, mask);
+		__io_poll_execute(req, mask, poll->events);
 	}
 	return 1;
 }
@@ -6124,7 +6131,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		/* can't multishot if failed, just queue the event we've got */
 		if (unlikely(ipt->error || !ipt->nr_entries))
 			poll->events |= EPOLLONESHOT;
-		__io_poll_execute(req, mask);
+		__io_poll_execute(req, mask, poll->events);
 		return 0;
 	}
 	io_add_napi(req->file, req->ctx);
@@ -6135,7 +6142,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	 */
 	v = atomic_dec_return(&req->poll_refs);
 	if (unlikely(v & IO_POLL_REF_MASK))
-		__io_poll_execute(req, 0);
+		__io_poll_execute(req, 0, poll->events);
 	return 0;
 }
 
@@ -6333,7 +6340,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EINVAL;
 
 	io_req_set_refcount(req);
-	poll->events = io_poll_parse_events(sqe, flags);
+	req->cflags = poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
 
-- 
2.35.1

