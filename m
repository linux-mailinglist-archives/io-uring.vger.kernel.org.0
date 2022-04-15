Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AF95031B3
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351729AbiDOVLx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350280AbiDOVLw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:52 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F35CB75
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:21 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id c64so11062566edf.11
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qd+0BXNWd4hOsq4ITiwnL6I/sSAUC3FhL98H77Qw/f4=;
        b=CCIW57FZOpRB9jX2afvg1tW2PQ57IeA3e4OTWgQKteGQ31i6NX6MgzXVhQMyDCwBoV
         e4xFFkP6x3XdDFh0quEV6yRU91Q6ZcddI0h+I1qZTNUOrMGUi9LZq3LpGtsoyqvknoLi
         H3np2sPbwLdFvpVSgyjrGtXsFOynKSKGAFgflZc3nLgxnaIWcfOl63ZwxVl5+kvoZ1oj
         LguzGpR1IOluGqOM5uIh9EI21OMS+PtGKxusxR8WeAXJNw8KGXGPIKCm4YhdqsDR92CQ
         r6JRjJQyWEdJQG3mQ53sTYSOz9vJbjdhLhSO8XQpAHo2/d+8o7nj+oivfgLTI6lZiTfF
         DjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qd+0BXNWd4hOsq4ITiwnL6I/sSAUC3FhL98H77Qw/f4=;
        b=4nSav6j+HeFAQrCNHvmDv6HD5U/zL1d0RUDyUAGAa7OjiDpPSRHD+D394V40vExJOb
         U62LI+7FrAflpZ7ICkr4Ud62liYeXvsR/P6j6loifoBCDRWTWqngLCSXCn4IsuNSD4qG
         cY9EfARcvCPAB5ce3rkzxx4DS7NuVz3P1XLi+mh0IKfjokz7Uglp1LrStOXPYGk/L5Rk
         iN8bgXOVSVbvyrZJuBFU7ZsYHE8koXfZ+sB1hbABdUXYm928sEEQpzXFqEDewkOmQBRm
         phpC+d9MsGZcolH1Waxtx6t1wiogjtX9u7lOg7DsUH1Fd3hBpdqaM0joaYt+8MSuLw9p
         GVOA==
X-Gm-Message-State: AOAM531v21tJcryrR3ApKD4+5lIl5rpODhc90Hh2WNGphDFWVVqqhofh
        02FMixLBIRDrShT2M+glIssSfbMtFDM=
X-Google-Smtp-Source: ABdhPJxuDXNwKSYInVNBVSDC5em8fyQ2JzXyNeSmD3PjehqNKmjvfRnH9yujldxcb4CK7Gi43MNz9A==
X-Received: by 2002:a05:6402:1e8b:b0:41c:59f6:2c26 with SMTP id f11-20020a0564021e8b00b0041c59f62c26mr1017592edf.156.1650056959904;
        Fri, 15 Apr 2022 14:09:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 08/14] io_uring: rename io_queue_async_work()
Date:   Fri, 15 Apr 2022 22:08:27 +0100
Message-Id: <5d4b25c54cccf084f9f2fd63bd4e4fa4515e998e.1650056133.git.asml.silence@gmail.com>
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

Rename io_queue_async_work(). The name is pretty old but now doesn't
reflect well what the function is doing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 959e244cb01d..71d79442d52a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1740,7 +1740,7 @@ static inline void io_req_add_compl_list(struct io_kiocb *req)
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
-static void io_queue_async_work(struct io_kiocb *req, bool *dont_use)
+static void io_queue_iowq(struct io_kiocb *req, bool *dont_use)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
@@ -2674,7 +2674,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 
 static void io_req_task_queue_reissue(struct io_kiocb *req)
 {
-	req->io_task_work.func = io_queue_async_work;
+	req->io_task_work.func = io_queue_iowq;
 	io_req_task_work_add(req, false);
 }
 
@@ -7502,7 +7502,7 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 		 * Queued up for async execution, worker will release
 		 * submit reference when the iocb is actually submitted.
 		 */
-		io_queue_async_work(req, NULL);
+		io_queue_iowq(req, NULL);
 		break;
 	case IO_APOLL_OK:
 		break;
@@ -7549,7 +7549,7 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		if (unlikely(ret))
 			io_req_complete_failed(req, ret);
 		else
-			io_queue_async_work(req, NULL);
+			io_queue_iowq(req, NULL);
 	}
 }
 
-- 
2.35.2

