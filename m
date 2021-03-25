Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8303492D9
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhCYNND (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhCYNMb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:31 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915D6C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:31 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j18so2253304wra.2
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZB5suhXyzVib0kj9RwE5sak4TpA3/HAOUFJ8JTcy+ro=;
        b=f5QWk0LstXrHGTi1fmvCSxt5+RR8/Ul2EfnfvHhkeLp3mOoLuMmPsQRLaVMtjYDly8
         cgRigI62oBEf2W/tUyKWcoAG6pa0emGiLvIzfeAUDjllgwFQo9ZaJdYxP4oD+rAoQx+E
         G1E77WXSyebQ4EiJ265WZZCE3HnubOyCDD3BjJ6Fdpo2LatFr3PIC+fvIU//8ovDk9D9
         MwzAQP2+YMvjrkMGbV+fc0jaPFnwZXY9kjcTkJL5FGf1tdzmGnPZ6mhf3hk20YjDrQrx
         6fNkmQgfRpoNRv1w0pc+EaVD4pXsShl949qDauCqXDjKZddfWiFrQT29d2gOx3isdqYL
         kk9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZB5suhXyzVib0kj9RwE5sak4TpA3/HAOUFJ8JTcy+ro=;
        b=rcoqR4RmFxxsAnsmi+fK6eWvX+JT55AJhbQQmPsTgA73O7HzFqxV09ffK9HJDKXy+B
         mh+G3WIpmwUwN3DCp9XFGaQ7yq0q0nvryRkpiM5nuwcb+dkbt/k/xyCsQNrFU6ivC84O
         yNbcWujYQC1YdTRJd49RKefhOguK734O+7upuJNseiYV+Uz0y51uYW5QKj7ApRoh6MOD
         Y0giCFzWq035twq+rWf2vZrGLI2Q2997y1pYgm3nqQFNaaQ01bDUF+iqq+A5f08PyNPC
         4vRnpOgEBAgLO7vXc6QDlUTfdzcYJBrmPf0wudcQkK43sw/C3I/ZPzyE5VVPzws7xRhT
         ZD8Q==
X-Gm-Message-State: AOAM533mfHpN0MRdxrI7ErzqNVy9atk6gvEfxWHVJRg43tdP4LoZ7jwu
        EVhUbNAiS9TBe/5MpQl38X3AmZc4Wz27iQ==
X-Google-Smtp-Source: ABdhPJzyGYOVboihzsTBVRTvny3bzLl46I9kMj6mTNdSzFBe/fp39HySl/9z07hVY21byoEHB4yLXg==
X-Received: by 2002:adf:e548:: with SMTP id z8mr9093298wrm.246.1616677950376;
        Thu, 25 Mar 2021 06:12:30 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 16/17] io_uring: store reg buffer end instead of length
Date:   Thu, 25 Mar 2021 13:08:05 +0000
Message-Id: <c42906ff1d5565479652ac9769c4c52ce1a70184.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
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
index f30580f59070..9f062bddae31 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -195,7 +195,7 @@ enum io_uring_cmd_flags {
 
 struct io_mapped_ubuf {
 	u64		ubuf;
-	size_t		len;
+	u64		ubuf_end;
 	struct		bio_vec *bvec;
 	unsigned int	nr_bvecs;
 	unsigned long	acct_pages;
@@ -2814,7 +2814,7 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
-	if (buf_addr < imu->ubuf || buf_end > imu->ubuf + imu->len)
+	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
 		return -EFAULT;
 
 	/*
@@ -8186,7 +8186,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	}
 	/* store original address for later verification */
 	imu->ubuf = ubuf;
-	imu->len = iov->iov_len;
+	imu->ubuf_end = ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	ret = 0;
 done:
@@ -9222,9 +9222,9 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
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

