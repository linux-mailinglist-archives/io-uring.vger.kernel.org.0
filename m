Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86946342700
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 21:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhCSUfi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhCSUf3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 16:35:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932E6C06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so5426527pjb.2
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mwFbTLfLjz0UyqTnseOZyJqOE1mSuUm4Njqt9cPC730=;
        b=wv9okxk/3F1epLlvgtvamQ79tTrRfdWwiIcXvF8YV++CRAWtASDR3Bj2BELttsl+Oq
         b7CzJkeUG0/cMZi+T8JN5tMz3Q7IjDiPVfmWytaWK2xOOyAt54wtHMX92CuxKFVy5R5L
         04y3s7ZnsBJDuXzBJtKjtoTw/s6pRr3NAFUi8uwnOONfdMg0C5QBUH0tUEKALY54Whb2
         8hNZ4ppJJXc9cptc53PrqqTRwSOqZgypd+cTwyc1/6mgsQOmfxIXN+HXaWHcdnDH4QzP
         NZocOBOvIUx31fhtrH1JoPANbiNsJOisVZ5kQ2QRa0m5lsgXpSZMvypoynBtmJaIAXNt
         F8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mwFbTLfLjz0UyqTnseOZyJqOE1mSuUm4Njqt9cPC730=;
        b=uio6tHJARivT0jBMHb8MzXevrs+Gw/ZDcj8Z9Mz+csbok3ZVfqQm5iRxXul5fbpoDx
         BePrLE38/ZVgkb/1Th6c0yLGZjARncxIB9R75a9NO6Kyy1VGFpBRvN2tybVH00033wR0
         o+FagYFI1rkBuhiqlIAb0oHDWCLiyjWWTnTeyDxO909o03W/IFno+Qi50cQ4gQAdzDFy
         jovoWH+CTbUomApYUxvKraE44+0h85ep+kwulGrEY/UwyUIFNAxr1LGgdZ3OEge7P8Ua
         NTFrbm0ity7c0IxAN1geimx5rnwqItFuP7SvnalQiUwmdD513T1/Mfx3QNxn3A+35+Tz
         iyoA==
X-Gm-Message-State: AOAM533hvHPUZzZU0SvAcPwz+Sz453PU4ysR7AC0/Wm0gU+2XACip2Yb
        FPGNlB5ir0fgnyKZxwGkyFJanjmgn4NTtA==
X-Google-Smtp-Source: ABdhPJyvHPW+MtHg4UiPic3jhdmA65FqQMSb9otLPYRxiyx2zPCwluII26wCfLssZO9YZxRLkfMPXQ==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr332345pjb.92.1616186128962;
        Fri, 19 Mar 2021 13:35:28 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b17sm6253498pfp.136.2021.03.19.13.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 13:35:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] io_uring: abstract out a io_poll_find_helper()
Date:   Fri, 19 Mar 2021 14:35:15 -0600
Message-Id: <20210319203516.790984-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319203516.790984-1-axboe@kernel.dk>
References: <20210319203516.790984-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We'll need this helper for another purpose, for now just abstract it
out and have io_poll_cancel() use it for lookups.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 103daef0db34..55a7674eb3b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5284,7 +5284,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	return posted != 0;
 }
 
-static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
+static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr)
 {
 	struct hlist_head *list;
 	struct io_kiocb *req;
@@ -5293,12 +5293,23 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
 	hlist_for_each_entry(req, list, hash_node) {
 		if (sqe_addr != req->user_data)
 			continue;
-		if (io_poll_remove_one(req))
-			return 0;
-		return -EALREADY;
+		return req;
 	}
 
-	return -ENOENT;
+	return NULL;
+}
+
+static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
+{
+	struct io_kiocb *req;
+
+	req = io_poll_find(ctx, sqe_addr);
+	if (!req)
+		return -ENOENT;
+	if (io_poll_remove_one(req))
+		return 0;
+
+	return -EALREADY;
 }
 
 static int io_poll_remove_prep(struct io_kiocb *req,
-- 
2.31.0

