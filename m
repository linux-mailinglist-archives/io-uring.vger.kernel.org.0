Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986265031C3
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345968AbiDOVLt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351066AbiDOVLs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:48 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DC18BE12
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:18 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 21so11129342edv.1
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vdu6c/ikjH9ztJfyZ+2p+kHRszm0UIGEjKtnyMAYbac=;
        b=ZpClKUQjWIYcFp3Q5ZLdTNMa8t8d09nqFzk+a4GsIImMawmd0m+t1jsZKLW2f/Mblw
         KFeVav3fSV90Quj5dK1zgadCj2DGtXIbiJxLrX753/LsAUYKf/hn8lf4FW+faDs4sxhl
         Qu20BqIGZfl6HureG6J9lsMs9HypKbqbKST48s+Lknr5URYV15/U1DOqhwNYQGs/9CGt
         Dw4uPczoS0Yb9Vldz2w+Ipo4UPAqSMy8cFodUC/KkOAIOcMzgb8DVWPMtIibgMk3EX/p
         CThsLENflC82qxOTDEjHXrrJtWwoSQ7yMTbuFhFIT31wggZXhaCe7cfelfE3QoGRaqIP
         6Gxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vdu6c/ikjH9ztJfyZ+2p+kHRszm0UIGEjKtnyMAYbac=;
        b=WR8ZCwiROt1REvycxpzjuWPy5LoI34HwDlB0Uf6Hn9SERuFVBJJKP7yP0tzh6lyp4B
         0ZhbizDtRLIPfJu9PhDQYDhKJOVEkVAhPIx+scx2llyCspRkL5flyji8NgfO6v93HMpL
         Uufy+ed4agCJ6aFGNTg4qiaKiZXAPqfiMjYlZryQJkK+HM3mUsAACzlo8P4f3fb+yxYn
         4z4RHLIUjkDf5Zg8HjgKgRblWpwdC38zdDbqwhFctv0arM3VMXW6LR8nI0V0Po/1dD8i
         u/S3vDzvA+x92YYESkDuiukpfemzneexbBmwYIn2oE4uG+wWs8ubhFn23/uYPVNWTISr
         7UZQ==
X-Gm-Message-State: AOAM532zubI4P3Yz3aeKqySEvkSf3ZIApGpAz/0IXpiTwo/dFpdR1v0Z
        6kKlNaaMw3uJ+hMkiKL2GG/Rx2Vb6do=
X-Google-Smtp-Source: ABdhPJytCKlUhtCji6guRurXsteen36TIP1ZLErLxe3cKPIwyJwOkbzy6FfWnBEAWJeSAsf75akYdg==
X-Received: by 2002:a05:6402:11cd:b0:41d:8dae:3123 with SMTP id j13-20020a05640211cd00b0041d8dae3123mr951911edw.195.1650056956757;
        Fri, 15 Apr 2022 14:09:16 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 06/14] io_uring: helper for prep+queuing linked timeouts
Date:   Fri, 15 Apr 2022 22:08:25 +0100
Message-Id: <ecf74df7ac77389b6d9211211ec4954e91de98ba.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We try to aggresively inline the submission path, so it's a good idea to
not pollute it with colder code. One of them is linked timeout
preparation + queue, which can be extracted into a function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d872c9b5885d..df588e4d3bee 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1679,6 +1679,17 @@ static inline struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	return __io_prep_linked_timeout(req);
 }
 
+static noinline void __io_arm_ltimeout(struct io_kiocb *req)
+{
+	io_queue_linked_timeout(__io_prep_linked_timeout(req));
+}
+
+static inline void io_arm_ltimeout(struct io_kiocb *req)
+{
+	if (unlikely(req->flags & REQ_F_ARM_LTIMEOUT))
+		__io_arm_ltimeout(req);
+}
+
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -7283,7 +7294,6 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	unsigned int issue_flags = IO_URING_F_UNLOCKED;
 	bool needs_poll = false;
-	struct io_kiocb *timeout;
 	int ret = 0, err = -ECANCELED;
 
 	/* one will be dropped by ->io_free_work() after returning to io-wq */
@@ -7292,10 +7302,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	else
 		req_ref_get(req);
 
-	timeout = io_prep_linked_timeout(req);
-	if (timeout)
-		io_queue_linked_timeout(timeout);
-
+	io_arm_ltimeout(req);
 
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL) {
@@ -7508,7 +7515,6 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 static inline void __io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_kiocb *linked_timeout;
 	int ret;
 
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
@@ -7522,9 +7528,7 @@ static inline void __io_queue_sqe(struct io_kiocb *req)
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (likely(!ret)) {
-		linked_timeout = io_prep_linked_timeout(req);
-		if (linked_timeout)
-			io_queue_linked_timeout(linked_timeout);
+		io_arm_ltimeout(req);
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		io_queue_sqe_arm_apoll(req);
 	} else {
-- 
2.35.2

