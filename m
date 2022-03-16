Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA24DBAD2
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 00:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbiCPXFW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 19:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiCPXFW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 19:05:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B5D12771
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 16:04:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n18so3013195plg.5
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 16:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXCthef4sABg2z4SKKMKNR/zOBArg8eygMq9FOq0mXs=;
        b=rX2702kG4GuMEsyxJE4Mf6LKqUwede7PJ5UiwO3TTGhqwXkq+Ll3Zi9iUfp2pPGizL
         FvUjjgGJ9kiRZcliQNLUfMLHBcf8fKO5KVNdzjX/EJ3QZ6VUaCxhCC/htkxl1Mv8immm
         nEERgQPYhF0bda4ZmnmTB1HAT4fVAEvGZskMwTh5ltD/HVUvK7UCpNvf6l4vbWKGdHDo
         hLLrGk20QH/B9RsWuNhBr0cU+a+BTeNhnABv5pdRXMu4Rq12IycgBXWET30yIlLLK8ok
         IoeJbmwQb8X8Mt80ftMoAvVqNK7g/wLwY8cTazSXZ1Enn6OG9J2KfWIWgukE7QkdHEUf
         FE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXCthef4sABg2z4SKKMKNR/zOBArg8eygMq9FOq0mXs=;
        b=xkBsP8BM5/S7Pg+ZuA2hDJYFXWnTaa0pTem0yKr88tExEmKgtrcxl3peW/hSxH4xXE
         PJsl8cKcIGJ0xa0u53m/JkEfj+bPoNl/ZVWWI58P9nZWM+j/ozWqtpy78v/NtTWPDv1Z
         FmrxYDXeZehorR4M9OFubokxaZCT05hCwH/RzzfVUvqjFYpZBArPJzXg7wwHRWxADH63
         nSzwpHh0zJtMfZN32FE5N6+VLJBMDxM9pSpBnIIAl9SDDcNW1T5VpjajMSH2S9Rh8P8G
         wfRAI80Luq9ISFdVS/hCQXZkOB758UUDVDWhk34kWm0VMxSn+mgf7AD7kyhs+wgbkpla
         0okQ==
X-Gm-Message-State: AOAM533YVJXB/KeOnnsGWCN6RUWdRlTAzohinv86D+iCfvbnXUxQ6Xf2
        4Gbss0ZBnQVOAOZCeTUnLU5tTlpLhIvXkVMF
X-Google-Smtp-Source: ABdhPJxTdLaDgNXL/8WU0nWqX9QSJdSpM6ubJX0KdEfZDlBrWeU9kIAEotfIljtAuY5rS8kniJfxXA==
X-Received: by 2002:a17:902:d4c1:b0:153:d493:3f1 with SMTP id o1-20020a170902d4c100b00153d49303f1mr2194403plg.102.1647471846301;
        Wed, 16 Mar 2022 16:04:06 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q17-20020aa79831000000b004f769d0c323sm4538351pfl.100.2022.03.16.16.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:04:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: cache poll/double-poll state with a request flag
Date:   Wed, 16 Mar 2022 17:03:55 -0600
Message-Id: <20220316230355.300656-3-axboe@kernel.dk>
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

With commit "io_uring: cache req->apoll->events in req->cflags" applied,
we now have just io_poll_remove_entries() dipping into req->apoll when
it isn't strictly necessary.

Mark poll and double-poll with a flag, so we know if we need to look
at apoll->double_poll. This avoids pulling in those cachelines if we
don't need them. The common case is that the poll wake handler already
removed these entries while hot off the completion path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bfddad7a14ef..5b5f48f0f81e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -771,6 +771,8 @@ enum {
 	REQ_F_ARM_LTIMEOUT_BIT,
 	REQ_F_ASYNC_DATA_BIT,
 	REQ_F_SKIP_LINK_CQES_BIT,
+	REQ_F_SINGLE_POLL_BIT,
+	REQ_F_DOUBLE_POLL_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -829,6 +831,10 @@ enum {
 	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
 	/* don't post CQEs while failing linked requests */
 	REQ_F_SKIP_LINK_CQES	= BIT(REQ_F_SKIP_LINK_CQES_BIT),
+	/* single poll may be active */
+	REQ_F_SINGLE_POLL	= BIT(REQ_F_SINGLE_POLL_BIT),
+	/* double poll may active */
+	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 };
 
 struct async_poll {
@@ -5823,8 +5829,12 @@ static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
 
 static void io_poll_remove_entries(struct io_kiocb *req)
 {
-	struct io_poll_iocb *poll = io_poll_get_single(req);
-	struct io_poll_iocb *poll_double = io_poll_get_double(req);
+	/*
+	 * Nothing to do if neither of those flags are set. Avoid dipping
+	 * into the poll/apoll/double cachelines if we can.
+	 */
+	if (!(req->flags & (REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL)))
+		return;
 
 	/*
 	 * While we hold the waitqueue lock and the waitqueue is nonempty,
@@ -5842,9 +5852,10 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 	 * In that case, only RCU prevents the queue memory from being freed.
 	 */
 	rcu_read_lock();
-	io_poll_remove_entry(poll);
-	if (poll_double)
-		io_poll_remove_entry(poll_double);
+	if (req->flags & REQ_F_SINGLE_POLL)
+		io_poll_remove_entry(io_poll_get_single(req));
+	if (req->flags & REQ_F_DOUBLE_POLL)
+		io_poll_remove_entry(io_poll_get_double(req));
 	rcu_read_unlock();
 }
 
@@ -6026,6 +6037,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		if (mask && poll->events & EPOLLONESHOT) {
 			list_del_init(&poll->wait.entry);
 			poll->head = NULL;
+			req->flags &= ~REQ_F_SINGLE_POLL;
 		}
 		__io_poll_execute(req, mask, poll->events);
 	}
@@ -6062,12 +6074,14 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -ENOMEM;
 			return;
 		}
+		req->flags |= REQ_F_DOUBLE_POLL;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
 		*poll_ptr = poll;
 		if (req->opcode == IORING_OP_POLL_ADD)
 			req->flags |= REQ_F_ASYNC_DATA;
 	}
 
+	req->flags |= REQ_F_SINGLE_POLL;
 	pt->nr_entries++;
 	poll->head = head;
 	poll->wait.private = req;
-- 
2.35.1

