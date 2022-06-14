Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3348D54B39F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238292AbiFNOiI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238373AbiFNOiE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:04 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B2213F93
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v14so11585026wra.5
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+JMB8B8dyekj9aNFFK4S1oUXrhmLvJwYZDZItF2JzC0=;
        b=o/O0wxEjafZhVmdyI5WhEC5iiOYANkX/lwYHXJLzHIYWLr8nS1ZxA0DOiSPXDJ2xFF
         tVV6B/CKcfOTjmNrXOyJl1Y7VNOKlgVwTvSaZGh7UgxHdG+jvGopSbZ7MWKglLErqbLU
         CEd7Q0q0hjOUjPfrDJlpoizzj4ZlN7kNCEDLQbgtJtObn88haEYC5zykGmfuINo1lCeG
         +lMUhjj0AS8v0Jqf+7pN7VeUpleyWuFBxnLJQtUb8VtK0XRtn1AN3Br8UqDTzq5krb/M
         j+gkNghe97N06Gz9RSI4sXjDuqSA4GxRKilWd4ro0hmh03dwuYw8ZI75QQL2qPXTkfub
         gWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+JMB8B8dyekj9aNFFK4S1oUXrhmLvJwYZDZItF2JzC0=;
        b=FCMEXzwL2pHdij82+fO63+yvVB2rbNRI4nKnnRKX06NX+60sdc8Hjzw6vnli4bWXQU
         4Wbq7iPeqULIiZ4ImjXVjVe2uaBrJp2tV//2mBAJnTJUhCVm7vR4kKyzkKNma90kAxB6
         JNJxBp04+mQ1wxOlMXBlshXZ7zoUJyRJtcUkbwlkjD9vZYEtnuk9XvQLprEeAdfuuh+2
         xuimV/B7/D7M8chCCv1ZG+S2KT8mU68KATPPVuuP8FURbtmwGHA8iMyxAMT7npfHGr6x
         IHwFO5VodGFE2LH08NoFyN49ehaClotwZc+3OXTJZKQWPzhdQeqq0ClWx8mKuwqHvdQS
         BA5w==
X-Gm-Message-State: AJIora8dm3D14gM90Iy+ThotoRh4M5UfxWaSArP6oyZhB3f3s02lKrdu
        2WJGJLFP7YWN7Zehk/gwRAgL8lvA/D7c2Q==
X-Google-Smtp-Source: AGRyM1t1Bj9dvHJljkNYYB3dDa5qljmKTk1Y75gxCw9grpD0wEqvaloJkXp+bBVbHoW9P+R6TToe3A==
X-Received: by 2002:adf:fd0a:0:b0:219:ea8d:c09e with SMTP id e10-20020adffd0a000000b00219ea8dc09emr5173395wrr.13.1655217481028;
        Tue, 14 Jun 2022 07:38:01 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:38:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 19/25] io_uring: clean up io_ring_ctx_alloc
Date:   Tue, 14 Jun 2022 15:37:09 +0100
Message-Id: <3d6a3659fcb7d777530b5cc67aac3e036a212dda.1655213915.git.asml.silence@gmail.com>
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

Add a variable for the number of hash buckets in io_ring_ctx_alloc(),
makes it more readable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2a7a5db12a0e..15d209f334eb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -700,6 +700,8 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
+	unsigned hash_buckets;
+	size_t hash_size;
 	int hash_bits;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -715,15 +717,15 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	 */
 	hash_bits = ilog2(p->cq_entries) - 5;
 	hash_bits = clamp(hash_bits, 1, 8);
+	hash_buckets = 1U << hash_bits;
+	hash_size = hash_buckets * sizeof(struct io_hash_bucket);
 
 	ctx->cancel_hash_bits = hash_bits;
-	ctx->cancel_hash =
-		kmalloc((1U << hash_bits) * sizeof(struct io_hash_bucket),
-			GFP_KERNEL);
+	ctx->cancel_hash = kmalloc(hash_size, GFP_KERNEL);
 	if (!ctx->cancel_hash)
 		goto err;
 
-	init_hash_table(ctx->cancel_hash, 1U << hash_bits);
+	init_hash_table(ctx->cancel_hash, hash_buckets);
 
 	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
 	if (!ctx->dummy_ubuf)
-- 
2.36.1

