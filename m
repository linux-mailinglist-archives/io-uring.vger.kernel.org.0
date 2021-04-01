Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC4B351826
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbhDARoI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbhDARiE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:38:04 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F98DC00458D
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:38 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e18so2097016wrt.6
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2qNg1Wa3A/erBvXVaSMUGz+mLdMrgmZSuT/mdhUt4Gc=;
        b=RlVCqh6Our3lIZDB0jjMQGS3WGNvoPIb0DkfyWBFhGfVc7hc87T5DspDaODmAHFaoi
         9UaMXZapLbpwRTWVySsTZmBTEW1webQM/NwMAUzaU1qkoJ+zflrlx0gJHqVU+6XKqjn/
         dYjN/37wyUps6Yv7Hkwgrctp69KncTI2IrOsz/b2aiC4NpLOf0CG3rbdSbgIFE8u5O02
         CncofAd8FpTtfiAfDit3Igm0qzUCkYe954qPQOxS3iwYg7jkQO1Kp4fZnote8xzMh/GU
         HnkdkSUv8AIGgD0Lgn4rRPZ5vUdt2DRLu9xnUKoIKhmWEQ50yJVhTP3RJx7efiMWTmlH
         dqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qNg1Wa3A/erBvXVaSMUGz+mLdMrgmZSuT/mdhUt4Gc=;
        b=umtqIfg1PD9D0QsgVsKh1BL33OiY2+UCmvx0CTGiZR5HRwuEpWDsfGBaEAXi8NAqsM
         vVvqaVManrHRZ8B77MBvq/t3iO+244CiPysNldJicTbfKLeuVpkyP8jn0mY1K18AEBuo
         azvs4QEGPsuEAn8c5RYjzF1trowrlhjkJnG0iDEJ8cdNSAuGzzdvO5yEqqfpTe8TtkKK
         s6Ja+aY9UMeevocrG7ukHEFkTWHIi7EIooS3rSh1vlFiGKE4qxv/6doxuB4QIDOWARaw
         53R8V1MQ4CN9gUY1/9051OtPqoSndkylIx/G7JmxMqmi5tppoiyqewnsbkO9rMyEcLvY
         ipgg==
X-Gm-Message-State: AOAM5331iVEEjkFkDUgsNTtlsk2EcuvMF3Yi/yZBhms25DKEA2T7Wukj
        SORK6MOG+wEFvGyS3oBbEmsAZclDA2L+bA==
X-Google-Smtp-Source: ABdhPJz1JUmSpfBa3dy2O63/xlsZlXtrQw9WeCIPcC5y8w2jhnG6kVX0k0hLxk65Nk66d1zsMFwZ9w==
X-Received: by 2002:adf:c70b:: with SMTP id k11mr10301779wrg.165.1617288517405;
        Thu, 01 Apr 2021 07:48:37 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 20/26] io_uring: put link timeout req consistently
Date:   Thu,  1 Apr 2021 15:43:59 +0100
Message-Id: <d75b70957f245275ab7cba83e0ac9c1b86aae78a.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't put linked timeout req in io_async_find_and_cancel() but do it in
io_link_timeout_fn(), so we have only one point for that and won't have
to do it differently as it's now (put vs put_deferred). Btw, improve a
bit io_async_find_and_cancel()'s locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a621582a2f11..dcd2f206e058 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5746,12 +5746,9 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	int ret;
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	if (ret != -ENOENT) {
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		goto done;
-	}
-
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	if (ret != -ENOENT)
+		goto done;
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto done;
@@ -5766,7 +5763,6 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -6341,8 +6337,8 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 		io_put_req_deferred(prev, 1);
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
-		io_put_req_deferred(req, 1);
 	}
+	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.24.0

