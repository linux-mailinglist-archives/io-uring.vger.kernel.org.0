Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DF26AE542
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 16:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjCGPqL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 10:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjCGPp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 10:45:56 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FB987355
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 07:45:41 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so1835238pjb.0
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 07:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678203940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xen20QJUue872g0lnWjwc3CNbhV57KgNKilPvGYp6G4=;
        b=NPmwkPwyjdsquHAwVWEA1DZMdmflFyir+hoRLG5uCmpMFapZwHKZo2aaXvva0kRNzl
         +pgef18RtYyHRSrU2Zu3MsW1PY3HjNkolLaGmaVqFMpPcntnFnKoCk5jYuwsNvKyUE7N
         bxCNcjtEg8NlIxHQyNmsRRAZ1K42yGEQhN8aGx9UNeM0CTyjJdOYGIIZ6bHA8wpay2AW
         kBvUqymXMZGce22QiBpC4SjEK2Jvp1p3yJpUR1u/CS3NHaYnA3+mlb+B9jbdW67n8fNo
         k7fkFCK8W+wbIS8QXjYGd5GJL1EmIiEKfJNWjOfIdzVH5qXNhL937K1CMg1hswJrB2KK
         43DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678203940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xen20QJUue872g0lnWjwc3CNbhV57KgNKilPvGYp6G4=;
        b=Oi6xp9fyuFQ8J2y/sCevtyVK5U7T5/wV0lwuOXsKyE9LMZ/0LdymnyUhUKFitd9TV3
         dyp2lR4LKTS6tti0yw+o8dRoxtC2FESGeK/GYUnTvYeXrFKURr/t5w1vwavU+FIN+8QM
         2K24zuvueVda5gw8U6TUOopvzMPEz6izqLnd1YrIbfk1dp9tbo1kym7vwn8t5uYTNkj9
         fcGishg3MrJDZhusk79ce6nMZS4vS161KRu5SLkNlddjFjMVqJ9YY+Vr2zgs55sjbzvS
         jOIAJ712D/OHWvee9myOIpYG8X8W2xIiBs9u3Iw0AXREYdHTJVa9dbjxDl6Tgv5U7WY3
         zMmA==
X-Gm-Message-State: AO0yUKXT4+vWILYnGyE8AkzNDn/ZbgzhSyY59da4Ezl5eyIwWePzyQQo
        sdQbQTvQz0SNpudZqwP/CyYCF5HIfJe13zEse4U=
X-Google-Smtp-Source: AK7set8qrbyGl0s8gaUtBtrp5mOfgjhX6/LX/oeCc9tma1UBFwmwMulLA9iHA+g3ARDPnb2acQ96Fg==
X-Received: by 2002:a17:902:e743:b0:19e:b5d3:170d with SMTP id p3-20020a170902e74300b0019eb5d3170dmr11331892plf.0.1678203939767;
        Tue, 07 Mar 2023 07:45:39 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id kl15-20020a170903074f00b0019945535973sm8612359plb.63.2023.03.07.07.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 07:45:39 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     brauner@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: assume read_iter/write_iter are safe for nonblocking
Date:   Tue,  7 Mar 2023 08:45:33 -0700
Message-Id: <20230307154533.11164-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307154533.11164-1-axboe@kernel.dk>
References: <20230307154533.11164-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All read_iter/write_iter must check IOCB_NOWAIT like they check for
O_NONBLOCK, and return -EAGAIN if we need to be sleeping.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/filetable.h |  4 ++--
 io_uring/io_uring.c  | 13 +++++++++----
 io_uring/rw.c        |  2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 351111ff8882..e221b5b9134f 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -21,7 +21,7 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset);
 int io_register_file_alloc_range(struct io_ring_ctx *ctx,
 				 struct io_uring_file_index_range __user *arg);
 
-unsigned int io_file_get_flags(struct file *file);
+unsigned int io_file_get_flags(struct file *file, fmode_t fmode);
 
 static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
 {
@@ -56,7 +56,7 @@ static inline void io_fixed_file_set(struct io_fixed_file *file_slot,
 {
 	unsigned long file_ptr = (unsigned long) file;
 
-	file_ptr |= io_file_get_flags(file);
+	file_ptr |= io_file_get_flags(file, file->f_mode);
 	file_slot->file_ptr = file_ptr;
 }
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fd1cc35a1c00..1592faec41e2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -422,7 +422,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
 	if (req->file && !io_req_ffs_set(req))
-		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
+		req->flags |= io_file_get_flags(req->file, 0) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
@@ -1719,7 +1719,8 @@ static bool io_bdev_nowait(struct block_device *bdev)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-static bool __io_file_supports_nowait(struct file *file, umode_t mode)
+static bool __io_file_supports_nowait(struct file *file, umode_t mode,
+				      fmode_t fmode)
 {
 	if (S_ISBLK(mode)) {
 		if (IS_ENABLED(CONFIG_BLOCK) &&
@@ -1740,6 +1741,10 @@ static bool __io_file_supports_nowait(struct file *file, umode_t mode)
 	/* any ->read/write should understand O_NONBLOCK */
 	if (file->f_flags & O_NONBLOCK)
 		return true;
+	if (fmode & FMODE_READ && file->f_op->read_iter)
+		return true;
+	if (fmode & FMODE_WRITE && file->f_op->write_iter)
+		return true;
 	return file->f_mode & FMODE_NOWAIT;
 }
 
@@ -1748,14 +1753,14 @@ static bool __io_file_supports_nowait(struct file *file, umode_t mode)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-unsigned int io_file_get_flags(struct file *file)
+unsigned int io_file_get_flags(struct file *file, fmode_t fmode)
 {
 	umode_t mode = file_inode(file)->i_mode;
 	unsigned int res = 0;
 
 	if (S_ISREG(mode))
 		res |= FFS_ISREG;
-	if (__io_file_supports_nowait(file, mode))
+	if (__io_file_supports_nowait(file, mode, fmode))
 		res |= FFS_NOWAIT;
 	return res;
 }
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4c233910e200..33c87eb061d2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -668,7 +668,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		return -EBADF;
 
 	if (!io_req_ffs_set(req))
-		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
+		req->flags |= io_file_get_flags(file, mode) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	kiocb->ki_flags = file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags);
-- 
2.39.2

