Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F6F22D61D
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 10:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGYIdZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 04:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGYIdZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 04:33:25 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F03AC0619E4
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 01:33:25 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg28so8606864edb.3
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 01:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LuTTDSj5JKT/UGbz0hgFL8Ce7rkUhYSB3MksXoz3JqQ=;
        b=fT77vSbCW0/Z3jdfn2fiwsW7r4eDSboxYa6s8DYye1DG9I+qFAWLbogBhElhLm+0F6
         yiVBFnoKEKpxEFdSodx7X9bdyhQVsgypPAKkX6DaTPlwe/ieZrDkUj8e+mcQkCB6GF9b
         3RCO4Oa4gqumnnHbagbpBlLUZJO2ZHtnITdkjflFlvc1MH95rSvrAl9cNte/30w5lq3G
         ykeVwJNKbdNv+2XPJvOpFkLg+nhch4U5g8q5GRQSDCEhgY32/sQbNxyPS4IGqZ2hR2+4
         quWjFVZzgQCTDh/p9BrxKtGfI9Wt7W5SHXf7iIlPMLMMXXkeqcamM0fgi+LjeDWr4MsI
         q/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LuTTDSj5JKT/UGbz0hgFL8Ce7rkUhYSB3MksXoz3JqQ=;
        b=muPsDSfXOC2DUUCOxtOv2OZHIyQk0fSii84j1g/HHleMinhVqpsONACcKVmj6kRRO7
         1JxnnC8ovuQBinpzWFZeJx22S+74MmgEQtatecfdQtooPHY5dYwpm+akywG+j/G1nEK9
         Yq7MiWctVGG+CXWahoO60i45E9yjrYtJ7g0hcsJ+c33mtVp6+wKOe1fZyx01e6MgRKI2
         ktPMkTxWwzT4wXhILMUXouL6l8Aj0HbUguvs5N09CZFm3FjNgGL2DARCjxh//tP4kkEf
         sw5p8oGUp+U4it2th7qGqXTogfKH/yRuwq9TLPRLwxhfBCMZYBk2D8S17HAXWfHim8O4
         G5rQ==
X-Gm-Message-State: AOAM531VzEfWSrDu6Y2ZjLaS2OTpvAtUSoUbbQPTco3cVy15g7t5bRyN
        X8+R0D5o2psqVbmL1eBYHAg=
X-Google-Smtp-Source: ABdhPJx4pLrIC79x5LHSc6NPyJf/IZ5A4gR1X0+OnabQXj5abSGxNk4/jdTKN03iJyryRcYqhLbDJA==
X-Received: by 2002:a05:6402:228d:: with SMTP id cw13mr12680167edb.343.1595666003847;
        Sat, 25 Jul 2020 01:33:23 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id r17sm2403597edw.68.2020.07.25.01.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 01:33:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: unionise ->apoll and ->work
Date:   Sat, 25 Jul 2020 11:31:23 +0300
Message-Id: <fcb1403b24e2b118bdc04aeae466772536edc235.1595664743.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595664743.git.asml.silence@gmail.com>
References: <cover.1595664743.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Save a bit of space by placing ->apoll and ->work ptrs into a union,
making io_kiocb to take 192B (3 cachelines)

note: this patch is just for reference, there are other probably better
ways to save 8B.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ef4c6e50aa4f..6894a9a5db30 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -597,6 +597,7 @@ enum {
 struct async_poll {
 	struct io_poll_iocb	poll;
 	struct io_poll_iocb	*double_poll;
+	struct io_wq_work	*work;
 };
 
 /*
@@ -658,8 +659,10 @@ struct io_kiocb {
 	 * async armed poll handlers for regular commands.
 	 */
 	struct hlist_node	hash_node;
-	struct async_poll	*apoll;
-	struct io_wq_work	*work;
+	union {
+		struct async_poll	*apoll;
+		struct io_wq_work	*work;
+	};
 	struct callback_head	task_work;
 };
 
@@ -4676,6 +4679,8 @@ static void io_async_task_func(struct callback_head *cb)
 	io_poll_remove_double(req, apoll->double_poll);
 	spin_unlock_irq(&ctx->completion_lock);
 
+	req->work = apoll->work;
+
 	if (!READ_ONCE(apoll->poll.canceled))
 		__io_req_task_submit(req);
 	else
@@ -4765,6 +4770,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	if (unlikely(!apoll))
 		return false;
 	apoll->double_poll = NULL;
+	apoll->work = req->work;
 
 	req->flags |= REQ_F_POLLED;
 	io_get_req_task(req);
@@ -4785,6 +4791,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	if (ret) {
 		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
+		req->work = apoll->work;
 		kfree(apoll->double_poll);
 		kfree(apoll);
 		return false;
@@ -4826,6 +4833,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
+			req->work = apoll->work;
 			io_put_req(req);
 			kfree(apoll->double_poll);
 			kfree(apoll);
@@ -4962,7 +4970,7 @@ static int io_poll_add(struct io_kiocb *req)
 
 	/* ->work is in union with hash_node and others */
 	io_req_clean_work(req);
-	req->flags &= ~REQ_F_WORK_INITIALIZED;
+	req->work = NULL;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	ipt.pt._qproc = io_poll_queue_proc;
-- 
2.24.0

