Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC66438350
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhJWLQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhJWLQo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:44 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25073C061767
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:15 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o20so3706738wro.3
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlsu21lpKzG0BU+KtWA0DDJFq+T4ppafvulCOhoJ5j4=;
        b=ay4DzWSKwu/Uzmb5MLdQHp6EvA1JBhoLoIgjCigIBdDa5jCagCwXOPfKuwyjQ6MCpX
         U1Oz9y3IZqw+LRt4mIgop5wYiv2nDuZUABZkchMsyI8bYFoSEM0wr23B4biBid5eGKq0
         7bfPeW5VkWYLqq5es+MxrC4efCOTFCfL7aKsCcCxYbjISUVLKUIOJWZEtnJn8fz3g8p5
         byui2+PKB6aoZyRSQuCYFSkjm7Lf31X+DHCqrkyXRxknKtV5/4vXcTMZkNHMoXYdKjGu
         FHa7XHR9KA6MF8Qhsq72ah4lo269s8LUclk5+KOkIEiS7ES7YrYk4dcdvFPQskJ+xstr
         yxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlsu21lpKzG0BU+KtWA0DDJFq+T4ppafvulCOhoJ5j4=;
        b=blZSq5XAt+Oq830T8vjHnbJJ9VtpS0zCpN+91D/pkc5xzRnkd96zn3B6Llmx4297os
         jwyV4kHgKWHeelL1e2kbVqYAHd8NrSNI4TQqeTRhs1njd6zhqDdHEdBwguUBXotM+lsd
         2cqf8KfJwdO8ri1pKhZ6haXAH6MnAm8DeYLxiCHfdeXliMyw+rGwf1lEDO/G91L4W/dH
         yDXWFRibD6b/Fb3pzGkTbsZ8YDYkv4KLKJzRaL/4I5T7Eq+Wa3sZapvWCiK1R2S+s9mF
         YlvqL2RmwtQLxq0+vtcQwJjTx0DYic5QvFLOqZLRAy/RrnEs5qZ25fF6X5r00ARX8ciF
         hc4g==
X-Gm-Message-State: AOAM530epskxnURGWLZvcUnw/A8Rznd8mTAUYWDvq6xLCdZKIGx8lAH1
        NurRRSBw2u0vJnN88pQssgBjDYmxuto=
X-Google-Smtp-Source: ABdhPJyDEt11HSzSWCA3OGs5TBhuX7ycGqKTEgVytmY2/Y4ugyFwWsMLwBuFiplJxIFai9ri6uyWxg==
X-Received: by 2002:a5d:4845:: with SMTP id n5mr6845879wrs.251.1634987654181;
        Sat, 23 Oct 2021 04:14:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6/8] io_uring: clean up timeout async_data allocation
Date:   Sat, 23 Oct 2021 12:14:00 +0100
Message-Id: <75a28ca7dbcc5af8b6cd9092819e8384c24dedd4.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

opcode prep functions are one of the first things that are called, we
can't have ->async_data allocated at this point and it's certainly a
bug. Reflect this assumption in io_timeout_prep() and add a WARN_ONCE
just in case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c6f32fcf387b..e775529a36d8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6113,7 +6113,9 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(off && !req->ctx->off_timeout_used))
 		req->ctx->off_timeout_used = true;
 
-	if (!req_has_async_data(req) && io_alloc_async_data(req))
+	if (WARN_ON_ONCE(req_has_async_data(req)))
+		return -EFAULT;
+	if (io_alloc_async_data(req))
 		return -ENOMEM;
 
 	data = req->async_data;
-- 
2.33.1

