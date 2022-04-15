Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E803502B01
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354021AbiDONiI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 09:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354016AbiDONfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 09:35:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B8C673CC
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so8354802pjk.4
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CMfeq2y50ep3iWgYcSAIfpUtrAVsbY3v5bbfxzN6s+Y=;
        b=bnjU6z84y8rPth4BFSpl2jw3GvsBpM1xJ2NXWaTvW4Fs0319i815KSDVYKK1xvrqjo
         QyocYWR5Zbto7nWt20+0M8iZEwGUh5erY+VPlsGDZfN+bh4dUuIKBITJuAbW4RHj+lVG
         F8auWv0ZxUcNBiVojIBXXK2afqIJ0EGRSVf1dJku1jcquJjd6Sqip6FTanVgeQmqRolM
         FkIYYbSYMFptle3uMdxrZxgWmAPqd8JISSYIEzci8w8vaRON9k3sWm0AWgQ9tCAp1EJE
         HnxIPaivD8yXXWDsWO5zz6RpF2T0A1LkdyqonqJfBPqWKXX0qJxV5xMSYx1KjpmVF1zg
         tj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CMfeq2y50ep3iWgYcSAIfpUtrAVsbY3v5bbfxzN6s+Y=;
        b=QGVFW0uV2QXoof7v826bndd9ymNJIZu7Y639tvJ4Djzi+la8U3Nul83dajjJd8djlH
         FZaSpMmjl4KnS3eLh25ZfzPwJtYoWBe1S5ZIcd7xWK2+lAf1KOJcaHMWsL79UCALo2kC
         YQs8r9n8Q1a+lNzsyfRje4VLcbqEFw6cXFyT9R/zfYVD8nGHkigGQu6AOTultRFboYPT
         066z1shzkqY5P611WH7X17nqoHRZRH2R4fhLwVsnGb1/7OqKcJqHy0I/skRPIfbmBg80
         KStYMrNiCcTmJ4JOtLokwEEYsIEds8wxLKKmFhsTEHUAEKefnfSTdIHBiQ1iwln4s92u
         TqyA==
X-Gm-Message-State: AOAM531HFli8aCl0YoO8+UF2AxzcsIQeUpEMhqWNieV75MDQCVk+JntY
        CznFr9Ov9mSrrb0sKoGECe5HAr3Ej8y4lA==
X-Google-Smtp-Source: ABdhPJx5FNGE52gbMZ4jLeTnxdjvxOmeG+Ta0/KUTNCRBU6+Z/4n+5imV7s8XzXsc1EsCTTCxkDvgA==
X-Received: by 2002:a17:90a:e7c6:b0:1c7:443:3fdf with SMTP id kb6-20020a17090ae7c600b001c704433fdfmr4269514pjb.3.1650029603425;
        Fri, 15 Apr 2022 06:33:23 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n19-20020a635c53000000b0039dc2ea9876sm4576604pgm.49.2022.04.15.06.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 06:33:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: remove dead 'poll_only' argument to io_poll_cancel()
Date:   Fri, 15 Apr 2022 07:33:15 -0600
Message-Id: <20220415133319.75077-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415133319.75077-1-axboe@kernel.dk>
References: <20220415133319.75077-1-axboe@kernel.dk>
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

