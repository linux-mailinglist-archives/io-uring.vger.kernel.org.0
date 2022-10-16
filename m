Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE085600347
	for <lists+io-uring@lfdr.de>; Sun, 16 Oct 2022 22:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJPUdK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 16:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJPUdJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 16:33:09 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3003B3057D
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:08 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b2so20856216eja.6
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUHvLcKLFL36tYPs8CH/YI7G5vNcC4S7LNovyR3sUgc=;
        b=ovv705iLe0E+UXCWEah8EIgQ2/ufU/yy4BhLzRIe2SVT1vBd/il4wPPJlbuYOo49MR
         aCx9hSn45FXuc54eJj9oVNIStE+9D/hUtVbEc7PmxnVeTARgGdyfSPUVdgWpN4uLNnvz
         2RdQzQ8qAb41h8INVG2KnxJkUX3u8xYxVQ8lzxTpjsAAprXLahMHzDncOWqe8l/i8d+a
         6kbFE7gurVgwnIDaB5PJckvfEjZIYEHHSx3ZuKpb0VEROaEqrBsaT4VcR4WU8xsdMVIP
         rX1pdCOIACVNny4kZtVA+4kK4AFxXfokfL6GooMIdJHp7j/0mm9A0m9f2fQwUhRZWubZ
         owMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tUHvLcKLFL36tYPs8CH/YI7G5vNcC4S7LNovyR3sUgc=;
        b=WN4rghDmmp8SnzBvKtkHFy5LdOY1yFfhrzciL2DtHw2zehaA9TSFmGyQyfYqqHEtd+
         W8lMtJAj7ClOirv56pHwcHwS6Yxdj8kPAfKzN+H0dtBFUoyTJ+zGTduxCz1X0KhCWWwh
         D3BMsb/4nL9EqLjJhlZQk2wMgEr+xu0RdFalORGNp//tIqbpPXfzoz0z6EwjbBWz8LcN
         gGEvKOmB7cw2+/F7hK4gjTIWAeX5CZ1oQuUdViCCg9zW0jMmveCJo5HNJLqn7xOmdQdk
         85Mm/xh65kzaL+i9Tc6B3hNnZ/GpFH9nEy5274QW+VcQphqdOfchLpJ1zDkPs5ZxqcI/
         MDRQ==
X-Gm-Message-State: ACrzQf0+4AISWj5saJR2PSWrYktsRDgKcwij+CbrHKAUUe2fsz80dDjV
        lcSniO349J9vaGaWVLOdkVF3l1sVjJE=
X-Google-Smtp-Source: AMsMyM4AJoTfU0xZCQG6xrkIZphYHuHMHT7WAKWQIK5KLL65H0rRwh3+p2U3HT4dLPp1Yio61OhUrg==
X-Received: by 2002:a17:907:162a:b0:78e:2859:76be with SMTP id hb42-20020a170907162a00b0078e285976bemr6152436ejc.768.1665952386449;
        Sun, 16 Oct 2022 13:33:06 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709060a8b00b00788c622fa2csm5069345ejf.135.2022.10.16.13.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:33:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring: don't iopoll from io_ring_ctx_wait_and_kill()
Date:   Sun, 16 Oct 2022 21:30:51 +0100
Message-Id: <7c03cc91455c4a1af49c6b9cbda4e57ea467aa11.1665891182.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665891182.git.asml.silence@gmail.com>
References: <cover.1665891182.git.asml.silence@gmail.com>
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

We should not be completing requests from a task context that already
undergone io_uring cancellations, i.e. __io_uring_cancel(), as there are
some assumptions, e.g. aroundd cached task refs draining. Remove
iopolling from io_ring_ctx_wait_and_kill() as it can be called later
after PF_EXITING is set with the last task_work run.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 62be51fbf39c..6cc16e39b27f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2804,15 +2804,12 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_poll_remove_all(ctx, NULL, true);
 	mutex_unlock(&ctx->uring_lock);
 
-	/* failed during ring init, it couldn't have issued any requests */
-	if (ctx->rings) {
+	/*
+	 * If we failed setting up the ctx, we might not have any rings
+	 * and therefore did not submit any requests
+	 */
+	if (ctx->rings)
 		io_kill_timeouts(ctx, NULL, true);
-		/* if we failed setting up the ctx, we might not have any rings */
-		io_iopoll_try_reap_events(ctx);
-		/* drop cached put refs after potentially doing completions */
-		if (current->io_uring)
-			io_uring_drop_tctx_refs(current);
-	}
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
-- 
2.38.0

