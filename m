Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E135E25B8B3
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgICCVH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbgICCVE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:04 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64A4C061246
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:21:03 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u20so980886pfn.0
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jsr/m2qCMJZs9lYgA2JIdiGg8dIhRn0MzzQ2WqNorz4=;
        b=vqCCBYAf2QWJP3SzLyaYG3Mv11uIobnUL0a4gbAAYS0UbRGaZ4GMg0rpbRjC6Xh30s
         siZ8Z4De5d+YRDj4csaxOEWDNeWMX30EuOfqZa2l0qTfXjTiHNMHsL8bwAhbFppirczo
         1GDjciedXRNTbClJ+bh0nF3vdMnhxAD1ZQ+ObBKGls1A4xI21Hk9nL6dYQyuYdqpTfZg
         FykJP+87yHUrI+lZstB0ki6SFlFsl6o9D0qn33asftGp0I3NdlaQX5Oe78bM9drFPHwJ
         Hc4MeObwlQBG/UIuA14iPkyhl/+1ix/geKryRm2n4ci6Imepv3Hgjo2luPGl2OXo7dtt
         izBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jsr/m2qCMJZs9lYgA2JIdiGg8dIhRn0MzzQ2WqNorz4=;
        b=pCpTN+BiEUxs2uw9O/xMk0h1T7oqJqwEQbiBWDkk1mGLdazI5RCuG7eCZHqGQ7IvB+
         F49ZilQIBjYZEfh5qOB8Po2xKIvVfKfCEMPwXFLgkDp5ovJPumf9B70JGmU31mdorjbD
         I5PXi/DTjnN0jXNxBGAdqkW8qjWLo5RGgveS32tU6OJWaYfdK9/EWCPeIYcPqILHVl8X
         5jecbdw7R1d1dY3GuG40E/RX3sn/4wKgc9u+ZWmRNzoma0jngC0TnCQneveYO19hi8gz
         oiVLKXUFXQ2yZoG0PGqA1qtH4wxzDhgFZDUrCG+3nAWMJhIES8vjSne205qtAXs++Rez
         pSXg==
X-Gm-Message-State: AOAM533WNextQE6O9LIIbU5pmPXMbV71ajj1LOTrw2WRc2wc+j2PgJQK
        hGP53K2ENK9DDM2XNjN0iEmU8vP2PqP8w1Qi
X-Google-Smtp-Source: ABdhPJxYPDl+f1yzaYY5o2JGREnljB0LFDYkWAeunnnIenpK2d2PBVMpJSoIkSIXhjohmAr6P7yang==
X-Received: by 2002:a65:610f:: with SMTP id z15mr847801pgu.123.1599099663136;
        Wed, 02 Sep 2020 19:21:03 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:21:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] io_uring: move SQPOLL post-wakeup ring need wakeup flag into wake handler
Date:   Wed,  2 Sep 2020 20:20:49 -0600
Message-Id: <20200903022053.912968-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903022053.912968-1-axboe@kernel.dk>
References: <20200903022053.912968-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need to decouple the clearing on wakeup from the the inline schedule,
as that is going to be required for handling multiple rings in one
thread.

Wrap our wakeup handler so we can clear it when we get the wakeup, by
definition that is when we no longer need the flag set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 76f02db37ffc..95c81e0395d9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6613,6 +6613,18 @@ static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
+static int io_sq_wake_function(struct wait_queue_entry *wqe, unsigned mode,
+			       int sync, void *key)
+{
+	struct io_ring_ctx *ctx = container_of(wqe, struct io_ring_ctx, sqo_wait_entry);
+	int ret;
+
+	ret = autoremove_wake_function(wqe, mode, sync, key);
+	if (ret)
+		io_ring_clear_wakeup_flag(ctx);
+	return ret;
+}
+
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
@@ -6621,6 +6633,7 @@ static int io_sq_thread(void *data)
 	int ret = 0;
 
 	init_wait(&ctx->sqo_wait_entry);
+	ctx->sqo_wait_entry.func = io_sq_wake_function;
 
 	complete(&ctx->sq_thread_comp);
 
@@ -6707,7 +6720,6 @@ static int io_sq_thread(void *data)
 				schedule();
 				finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
 
-				io_ring_clear_wakeup_flag(ctx);
 				ret = 0;
 				continue;
 			}
-- 
2.28.0

