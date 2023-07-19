Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844D3759F0A
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 21:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjGSTya (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 15:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjGSTya (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 15:54:30 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D709F1FD7
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 12:54:27 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-34637e55d9dso134535ab.1
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 12:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689796466; x=1690401266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giarwnzcCaT/PBvps45FEOjjLZagrA/AJXIKNe98qXk=;
        b=eksc0EVn1J7E9i2FEHXrZSmg9JRoO+qtoe8f9+uIhNMqDFZiYOx1oRbck3k8Elvw8l
         lVfKAeju+yS+rGI67gQI27KgveS4qQZ3OG18L1MeD043TMBKI87nLpqa8QX8VgKILRYA
         yd8dGS1bnVZir0jayDAP9fYUKf3Wj0Mj29dpGbYiWfqMNENj0338HyGKqod4WZJJoAyU
         6k3G1TaLzHLZ7o/WsTFxuY2/hCmKs7afLqrsp1yqcwT2+cszT7SUNhFr4GjeJnJtXkEH
         3ZysLsIWOVOW45NlVm65bQn3M75oJ17oIDFD8daifdZb0pfPkjnO159lHDsiDqsJUAE6
         NNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796466; x=1690401266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=giarwnzcCaT/PBvps45FEOjjLZagrA/AJXIKNe98qXk=;
        b=dnJT77Hpse+iU36QQgV9E0sWeyL39cbKw8SSi7zqJnBatnClCj3jH+h+/56iW/0Tco
         EMxT2aegVhmVzGplrg2oZEg/dKLaqOz2haqKUcapYIDfdzr+4wU+ePUgJEeDiTzp9RuG
         XcyKpz6gmifMeKpNnsv7AP31e0bzQ3OJPmAQXF47yKB97lQUv8SNJaW1C1+6beiMaILB
         Ap2EeMgZRdwN+6VtpnL+8s4Qh+jclIFX6zAdAyzDpYnZ7nF+qHyWtIJB+lmEN91yAieA
         bccYNbfQdtAHZXu9Azs9re/RmYs9z4uAD7PQa2ilScSgl8kk3j/1vzVSLU0P2KWwU5d4
         j62Q==
X-Gm-Message-State: ABy/qLYJs6EeVy09xhEqzwWBjiBomeVivmfzsCQF3aOeCnBcqe54k3jl
        ftG+lYziojTgfsG/+/X9GV8VQDGRcbzyOn/lwUA=
X-Google-Smtp-Source: APBJJlGAukebKX7XN84+x+/Sd6SfjBNgKmNb3bQZ5eAU4XvDWiN/z7PSkEMd6iAlarxUJBBPh0asUg==
X-Received: by 2002:a92:c243:0:b0:346:1919:7cb1 with SMTP id k3-20020a92c243000000b0034619197cb1mr9293424ilo.2.1689796466653;
        Wed, 19 Jul 2023 12:54:26 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j21-20020a02a695000000b0042bb13cb80fsm1471893jam.120.2023.07.19.12.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 12:54:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] iomap: treat a write through cache the same as FUA
Date:   Wed, 19 Jul 2023 13:54:14 -0600
Message-Id: <20230719195417.1704513-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719195417.1704513-1-axboe@kernel.dk>
References: <20230719195417.1704513-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Whether we have a write back cache and are using FUA or don't have
a write back cache at all is the same situation. Treat them the same.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 6b302bf8790b..b30c3edf2ef3 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -280,7 +280,8 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		 * cache flushes on IO completion.
 		 */
 		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
-		    (dio->flags & IOMAP_DIO_WRITE_FUA) && bdev_fua(iomap->bdev))
+		    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
+		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
 			use_fua = true;
 	}
 
-- 
2.40.1

