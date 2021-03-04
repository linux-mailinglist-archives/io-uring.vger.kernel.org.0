Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FC132C9A0
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbhCDBKG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355277AbhCDAeL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:34:11 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34826C0610D0
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:31 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id g4so17666013pgj.0
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y+xH6vUbcFJgmLv9C+KqK/lMT/MsrfVlG5nqHBKrWLY=;
        b=L+WSwwd3nooceC8IzAWDQwNqA9TFXHPY6iYbr5JyhGPNAtr/l/aI4sD6VypanrFfPj
         RrYxv2tsHYJPBYxvQr++iUbkArNdJnG6uo2D8ivREcGHyw9AHuYJPJdfa5YZFKRgwDBG
         9/62kwTRpWxmhaVqKJPlNK1/CJ12hfPuCGXkReWecxWrNroHjeZ0zvM0yjdnJbxrWutX
         pRsZlD8YeSxxLHOr5aHsrbjnt3I7GsISHfQZk6/wXpHbfa/yk8jy/xOc/rNFccnR4hPH
         Hcpp2oiGK3Zk8wq6ag9GwxD19oFEE4qeaUT87/CBq2Qaz5amjtcMIFQ78zhuQrl70tDm
         FWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y+xH6vUbcFJgmLv9C+KqK/lMT/MsrfVlG5nqHBKrWLY=;
        b=P4pmwQUdfKDG98ax4wahRFawau+8AaSeIm3N72/fLdbDsFVDVFhXtDRkwPJYiuA74J
         Ud+rBRvLlojzdZif+8YrV4uoITTQA9TvtK6RKdAXgmlb1TxUyu5sndPZRixQvPUgTe10
         oSVCB1+JhMsSrCPrS9f2//ZcI0NJ2GzazGQZMJYEM01bBgIKBE53Wdb4SCfcwDfyzsTp
         1yoT9JU6ecx7HteVFJPVAwL6ij4Q3/o7zEb7LomReuJkRfl11v8tGmmgXatORjJg/QEU
         NQuYbmXIT6gy1YX30CgPwA9kDDcxSzrsik4lA9orK8SzZ9UtEp77cO1IVJ+o0pQqz5F8
         Dx8Q==
X-Gm-Message-State: AOAM531yGELTf0U5UfQjir2I6oN5P6hnIvlCHuS72KugAiVUuPSXZ59a
        vajMiHqR1JBMzoiMDRxlESoaK0WPgxmuBbq3
X-Google-Smtp-Source: ABdhPJxJbUS2IsN9gGgWPI85Oc8QFm79PXjiSG3YnHdvhuxicfuot8qCydqCx/qCxlphdKYN4F4IWg==
X-Received: by 2002:a63:4e26:: with SMTP id c38mr1325284pgb.81.1614817650488;
        Wed, 03 Mar 2021 16:27:30 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:30 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 21/33] io_uring: replace cmpxchg in fallback with xchg
Date:   Wed,  3 Mar 2021 17:26:48 -0700
Message-Id: <20210304002700.374417-22-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

io_run_ctx_fallback() can use xchg() instead of cmpxchg(). It's simpler
and faster.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index befa0f4dd575..5bd039aa97bb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8484,15 +8484,11 @@ static int io_remove_personalities(int id, void *p, void *data)
 
 static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 {
-	struct callback_head *work, *head, *next;
+	struct callback_head *work, *next;
 	bool executed = false;
 
 	do {
-		do {
-			head = NULL;
-			work = READ_ONCE(ctx->exit_task_work);
-		} while (cmpxchg(&ctx->exit_task_work, work, head) != work);
-
+		work = xchg(&ctx->exit_task_work, NULL);
 		if (!work)
 			break;
 
-- 
2.30.1

