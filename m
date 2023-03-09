Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36BF6B24CA
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 14:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjCINAc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 08:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjCINAM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 08:00:12 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9256FF2C33
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 04:59:10 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u9so6667512edd.2
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 04:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678366747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ytRkAHqL4omXCmjY6VAm9K/7VLTY0ym5LJK/BIxXHw=;
        b=nxw6TLHAh3yJCFURyrCbk1iiVvLkKlbMKz5SXgS4PXCq2BHMPO/vEiYNRsYKazdQlU
         E+Dn3JSXzszgjuauCwVQHubBhnfZCXxSty06Wn3bIMtsp+u2o2kgTxN8iPP2la2bC07s
         tF3vxX49w+dTIgEqIfObjnNPuQ8Oy6op+1/uY45cPt2Qiez72YLxwktz9fGsEhz5OPRq
         MzoJt0sYcnQPClXjLu5xR549Sq/eqOKROkkltNggt3WWTFHP3y9I18qFUWuulTYmT6Nw
         tjZsRJSTxOiOcj5KnXfgWDlzbapHP7Tn+qCZdXiIS0G1mzsB2J3Y9lvbBVxUbaLPLtTp
         Esqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678366747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ytRkAHqL4omXCmjY6VAm9K/7VLTY0ym5LJK/BIxXHw=;
        b=BiFWAfGTgRoVRdqz6g1x1MKxJO31oiq9PHdVl3uysooXGkaCHYfdX18Bfvoq3cvbdw
         bRTKyU89PkoDQU7GRNFGLwh9x/zqwH7u7SNpMLaj9ce0p2sBsKfdnsGxg7vS9J3fnUXS
         bTGxG9RYfbIuQUauRD41EuP2YVj76fk4tLMUStCR1xLgxjLpIQl0ZvWwB/36Tqvg35vh
         Atap8qNfOVVPf0FwWAJokLTKcFfCxYJBP732d1FejlKZgNg6WHbE6F1iZ0n4g38KDUv8
         j3dNkisrSm0SDr+c21UliRNGwwCHsqhgCruRu51OUUwbCI5hpxVwmUnZhaj/NqWg6/Gy
         O6Xg==
X-Gm-Message-State: AO0yUKW+rjFfZI29iIhwdPfFynLtyHr5EfoZHha3Mt8SXIhLB+SJhunq
        y9Fupq8z+D6MCp1VHle4uS23lZJtdWuBug==
X-Google-Smtp-Source: AK7set/s7Xh/Ahw6x1wHvQa+5VWnKwPPLb7mx7ueqKx/xdlbYryZdow0RdAV9UFPOM42xVGkrNQi6Q==
X-Received: by 2002:a05:6402:8d1:b0:4af:60c1:1961 with SMTP id d17-20020a05640208d100b004af60c11961mr21036533edz.23.1678366747148;
        Thu, 09 Mar 2023 04:59:07 -0800 (PST)
Received: from localhost.localdomain ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id z15-20020a5096cf000000b004f0de6d52fcsm3297147eda.74.2023.03.09.04.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 04:59:06 -0800 (PST)
From:   Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH v2] io_uring: suppress an unused warning
Date:   Thu,  9 Mar 2023 13:59:03 +0100
Message-Id: <20230309125903.170857-1-vincenzopalazzodev@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

suppress unused warnings and fix the error that there is
with the W=1 enabled.

Warning generated

io_uring/io_uring.c: In function ‘__io_submit_flush_completions’:
io_uring/io_uring.c:1502:40: error: variable ‘prev’ set but not used [-Werror=unused-but-set-variable]
 1502 |         struct io_wq_work_node *node, *prev;

Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fd1cc35a1c00..bd38e45522da 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1499,7 +1499,7 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_wq_work_node *node, *prev;
+	struct io_wq_work_node *node, *prev __maybe_unused;
 	struct io_submit_state *state = &ctx->submit_state;
 
 	__io_cq_lock(ctx);
-- 
2.39.2

