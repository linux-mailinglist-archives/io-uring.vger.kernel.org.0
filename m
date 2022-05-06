Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1CC51D1CE
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 09:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387111AbiEFHE4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 03:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386846AbiEFHEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 03:04:54 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331FB50050;
        Fri,  6 May 2022 00:01:12 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e5so5425055pgc.5;
        Fri, 06 May 2022 00:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lEkfxhWlZ3rm6gnDVC2XNnFXDrzBYLt+qna5jxuoeL8=;
        b=JhPvHm9Kj9rZIgKJngzFkHQrOdfhqvsHTvp5QjdogcCQasAhI5jC5yuv5ppMuFwx+0
         awGu2ntdPL3F7iO1pSwmheNHYf4g/Xfra2+JuTySbMNVdIgD5u/p1WbLVHPZ1i6zQsJt
         Py06dKeatANftaGneNWMrlRVbHkcwCpbXkA7ydcE3LlgvxcCUx3ny4ZZiRXu8U7AFpX1
         JKGPJvPHUcjNtteXHLVKMCYKOi6ja61UHY3nZ9/1ywoVuRhGSzIcEXOQ3ApKB7vRXhY4
         nBzOYdEf3zM5T5sqxmUWQuCaFcdgqkEJwb7LZlW1ZhT8tuHdM8Q5lNGOb9QyEfKSHCay
         eUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lEkfxhWlZ3rm6gnDVC2XNnFXDrzBYLt+qna5jxuoeL8=;
        b=ETk2S1iiTXWClSSjGn7kxe4XXQ1KMrVzu7pNvs5IwvUeCEmMUUOTQRKxJ0Bd2nMKKa
         7q1IDAwtp37IhuAk8xOei3Za/gAzZgTpIwMsoHp/BYSJI4P+q2wuwBuCCVHlQ9z+BnTc
         mQO75IHQzybiAs/M1hbmu8HF7dNB2/TXM3PzA0a4Cty1UStMfurU4jljvpPlZQZxJt1P
         6owq6zK9Bp3GHq0GhGjYyCfKzLaHsuq2IbrO6JvGgnnMimOXlDT3M7CKmzTq2LvoRV6D
         27Qs8IgnOkEeNduYqYvyW6BzOzECs+ILNasz3FwKaFewHzToGJokkGTL401eok/uFfEj
         Njmw==
X-Gm-Message-State: AOAM532J76sh5HGvSmT/lEs3vJ3prvwxijH6hiYsni/SNnS/uiheXtOE
        k0QYOsu/4E9yeb2O1gqYj+gjBHnLB9g=
X-Google-Smtp-Source: ABdhPJyxBvHXm9HEIyk97EgDCmCfrE3tPbRm2gr6KIxIM0sVv4rD/DZj0ndj754aS3Zl/MCkLtQf8A==
X-Received: by 2002:a63:493:0:b0:3ab:3dda:7e90 with SMTP id 141-20020a630493000000b003ab3dda7e90mr1680529pge.106.1651820471648;
        Fri, 06 May 2022 00:01:11 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2desm813112plb.296.2022.05.06.00.01.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 May 2022 00:01:11 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] io_uring: add a helper for poll clean
Date:   Fri,  6 May 2022 15:01:01 +0800
Message-Id: <20220506070102.26032-5-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220506070102.26032-1-haoxu.linux@gmail.com>
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Add a helper for poll clean, it will be used in the multishot accept in
the later patches.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d33777575faf..0a83ecc457d1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5711,6 +5711,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static inline void __io_poll_clean(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_poll_remove_entries(req);
+	spin_lock(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	spin_unlock(&ctx->completion_lock);
+}
+
+#define REQ_F_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
+static inline void io_poll_clean(struct io_kiocb *req)
+{
+	if ((req->flags & REQ_F_APOLL_MULTI_POLLED) == REQ_F_APOLL_MULTI_POLLED)
+		__io_poll_clean(req);
+}
+
 static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_accept *accept = &req->accept;
@@ -6041,17 +6058,13 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
-	io_poll_remove_entries(req);
-	spin_lock(&ctx->completion_lock);
-	hash_del(&req->hash_node);
-	spin_unlock(&ctx->completion_lock);
+	__io_poll_clean(req);
 
 	if (!ret)
 		io_req_task_submit(req, locked);
-- 
2.36.0

