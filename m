Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970993F00F9
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 11:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhHRJwF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 05:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhHRJwF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 05:52:05 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B5AC061764
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 02:51:30 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u16so2547016wrn.5
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 02:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qoFDj8wfPOGSAZWZfG5A3H/bwRW9ftEu7+QZMz4WK+w=;
        b=OQM3V3liJMxfSz9y7h+WEH5EXniGl2+cgE/MrJ9ASKTm2NddTcLz3HQPNWB72OY+fP
         GeyabnvzOY33eM5VwkvbgWpu0xYUcLJPDiFGLBOlIKJ5sIe23i+pqpN7R59AH2QARUtU
         iHCOf96bSBUBMjoQ1xiCd7LPO+ac3MMdaQQEFIX4JEaaP7i0eH0X5JAmaR+4uQF4Innh
         CnvPSpcR7boaTMuTg2cWWoLFQwXg5YUQVlb5dXoDSEB1mdjTPSq+W5lrq9NUZY06iL5m
         JlUz1MSTElXVDm7MXXZLn3wltPXXDOwMLktXiYPoF9ShbGGGUL//mOg+gX4Rq32vpZxI
         fevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qoFDj8wfPOGSAZWZfG5A3H/bwRW9ftEu7+QZMz4WK+w=;
        b=WFNdb9G0EMMBEZMFHvqsenT+OvjvgGGn0Jxx0jc6HY/Vk+pe56dd63WdgsArSUOVOj
         e8WT7BAmgbAAkckI9ruJ5K0g4TYtdA6E/fe9dBaQP2bDiXvqqEezak8C6NVbxSxz2hUI
         7Dm1ZHlajzVqeStnrof2ml3BYjcDg/4Pq4lhWdxRbEi3oJ1gIJFoypz9dXseBpujdCX9
         9RofDj7lxaP9a7zcfnBMYnVUIx+Bluu38g3pkmlOvBWrgO86rXt+pSL3YUKK0VYVPcI4
         AXbserI45r7yknXdGuYI45MlFQJlEn6SGple4/qfOU0FOjZRvBhgxs0HGwqNeNk6u1Tx
         Uygg==
X-Gm-Message-State: AOAM5330p50XAYQADvhbdZmliYEIJPREG6XZEbg/bjH6ZpDYiTVt4OLO
        WkW8mRdMXCCzONLtk0qr9EqjI3WlScs=
X-Google-Smtp-Source: ABdhPJyWpA1FrKFKq3aLcjE2h8zSp+jgQDluuDvUg2/zc/j0uwUIb5D9JSfRWaIcmcN9p2GqPyf/yw==
X-Received: by 2002:a5d:45c9:: with SMTP id b9mr9576199wrs.395.1629280289386;
        Wed, 18 Aug 2021 02:51:29 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.2])
        by smtp.gmail.com with ESMTPSA id o14sm4455595wms.2.2021.08.18.02.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 02:51:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: fix io_timeout_remove locking
Date:   Wed, 18 Aug 2021 10:50:52 +0100
Message-Id: <d6f03d653a4d7bf693ef6f39b6a426b6d97fd96f.1629280204.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_timeout_cancel() posts CQEs so needs ->completion_lock to be held,
so grab it in io_timeout_remove().

Fixes: 48ecb6369f1f2 ("io_uring: run timeouts from task_work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a22e24904fe4..ba087f395507 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5581,6 +5581,7 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 }
 
 static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
+	__must_hold(&ctx->completion_lock)
 	__must_hold(&ctx->timeout_lock)
 {
 	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
@@ -5655,13 +5656,18 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	spin_lock_irq(&ctx->timeout_lock);
-	if (!(req->timeout_rem.flags & IORING_TIMEOUT_UPDATE))
+	if (!(req->timeout_rem.flags & IORING_TIMEOUT_UPDATE)) {
+		spin_lock(&ctx->completion_lock);
+		spin_lock_irq(&ctx->timeout_lock);
 		ret = io_timeout_cancel(ctx, tr->addr);
-	else
+		spin_unlock_irq(&ctx->timeout_lock);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		spin_lock_irq(&ctx->timeout_lock);
 		ret = io_timeout_update(ctx, tr->addr, &tr->ts,
 					io_translate_timeout_mode(tr->flags));
-	spin_unlock_irq(&ctx->timeout_lock);
+		spin_unlock_irq(&ctx->timeout_lock);
+	}
 
 	if (ret < 0)
 		req_set_fail(req);
-- 
2.32.0

