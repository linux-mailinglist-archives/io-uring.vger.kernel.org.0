Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC024A9137
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356040AbiBCXe4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356039AbiBCXeu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:34:50 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4219C06173E
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 15:34:49 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l67-20020a1c2546000000b00353951c3f62so2236169wml.5
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 15:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dtu5i1R4hfxOELb/nXJNtBsjoPa0tCK5wXG8XtHwg9o=;
        b=WDQ7UXWlnbH4SDADWxq915GaFbCRtyy2anBIIXO7sRRS7bvgSaKsWpcDjIYdGqV4J3
         UZuo3ZB197owh0sNexELBc/NWhDYJDNG3opgDlruCLKi7p/r/9C2CE8+JsiEtmrvmpL/
         jQ0jF95rZr2qfaNwV2rqLrLEGzm2UqbqdmFCKZEd9aHWh7qWnOTRxJRmCHPpHGhHdTyr
         EHedeO8dS8XtsoPvzDypDEII66xknPS5yXx6h7IR+JLWZrFNVKyFJG3YNsOoFPhCv06Y
         RvLBuhV3uhHeenOnsqKSsbvAKrvGXuH/5eIgk/p1QJ1+u3gm6K2lBjLxH5REOX0KXtz+
         L5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dtu5i1R4hfxOELb/nXJNtBsjoPa0tCK5wXG8XtHwg9o=;
        b=YcLn1OC1dzVNBUVIwp4X1xN7sAwIrcHA8zPew+MZQ/Kon7eBQ38wXAiS+mQVt9a6i8
         VGOmi3ehM+iVk7OQnijhbOcL3TrOP/Xlv591r5vguShxWgB4viLRr5jU9/57VJUpu+1e
         egitTi1fSDaK/9Tw8f8MVZPRwrmEzCFShEQzh452QHm7qjaMy7uGSV1zFirXsRt5cjzU
         HGqWas5WpSXgSlQum2KAzqxDAGOYiNhk9XLVoXJxcDDhjLgEhrmTL8Ack04qkWi33ERp
         CzrQL/GOl5ghWIzgPVkq7FgjL0a1mTN7BhiiPQ8qfazduntpoqDN+1AVgpFTObjYs2JY
         PHwg==
X-Gm-Message-State: AOAM532czVeQcmW57UwlrxAPDq4kUm96dUlXiwpDS+dr9d6ZqL5mdGTi
        tQkSDtqQRryILyDxdXW17aUpo0jOQD58Cw==
X-Google-Smtp-Source: ABdhPJwIfrb4/YByPVeNa9Oc0Ulr8ZQR5uQiDJfVsZBEIskH9buWEoEZaiAHxNGaUFm1tKPgvGLCBw==
X-Received: by 2002:a1c:2b06:: with SMTP id r6mr62849wmr.4.1643931288274;
        Thu, 03 Feb 2022 15:34:48 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id j15sm148494wmq.19.2022.02.03.15.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 15:34:47 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v5 4/4] io_uring: remove ring quiesce for io_uring_register
Date:   Thu,  3 Feb 2022 23:34:39 +0000
Message-Id: <20220203233439.845408-5-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220203233439.845408-1-usama.arif@bytedance.com>
References: <20220203233439.845408-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ring quiesce is currently only used for 2 opcodes
IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS.
IORING_SETUP_R_DISABLED prevents submitting requests and
so there will be no requests until IORING_REGISTER_ENABLE_RINGS
is called. And IORING_REGISTER_RESTRICTIONS works only before
IORING_REGISTER_ENABLE_RINGS is called. Hence ring quiesce is
not needed for these opcodes and therefore io_uring_register.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 69 ---------------------------------------------------
 1 file changed, 69 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ae51ea12f0f..89e4dd7e8995 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11022,64 +11022,6 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return ret;
 }
 
-static bool io_register_op_must_quiesce(int op)
-{
-	switch (op) {
-	case IORING_REGISTER_BUFFERS:
-	case IORING_UNREGISTER_BUFFERS:
-	case IORING_REGISTER_FILES:
-	case IORING_UNREGISTER_FILES:
-	case IORING_REGISTER_FILES_UPDATE:
-	case IORING_REGISTER_EVENTFD:
-	case IORING_REGISTER_EVENTFD_ASYNC:
-	case IORING_UNREGISTER_EVENTFD:
-	case IORING_REGISTER_PROBE:
-	case IORING_REGISTER_PERSONALITY:
-	case IORING_UNREGISTER_PERSONALITY:
-	case IORING_REGISTER_FILES2:
-	case IORING_REGISTER_FILES_UPDATE2:
-	case IORING_REGISTER_BUFFERS2:
-	case IORING_REGISTER_BUFFERS_UPDATE:
-	case IORING_REGISTER_IOWQ_AFF:
-	case IORING_UNREGISTER_IOWQ_AFF:
-	case IORING_REGISTER_IOWQ_MAX_WORKERS:
-		return false;
-	default:
-		return true;
-	}
-}
-
-static __cold int io_ctx_quiesce(struct io_ring_ctx *ctx)
-{
-	long ret;
-
-	percpu_ref_kill(&ctx->refs);
-
-	/*
-	 * Drop uring mutex before waiting for references to exit. If another
-	 * thread is currently inside io_uring_enter() it might need to grab the
-	 * uring_lock to make progress. If we hold it here across the drain
-	 * wait, then we can deadlock. It's safe to drop the mutex here, since
-	 * no new references will come in after we've killed the percpu ref.
-	 */
-	mutex_unlock(&ctx->uring_lock);
-	do {
-		ret = wait_for_completion_interruptible_timeout(&ctx->ref_comp, HZ);
-		if (ret) {
-			ret = min(0L, ret);
-			break;
-		}
-
-		ret = io_run_task_work_sig();
-		io_req_caches_free(ctx);
-	} while (ret >= 0);
-	mutex_lock(&ctx->uring_lock);
-
-	if (ret)
-		io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
-	return ret;
-}
-
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -11103,12 +11045,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			return -EACCES;
 	}
 
-	if (io_register_op_must_quiesce(opcode)) {
-		ret = io_ctx_quiesce(ctx);
-		if (ret)
-			return ret;
-	}
-
 	switch (opcode) {
 	case IORING_REGISTER_BUFFERS:
 		ret = io_sqe_buffers_register(ctx, arg, nr_args, NULL);
@@ -11213,11 +11149,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		break;
 	}
 
-	if (io_register_op_must_quiesce(opcode)) {
-		/* bring the ctx back to life */
-		percpu_ref_reinit(&ctx->refs);
-		reinit_completion(&ctx->ref_comp);
-	}
 	return ret;
 }
 
-- 
2.25.1

