Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40867468790
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 21:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhLDUx1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 15:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhLDUx1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 15:53:27 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1155C061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 12:50:00 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id c4so13437907wrd.9
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 12:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m8jI2e4vtIRUvbDrG2Rp1kUa0vdcXNX713NyeDRD+Yo=;
        b=GliA56w4UdSNey+b3nqBdJSk73qzpuPt9OCGgqg9Wq0g9CzMpkseHXA9OftECtkMsy
         Mi9fQKF8G/gy74Rlw6I6S11jJPhO5fsEPcHB6NVk3bAlGDOVGI0QKRbpLBqdn3atiWkG
         I+pdKzsD6scSsEacf+xN98xzfWnHoB4lGi+F9E2PYUPsV7yeZvJ3ktO0KntT496CsuV/
         dlAdfUBM/DHHj2MFE2kQdY9278Mn4FpmQpfOURRf2fOKgXanYoCnEC4fb5kZN4SUJpMA
         iTXzMBRR5ZE+oqiwuPtPZAM2Q4p9hO79JjoAR/BPtlrZbCjS7w+pecc4KOeOG+38deN/
         3jLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m8jI2e4vtIRUvbDrG2Rp1kUa0vdcXNX713NyeDRD+Yo=;
        b=qDkoii2cWhWBuIPMJRPMr5FkE/131MJ9auY6zFBBr61rEI7qPTnZ6aw+6PlvN4/mve
         /xn4+nT3X/e95CTIykafMnDQueueoy7zz9JVyGtQE1/y9Z/L48oDBCkKPRqOsyOJSF2Z
         3eczVAnjFFU705QXBquA67pspgMcht0UPrCEFu79ENlstynwn7Chr5lioo97k3gSfcAQ
         u/5HnSNa9YChdp3Gb/+xoSz4IOQdH88TpsNsLywy2Fj4Z66qeoEFh/RFYQp8ooXA126p
         bEH4/vU8GSzQOaX1gPKKQsI7cQUm1N2BGV6A0KJdZ1aRGwUQU2LlKxISvdl4GtRNR3R/
         /Z9w==
X-Gm-Message-State: AOAM531pLMNBraqNKqLoX47mIToaqOQuwiUdkn8I6IMc5q8w++etL34t
        oj4beoStGrj9+WnETB0cAg/GCahFH04=
X-Google-Smtp-Source: ABdhPJzrh9SwOn7SyNbxjDfHXlPWsKWYAs8DWPgCR3sxyZPUmOtjtSLUcQdbkiKeSIj3AY4f5ITlCg==
X-Received: by 2002:adf:a190:: with SMTP id u16mr31987540wru.483.1638650999262;
        Sat, 04 Dec 2021 12:49:59 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id k187sm8393143wme.0.2021.12.04.12.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 12:49:58 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH 1/4] io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
Date:   Sat,  4 Dec 2021 20:49:27 +0000
Message-Id: <3631243d6fc4a79bbba0cd62597fc8cd5be95924.1638650836.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638650836.git.asml.silence@gmail.com>
References: <cover.1638650836.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

Move them up to avoid explicit declaration. We will use them in later
patches.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b6bfed16f65..ffbe1b76f3a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1273,6 +1273,24 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 	}
 }
 
+static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
+{
+	unsigned int cflags;
+
+	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
+	cflags |= IORING_CQE_F_BUFFER;
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	kfree(kbuf);
+	return cflags;
+}
+
+static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
+{
+	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return 0;
+	return io_put_kbuf(req, req->kbuf);
+}
+
 static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
 {
 	bool got = percpu_ref_tryget(ref);
@@ -2456,24 +2474,6 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
 
-static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
-{
-	unsigned int cflags;
-
-	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
-	cflags |= IORING_CQE_F_BUFFER;
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	kfree(kbuf);
-	return cflags;
-}
-
-static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
-{
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
-		return 0;
-	return io_put_kbuf(req, req->kbuf);
-}
-
 static inline bool io_run_task_work(void)
 {
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
-- 
2.34.0

