Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28C6334BD7
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhCJWoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhCJWo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:28 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFC3C061764
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:27 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so731506pjb.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y92Eg41gb0FkjtNQmx2EOWTDiaZhw1y3/05orE4wcr0=;
        b=wPCRsT0su4QdsmWxXub8Oq1LLkIXW/MRcOoyOF3DSWhtzvtvXNotGwHhdvfU3ws6d2
         +ee+yfrzvuWLab/aEFFsxXIIcw62FhcFpgG5jclcRoG6FJeUS2xyXD5krkSgbxPBWJja
         6bnP+qAEP3iH9/IDwkUR/eSbfFtsJygu+YV1VZBxiFYw1S9AfbyGiEGMQa23nUAZ35gS
         YLkTSHd/N6T7wD2mCaziDfw4t4OCyUxi3Q+gBOUQTjO1ZnbLxQLZiePeb3mQsS/m3xof
         KDbPpfSEWDRtWjSsrQfBvbd+Xn7P2LBV2VKeNsdcmLklVvDUTboRQ8Y0eiQA4Un+ff8V
         sWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y92Eg41gb0FkjtNQmx2EOWTDiaZhw1y3/05orE4wcr0=;
        b=MYHo6Xitip3yw4xLWaYn2LRZ7weOi1uJwXPZge3iGECaHkUrQcx+3n5leUP6mu6LI8
         SaW/ufojmsYw8Ua6QLywWmL/NOAJRG1shG/t3OoS4RVAYwd5N44VPvk18N/Bjc1xlG/y
         7AnHbWdNgun5YMGNxancxCU+1cC0GQVlRggpn3Rh64ciU+a3B4zfOvKQ+r1R7DbRRNk7
         aXC+eOU+sc0Xi1b6VGn0GgxSxPNv5BF5UwMQXM1gzIp5jEkIr/0pqZRgryJwDziKPkdY
         V8J81aeRt6q4C/sJ8vSi4KsGhYTEO97teQd2KVcyeIzuv/OQvXqzQ5OntCVfMrUHIYdG
         W0eQ==
X-Gm-Message-State: AOAM531+gLbQb4GlxgJYkpEhai9e9OAWEq6nqT7IdG5UbtXIeQ+YTlsX
        HxbUlJZz/+U9pUx8rqZVRwBxoB1+RFVGaA==
X-Google-Smtp-Source: ABdhPJzsrpdKonmw5dzE6IkkUHz3PE2gRaeiEiiCF3egMiaXXdvEx3Z/ojhz90WgGKGyv4pYzo7j/A==
X-Received: by 2002:a17:90a:d184:: with SMTP id fu4mr3466757pjb.236.1615416267266;
        Wed, 10 Mar 2021 14:44:27 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 23/27] io_uring: remove unneeded variable 'ret'
Date:   Wed, 10 Mar 2021 15:43:54 -0700
Message-Id: <20210310224358.1494503-24-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

Fix the following coccicheck warning:
./fs/io_uring.c:8984:5-8: Unneeded variable: "ret". Return "0" on line
8998

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Link: https://lore.kernel.org/r/1615271441-33649-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0f18e4a7bd08..6325f32ef6a3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9022,7 +9022,6 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 
 static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 {
-	int ret = 0;
 	DEFINE_WAIT(wait);
 
 	do {
@@ -9036,7 +9035,7 @@ static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	} while (!signal_pending(current));
 
 	finish_wait(&ctx->sqo_sq_wait, &wait);
-	return ret;
+	return 0;
 }
 
 static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
-- 
2.30.2

