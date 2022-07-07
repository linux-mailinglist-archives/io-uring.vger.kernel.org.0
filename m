Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A4356A52E
	for <lists+io-uring@lfdr.de>; Thu,  7 Jul 2022 16:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiGGOOW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 10:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiGGOOV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 10:14:21 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FF72F39C
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 07:14:20 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id os14so2430579ejb.4
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 07:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xykTgCQ9MK6li84TM+cB65FPijGtvT2IntKDqB/chPM=;
        b=NNfi/RUJLb6kqFrWk9iw0r6c4axZAo5X602z2LPkLS9fvQT39JH3Zmsv9TOalMcu1N
         UqLpGd5kmexKZBw8GZ57QFtLkLgTj7ICDNwPeEGomKJPcAQGKVy260wBtxGWOAIQGU4x
         wV8g4XHGSx9NG0XbCWUYfCp45xy1TRtai21IuXFjYfNrMYxQBwAO8nsaQcHeGlb6eE4v
         Gn3+HrYjwKYTaoDfteZyyidVvpLx3vpCrVobRc1ZsNvofjBSVds5BO6IyKueAql3Y2SA
         Pu6wYul1LNiuLm9SKenoJKucwKg/qZ7aUpHZw3hvMvk4atBbTEy0AExoa+UwN/BBvEw0
         W9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xykTgCQ9MK6li84TM+cB65FPijGtvT2IntKDqB/chPM=;
        b=n2NpHGnpL1nCJGfqxE9u0nZNz3AHDSbuW0Yacc/pV0t/I0CBl4MG17tEECv3Cq288S
         tl0NdZISQHx4pnkFWvRlMw/UkPSRut/WO0+Hh746lk6IrG9pEGi+xQiLkN9fmiduD/3U
         VdyLrfyh2XPrC2qx4QYnKDxdOQ10FkJ6sYuHWQdbpuwvgk0iivsqLw3E0lugdYde0eY4
         0KYHxBo347Po1Al1yXDrC7h9eXnyX8Ufnnt9mxBPZs22+t2GiZqLdhd3fJAyA5ANK9ht
         LYPFh0Wgy1V2JHLZcEJdUEgYpehOQHBSiqiMq7ha7mU9KpH3TqvKJF1j09GxAQvVqoeQ
         OIoA==
X-Gm-Message-State: AJIora9toX4J+u1yy+opoY4Kqbwvwh9EGB2osYXd/8jFfSYpkLipeoiN
        ypvgKaVyO8Lrl5WCS1s2vZOanngw20453r0y
X-Google-Smtp-Source: AGRyM1tkgoQUjqldcT/SAU9DPYy7C2dwPROcgOsTy7XrOh9U/oLPohR4065oYYjFSbY6kxtHD0pLcA==
X-Received: by 2002:a17:907:3e9a:b0:726:d079:d868 with SMTP id hs26-20020a1709073e9a00b00726d079d868mr46023154ejc.620.1657203258987;
        Thu, 07 Jul 2022 07:14:18 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:3fc3])
        by smtp.gmail.com with ESMTPSA id bq15-20020a056402214f00b00435a742e350sm28254125edb.75.2022.07.07.07.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:14:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/4] io_uring: clear REQ_F_HASH_LOCKED on hash removal
Date:   Thu,  7 Jul 2022 15:13:16 +0100
Message-Id: <02e48bb88d6f1480c94ac2924c43ad1fbd48e92a.1657203020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657203020.git.asml.silence@gmail.com>
References: <cover.1657203020.git.asml.silence@gmail.com>
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

Instead of clearing REQ_F_HASH_LOCKED while arming a poll, unset the bit
when we're removing the entry from the table in io_poll_tw_hash_eject().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index c1359d45a396..77b669b06046 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -132,6 +132,7 @@ static void io_poll_tw_hash_eject(struct io_kiocb *req, bool *locked)
 		 */
 		io_tw_lock(ctx, locked);
 		hash_del(&req->hash_node);
+		req->flags &= ~REQ_F_HASH_LOCKED;
 	} else {
 		io_poll_req_delete(req, ctx);
 	}
@@ -617,9 +618,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	 * apoll requests already grab the mutex to complete in the tw handler,
 	 * so removal from the mutex-backed hash is free, use it by default.
 	 */
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		req->flags &= ~REQ_F_HASH_LOCKED;
-	else
+	if (!(issue_flags & IO_URING_F_UNLOCKED))
 		req->flags |= REQ_F_HASH_LOCKED;
 
 	if (!def->pollin && !def->pollout)
@@ -880,8 +879,6 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
 	    (req->ctx->flags & (IORING_SETUP_SQPOLL | IORING_SETUP_SINGLE_ISSUER)))
 		req->flags |= REQ_F_HASH_LOCKED;
-	else
-		req->flags &= ~REQ_F_HASH_LOCKED;
 
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events, issue_flags);
 	if (ret > 0) {
-- 
2.36.1

