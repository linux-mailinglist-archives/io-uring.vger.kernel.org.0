Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A86335B10F
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhDKAvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhDKAvU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:20 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B102C06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:04 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id z24-20020a1cf4180000b029012463a9027fso4852262wma.5
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p7SRyLaqO2B6gSaNhdkUZxYH2YhwdEoENsp5STZH57c=;
        b=kvoYDYgUpBnxAB17A1CTWHC/gI74GzIMy/j9aO0tFjWlK0XcQwMW/wRTqVzZKec/E+
         pfDj+bACCN88Ek5Q1HGvZIQO8ZHw43KUoavjAxg7BWBZz9dMnwmFOfsyI4aOWpqa5OH8
         HuFmjNIGLDrPn41Me8CualungdPGiZ2w6d95l9lis2VDXbBTcBWboVIezeBJ2QuOBzcB
         TjLEgZ5+R71DQKpf11c8cHvpSl8cqhpQCLFQIH0xTKcjZ4BcDuZqygCSLj4BKCyYOnKy
         OzqJ7XENNo6UJCZ5riY1El+6gjP8WKjaX8N1+MDrysuxqSf74JBVtqtsn9VK2ojbJ5OE
         LzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p7SRyLaqO2B6gSaNhdkUZxYH2YhwdEoENsp5STZH57c=;
        b=CCts9Ww/xwxS1Lz8RR3HerAqWmUShpMHhTfKjPDm+7lrk2V9FNoVaan58W1mArur5w
         CG4NTdWbrm9oomYJcmP4mxqhHp1HesE+IeOX298iOd+wORga0f/2O7QtprfjVodq3ILj
         fHMmqp86We/miOy776YXWCCSGoBNLRH0oT1+S5oQvyuLcEk9zs4SUKJQDud/f4gnMwrM
         EY9OSkvyM5GurLuCw0qYiLs+Tqwwzl++YNAYuLPbT4Y1IY8yU79Vg3794LNbU9mEsQm2
         DusZfFYsxVXTSdYWwMVmRgLuqpvGScwNTWtJ3j+7VNrjiOz29Bs8Xzn6vsMfe4FABjXm
         Z6og==
X-Gm-Message-State: AOAM530YPKKosBA+Lr3dZzMshu83IyA7exnRTNVKLdOJH1OF3MnySUpY
        IGiUpgrM4kYjdEixnNMIWUq4B940wsliYg==
X-Google-Smtp-Source: ABdhPJwBJ1z0kH4UbjraCg01lOU789e8Ttd4i/lnRImwig1k92UF6ZVjO8CoWpKdoEPDXM0Jnv2RCw==
X-Received: by 2002:a1c:94:: with SMTP id 142mr14568155wma.31.1618102263474;
        Sat, 10 Apr 2021 17:51:03 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 11/16] io_uring: add buffer unmap helper
Date:   Sun, 11 Apr 2021 01:46:35 +0100
Message-Id: <66cbc6ea863be865bac7b7080ed6a3d5c542b71f.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper for unmapping registered buffers, better than double
indexing and will be reused in the future.

Suggested-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 143afe827cad..157e8b6f1fc4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8098,25 +8098,27 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 	return off;
 }
 
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
+{
+	unsigned int i;
+
+	for (i = 0; i < imu->nr_bvecs; i++)
+		unpin_user_page(imu->bvec[i].bv_page);
+	if (imu->acct_pages)
+		io_unaccount_mem(ctx, imu->acct_pages);
+	kvfree(imu->bvec);
+	imu->nr_bvecs = 0;
+}
+
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
-	int i, j;
+	unsigned int i;
 
 	if (!ctx->user_bufs)
 		return -ENXIO;
 
-	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
-
-		for (j = 0; j < imu->nr_bvecs; j++)
-			unpin_user_page(imu->bvec[j].bv_page);
-
-		if (imu->acct_pages)
-			io_unaccount_mem(ctx, imu->acct_pages);
-		kvfree(imu->bvec);
-		imu->nr_bvecs = 0;
-	}
-
+	for (i = 0; i < ctx->nr_user_bufs; i++)
+		io_buffer_unmap(ctx, &ctx->user_bufs[i]);
 	kfree(ctx->user_bufs);
 	ctx->user_bufs = NULL;
 	ctx->nr_user_bufs = 0;
-- 
2.24.0

