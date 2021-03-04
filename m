Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC9A32C9A1
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbhCDBKU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448902AbhCDAfr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:35:47 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEE4C05BD40
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:43 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id l2so17665038pgb.1
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I76jQgWol6WzOR1N50doeoSued4dF/z7Axlusf7kfvM=;
        b=Lb0j/JU8ZBceG/msMm2bV4EzxSLF0ABGFgdLikVBPxV5FtBYwjkKGq9YFBSDmzAW2G
         EfrFpKlKuGkCEcULt1Y5DDb8SV5QndkEYSZddtaVT70TjiCLhPeN/8rVDT14CiWdePyK
         A99wG7iBgf8QrmKOQQicTwM9pKyNsirRyqUMwjlb1gKWSzEAuPZBG9k7QF1DP3ZNXPet
         q8+FhEUwx5AzsA4iDL3ES76BQhn+70PP+KVVBH4628JA10rVt3VtxkOJ9Vv+GDG4utPe
         Ygzu/B2I/AYVLvyy8yav46siVoB7K4KxpCMQPtqM11ph0IiVCLlwDjfu+rY4VINOoxPP
         6gtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I76jQgWol6WzOR1N50doeoSued4dF/z7Axlusf7kfvM=;
        b=qTGqkJNuF+cSZ2S1Wh17IlG3LCPKMpk8IGg/kTppEV0anCwdf+/HrVRhCbUPyCw4/E
         oDRWc/7Bal5iR8uYXBAyjeyAVO3Q5XlH1MOHY+nQXWVbrazL4YQnc4D3FDHyoJ+Fu0Ki
         83LaS73QI40yqz5PcgPVUGaomGv/pMxPimwj829OTxblszVWAlXcfqHQSa2TiWnyterl
         4QgS0RFynaz5IlbFLhuvviCmlccXHtQ4gniPKZqvjaHSvlCKM2Q3T0Wxjo895fYP9UYR
         RXR3P9jubvg23TgvtFjZHUcim0HjHRzDEE6EUIIXcEI9OJHVxaHD8sWiMow7wRnf2Lqq
         OnbQ==
X-Gm-Message-State: AOAM531zzpHf904oElFxa4pFuMwl7PwH6fl7MNDOvQHnwA6wzN/WmZG3
        UZcLZU4h9YdAzftJ6hO4MbSJUiKyVJOaaTkD
X-Google-Smtp-Source: ABdhPJyFW150lbsGf727RtAm+fRcIDz2ZC2uUr1t5o5PXHFDP7xVG4E7V+MdD5gFv5vKHygUJcio3A==
X-Received: by 2002:a62:2:0:b029:1ed:6304:17d7 with SMTP id 2-20020a6200020000b02901ed630417d7mr1560345pfa.58.1614817662678;
        Wed, 03 Mar 2021 16:27:42 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 31/33] io_uring: remove extra in_idle wake up
Date:   Wed,  3 Mar 2021 17:26:58 -0700
Message-Id: <20210304002700.374417-32-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

io_dismantle_req() is always followed by io_put_task(), which already do
proper in_idle wake ups, so we can skip waking the owner task in
io_dismantle_req(). The rules are simpler now, do io_put_task() shortly
after ending a request, and it will be fine.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7ae413736c04..d9161b181a21 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1649,18 +1649,16 @@ static void io_dismantle_req(struct io_kiocb *req)
 
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
-		struct io_uring_task *tctx = req->task->io_uring;
 		unsigned long flags;
 
 		spin_lock_irqsave(&ctx->inflight_lock, flags);
 		list_del(&req->inflight_entry);
 		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 		req->flags &= ~REQ_F_INFLIGHT;
-		if (atomic_read(&tctx->in_idle))
-			wake_up(&tctx->wait);
 	}
 }
 
+/* must to be called somewhat shortly after putting a request */
 static inline void io_put_task(struct task_struct *task, int nr)
 {
 	struct io_uring_task *tctx = task->io_uring;
-- 
2.30.1

