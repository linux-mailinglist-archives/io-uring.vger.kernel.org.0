Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35D22249D8
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 10:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgGRIdU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 04:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgGRIdU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 04:33:20 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE980C0619D2
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 01:33:19 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id k17so7318896lfg.3
        for <io-uring@vger.kernel.org>; Sat, 18 Jul 2020 01:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Zfe+X7AF6+cipJ2294fn9B4pq12SDZvu0VK7tklpDtg=;
        b=rr49fokQQCMFhuOzQx/qyognbq2bttcKVuzuny4ciGYPFes1E+XgSWsjF0CF6Ub4I0
         1xuJS7gpmO+IikV3NhipnWIXKNLcCOzfMJl4+RA8vH8qLIkmdjf736cA/mMWKWhBvX1P
         Lqy60lAkgoicwpq2l5Ykn3muo+xAAUwNu/YIjSMaHVYLbP1A8PLNQ6/O7EJsYIgSA6Ck
         VMPkkX6QHVud3Vh8PVvfWIeNxf5Fjv346OFCL6kGg1cfKdMg6hrYTmncQwRElUIZUcZ9
         jD4EoEX8HKqKuzXgNy8sPyGGp4Or1IryM4wHYWmViVauNXLVUT19tlsZckZ0sa6JfMS/
         JZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zfe+X7AF6+cipJ2294fn9B4pq12SDZvu0VK7tklpDtg=;
        b=rjJ2sXceI3lsxsxSCZ5PzFmkYOfoM2kn5+4XvEDXSr04e7IncgkwKutxJ2kEX8ZA6O
         4zEI3hQL8rCU2/4+fQ2FERp71bELV38HX+peraYWgpdiqB/iJFvSZMHSmHdWVSknvXCV
         H+R30Vn0/0zGBUQKjonsgOMWks5t07wVp416Y0J8vKsIpGn2L3xpqMN0Stiw1igbm6B5
         /MVI2KdP8wCcGIuBG7z6YEB32vYKNgsJzFBQd6to+i+3W5T3UNkV+yLQ91cxjOFM9s6f
         KoqwsZ8Gsaxt6rfqGhaqkXX5v+mBArRk4Bw806UYa1VRywzrNlpce1+xHxuBbSDfswKh
         ULrA==
X-Gm-Message-State: AOAM532drPvXLx55JJiVptQI1ZL2n+VHOYK7So9Ob5QQJf6+5S6Vxf2+
        RXjrsp8gIyCwY4LikQowmiXnciqY
X-Google-Smtp-Source: ABdhPJx6jaQGwqw/0YgyNugOBtWpaNm/1dH1P1+nzzxwcm4CFhsefCivg3uVK/Nen+sCpZ97hWzyMA==
X-Received: by 2002:a19:c389:: with SMTP id t131mr6348085lff.130.1595061198281;
        Sat, 18 Jul 2020 01:33:18 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id e16sm2089451ljn.12.2020.07.18.01.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 01:33:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: don't miscount pinned memory
Date:   Sat, 18 Jul 2020 11:31:20 +0300
Message-Id: <2d9117b714bdf47de13374cc861c0ffd141da0c4.1595017706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595017706.git.asml.silence@gmail.com>
References: <cover.1595017706.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_sqe_buffer_unregister() uses cxt->sqo_mm for memory accounting, but
io_ring_ctx_free() drops ->sqo_mm before leaving pinned_vm
over-accounted. Postpone mm cleanup for when it's not needed anymore.

Fixes: 309758254ea62 ("io_uring: report pinned memory usage")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 644e5727389c..e535152fefab 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7655,12 +7655,12 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_finish_async(ctx);
+	io_sqe_buffer_unregister(ctx);
 	if (ctx->sqo_mm) {
 		mmdrop(ctx->sqo_mm);
 		ctx->sqo_mm = NULL;
 	}
 
-	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
-- 
2.24.0

