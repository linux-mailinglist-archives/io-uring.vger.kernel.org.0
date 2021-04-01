Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A54351837
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhDARoT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbhDARjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:39:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6C2C0045FB
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x16so2104366wrn.4
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Y95CJayNrwzOaVNWU8hPBC0uk5jvclW1/zV21RVy3lU=;
        b=HZMrXOWLd5+RgUMiSHSSG6xTU83bpDrF/TjegyCEBxQ+qW1t/c3w7FHloGcZeeV81J
         n7asFYsa/vECUhCebFlDIE30Pp2P9fquCFVsmNlVytAp5qUAjExnHyQ2eZN1Co9ahmit
         +1rWeflZ1hX0Gh5BL4i/dZBZim6Z4sSA1LnNQ7Daf5esGYFpBvru8qR4rUj3zf4L6EKl
         ldfW5gjeb8e2Ao950FRcAjNTRQTIHpOlBTfbuIyabxrxwH6LDPUxscHgvxUlMx4NgFdO
         5S4gA0wutwScrwILnChALUqdU3DVDGM5e4ADs2X/LmaPbpF4xDms7DMyLUjZqiHfPKyU
         qyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y95CJayNrwzOaVNWU8hPBC0uk5jvclW1/zV21RVy3lU=;
        b=SGt0I6i1C/vr/NaycUGrOBRv8Dt0/3zV/PUtg9MIlsTtM5mLbXQSU765OJibaBwnZI
         Re/GU3HTbn+fm0Jr1+JEHxW9lZBedTxf2ptJ3lj+EleXKUAiKdcSqjDzmZ4IUdIH2UGT
         BMYDu/xttoxqKot9gwYXa40lnsIDNp5d+ZGoGPeKK2emeCSy8yVO/tNYwhuVDEV3i6jI
         lZpjW6YeIhPNGI/lVsuK3BqGOY48helPcIrqX7YmBisc0OJsryqCx6bNcZ3cdPdO9xRN
         25LbnTcDD3TfSwLCWHYGQtQ/SrcX4stNvKQ41i3Z8/jweMP9CWL8fPE35tB+hk/+ZYLG
         flUQ==
X-Gm-Message-State: AOAM532jGtMDskMkB2HR5p+iVgJTeFgIS8RCyPxHLqhHRXe/er0A0+Yy
        fCYClicICMWHTRX5QSFP2k8=
X-Google-Smtp-Source: ABdhPJyAAu6DL1N74FGdZAXtE8rQA+C000Zln6JEjIfDsFZRcUxImJEQIcZal6XhYRV1QZgXdkwQhA==
X-Received: by 2002:adf:e791:: with SMTP id n17mr10128112wrm.322.1617288507437;
        Thu, 01 Apr 2021 07:48:27 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 10/26] io_uring: refactor rw reissue
Date:   Thu,  1 Apr 2021 15:43:49 +0100
Message-Id: <a0d8f74f5a03bded8374bd29c0978aaa5af17fdf.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_rw_should_reissue() check into io_resubmit_prep(), so we don't
need, so we can remove it from io_rw_reissue() and
io_complete_rw_iopoll().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8d95feed75f..e9bfe137270c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2441,17 +2441,6 @@ static void kiocb_end_write(struct io_kiocb *req)
 }
 
 #ifdef CONFIG_BLOCK
-static bool io_resubmit_prep(struct io_kiocb *req)
-{
-	struct io_async_rw *rw = req->async_data;
-
-	if (!rw)
-		return !io_req_prep_async(req);
-	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
-	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
-	return true;
-}
-
 static bool io_rw_should_reissue(struct io_kiocb *req)
 {
 	umode_t mode = file_inode(req->file)->i_mode;
@@ -2467,26 +2456,34 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 * Don't attempt to reissue from that path, just let it fail with
 	 * -EAGAIN.
 	 */
-	if (percpu_ref_is_dying(&ctx->refs))
-		return false;
-	return true;
+	return !percpu_ref_is_dying(&ctx->refs);
 }
-#endif
 
-static bool io_rw_reissue(struct io_kiocb *req)
+static bool io_resubmit_prep(struct io_kiocb *req)
 {
-#ifdef CONFIG_BLOCK
+	struct io_async_rw *rw = req->async_data;
+
 	if (!io_rw_should_reissue(req))
 		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
+	if (!rw)
+		return !io_req_prep_async(req);
+	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
+	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
+	return true;
+}
+#endif
+
+static bool io_rw_reissue(struct io_kiocb *req)
+{
+#ifdef CONFIG_BLOCK
 	if (io_resubmit_prep(req)) {
 		req_ref_get(req);
 		io_queue_async_work(req);
 		return true;
 	}
-	req_set_fail_links(req);
 #endif
 	return false;
 }
@@ -2525,9 +2522,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 		bool fail = true;
 
 #ifdef CONFIG_BLOCK
-		if (res == -EAGAIN && io_rw_should_reissue(req) &&
-		    io_resubmit_prep(req))
-			fail = false;
+		fail = res != -EAGAIN || !io_resubmit_prep(req);
 #endif
 		if (fail) {
 			req_set_fail_links(req);
-- 
2.24.0

