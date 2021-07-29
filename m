Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04A03DA720
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbhG2PGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbhG2PGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:43 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5E2C061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:40 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so4264640wmb.5
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nOj0ZOjXomMEl56WqR/pgMaLuE0A23Xpam/dbXA/Sxo=;
        b=UTdhsxfuDjyQtZh8vy2Tdhmh6McpM1SHHxM2uaZt2SOIt2FWaPu/qA5uIHDy4AqJJI
         XboKLYIljunGmerq6KsrFQzww6yWmibDkRUqX0WzP/gIqf8IcQfehip4PKesmmoQnNw8
         uZXLVhp43GjPp2zFT/GsAkUZnLzCsg0ddx3bzDbT90DLRB6maRKiKoHDqISekcTazSf5
         9M3kTnx+LJdMC7/CYU6cWFlugnJpkTn2bUJMcDE3+k/HZr6cx6ztfN9PkKM37NmJRu9U
         lzxXbtQDLXEO84s2P5MWhf8QNEwM1IovlHp2FfB6BjhrJqqDjMahwbsm38Uji2JujH1k
         v+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nOj0ZOjXomMEl56WqR/pgMaLuE0A23Xpam/dbXA/Sxo=;
        b=QaFLuTniC95DfyipUOvWWvzSvSQBSkjyhFqMDI7lkTGUhNxxDP/09XNGjMU28k5UC/
         KX5D/jDC41o71PIc0KfDsgnGh8rGX7BwvMsGFu5mGCBRU9PNTL7Z0lsPy+NrRR8+t1sV
         qcqzQR4dHHvDcsOqCCnim2jt1XHHoyd7VW3C65n2xQnj2yfZ8WcPsPJXyI7UF9t8Wbqz
         RWa4nUZfs2qdvgMydsnipPJuWo9puVJrQmLUKD3Y91bPyQLBcRVsN4ZVkShg60yDC5cH
         uyeOQYhpnmuzRkLJ9LNM18x1FOt9amweyCMo5pJ+ehAPEYF2m4BExLxw1ECgktRLHYpx
         BkQA==
X-Gm-Message-State: AOAM532knvuydzG3uG+LmLJW1kGE2temrdvTUm5pXMeWN41TsFolNhB4
        wH0cPa9fS8FSWwU3AyM7ITk=
X-Google-Smtp-Source: ABdhPJwPFz4SBWDcyQOZ3HAsjT0Y6JDDQ1K6sk/UtE7aYejX3kvo/e9VhrpHg7XYB1vKmntN+MXmog==
X-Received: by 2002:a05:600c:2204:: with SMTP id z4mr5230897wml.164.1627571198690;
        Thu, 29 Jul 2021 08:06:38 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 18/23] io_uring: cache __io_free_req()'d requests
Date:   Thu, 29 Jul 2021 16:05:45 +0100
Message-Id: <1e18808b9681cf9a21454e5b83c33de670407177.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't kfree requests in __io_free_req() but put them back into the
internal request cache. That makes allocations more sustainable and will
be used for refcounting optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44d7df32848d..e690aec77543 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1826,11 +1826,16 @@ static void io_dismantle_req(struct io_kiocb *req)
 static void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
 
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
 
-	kmem_cache_free(req_cachep, req);
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	list_add(&req->compl.list, &ctx->locked_free_list);
+	ctx->locked_free_nr++;
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
 	percpu_ref_put(&ctx->refs);
 }
 
-- 
2.32.0

