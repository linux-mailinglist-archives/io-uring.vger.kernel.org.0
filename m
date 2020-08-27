Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63285255158
	for <lists+io-uring@lfdr.de>; Fri, 28 Aug 2020 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgH0WwC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 18:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgH0WwB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 18:52:01 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570E2C061264
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 15:52:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k18so4638970pfp.7
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 15:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5b2t70KTKIbGjXzNmfiw6qbTP+tp7fpMEwkNhnQw7o=;
        b=xshBMJWpe3241mj6sHV5usXCQc9qHFXhH7HA+Prsi7J9AL3Av/dEEiuqZHK8lVkxXW
         CewI19H4qvKatheOAdynCXB++d+hjtuCnYNb45IR6zBX965ssU7OONqXTiZvFDBgXYUS
         6EdLl79EHUsi2odbO8Yuzw4OlqUlJtMv7fmzHjjSxZOYey1BJUPnKFOJTsTzt0bYvhZ4
         8IyUR9yzsPe6LK7BZ+tV5jEj3k3/0oa8fQdQk8mzWdAIRdmnyEbb3ZGFNkUga4SRENeU
         GNjCAdNbJ0gHG9vGVkjOOIdJ/enJwSdgqH2JCLuzbvlZVC59F2JlIswtbqfIhyx+r8sM
         +RSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5b2t70KTKIbGjXzNmfiw6qbTP+tp7fpMEwkNhnQw7o=;
        b=r9zF3wifS6EXjxf/Y7gP6AOge3LXvWa1kkUZQUwhNG895eSRjoMzbBA3GFPONfo5Q8
         AGySM/FdLJs2FoEVM7AebWldtj5wjcSRC1qdNifONJBBXaXkeNc9C+7klnEC1HkwDUAE
         pPk9H4FOWFlttPMUdxcloML/UgDP3yneD2ev7eeqE0W7fi1esfnGQ1/b570KWEx+m/Jh
         Sec/+lqcNs7ntdZi+IVaL1/53rWacKqPmkwYP/IX8bBiLtpKYGOgx9yaLbG4Yik7JZal
         pOMWaZVEbn/M7x/pr09XGhPBUlORcKlCaYD1QsKoGpj/2Pw+cwQXwch0eXcSSuSymAHV
         AsSQ==
X-Gm-Message-State: AOAM5323bL2CeFHzjV88V1QxK2AUMb78tfY3XD7/PMIbzhEvgJ9zrakn
        wYCUC2bSOJUCTP62CasFalhA2eCd/2kUCmwP
X-Google-Smtp-Source: ABdhPJwTTwKBzUAiIP2qLfwLuS3MeJCoeCgAzmujhrALvLbUzRJgOeKx5ELrc8cBVUNqVp4+hXSaUw==
X-Received: by 2002:a63:f813:: with SMTP id n19mr15954232pgh.34.1598568720609;
        Thu, 27 Aug 2020 15:52:00 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id js19sm3087868pjb.33.2020.08.27.15.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 15:52:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: don't bounce block based -EAGAIN retry off task_work
Date:   Thu, 27 Aug 2020 16:49:55 -0600
Message-Id: <20200827224955.642443-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827224955.642443-1-axboe@kernel.dk>
References: <20200827224955.642443-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These events happen inline from submission, so there's no need to
bounce them through the original task. Just set them up for retry
and issue retry directly instead of going over task_work.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d27fe2b742d8..81143458f3b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2295,22 +2295,6 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 	io_req_complete(req, ret);
 	return false;
 }
-
-static void io_rw_resubmit(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-	struct io_ring_ctx *ctx = req->ctx;
-	int err;
-
-	err = io_sq_thread_acquire_mm(ctx, req);
-
-	if (io_resubmit_prep(req, err)) {
-		refcount_inc(&req->refs);
-		io_queue_async_work(req);
-	}
-
-	percpu_ref_put(&ctx->refs);
-}
 #endif
 
 static bool io_rw_reissue(struct io_kiocb *req, long res)
@@ -2321,12 +2305,14 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
 		return false;
 
-	init_task_work(&req->task_work, io_rw_resubmit);
-	percpu_ref_get(&req->ctx->refs);
+	ret = io_sq_thread_acquire_mm(req->ctx, req);
 
-	ret = io_req_task_work_add(req, &req->task_work, true);
-	if (!ret)
+	if (io_resubmit_prep(req, ret)) {
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
 		return true;
+	}
+
 #endif
 	return false;
 }
-- 
2.28.0

