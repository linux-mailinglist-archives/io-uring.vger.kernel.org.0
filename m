Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A0342F7C0
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241125AbhJOQMZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241138AbhJOQMT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B72C061764
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:12 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e12so27390137wra.4
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P27WwlbaRMrLJEtxDFd0/GcO8h2SiXJYPH50hcUsc4Q=;
        b=fV6fFgtmguLZWjYSXA1sXHqJk+1m/+S9QKa/tN8wFPP1T2HXkI4xgX1F896+H24Qfk
         KdsMYoyDRylySlfDeIDLL65eZKQXUtZ78NzC0JGpN9Rf5cwZicWiAkfJSXzXvYNZfNIB
         m/ZEzsYW4tSSlRal77gLIQhMORp698zF35eL58B6+mGMChX+xoUSWzRSAf2XxAkNg0X+
         k8LvjXEYDb4n82NCAufEIhyW4CqwTxN5zyLdE1w3+Om5d9bvEy33Kpd2wbCnvl4QXgyo
         GZXbYw5NarDVn+S1Whti6veNolVbLDV2MK0mEoZzeyWKF6yQ/+AXqIaBakWGZQdvTrAg
         9Xmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P27WwlbaRMrLJEtxDFd0/GcO8h2SiXJYPH50hcUsc4Q=;
        b=okZZdu1nEIPkbzJDpHP8J4/dv1h65Q9/Xsuj2v2UaQ7PlvOLj8idyvsq3LBnTyDRj3
         wQmEZg4ILAleAK/oLSLYW19Xqa6S2aDliJLX3iAaatKpVnaTgfvBjGJs86rJeKzJ5IOe
         tR7gjXIqHRbOHDd8SdHVxuJexiS4+unBKNQPWNfyGrGUrjpCIKXK5yDWxnfDWzliF1ka
         /Gtzg2fuD8cknBrwu/OJzGewM6F94EVkV23HXYXtBIa9f3ZQhPRQuv+a8Cjq2gfd0sFp
         0FuiZfHeZ86SD/7SLx20yAbAQB2K4BSZrUaALeC8qvmLL9y5Qnoa8GlmmQIsE1fs2K4L
         eGPw==
X-Gm-Message-State: AOAM531pdgj1H6UxxpHP7feeNVmWmvXcj9Q8Tra9tmxa+sQjuiamKtUh
        8NgskGd9SEIJEW+EYfPxFnkCTW05kAg=
X-Google-Smtp-Source: ABdhPJyFFzJYhV68hxj3C12MzcCyn+rpL83eB3POAwC7pn5tiiHQW8KqlZzJsU19MF1enN/j07tq1w==
X-Received: by 2002:a05:6000:1289:: with SMTP id f9mr15622263wrx.192.1634314211029;
        Fri, 15 Oct 2021 09:10:11 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 8/8] io_uring: simplify io_file_supports_nowait()
Date:   Fri, 15 Oct 2021 17:09:18 +0100
Message-Id: <b364bdf0dc7a8c39802b7274f741482cbe7611d9.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure that REQ_F_SUPPORT_NOWAIT is always set io_prep_rw(), and so
we can stop caring about setting it down the line simplifying
io_file_supports_nowait().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c9acb4d2a1ff..b6f7fb5c910b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2767,10 +2767,8 @@ static bool io_bdev_nowait(struct block_device *bdev)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-static bool __io_file_supports_nowait(struct file *file)
+static bool __io_file_supports_nowait(struct file *file, umode_t mode)
 {
-	umode_t mode = file_inode(file)->i_mode;
-
 	if (S_ISBLK(mode)) {
 		if (IS_ENABLED(CONFIG_BLOCK) &&
 		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
@@ -2793,11 +2791,26 @@ static bool __io_file_supports_nowait(struct file *file)
 	return file->f_mode & FMODE_NOWAIT;
 }
 
+/*
+ * If we tracked the file through the SCM inflight mechanism, we could support
+ * any file. For now, just ensure that anything potentially problematic is done
+ * inline.
+ */
+static unsigned int io_file_get_flags(struct file *file)
+{
+	umode_t mode = file_inode(file)->i_mode;
+	unsigned int res = 0;
+
+	if (S_ISREG(mode))
+		res |= FFS_ISREG;
+	if (__io_file_supports_nowait(file, mode))
+		res |= FFS_NOWAIT;
+	return res;
+}
+
 static inline bool io_file_supports_nowait(struct io_kiocb *req)
 {
-	if (likely(req->flags & REQ_F_SUPPORT_NOWAIT))
-		return true;
-	return __io_file_supports_nowait(req->file);
+	return req->flags & REQ_F_SUPPORT_NOWAIT;
 }
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
@@ -2809,8 +2822,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	unsigned ioprio;
 	int ret;
 
-	if (!io_req_ffs_set(req) && S_ISREG(file_inode(file)->i_mode))
-		req->flags |= REQ_F_ISREG;
+	if (!io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 	if (kiocb->ki_pos == -1 && !(file->f_mode & FMODE_STREAM)) {
@@ -6767,10 +6780,7 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
 {
 	unsigned long file_ptr = (unsigned long) file;
 
-	if (__io_file_supports_nowait(file))
-		file_ptr |= FFS_NOWAIT;
-	if (S_ISREG(file_inode(file)->i_mode))
-		file_ptr |= FFS_ISREG;
+	file_ptr |= io_file_get_flags(file);
 	file_slot->file_ptr = file_ptr;
 }
 
-- 
2.33.0

