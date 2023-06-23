Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9973B612
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjFWLYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjFWLYm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:42 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC88E1739
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:41 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-988689a5f44so44976966b.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519480; x=1690111480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8IzdFjveQ9hwmkRa48Ek1vMmW1XJWaCIZgZ0bHO5ik=;
        b=mx4U/yiUy6F4aZVnwnZVRTyHCR7UqNc0GwOEmKT/1cXhyZFNraMikAjl8gpLCoO1Ql
         I/amnD0LzDmQpO9Oh9Dz6Rck0gbgA5yb4RFeyObt8ciFnT/ZNBso6DRJt+sPSsWjSPvj
         5PmqT9m5T6OIF38GiRCfsL1Ud4zjlwc0hgybX3i1oKR68Xk75F5KHpFKeGtOOnvVRypm
         58qeUDyFfvu3TLheO3bXNoYo0DubqOVfBVy/xLpbBaIb3CPOHPxLCZARIW1Nn7MmrJgj
         QF2/vb3iqnsbwIdfxzbbq/oQTwAXwVQTQ1hC1589AUWpC36h1Ssmyq5QINNoLemqL3mb
         Fx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519480; x=1690111480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U8IzdFjveQ9hwmkRa48Ek1vMmW1XJWaCIZgZ0bHO5ik=;
        b=bCZtArToCEX8aQ1czOFE69IuDVDT+FeG3jl8mAaBhfXezE5Sj4VUqB/h95Rq9YRlZ1
         sPMCDqXaMCYA6sJ58orzGH1AAHjAvfqFi4OaWVHsaeomdBKvIizvGtskiku97BBbJHiz
         i3brkz/BpmuF6XsSynJ2xa0G8vwpXAnGjy2SsPdXY3juBYYTYLvItqe0S3/xJT6Hvb43
         0XYjfw+6drIYUTISM35tIHcj35nuLMG+Ji5FGvSRrCPjl5chRITyUuQ8tpB9FgADO8hz
         cyiGha02tg6on5aT1/IxQFC/BscrkCCofCknqDg6mXsSlpgOihbH2qXyeCIcqEN6nzxv
         bZWg==
X-Gm-Message-State: AC+VfDwAa3TAunrY0ZPq1xmmVVUEeEkIwxnXpt9TAWWNHmRCL5H2Aesz
        vZqK3uVCS/nkJYravQev9zxLdEks2aI=
X-Google-Smtp-Source: ACHHUZ4/uktIQEljZ46am/ae4mVKpKSl9L5/v6kSTX5kCcd0ELLeW3SE2bvxrvvTaKUZQE65+HOIMA==
X-Received: by 2002:a17:907:3f99:b0:973:e349:43c9 with SMTP id hr25-20020a1709073f9900b00973e34943c9mr19203901ejc.77.1687519480072;
        Fri, 23 Jun 2023 04:24:40 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 07/11] io_uring: kill io_cq_unlock()
Date:   Fri, 23 Jun 2023 12:23:27 +0100
Message-Id: <7dabb36856db2b562e78780480396c52c29b2bf4.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
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

We're abusing ->completion_lock helpers. io_cq_unlock() neither
locking conditionally nor doing CQE flushing, which means that callers
must have some side reason of taking the lock and should do it directly.

Open code io_cq_unlock() into io_cqring_overflow_kill() and clean it up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 776d1aa73d26..2f55abb676c0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -644,12 +644,6 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 	spin_lock(&ctx->completion_lock);
 }
 
-static inline void io_cq_unlock(struct io_ring_ctx *ctx)
-	__releases(ctx->completion_lock)
-{
-	spin_unlock(&ctx->completion_lock);
-}
-
 /* keep it inlined for io_submit_flush_completions() */
 static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
@@ -694,10 +688,10 @@ static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
 	struct io_overflow_cqe *ocqe;
 	LIST_HEAD(list);
 
-	io_cq_lock(ctx);
+	spin_lock(&ctx->completion_lock);
 	list_splice_init(&ctx->cq_overflow_list, &list);
 	clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
-	io_cq_unlock(ctx);
+	spin_unlock(&ctx->completion_lock);
 
 	while (!list_empty(&list)) {
 		ocqe = list_first_entry(&list, struct io_overflow_cqe, list);
-- 
2.40.0

