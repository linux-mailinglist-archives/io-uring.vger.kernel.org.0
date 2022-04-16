Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81BC50336A
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 07:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiDPA2j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 20:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiDPA2i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 20:28:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22A3CEE30
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:05 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so12858795pjb.4
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CMfeq2y50ep3iWgYcSAIfpUtrAVsbY3v5bbfxzN6s+Y=;
        b=1hsqMEm1UzCd52wjYjUUnKHVBVux/ecRX6ftwb8GgWD4+jAHU5Vs7tNo8zrpijQ9lz
         34ZFHTCiRPflgft8bls82P/wzJR7VTbjkrOADyKrDmXov/kKRb13N9ipO8iFGpzrd4xB
         FA5OmvQejGReWTcrT6AjCogE9xlLFM6GHk8gMNmwhEIsjEC1lQKvW63JLV3SJLDjPSSE
         bf6YoOR/pK9WSgBhqR/HhJiFHk8j+NUdoYVaGcbVxk0AC9jwUA2KRYCElVQXa2Foql1D
         UQPB9TYZToklCnmak2WxReVt4+szrczCsWxK7/f3V9exEmHrVq6c3jar5FpVzN6q/SeE
         puMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CMfeq2y50ep3iWgYcSAIfpUtrAVsbY3v5bbfxzN6s+Y=;
        b=mFk8tvRROAmK/GyORfnHSeCONmE8q12Wj/MmwtBQV+T22ePeoXbLMYH+mfURjznuoq
         ILUEMNenBFlVNHAVsHqtTIzSoc/2znCMGfvRMfEONfaVF+JEpJnKipzD9IlNiuWr6mcT
         +uGb1YOkiBMy6QedFmbdau66Pfz+P0jiOthtTg/3/iPFQ0+yt8Vz7seGv7kryrj1LVHS
         vWONJcDwqyXoW36DUOwtQK2fOxgdq1CJY1jv1E/Ld2wC9IpeXMgGviohvwlapDCJ5u2T
         NYAoTLP3O02rJcM665u7Br1PzI0vz9trrF6sBVBxz4TMM7bOo8qbgcSuPT/r833lyvae
         7z8g==
X-Gm-Message-State: AOAM5303gmxVfGxeA5CEkqUtA3YTb9mw2Q/58ekMlG6ve9RcDb02UJU8
        bjByx3iM+r1KUQLJRo/Gk7ssmiaRDBPqNw==
X-Google-Smtp-Source: ABdhPJz99aZlmGIj8OVwE3Gcwc/c9TJJ2a4Q4FSW90GFzdWFSmWS2COLKg63W1UYgaAQW6DLRPoBQQ==
X-Received: by 2002:a17:903:246:b0:153:87f0:a93e with SMTP id j6-20020a170903024600b0015387f0a93emr1472295plh.171.1650068764700;
        Fri, 15 Apr 2022 17:26:04 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78d54000000b004fac74c83b3sm3895375pfe.186.2022.04.15.17.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:26:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: remove dead 'poll_only' argument to io_poll_cancel()
Date:   Fri, 15 Apr 2022 18:25:58 -0600
Message-Id: <20220416002601.360026-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220416002601.360026-1-axboe@kernel.dk>
References: <20220416002601.360026-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's only called from one location, and it always passes in 'false'.
Kill the argument, and just pass in 'false' to io_poll_find().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d3fc0c5b4e82..878d30a31606 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6316,11 +6316,10 @@ static bool io_poll_disarm(struct io_kiocb *req)
 	return true;
 }
 
-static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr,
-			  bool poll_only)
+static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, poll_only);
+	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, false);
 
 	if (!req)
 		return -ENOENT;
@@ -6808,7 +6807,7 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 		return 0;
 
 	spin_lock(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, sqe_addr, false);
+	ret = io_poll_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto out;
 
-- 
2.35.1

