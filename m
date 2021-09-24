Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8DD4178EC
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245498AbhIXQiV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347596AbhIXQh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:57 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7500FC0612A5
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id dm26so4015972edb.12
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=o4htibYjBMaVZG9JX/lhR64x8IMMjAac8cfW7m5N5uM=;
        b=KrCklsRp5QXd7SN2wmSYVIjH+yqddj1X0WoL8b7CWJtmT9OzcBL7alub7/ys7ncCy2
         UzFXs+p5BW4AyzDi57TXtEdzV5zsHBA+1h7z2SGgvJI3XsQr3LtKHgu8GolC3cs961K4
         SIPqlm3tHsy30d8mwDega4gdYBIIXV13fBUpOu0gymrkZRxgyI2MJxdCEUQtHIXTFlte
         nGgJhJgLtWMC0CKg7JV+Z/AmTgLu318NFUWu3MYk5zMEZWs0k497dBF+yUkBegNMTtyt
         Hkn6dxKrxrlZQuw41x6JmKDcgTEKVSmQ9JFP1jMN+FG5TGqeEMr8vDEwhEzM1hDv8Nvk
         wdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o4htibYjBMaVZG9JX/lhR64x8IMMjAac8cfW7m5N5uM=;
        b=D1zjOKbu9JjX42bVRZGpkDUnqxYl+MDIPojgx9HjYrzwvoDGfxnHJZmIdT+96z+Pk6
         kBm+Al3wllPVO+oxY1HBxnly30ww0669M5USU+CGfEnQx/Ojp11BaZ20R78E/0ER5wa6
         aoP7HXKon2u48wQsiOgNODqH+r6jxFeDpWfppqGtufV3riN9JIuS/M898lPSc5DninOz
         1H12ju0Zm3yQ3A/U5BkuOnf6AVZh5I995zP2PnthxcscgMboe6zXVY8QzYdjstax+9uf
         p0NQH3/huWe8e+PjJznIfwE/lQb2UBgBgOCzh27laoZk4wO/lD5+ZO9DQGNUw2SRGJER
         ktkw==
X-Gm-Message-State: AOAM532HyiEjBTb7U9at7AbdkP/IJ0b6tzK/aSm4BW5gP0ROOZ6eGe3s
        adfN2RCzc0vHaGOf2UVDZ06SrlGP4MY=
X-Google-Smtp-Source: ABdhPJy6EY+sHlfKjCak8GP8Jv5zaiLUL+CqoTwkTV1+r1hlhyw6CCRUDncC+uGYGDJEBVadixTm0A==
X-Received: by 2002:a17:907:c22:: with SMTP id ga34mr12414712ejc.336.1632501183112;
        Fri, 24 Sep 2021 09:33:03 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:33:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 18/23] io_uring: split slow path from io_queue_sqe
Date:   Fri, 24 Sep 2021 17:31:56 +0100
Message-Id: <2624c7651681ffc2a3ee27e38b12359a233c517b.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't want the slow path of io_queue_sqe to be inlined, so extract a
function from it.

   text    data     bss     dec     hex filename
  91950   13986       8  105944   19dd8 ./fs/io_uring.o
  91758   13986       8  105752   19d18 ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c1c967088252..6d47b5150e80 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6927,12 +6927,10 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	}
 }
 
-static inline void io_queue_sqe(struct io_kiocb *req)
+static void io_queue_sqe_fallback(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
-		__io_queue_sqe(req);
-	} else if (req->flags & REQ_F_FAIL) {
+	if (req->flags & REQ_F_FAIL) {
 		io_req_complete_fail_submit(req);
 	} else if (unlikely(req->ctx->drain_active) && io_drain_req(req)) {
 		return;
@@ -6946,6 +6944,15 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	}
 }
 
+static inline void io_queue_sqe(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
+{
+	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
+		__io_queue_sqe(req);
+	else
+		io_queue_sqe_fallback(req);
+}
+
 /*
  * Check SQE restrictions (opcode and flags).
  *
-- 
2.33.0

