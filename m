Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F33351840
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbhDARoV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbhDARjV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:39:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97592C004589
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j7so2117572wrd.1
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=40wYh3UdHMe47UUwlrN0dox4PnP9hwD4pIYHxZ1WNTg=;
        b=hNBCoASysQzoXqXd8lOpbdSwYMu+BsjKbfOVzkqgrRo8ZHJfhrMqvQEb/L+508MWal
         CL3x4fePKc7Wd4zvZ2tCP1srwQ0zKS07kpCfCsbP8Ngob4C3CuBfzi48Nx2ZABg5Kpan
         j1rG8k2HQdW+k0lhRRqOuiC/u+gpx8UIM+duGvtwyhL2tF2XTnUsv6o8mKMJTuOkZnv4
         NpvAWihpyZ1OyWMBwmXF3PqIYfYfDqj+SDgcobO4HKrFkAWWLtvddI3+hBc/yjRhpLRj
         LeGi1k0jgLVkL4sl2rDVi/dBkB+dK0Fmgts4XYB6PlRTRw/GgxzyqOtJGr81E9whU3Li
         EmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=40wYh3UdHMe47UUwlrN0dox4PnP9hwD4pIYHxZ1WNTg=;
        b=Ym2mLXsChktlP0fdaFZJk/zLsuM5Lqx5rANqPtKaTdCWBDr50zqkuxmyJERh3fV27v
         qi7UNqbTeMxkFGwStboQSYzHnJFLjpP4EvLBAuisi90I8D0bKKa4u+qKgUu04R8onGRX
         ngYhsetFAe4vSEZV2hTg2BI+FttMuBXyk6aKeyHnknXtlFcplR+qH+AWB7TWbKFO6LCK
         E/9guK5x6QNe4kSuepKNRVn2eulpk1JC8M5o1yVNdL+5Ise2iVCZQIa3w1jDuhuH+b5n
         MYYxEtepU0svh+s4a2nYrD2ItsyHmpZb3gvmdMwpJRuWmnuDhcmSIwFA19mlWAhdLQ8X
         unSg==
X-Gm-Message-State: AOAM533SWS/8Gw+8nnqDzn9BPG0c8waDTbJpKrADGIuZPyGX2jjOYBdi
        /u0pgDcB1Gkgcuj6XiRPg2q2wJ9TjhQecA==
X-Google-Smtp-Source: ABdhPJwDrV4DICwFVFspnHR7u8O5/GNhj6CdstyWgqS1/xLlsMpmctF4TIpAusaqvbOnR0HcbMK/2Q==
X-Received: by 2002:adf:e7cf:: with SMTP id e15mr10244543wrn.346.1617288513395;
        Thu, 01 Apr 2021 07:48:33 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 16/26] io_uring: store reg buffer end instead of length
Date:   Thu,  1 Apr 2021 15:43:55 +0100
Message-Id: <39164403fe92f1dc437af134adeec2423cdf9395.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's a bit more convenient for us to store a registered buffer end
address instead of length, see struct io_mapped_ubuf, as it allow to not
recompute it every time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 053baa4ca02e..bafe84ad5b32 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -194,7 +194,7 @@ enum io_uring_cmd_flags {
 
 struct io_mapped_ubuf {
 	u64		ubuf;
-	size_t		len;
+	u64		ubuf_end;
 	struct		bio_vec *bvec;
 	unsigned int	nr_bvecs;
 	unsigned long	acct_pages;
@@ -2783,7 +2783,7 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
-	if (buf_addr < imu->ubuf || buf_end > imu->ubuf + imu->len)
+	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
 		return -EFAULT;
 
 	/*
@@ -8296,7 +8296,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	}
 	/* store original address for later verification */
 	imu->ubuf = ubuf;
-	imu->len = iov->iov_len;
+	imu->ubuf_end = ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	ret = 0;
 done:
@@ -9353,9 +9353,9 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
 		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+		unsigned int len = buf->ubuf_end - buf->ubuf;
 
-		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
-						(unsigned int) buf->len);
+		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, len);
 	}
 	if (has_lock && !xa_empty(&ctx->personalities)) {
 		unsigned long index;
-- 
2.24.0

