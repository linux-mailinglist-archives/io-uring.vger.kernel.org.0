Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAC04A9B7D
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 15:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359482AbiBDOv3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Feb 2022 09:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359493AbiBDOv2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Feb 2022 09:51:28 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16DDC061401
        for <io-uring@vger.kernel.org>; Fri,  4 Feb 2022 06:51:27 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id l35-20020a05600c1d2300b0034d477271c1so3941659wms.3
        for <io-uring@vger.kernel.org>; Fri, 04 Feb 2022 06:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CaJ8vk5yyQY0T2mdc+r8fsmHsQDS+9ThebmdKt84DM=;
        b=WViNpK9iFN/B/XayGYeKNnTmyaV5k1IqBAmyt+A0jrJME4LyZwKmAREWJz1eCRUArJ
         mfRXZb4JacNW893IU/rb7firli+D+csTpY8sQSb/Mmq3qgXEf6RQa+aQeEhwNTInFtQt
         aCgQ+5slbpSSi9YiDAqIksTSFt1MZDGCj1hZRy5sztAEHVLOOGEDzF4X/PIs+dIW5u86
         8XspjFZJ9UYx61ZBfv3k2Vi14UGeymswLdJoivfAA+CsLeHybjnEDGvo+2Ugb7d9QTMn
         2fgsbTeSPVQz4NYQE9BBZHYAMSpTq7POpUjArVi68EHzdjIzMM4rUSwZVg7DwvhHwfWA
         DtxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CaJ8vk5yyQY0T2mdc+r8fsmHsQDS+9ThebmdKt84DM=;
        b=VU5JIYvL7/1MlwsYtaZ3hxO1LdrZrrZslwPT1vu3z7O5O6BcnWG7FaLyB9uGhc1zXL
         ekKbTKWqE6WgZyDlsDI0VuuLm43KoHnQmqHltrrc7AjMDSchHuCnhKHZKK7ymf+SvNQt
         swDGzKoyqsK/32QDI59XYNJwVR+HNrmqKcb8rwzAn22nQFKi1z9NL6YyqQMRvsO3NU5i
         m76bV/34LytuevMxvDnQRFwfn0r9B9sj1u52KWiEvUClsQHTPVPOR2WeE/TDNHHm15P5
         BeRb0EoHcGxQOvp1yED+DepltMfJR8s/Qb2Uu7mOu2g8unr+V75kuxvyPSPnFlB0iwl4
         8eGw==
X-Gm-Message-State: AOAM533rUGiHN7EFxfVyaRYpydapPkNRDYzJRbAQDyLYi7OYCxvUkFCT
        qSNhDKvxaAKANtjVhwMtdTIZf/MO+ES3pw==
X-Google-Smtp-Source: ABdhPJwQshqJLL/4yrbgwioourFtbu/7Ak+InZgBQiYRuzefDcbbDOMvqCXJznsRF3DWLEoHdooK4Q==
X-Received: by 2002:a7b:c117:: with SMTP id w23mr2547498wmi.63.1643986286182;
        Fri, 04 Feb 2022 06:51:26 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:e94c:d0f2:1084:a0d3])
        by smtp.gmail.com with ESMTPSA id c11sm2552898wri.43.2022.02.04.06.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 06:51:25 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v6 5/5] io_uring: remove ring quiesce for io_uring_register
Date:   Fri,  4 Feb 2022 14:51:17 +0000
Message-Id: <20220204145117.1186568-6-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220204145117.1186568-1-usama.arif@bytedance.com>
References: <20220204145117.1186568-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

None of the opcodes in io_uring_register use ring quiesce
anymore. Hence io_register_op_must_quiesce always returns
false and io_ctx_quiesce is never called.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 83 ---------------------------------------------------
 1 file changed, 83 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a2ce2601d4de..ad8f84376955 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1292,18 +1292,6 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req)
 	return __io_put_kbuf(req);
 }
 
-static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
-{
-	bool got = percpu_ref_tryget(ref);
-
-	/* already at zero, wait for ->release() */
-	if (!got)
-		wait_for_completion(compl);
-	percpu_ref_resurrect(ref);
-	if (got)
-		percpu_ref_put(ref);
-}
-
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
 	__must_hold(&req->ctx->timeout_lock)
@@ -10993,66 +10981,6 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
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
-	case IORING_REGISTER_ENABLE_RINGS:
-	case IORING_REGISTER_RESTRICTIONS:
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
@@ -11076,12 +11004,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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
@@ -11186,11 +11108,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

