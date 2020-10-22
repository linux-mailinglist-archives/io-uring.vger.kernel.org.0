Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758112961DA
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368716AbgJVPqX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368712AbgJVPqX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:46:23 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87AFC0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:22 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t9so3011340wrq.11
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jRtjUo+F/uFhEU8W8EVOi9WQiBCusx7PLgu+vuS82TY=;
        b=QMUyrCFhGQ9fIYzA4R6p8Y8zvxXxOxMx6cjE4G7IXT+8sGyw0xDna50kC/umpMMuUB
         yDWyTotZh3hYxn35mfPXkXmU5pCIXbkhmQOL+ICo3qDUDC+vkbgtyLT21pAZLQRuQqMJ
         OtDT3/fmr1bHTtTDtZccatUdE6tAseapA5K1z+qzj5Vr8zhFbPpBcedrdrEkHPHP+LK7
         jEhaGcHXcw8XDBfoQXGdyQU/AqIKc0dtPX24EoP9Dapd1gPECsMRrJghD87F8Vh/5O7Y
         d2wuVOyQeET1nEhQ1OkfFEesU/9A9owko000M7EPS37GRKYtiE2meX8RPZDJqlHsqWKx
         5RLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jRtjUo+F/uFhEU8W8EVOi9WQiBCusx7PLgu+vuS82TY=;
        b=YqE0CJ1JgeugXTzXFbqzI7M0o/VvcsiT5/pPQIN5c7UixCdbgIdU6seZpYA9YuyE9i
         7vb6/BAaqpOvf3erQwMtxnbiH/B+txweqgC3onDzswpXZphPGfJ8xzFgx4mZ7vgruBV8
         GFymqYYj9tfte9qO4+FPLcqt/1/tTmDuAwtln8BjYk4BQbVaGeTFiTt2ezcpv3g4onBx
         8+xuYkjUUAqsVCOdtvaeK5RTQ9dRfLTejSLvcRn4YPNyoIE/fePsq7D2qKNMAwCVb++C
         BTeqomQvyasjoQm10WctivxdrjqvoaMp/LqpGlVSevk6DpmxzCxbRr0nm8Qr1aann00G
         OoGw==
X-Gm-Message-State: AOAM531p9zNQ/Wd+m6Kp5mKgG3/HWsYju3WnHpJgxdwvbQ5Q/m20w8Cr
        GNeRGGNqos2agi+tDgQ89go=
X-Google-Smtp-Source: ABdhPJy/V9lJqJ74BGx+7X1xCm1o3im/IuTmTP3RlG7wIPS2Nt/g7CZ6BYs8my/fgpubYP0ZZliUgw==
X-Received: by 2002:adf:a501:: with SMTP id i1mr3318837wrb.162.1603381581438;
        Thu, 22 Oct 2020 08:46:21 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id s11sm4329536wrm.56.2020.10.22.08.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:46:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: always clear LINK_TIMEOUT after cancel
Date:   Thu, 22 Oct 2020 16:43:10 +0100
Message-Id: <a671c1f0204747d226e284d31a9335449e71e0cb.1603381140.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603381140.git.asml.silence@gmail.com>
References: <cover.1603381140.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move REQ_F_LINK_TIMEOUT clearing out of __io_kill_linked_timeout()
because it might return early and leave the flag set. It's not a
problem, but may be confusing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5e327d620b8f..d9ac45f850be 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1881,7 +1881,6 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 
 	list_del_init(&link->link_list);
 	wake_ev = io_link_cancel_timeout(link);
-	req->flags &= ~REQ_F_LINK_TIMEOUT;
 	return wake_ev;
 }
 
@@ -1893,6 +1892,7 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	wake_ev = __io_kill_linked_timeout(req);
+	req->flags &= ~REQ_F_LINK_TIMEOUT;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (wake_ev)
-- 
2.24.0

