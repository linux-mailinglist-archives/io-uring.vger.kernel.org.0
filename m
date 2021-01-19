Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BFF2FBA8F
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391689AbhASOyx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394358AbhASNhW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:37:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660D1C0613C1
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:36 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id a12so19735488wrv.8
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CvhMBY5n6MzbjzQZggjOitRDa/Jkpp7DkCAbk1lnDU4=;
        b=PVstwWPgZ+G8CSHdlncLBV+wNjajnc+SQ6vxstV9i8nabEsNJ0iXpSk52HYwtMvBPt
         VUNGvAabiaUloESjIcfKX0u8C0WffCio2p4rEHB+1L901AH5egEWqeXteK9nkNxnT7x1
         k6q33U6IV9+/tCqO3vktEHbD5urf9zWQ/H0ErBN776v33dsEN8OmhaBSxYU2LEwhIVqk
         P3DSilGZ7p0SQx4CpXHwuQhYPi9fd1p/EjIfLCDwin7nTgpkPZLnhPrn7bJh3Ogfi+di
         pkSWEK5PeUplORNN/nV9bOhUuTRZTO2qRU7bJ0klUtNd9gxhAwE/aix+O1+DLGuEFMUi
         J2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CvhMBY5n6MzbjzQZggjOitRDa/Jkpp7DkCAbk1lnDU4=;
        b=PIsdY974K+cluf5zb2WHaEyJyPf9zQi2nvx2BaHhqdmnLExy2LWfwMH4vdz+kXgkzz
         b43KARov0R1eZrjyY6eMoacAIQSdQ5iQOVLFZZs4o8jeJ2A/M5DAvye222lKf2gZTibx
         uSe7pbgzJI/G/ctRMe1RnRVwq33pBUhRpj/Bt9LA7OenV2TS9h074NvgVcyPz1MwdDNc
         TGtOlSiHZG62gdzcSmyEPNSs/1Sy5KLLjNwbYbP5MMy2uWlRVBZfaE/h8s9ds9pZ8Jfo
         iok/WkppCoizXH7KhlyhqjMJEf9DgVZsne9tN/fcVG6bb+kV3bJP3i4JcGs8d8+pC+5P
         h/Iw==
X-Gm-Message-State: AOAM533JF+Etk+GilqRp7CJziciphdOBwdYgECHTiIekIZe0qnRgYAF/
        HJ++mJFIuENYN0ihdyqSt1ujtvF8SOUqGQ==
X-Google-Smtp-Source: ABdhPJxx756nCE2wsmtTYhMKGmoH7DK/EEfwnPtTbsGIQBsHwPnti5Q4pAPiaAqHh/x8hydUakrM5g==
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr4565533wrd.118.1611063395247;
        Tue, 19 Jan 2021 05:36:35 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/14] io_uring: cleanup personalities under uring_lock
Date:   Tue, 19 Jan 2021 13:32:36 +0000
Message-Id: <60a599555d9de2af2fc10467d4b7bb547299b62f.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

personality_idr is usually synchronised by uring_lock, the exception
would be removing personalities in io_ring_ctx_wait_and_kill(), which
is legit as refs are killed by that point but still would be more
resilient to do it under the lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eb8bee704374..88786b649ade 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8749,6 +8749,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
+	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL, NULL);
@@ -8759,7 +8760,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 
 	/*
 	 * Do this upfront, so we won't have a grace period where the ring
-- 
2.24.0

