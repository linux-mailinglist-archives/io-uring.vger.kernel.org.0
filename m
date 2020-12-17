Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FCC2DD407
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgLQPVu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 10:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLQPVt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 10:21:49 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB0BC0617B0
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:21:09 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id y5so27817603iow.5
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cs6bkt1kFG1/9er9WT09SLBBaLaQZeoTVJunyWgBesQ=;
        b=aGltlA8Z4kB8jiVesQp5J5R87dTkLKP0+7EGiE+4RqHX8Hy635cn9duA61F7dAWsNc
         ydAugIfBlbRWEG+7QUKXa/qp3WJhEq+kdaF1+AGnMLA8AB71GXlC1dovFUEVHEX1wyeo
         BbNUpH+ztY++zB185bff+0EwQrvXyQ58mb5DX/YGxj1quBDXVXFZm5sPii6v8BROohrn
         fTeSAzEf935DY4ZKhYwNrnbp2ZH1uyV1hDLD5axPEAcOBPZgFODflvBJyaRDwMqg39Vr
         0svLoglPt6+QJLLrih+BSyJGj9sKxxoEUNajwN3EqGtDmbbWU8ZJoRxDT+Kky/MOwjSI
         NfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cs6bkt1kFG1/9er9WT09SLBBaLaQZeoTVJunyWgBesQ=;
        b=csPbOoDvvcYjMEV69X/BEKQhUkF2P5/M0H4OI4iFnvi/diDo8DGBcEO1iowRWM44n9
         74CcgQqguro5wSomBrDzJBxrOtQ2vQ+eJYQp2U7J1t6F0Ksp1IPrApWUCaJo4vQyNaJC
         VqB7swV2tzKRHLsscq/Dz9GEhw1Nvr7kSTqHJtXla7Qc8n1HMUj6fKC3JVBh0/B2ABPt
         I7f+d753lsvF8tlOK+mV63VcfMMDoK4RGU232glFSsV93bytIq8l+a2G33zaTdBDwpN7
         Q+e/GF3ad/2XxtjKjeh5x7ZwiT55ovAsI0GG8o30iRaBjR4yhMYNA17/lpmo4A//gco3
         CIOA==
X-Gm-Message-State: AOAM531ZWiWbIQ7wmuqh53jOfVN1lF10coU4RO+qeK+YBDqmpbfDjqT/
        lCGnTJi3pSEJHkEoTx6mBr2Ee3yzqVdx6A==
X-Google-Smtp-Source: ABdhPJwlZAzxskm4QqpUOdM10vTZV5RzUnFv5HInrCBs9a+iR4VaWUY+WGJPGk4NJybGClyxgpuCdA==
X-Received: by 2002:a02:856d:: with SMTP id g100mr48426886jai.10.1608218468869;
        Thu, 17 Dec 2020 07:21:08 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l78sm3611793ild.30.2020.12.17.07.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 07:21:08 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: hold mmap_sem for mm->locked_vm manipulation
Date:   Thu, 17 Dec 2020 08:21:05 -0700
Message-Id: <20201217152105.693264-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217152105.693264-1-axboe@kernel.dk>
References: <20201217152105.693264-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The kernel doesn't seem to have clear rules around this, but various
spots are using the mmap_sem to serialize access to modifying the
locked_vm count. Play it safe and lock the mm for write when accounting
or unaccounting locked memory.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6a4560c9ed9a..2d07d35e7262 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8157,10 +8157,13 @@ static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
 		__io_unaccount_mem(ctx->user, nr_pages);
 
 	if (ctx->mm_account) {
-		if (acct == ACCT_LOCKED)
+		if (acct == ACCT_LOCKED) {
+			mmap_write_lock(ctx->mm_account);
 			ctx->mm_account->locked_vm -= nr_pages;
-		else if (acct == ACCT_PINNED)
+			mmap_write_unlock(ctx->mm_account);
+		}else if (acct == ACCT_PINNED) {
 			atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
+		}
 	}
 }
 
@@ -8176,10 +8179,13 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
 	}
 
 	if (ctx->mm_account) {
-		if (acct == ACCT_LOCKED)
+		if (acct == ACCT_LOCKED) {
+			mmap_write_lock(ctx->mm_account);
 			ctx->mm_account->locked_vm += nr_pages;
-		else if (acct == ACCT_PINNED)
+			mmap_write_unlock(ctx->mm_account);
+		} else if (acct == ACCT_PINNED) {
 			atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
+		}
 	}
 
 	return 0;
-- 
2.29.2

