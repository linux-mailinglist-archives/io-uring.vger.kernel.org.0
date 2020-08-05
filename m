Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A57523CECD
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 21:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgHETFY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Aug 2020 15:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbgHETEe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Aug 2020 15:04:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F60C0617A2
        for <io-uring@vger.kernel.org>; Wed,  5 Aug 2020 12:04:33 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f9so4908989pju.4
        for <io-uring@vger.kernel.org>; Wed, 05 Aug 2020 12:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m5JfTfv7DLYCIDpNvp8o9HfHiYwqyqYFWT7DHpiv3JM=;
        b=sareqeCva7CeLUMclEd625oir6TCytQ2Pu1FM3DipfUwPKyR8TiVCE7D06IEdUwAln
         Vj2QWdv9kU5ICqVXgY7G70cpy9gOnqEz6WbUfQF9iSl7GAsNA6xbArwPa37rFLxLIOX7
         /r7iB8jwyz8+eNMmXANkVBvghmV1R3i6nuEm2pTpMIH9V0ao/zT/L+G6bJ0ku0HYszS7
         qmk/EXpEF/xOOQfDvx1+1qq/P/Ot3nCtMUVtEzpMLCMegMlmYZhcc6/KdZA8pWhtZ8II
         CGE7envWHaSENi5hlNUxV1Z2epGhX/Kw4fDz4Q7KVH6++jVhBudQFKzb4c8SLgZTHOGX
         P9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m5JfTfv7DLYCIDpNvp8o9HfHiYwqyqYFWT7DHpiv3JM=;
        b=UdZM7z/N7ePnpqz2sXmGSpvBqeeJ4kAxtV2/CpMhtm9hOd8fQshLDvPvXeCUzEyZ5u
         xnArwLIyCFdFWT6UM0XRQKtXzj2NnByeFFZ7Ej2tJ/rAZuxWIGUTyeKw6vzLxNjczWXN
         qpHBj63EER+Uov7HMhAageVemPJf5ZyQb2oBi9PeMtTCPr5KSYtBAAkhY2xYRPrbGyry
         LvCcHmc2dt+G9WKLZqHZajVcBZbgbnKaNEOd7Ajq0Ww35DDEppBp++hSPfm45C/jJvTE
         0WLhU2URp4gMxsxjlF3OyWb4xTdeqd7ND0GzZ8OZ5UscLa5q0u50HQKWttNLKAoeBoum
         VJ/A==
X-Gm-Message-State: AOAM531/9u8Q+2VwYFr3tRCdTqU1FMr2OE9+xx5GCzWNmHytEvre4W9v
        JYOAt3F6NQIuHICRb3R75SzCAtXzsv0=
X-Google-Smtp-Source: ABdhPJy3mCL9czObm3wVYIbJ2GVTfH/OkNWdffQvxTT/NSVbJ0nfO82oNrsXomUi/XbfPUiPj3hxvQ==
X-Received: by 2002:a17:90a:9f98:: with SMTP id o24mr4328501pjp.221.1596654269971;
        Wed, 05 Aug 2020 12:04:29 -0700 (PDT)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b15sm4071881pgk.14.2020.08.05.12.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 12:04:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: account locked memory before potential error case
Date:   Wed,  5 Aug 2020 13:02:24 -0600
Message-Id: <20200805190224.401962-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805190224.401962-1-axboe@kernel.dk>
References: <20200805190224.401962-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The tear down path will always unaccount the memory, so ensure that we
have accounted it before hitting any of them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d857f7ca507..7c42f63fbb0a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8341,6 +8341,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 
+	/*
+	 * Account memory _before_ installing the file descriptor. Once
+	 * the descriptor is installed, it can get closed at any time.
+	 */
+	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
+		       ACCT_LOCKED);
+	ctx->limit_mem = limit_mem;
+
 	ret = io_allocate_scq_urings(ctx, p);
 	if (ret)
 		goto err;
@@ -8377,14 +8385,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
-	/*
-	 * Account memory _before_ installing the file descriptor. Once
-	 * the descriptor is installed, it can get closed at any time.
-	 */
-	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
-		       ACCT_LOCKED);
-	ctx->limit_mem = limit_mem;
-
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
-- 
2.28.0

