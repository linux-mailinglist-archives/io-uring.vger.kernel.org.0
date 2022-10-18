Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B8260337F
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJRTwk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 15:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJRTwj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:52:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38B18768D;
        Tue, 18 Oct 2022 12:52:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a26so34605046ejc.4;
        Tue, 18 Oct 2022 12:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5GqQPQo1EN7QTPOq98P7aatI+dm61orL9Tt4wQrx+M=;
        b=DxrIRWF3IlLy7RscwISMjCOi24P2yJVMt2Xc0TV752F4rLMsC93h2W5TYQdYGCt1MR
         jyRwSmKys8FRe2BXkY4D59joFsHthbLLe3FDyZQJZVDmwj+4W94mZQK1U5BNwQSTdfD1
         T7QvSss0PnHop/E92i5X+3vitwOD+/dhuz3LihI7I7SrO0yU32x5JKCDAqLAOPDpsJxt
         /DFqOVPve/MX8cq5RftjsGcfxNArnWahhuxRbxc16R4CMgF4jEOBAn81HVQKTW8rveeq
         x/maZeaY21ZPPxj+fw2xBewgJBEtwCF5TT3xLCSPbu+xL0heQuU40uzlWt2TJUKUHLK6
         NrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5GqQPQo1EN7QTPOq98P7aatI+dm61orL9Tt4wQrx+M=;
        b=1ez2zHwpPx4yyMSrHFENL7zkBDqYN3NG/TIA9Few8ZyEcprPYdBm1JRGMVkqxr0vyz
         NXpf/LX4CHJj4BWnC984Tjx9pk8MDuQeKpxQR9Wc86eHOMTv/HPKgJRudW85wBf3NG0s
         lHGh9gQ6owpBqBPklnuAldh1IKFVhyr8CneVOk15PTGgZ3g508ubaiJPLFF5bsVQDZ9Z
         N3UHicVAA1WO7URpF0CdmnpGFZgD/tpa3H/Rh7QFaafBJryFrGBnOWRBS2FiEO00kO39
         YEFWJ8Lb3V2Cuf6h12Wpy7mAY5BBOfsV5YUX7fabCMke0F2lV9h7Ua7Pu3YSdkbm6zjV
         1g7A==
X-Gm-Message-State: ACrzQf2gwCilgAEeSWDZim++TCYu2G1HaLWj2cUWbakk4MUc8JCjyknI
        fP7YZFxX+g+0wigUi2/8LKc+Eoe4Gwk=
X-Google-Smtp-Source: AMsMyM4zsLcwKui+DBi3RWrqYY07/MzotigsDhvrl8qX0g3qPewyVvoTQ9L5Cr+i/o0koesR1xQMRw==
X-Received: by 2002:a17:907:6e9e:b0:78e:214b:e3c2 with SMTP id sh30-20020a1709076e9e00b0078e214be3c2mr3709856ejc.15.1666122726606;
        Tue, 18 Oct 2022 12:52:06 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id r1-20020a1709061ba100b0072a881b21d8sm7945858ejg.119.2022.10.18.12.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 12:52:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next v2 2/4] bio: split pcpu cache part of bio_put into a helper
Date:   Tue, 18 Oct 2022 20:50:56 +0100
Message-Id: <cd6df8c5289a2df20c338d0842172950b0dedef2.1666122465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666122465.git.asml.silence@gmail.com>
References: <cover.1666122465.git.asml.silence@gmail.com>
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

