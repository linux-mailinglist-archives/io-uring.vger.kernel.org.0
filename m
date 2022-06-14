Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CE354B378
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbiFNOiH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbiFNOiE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:04 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934EEB7F2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:01 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id u8so11544860wrm.13
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rLp+y2Cb7SGsOa4Obd9vWUi02TdIW1M+K1OPPdobolA=;
        b=Mn8Ky7Jy4loDj5LXl+qEPXExYO+fdvaUxAMaXVRKjDtsjtekmmgSLcZ8L9Shrxu816
         oUDrxnK6GhEWy1Q6691s2cbW21MmJLhispCkfYty+R++jDZ9NarZUXbdYDIynTdo9moc
         V4mTSB+JQLmWpOpnWFryk0pGlbop0gW1OeeGUWLvRalUivctYrd40i+PMaZ+7mfWdC33
         85bamVg34HD8m04I9GcbPjGfOcHIwx90dXGGCN2xdsUTc6DzbsH464xvbT/vrriCNKC2
         GQvWsFCndEDXskpXqAAzlrAOA83gmKkPaTw014+EIRslB4QDbJgbkZcICwZRVHMw2TzS
         HlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rLp+y2Cb7SGsOa4Obd9vWUi02TdIW1M+K1OPPdobolA=;
        b=rZNfQnhgOyFyTUd0jEdk7++f+40EUTXASpvKZLFwosSGFuTqPlOo5i6kZ7ICLDOnHQ
         O8drfAgoxbqf2yrPfxAbbRUXyuZHMJbeld7/WlQv3qCgBbpjip+Eu4BS9KaOQK80nmlP
         KpfJyHvTVWFrAtVcbJbec66tUkt3AB6UFrLgcy1oFXRUBznrTmOFDqn8HLr4zFlq6VAU
         OictliRgcV4BiraRyNpJfh+EMK1zOYIEo2ZOrlCPkGjhXricGzKzaaZBJTTFb6fI0+Z6
         IBYwwBKoYuNXESCE/ICsgQ/Xt3FJztWpaffzdRHjnI0Qu8LNs2cc2tSAEB/tKT0ymEYZ
         CL9w==
X-Gm-Message-State: AJIora+IxBBS5MBwv8pSzB6AeIiVdvKHn8tek6mAly5zrc1fckpETY5x
        4m8F/PjKd52dc5lbu+R5IJYvk4d+HR4eBQ==
X-Google-Smtp-Source: AGRyM1v77VP+8Peb3biaoWVo6lzSoqPJlKccOfowZVRMskAUw+z7U1tAnzJKUz4+GJeT5q69WcbtbA==
X-Received: by 2002:a5d:55ca:0:b0:211:4092:1c27 with SMTP id i10-20020a5d55ca000000b0021140921c27mr5405759wrw.108.1655217479849;
        Tue, 14 Jun 2022 07:37:59 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 18/25] io_uring: limit number hash buckets
Date:   Tue, 14 Jun 2022 15:37:08 +0100
Message-Id: <57a30f28ac6235d7913444ff3bee9bc5ce70f5d4.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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
index 4d94757e6e28..2a7a5db12a0e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -710,12 +710,12 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 
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

