Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2432D32C9AE
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbhCDBKV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448897AbhCDAfr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:35:47 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E46C0604DE
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:41 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t25so17636477pga.2
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ba1tt3w/TPLLg8VHaWsW0mQIjXsxDaiLtrs4B1JW5kc=;
        b=XkK31q71Le2ZZy8FQ8kplnxcUkT1MZiTKpZhuX3d/l6KaSib+cmZg+HR3lftid7Ypz
         753sWqVJFKW8VfWmJuPOWPkQY2d7YOjPFrCS9t5dLLCpg0BgX/JoBu/x9J6tyVSMJpzO
         AOlvEIUKFHnBYzv/dzSY6i0jR0y+OA3jyvcC71bEVVPDINQlUqCNXc7jMuMx9/DwxtxO
         kD5dwXlGMc7Uy6CrKLKw9q/W+eVARHqS2QgrRbxn/uOCsIFGnqQP7/RQKBRrBfd4Jx7a
         AP2UQbRjxCfK5HwzxOcsHDToXsgtm8Qf6H3zJjkolrjrt8oxsm9Y2ohCH+G6qSTMUGkd
         xKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ba1tt3w/TPLLg8VHaWsW0mQIjXsxDaiLtrs4B1JW5kc=;
        b=JHNVlMP2pgb2hW2TSUwNdQdYxm77mJ1WC7PmrHiKK2hsWmzj0noBMzyQcYJv35R0xd
         QTED9sQOILLMgycB1IQv3tXWrl55I5tKPPRofNJvL4zj52LOQvqFW8TQ0LTedas1c9yN
         ghVyiASiQUaFVqMT2YBRuqNgGsKkCee57aAUjX85gkcnlyy9wGczVxaNrV5Qywt258pr
         Wuy4+w4ODbhz6inKGiTCBWhN9t9TSaHuMAQfP37jNG61L6KDYuV8K3A0hLmAwfeAo1oi
         Kc0D3LOen0FTU8lE/CR6NFVYLICUIA6vWKJoxyvu3bMPPvcw7iZAwEHyBXY02p+ivxXv
         nlxQ==
X-Gm-Message-State: AOAM530nGM4IL73JmxXV3vis9CesnugpjdkOsTj1DBOT7F4UJvf4+Set
        gkzTjCVVip60Q8LcOGZrvnpjtShvpadRDe0n
X-Google-Smtp-Source: ABdhPJwTFD0eHHRnOTNvb7oP1t9MH8SJ6Q/IS9trlDVZw2B2kKT5qzq6Hph0WP+8/42vyPdl1ydnsw==
X-Received: by 2002:aa7:9711:0:b029:1ee:b2c7:ecfe with SMTP id a17-20020aa797110000b02901eeb2c7ecfemr1257161pfg.58.1614817661207;
        Wed, 03 Mar 2021 16:27:41 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:40 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 30/33] io_uring: inline __io_queue_async_work()
Date:   Wed,  3 Mar 2021 17:26:57 -0700
Message-Id: <20210304002700.374417-31-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

__io_queue_async_work() is only called from io_queue_async_work(),
inline it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ef6f225762e4..7ae413736c04 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1205,7 +1205,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 		io_prep_async_work(cur);
 }
 
-static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
+static void io_queue_async_work(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
@@ -1216,18 +1216,9 @@ static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
 
 	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
 					&req->work, req->flags);
-	io_wq_enqueue(tctx->io_wq, &req->work);
-	return link;
-}
-
-static void io_queue_async_work(struct io_kiocb *req)
-{
-	struct io_kiocb *link;
-
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
-	link = __io_queue_async_work(req);
-
+	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
 		io_queue_linked_timeout(link);
 }
-- 
2.30.1

