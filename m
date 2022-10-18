Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66F6032BC
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 20:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiJRSsw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 14:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJRSsw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 14:48:52 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3746A2ABB;
        Tue, 18 Oct 2022 11:48:47 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z97so21858617ede.8;
        Tue, 18 Oct 2022 11:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5GqQPQo1EN7QTPOq98P7aatI+dm61orL9Tt4wQrx+M=;
        b=pQVhTRrUCNr5iWknH5+wZ6tovh3QucpIXrfLs3BqoUkMXX5cbjzVfBS4+FhSKAU7kq
         cbLGxN3Bx0WzENB/z0YXhLKrxTbiaU6y3EGLc4dz4KZPwiZY/rlP5h3oVf/AcYu6p4im
         Uajr6V1YveMZIlhVs7KtCulPeJ1rJBCD7wdRwIO1u1eC0xgL4XxuhTvGIfcIKELNVrEK
         IJNyEpEkRxTHUaQvOPxa8Ph4iwEytWtPfQ3DUXpFJY5B7HwhOCwUcv90rLkrnA2vtfvb
         6Bt2TpTEic8L7crNDFmNGPR05IsBB5YGLlxgADDBPHtDyekeYL9GkQocaKXTD1DycdU2
         Jqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5GqQPQo1EN7QTPOq98P7aatI+dm61orL9Tt4wQrx+M=;
        b=xumUHBiu28KJJ5JpV3gwShRxFZN9TzfE8V3czluST51kk2HpLdBMYRgwQrTvCH9rG8
         frgCzljnA5ZdufWbeIQL5W6LEDehp4FEu4RK2g54Q4dPhA7wnzVkLbXVZE974A7riIhx
         TJeh00y8YTL3xKCneYd+Pwpw21saaNarGb9s2lDvTCSWF9Emlq/YTp5UnrLoDy77Goft
         kKQWRjtZOwgjGM3XWM7CSAjtGYbCuzgc9vrJiiLxX3weT0f/yKGqwEOAazcBP46+OiKz
         abmgtXbpYq3HpfswzX57eWnGdPCbwUhCODvTov7huApCsYOi7awhoZG024MGCH41B5vY
         tQYA==
X-Gm-Message-State: ACrzQf2fvcrx58/X9R/fvFm8UnT3yhCuOItXY+aWTxE94ddCeO9g5Ijw
        XzNC+pyN3xT8q+WrgwG5XRE=
X-Google-Smtp-Source: AMsMyM4hCMBwizRT+tDQIvDOjWgarwgj+ZsFLHsRMaUJopOWfLq+XSgiU4G1Ahe/9J9GRUK/Ci0XaA==
X-Received: by 2002:aa7:d28c:0:b0:459:3cc5:3cb8 with SMTP id w12-20020aa7d28c000000b004593cc53cb8mr3997366edq.261.1666118925643;
        Tue, 18 Oct 2022 11:48:45 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id j18-20020a17090623f200b0078db18d7972sm7855355ejg.117.2022.10.18.11.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 11:48:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next 2/4] bio: split pcpu cache part of bio_put into a helper
Date:   Tue, 18 Oct 2022 19:47:14 +0100
Message-Id: <cd6df8c5289a2df20c338d0842172950b0dedef2.1666114003.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666114003.git.asml.silence@gmail.com>
References: <cover.1666114003.git.asml.silence@gmail.com>
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

Extract a helper out of bio_put for recycling into percpu caches.
It's a preparation patch without functional changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5b4594daa259..ac16cc154476 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -725,6 +725,28 @@ static void bio_alloc_cache_destroy(struct bio_set *bs)
 	bs->cache = NULL;
 }
 
+static inline void bio_put_percpu_cache(struct bio *bio)
+{
+	struct bio_alloc_cache *cache;
+
+	cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
+	bio_uninit(bio);
+
+	if ((bio->bi_opf & REQ_POLLED) && !WARN_ON_ONCE(in_interrupt())) {
+		bio->bi_next = cache->free_list;
+		cache->free_list = bio;
+		cache->nr++;
+	} else {
+		put_cpu();
+		bio_free(bio);
+		return;
+	}
+
+	if (cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
+		bio_alloc_cache_prune(cache, ALLOC_CACHE_SLACK);
+	put_cpu();
+}
+
 /**
  * bio_put - release a reference to a bio
  * @bio:   bio to release reference to
@@ -740,20 +762,10 @@ void bio_put(struct bio *bio)
 		if (!atomic_dec_and_test(&bio->__bi_cnt))
 			return;
 	}
-
-	if ((bio->bi_opf & REQ_ALLOC_CACHE) && !WARN_ON_ONCE(in_interrupt())) {
-		struct bio_alloc_cache *cache;
-
-		bio_uninit(bio);
-		cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
-		bio->bi_next = cache->free_list;
-		cache->free_list = bio;
-		if (++cache->nr > ALLOC_CACHE_MAX + ALLOC_CACHE_SLACK)
-			bio_alloc_cache_prune(cache, ALLOC_CACHE_SLACK);
-		put_cpu();
-	} else {
+	if (bio->bi_opf & REQ_ALLOC_CACHE)
+		bio_put_percpu_cache(bio);
+	else
 		bio_free(bio);
-	}
 }
 EXPORT_SYMBOL(bio_put);
 
-- 
2.38.0

