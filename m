Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FBE54DE1A
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376331AbiFPJW4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376481AbiFPJWy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:54 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7749B11174
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id s1so1035718wra.9
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fb6MpG+TUR+lfc/l0HsFy1uGwvkTzMYMEuxuESOhYE4=;
        b=HrvVHvyie15H815z2sNl4TYkIdl/No+fxC/1/XFc3hlf6Yo/sNS0K7guQ+3JtGQ4ly
         fo7PT5J8o1BUdR+SC2LMvBc5N4+1LvdVGHHTh+Qkxj0iEXqKXXTIYbePhyUBCk/K8q5R
         /WN+k19jJht4AYhzrzLexgnCjBaRK6A8CK3ruP7xkHRc251tOMHsZetd2iAyK7biVYb5
         jVdUlZXNEllhZlhLfS5rEtAjvaqi6FBhY3YgE4k4xrMCwChJg82fGoQZtY/JvNXaK1Rm
         V1l1NVm/IQNRfiJTUUPOJyVK5SRi1BSlSpaMvcO9KR2cdJ4tXV395W/lwIS2FhxZ3kUK
         FOMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fb6MpG+TUR+lfc/l0HsFy1uGwvkTzMYMEuxuESOhYE4=;
        b=PwaRnlnCb/ZFdn2JITRC4PmGU9J5TkRdUEFb3ndWqdHuxJ+sASoDD2M9mB0tcbwMv8
         lwJSYYPeFkLksNmr/s9zb6pMi6VjMnIctyo6yS1EoZ/ODkvZ3hckuj5PK5R+iyq70PZj
         b6DzD6ALCPxNT68T4SW2PXBEJYOMHhZNXzsDAhftrfccnZ5EjhMDv5AiV2xSS7rqP2AJ
         IbbljO1Y9LTV3V+rqhaVx/X87U98Ok/J7Wwtn+HKFtkUQAAUsyjKNDuQIAV1b1ESoUT5
         1dgYLgjUhke24Pw5hUgJqZi6yPczEJbwLMV+1HnV+bOFwRHRxQyvOTqPLPrabwVzQONZ
         mZnw==
X-Gm-Message-State: AJIora8SIOXZdWvlekBBOiHf7NJVzPcrNpzxc2lrOjPr99UoDn5EkLAu
        Chf9HGN2f0xhTkJ26NdmNOEd/iE+1VjKEg==
X-Google-Smtp-Source: AGRyM1uzuD58Gvw8ldCGsMjEj9bif5uM5n1mI+w4DxkZrCSYFjIOptjgJbeQYnZve+HKVZa2FPRdFw==
X-Received: by 2002:a5d:6d0d:0:b0:218:45b1:ef1f with SMTP id e13-20020a5d6d0d000000b0021845b1ef1fmr3784547wrq.558.1655371372744;
        Thu, 16 Jun 2022 02:22:52 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 09/16] io_uring: limit the number of cancellation buckets
Date:   Thu, 16 Jun 2022 10:22:05 +0100
Message-Id: <b9620c8072ba61a2d50eba894b89bd93a94a9abd.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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

Don't allocate to many hash/cancellation buckets, there might be too
many, clamp it to 8 bits, or 256 * 64B = 16KB. We don't usually have too
many requests, and 256 buckets should be enough, especially since we
do hash search only in the cancellation path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d0242e5c8d0a..97113c71e881 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -254,12 +254,12 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
-	 * 32 entries per hash list if totally full and uniformly spread.
+	 * 32 entries per hash list if totally full and uniformly spread, but
+	 * don't keep too many buckets to not overconsume memory.
 	 */
-	hash_bits = ilog2(p->cq_entries);
-	hash_bits -= 5;
-	if (hash_bits <= 0)
-		hash_bits = 1;
+	hash_bits = ilog2(p->cq_entries) - 5;
+	hash_bits = clamp(hash_bits, 1, 8);
+
 	ctx->cancel_hash_bits = hash_bits;
 	ctx->cancel_hash =
 		kmalloc((1U << hash_bits) * sizeof(struct io_hash_bucket),
-- 
2.36.1

