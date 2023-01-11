Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9686658D7
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 11:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjAKKU2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 05:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbjAKKUG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 05:20:06 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59C7BCC;
        Wed, 11 Jan 2023 02:20:05 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y5so11049536pfe.2;
        Wed, 11 Jan 2023 02:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g71XtJYmKF1U64u/mKee6gqmuQMnGQrpGMXwCiQqmnM=;
        b=o3SbFNcgwgzOvz4PAWC7qpB3Yz+gUEFvjJ5ORg1nI+7VuDs3WKd+SWQGyo0t4NbTru
         3Q3cn9wYg37lK28hwpq6UZxB52lNRr99WB5jxTj8O+ZS3L8rCseHqtrrsJzAdjjGuktP
         2lybFkIyQkzfsJZFTuvbhTvyceX4ENEEqX5cvukge+1MF55qQ7aSy9DGgBcl31pjJf1e
         PhZQIAyTdcmgouKcnqufa/msLhrx7fJK+eyUwmDp4STb6hNba3feoMIv+eFwrvGN5dtg
         OXHm4cB7p9T+U9cbLfbVvKlizDdrxtiIdhXQQKA6hWTsbUe3eChDgMAerWZR+4IIxpl4
         Oegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g71XtJYmKF1U64u/mKee6gqmuQMnGQrpGMXwCiQqmnM=;
        b=c2Up8iwwPRQlc7XsY3zl6LjhWeiUGAwHThughhUSadfKoEiagFEwu6+sca40tQrAC/
         30CueplhrUD5J+8aolt+cjdQ68paqVW6zqEHwF/nGemrM6wREJyVmeD8pkzP+OIMn/Bj
         2Zo6EpP3RiFAr79fRaYZZjlZD5o+Bp0SZ3VwS2YHM/JwUgslA99ZT4zL5TRgKcT7ZSL9
         b8xJQcCQtZP82AT5M09lF2pMic4K8So0TvgbXR2c8GLv7vzK0IE5xfj5DTY8xHn3mg02
         hB36YZHSAZFcagw6vPX9dzGCoNlBDsqj96aY3tweTkjynh/qlTzZw7/o0RJW2GlDOM/o
         l2hQ==
X-Gm-Message-State: AFqh2krhYhi/JCxf2RgMsv2HtRcUu0N9ulz18ORKYnbDyVvlFlauecOX
        gVkXrRhVLYlnEREDjmchWTE=
X-Google-Smtp-Source: AMrXdXuAeggcFUWLCbqFQzqew6nbFoUotRMWKRYNGjGp1nc4LjZe8ld3NRx79nB7XYz5xW97uEikOw==
X-Received: by 2002:a62:1c4e:0:b0:587:e40c:59e with SMTP id c75-20020a621c4e000000b00587e40c059emr1740065pfc.18.1673432405307;
        Wed, 11 Jan 2023 02:20:05 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.142])
        by smtp.gmail.com with ESMTPSA id u190-20020a6260c7000000b00575caf80d08sm9663761pfb.31.2023.01.11.02.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 02:20:04 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] io_uring: Add NULL checks for current->io_uring
Date:   Wed, 11 Jan 2023 18:19:07 +0800
Message-Id: <20230111101907.600820-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As described in a previous commit 998b30c3948e, current->io_uring could
be NULL, and thus a NULL check is required for this variable.

In the same way, other functions that access current->io_uring also
require NULL checks of this variable.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
---
 io_uring/io_uring.c | 3 ++-
 io_uring/io_uring.h | 3 +++
 io_uring/tctx.c     | 9 ++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ac1cd8d23ea..8075c0880c7a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2406,7 +2406,8 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		/* try again if it submitted nothing and can't allocate a req */
 		if (!ret && io_req_cache_empty(ctx))
 			ret = -EAGAIN;
-		current->io_uring->cached_refs += left;
+		if (likely(current->io_uring))
+			current->io_uring->cached_refs += left;
 	}
 
 	io_submit_state_end(ctx);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ab4b2a1c3b7e..398c7c2ba22b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -362,6 +362,9 @@ static inline void io_get_task_refs(int nr)
 {
 	struct io_uring_task *tctx = current->io_uring;
 
+	if (unlikely(!tctx))
+		return;
+
 	tctx->cached_refs -= nr;
 	if (unlikely(tctx->cached_refs < 0))
 		io_task_refs_refill(tctx);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 4324b1cf1f6a..6574bbe82b5d 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -145,7 +145,8 @@ int __io_uring_add_tctx_node_from_submit(struct io_ring_ctx *ctx)
 	if (ret)
 		return ret;
 
-	current->io_uring->last = ctx;
+	if (likely(current->io_uring))
+		current->io_uring->last = ctx;
 	return 0;
 }
 
@@ -200,6 +201,9 @@ void io_uring_unreg_ringfd(void)
 	struct io_uring_task *tctx = current->io_uring;
 	int i;
 
+	if (unlikely(!tctx))
+		return;
+
 	for (i = 0; i < IO_RINGFD_REG_MAX; i++) {
 		if (tctx->registered_rings[i]) {
 			fput(tctx->registered_rings[i]);
@@ -259,6 +263,9 @@ int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
 		return ret;
 
 	tctx = current->io_uring;
+	if (unlikely(!tctx))
+		return -EINVAL;
+
 	for (i = 0; i < nr_args; i++) {
 		int start, end;
 
-- 
2.34.1

