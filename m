Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A742A3E50B4
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 03:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhHJBpc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 21:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhHJBpc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 21:45:32 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F0FC0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 18:45:11 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h14so23922448wrx.10
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 18:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SgjenLCxIRHqkXwMm4vzCWybx8UINpO2oTPgSVJaUjQ=;
        b=W3F8UvOMFUXvmUI61Weml1RwJhgwHPmaS+IqTJ9W2a/T6fKRoRQsI9RvEDPekXdnJs
         FDbDbg6NxTjqfzhihKM6VXRDHVtjspf4PUPexbTXX+Dua+YnMw4sPViWgSv8McxLKDdD
         s24Ey7GT/XpPD5rmnUn2ks08KLDteVsOjoxt5AmbiAWExwJxeZ+G42QRdy3NKH/2R90s
         MJwvvSxAhVsio81spCbg8m2iNgELaw/ZATfAr6WRcGcq+XJQo/mwFc7qsCiX2S1yC5uk
         z23nOsU/wWGDHropNF1SEangmJp1NRHARp64wO/3I0xr2an6Db22k9AtUwdKK3O/51bu
         ukRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SgjenLCxIRHqkXwMm4vzCWybx8UINpO2oTPgSVJaUjQ=;
        b=DmV7vmKRnCOhEJrCP9iLyRdJFob3YYDT+dE2vBpMHhkRVonSqzV+RR2mHUq/w1/TCF
         NfS36ANq8zQpILNuX9itOuW6jvIbT/n0Ev3kazVKmTLr/06usgvT38kCWpuWGcWQ30U1
         W8q81hd9v/wB6FeLjh8uYA8m9rykDMg4BcspXeGyZkfE+a32DNXQsI6jO9G0Tvy1TgRz
         dxGVihN+6FO9gHpPnjxY6evoSEKNcj5nky5zmScfI6sw5G4uJgud9BeaGC5cu+UvLUDE
         T1VLBG/orxSbu0ncCEw5oe+PvEf/GP8PMTVN2q67wc3trTrWjaZyxcGFsBcXEjb7yKdJ
         ZcEw==
X-Gm-Message-State: AOAM533L9DKAC6GE48NuWOiMsJVGGR42LAUFr22LAZw/7+IHanmw69R6
        SNqRP/BxrS7873p5vH2lHES8EhuA2d4=
X-Google-Smtp-Source: ABdhPJw+h6Ub2K0mWdGVSN/GyXt9ejE8SgeapIwYUpq2DCPaVSiU2sBRn4+azk5CnDa9qRmYPWTzUA==
X-Received: by 2002:a5d:5646:: with SMTP id j6mr9597361wrw.314.1628559909720;
        Mon, 09 Aug 2021 18:45:09 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id k1sm21818211wrz.61.2021.08.09.18.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 18:45:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 5.14] io_uring: fix ctx-exit io_rsrc_put_work() deadlock
Date:   Tue, 10 Aug 2021 02:44:23 +0100
Message-Id: <0130c5c2693468173ec1afab714e0885d2c9c363.1628559783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_rsrc_put_work() might need ->uring_lock, so nobody should wait for
rsrc nodes holding the mutex. However, that's exactly what
io_ring_ctx_free() does with io_wait_rsrc_data().

Split it into rsrc wait + dealloc, and move the first one out of the
lock.

Cc: stable@vger.kernel.org
Fixes: b60c8dce33895 ("io_uring: preparation for rsrc tagging")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 331b866b39cf..d59e34e58b14 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8645,13 +8645,10 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static bool io_wait_rsrc_data(struct io_rsrc_data *data)
+static void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
-	if (!data)
-		return false;
-	if (!atomic_dec_and_test(&data->refs))
+	if (data && !atomic_dec_and_test(&data->refs))
 		wait_for_completion(&data->done);
-	return true;
 }
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
@@ -8663,10 +8660,14 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		ctx->mm_account = NULL;
 	}
 
+	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
+	io_wait_rsrc_data(ctx->buf_data);
+	io_wait_rsrc_data(ctx->file_data);
+
 	mutex_lock(&ctx->uring_lock);
-	if (io_wait_rsrc_data(ctx->buf_data))
+	if (ctx->buf_data)
 		__io_sqe_buffers_unregister(ctx);
-	if (io_wait_rsrc_data(ctx->file_data))
+	if (ctx->file_data)
 		__io_sqe_files_unregister(ctx);
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
-- 
2.32.0

