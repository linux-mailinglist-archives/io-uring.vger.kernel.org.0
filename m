Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A30565E9B8
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjAELXl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjAELXd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:33 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA75559CA
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:31 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id fm16-20020a05600c0c1000b003d96fb976efso1056104wmb.3
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GscsiLJ8rccsuSYYxaQoDj9SBHinsWa28fb7CygtUTE=;
        b=cmavc8o0jCH0KYmL/38TcF9X89ROmwzZybx4dDkLzXT6KqjJ4XEjlp/4JjepWfxyKM
         FHRmG4z32g9Kyoj6qtPgjNFdq4PQwc0weqU6VqQXt4KPlW24Dbqy3Z+1uamrMs8iSdX5
         gY6Xj5l1FLnMOixSYDrM5aKxRYLn9JTYNoDTxvtYDtC6Cygp12c+js1N+F8BWFtn3+IJ
         o0j+2/JqC8NrkqggC+d/IjErsfMBrEvhUvjtJlHiR1PGks4HQHgiu2CSpg6ARU/WUVrm
         LLyZ/E5UaH1QHZvQhhl0aeOWA7RLvPeHtoRdXv4S1XqmoDIEo63JGPMkRSOm+N9wAdJb
         AabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GscsiLJ8rccsuSYYxaQoDj9SBHinsWa28fb7CygtUTE=;
        b=nClFjtlvCJ3MfLSlQU/npxeJDZ8UkBKZRgoupDDvCnXNvKbQ6/4IEDxXXBJ7j55jB8
         qDs2lXCyEkjyCYo1WMjWbKfL1bWDUy88dqIycwgjor0X9nE3YIJg93163ypb4Kx/F7uT
         JKcC0nT/JnJRF3pHfD+bnUXY3O0wUvMDQ9njzwjBquxznR5v/3zoCD+hVglTpNV9m3Pa
         lcExnfTwmy/CwgVV76YJiP+enVzGIY7SgF65f4Jumtcf32eyYDjrMrsDuj/wPr7XG8Pr
         9kDvQZ89nvinePAQXTVcsUrMucVay3ffrzcuAOP3G4ZLa5lBMV215opZ01m3lDkYFkoL
         hnIQ==
X-Gm-Message-State: AFqh2krosIIj8T6XsDjoFkGO8qo8Lhr0mRRcjVqZLciVxX3iZ88zZcs7
        ZPe0T9AiYPdHYfVhZDP5+5cRHcukgIM=
X-Google-Smtp-Source: AMrXdXvtzts/6sKGk/2DCMr0NtjH182/PA8nGCcUY9RxEI2qDOIzD4nxczVVe+c/BLLrODFA5WbP/Q==
X-Received: by 2002:a05:600c:1c21:b0:3cf:9844:7b11 with SMTP id j33-20020a05600c1c2100b003cf98447b11mr43782422wms.23.1672917809651;
        Thu, 05 Jan 2023 03:23:29 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 02/10] io_uring: don't iterate cq wait fast path
Date:   Thu,  5 Jan 2023 11:22:21 +0000
Message-Id: <1f9565726661266abaa5d921e97433c831759ecf.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Task work runners keep running until all queues tw items are exhausted.
It's also rare for defer tw to queue normal tw and vise versa. Taking it
into account, there is only a dim chance that further iterating the
io_cqring_wait() fast path will get us anything and so we can remove
the loop there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cddfcfddcb52..ec800a8bed28 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2507,18 +2507,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
-
-	do {
-		/* always run at least 1 task work to process local work */
-		ret = io_run_task_work_ctx(ctx);
+	if (!llist_empty(&ctx->work_llist)) {
+		ret = io_run_local_work(ctx);
 		if (ret < 0)
 			return ret;
-		io_cqring_overflow_flush(ctx);
-
-		/* if user messes with these they will just get an early return */
-		if (__io_cqring_events_user(ctx) >= min_events)
-			return 0;
-	} while (ret > 0);
+	}
+	io_run_task_work();
+	io_cqring_overflow_flush(ctx);
+	/* if user messes with these they will just get an early return */
+	if (__io_cqring_events_user(ctx) >= min_events)
+		return 0;
 
 	if (sig) {
 #ifdef CONFIG_COMPAT
-- 
2.38.1

