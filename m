Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15648607515
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJUKg0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 06:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJUKgY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 06:36:24 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F71245E9F;
        Fri, 21 Oct 2022 03:36:17 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a14so1331458wru.5;
        Fri, 21 Oct 2022 03:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=erLTlmyi83dM0fdrryvYn9BtXwohwFqw9KpHLk/mAwk=;
        b=GV/LMIDHpWiYWvuunCnNMCfMciupdhaB5W5535rM/tXU0gpxVIvM+yzcu3C9SR1/Fx
         D8VmDEZeN9TzxytOkxU8Kco6zYiEbxeUK+jFfP8jBaXEKdNSJG596vY6ufysfC76/C6d
         1BtLT5SC70uCaSMgXnra6nsp43gD6HXiIeaek2Xig9VTryLdFsZGRV5LhRBjILmtt03H
         0yRmvaYyyxagUklmTYxuIByuAympM67kQ8x9bMkcgi3OCzGqVv+mEh79UYyQCIj25jtM
         Di6Oiz5wr0IlNj0B9/L23ruHDVRX///hOp1G6Xyj26gUMP7z2Z7q4eZ+1f6yA2U4dt1H
         QD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=erLTlmyi83dM0fdrryvYn9BtXwohwFqw9KpHLk/mAwk=;
        b=FPsJdRAP41XhIigGFN5D4RNaLeBQLSUG4znMl2QYtQ+s1lZspH/mYqvmVESmcnh2gW
         n5p0c9/BvqobdjPETBSEAChRdOmyAz99qk0GrgrOE/TtTTPAIfrD8bwfoouFQzCF+JJ6
         oGLmrZmj/jZJyKiG1KwESV0w8qSLYaPtxjVYrAj4Z33CtD8SYwWudpzdu7O3dFD692OP
         rgtGTAUuQnbwJRC4KTE9yz5o9FbcdtdTcq0euc1JdRtF6/UxFoEBsGYxWh7RWX24Qf6Y
         9M31ED4k0NQOArZHma9tSNTrSpVRdcnzfd7VpvQrAi8iBOFOs8cwQ5Mcyf/begSaSZd8
         utyA==
X-Gm-Message-State: ACrzQf2pZSFNgoTFbwMw+cohudUv3FeLyQBXoo9iFdE2X0YI/yfP1N9a
        wfw3IaeOSKqQWJEKVlgXD7c=
X-Google-Smtp-Source: AMsMyM6IZwIxhNDxvaK8eVMfkZvkdycOYUwNTkS1F/+DSZalqlMTnpEZBhtwQWQFdTwFz8BqF01EqQ==
X-Received: by 2002:a05:6000:184e:b0:22e:4649:b3c9 with SMTP id c14-20020a056000184e00b0022e4649b3c9mr12323125wri.671.1666348575442;
        Fri, 21 Oct 2022 03:36:15 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d65ce000000b0022abcc1e3cesm18544759wrw.116.2022.10.21.03.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:36:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next v3 1/3] bio: split pcpu cache part of bio_put into a helper
Date:   Fri, 21 Oct 2022 11:34:05 +0100
Message-Id: <5cbfcc454cd9ecda250332b393f282d5742ba987.1666347703.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666347703.git.asml.silence@gmail.com>
References: <cover.1666347703.git.asml.silence@gmail.com>
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
index 0a14af923738..7a573e0f5f52 100644
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

