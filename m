Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8E86AFD3E
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 04:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCHDKl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 22:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCHDKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 22:10:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B26A729B
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 19:10:37 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id p6so16496960plf.0
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 19:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678245037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FB0AlMXXyfbVB/DAeV/LMnWywE/8dZnz2/fFoG7xdHE=;
        b=SF75gIG+NWJnuHTSctHio4NqNZbahLtPmGtOfMudXUmkStMSOKugh7Ag20L69OeJa4
         17yK6xGWC2pAx0Vw30Sgu2785XpsDWdzMCBaxg1MPOYhNxPKS6ZEqpDSsS16hlKqgT9A
         Lk9aMUF0FXnQa2gFaAEc6NMRpaZAMjpUho7Xmsa1E4BmiKmeECaHtojZcuCgrCsaj36a
         4PuOoI9tqjzsg548d7t1W/YYaV+i7/+c1zWpjfLAwu7t9dI0lGjnSNg+GCIeUutEw/9D
         C48SipNDEJQvHbbqb2mxGveA0zWKzdS2wjLqL7rYNssnFrvcl1Gk8pkRPnpVwkD6CuQz
         3pbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678245037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FB0AlMXXyfbVB/DAeV/LMnWywE/8dZnz2/fFoG7xdHE=;
        b=qNQyUvUvsQ5+6Oz8Tov3f3ledyP1KF+VgdGK4wNXBVJtznh7GeC0HIficI8mmUKWuV
         GXDIxfY13O2FMrHqVa+bCf6TTP/+LgSnZ1owq6YSjRZuDoNCQ/fH36vaPAarRMwRVvZi
         d8NoNfoIqekmfMmXzr2lnOtTWbFd1hFBpkGaoduQIBO/pJsZ5xZ0bXmoONklBWuPoKpu
         7gMIvk8GhasTcidfQGm/FLornOm6OJnk5DuuCbGBgpfQCwDdB6yYeaxXXApb3JtqlN4A
         nloU9OIi7a49PjLY2I2mouN7wd8useSmP3WHvWFQvxtgiuoDkQcixTinw4M4iE+6JTvC
         Vh/w==
X-Gm-Message-State: AO0yUKUbCNwnpKbpT6pJrMqkfc56wF41AWjRFGR8pBF1rFC5fRoBAVaf
        Q7Lu+T0pRg33Y02lh0rulNGzeJ2V+rtt/twf9Gc=
X-Google-Smtp-Source: AK7set/o4+EhRBnpK7QuvDVJy4zTXRltjIkts8JDuPfLAYO1AwQc1dY0ZGqKId2Ebs+sELlpdRd64g==
X-Received: by 2002:a17:90a:8d13:b0:234:b170:1f27 with SMTP id c19-20020a17090a8d1300b00234b1701f27mr12042521pjo.0.1678245037104;
        Tue, 07 Mar 2023 19:10:37 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id o44-20020a17090a0a2f00b0023440af7aafsm7995806pjo.9.2023.03.07.19.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 19:10:36 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] fs: add 'nonblock' parameter to pipe_buf_confirm() and fops method
Date:   Tue,  7 Mar 2023 20:10:31 -0700
Message-Id: <20230308031033.155717-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308031033.155717-1-axboe@kernel.dk>
References: <20230308031033.155717-1-axboe@kernel.dk>
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

In preparation for being able to do a nonblocking confirm attempt of a
pipe buffer, plumb a parameter through the stack to indicate if this is
a nonblocking attempt or not.

Each caller is passing down 'false' right now, but the only confirm
method in the tree, page_cache_pipe_buf_confirm(), is converted to do a
trylock_page() if nonblock == true.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/fuse/dev.c             |  4 ++--
 fs/pipe.c                 |  4 ++--
 fs/splice.c               | 11 +++++++----
 include/linux/pipe_fs_i.h |  7 ++++---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index eb4f88e3dc97..0bd1b0870f2d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -700,7 +700,7 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
 		struct pipe_buffer *buf = cs->pipebufs;
 
 		if (!cs->write) {
-			err = pipe_buf_confirm(cs->pipe, buf);
+			err = pipe_buf_confirm(cs->pipe, buf, false);
 			if (err)
 				return err;
 
@@ -800,7 +800,7 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 
 	fuse_copy_finish(cs);
 
-	err = pipe_buf_confirm(cs->pipe, buf);
+	err = pipe_buf_confirm(cs->pipe, buf, false);
 	if (err)
 		goto out_put_old;
 
diff --git a/fs/pipe.c b/fs/pipe.c
index 42c7ff41c2db..340f253913a2 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -297,7 +297,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 				chars = total_len;
 			}
 
-			error = pipe_buf_confirm(pipe, buf);
+			error = pipe_buf_confirm(pipe, buf, false);
 			if (error) {
 				if (!ret)
 					ret = error;
@@ -461,7 +461,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 
 		if ((buf->flags & PIPE_BUF_FLAG_CAN_MERGE) &&
 		    offset + chars <= PAGE_SIZE) {
-			ret = pipe_buf_confirm(pipe, buf);
+			ret = pipe_buf_confirm(pipe, buf, false);
 			if (ret)
 				goto out;
 
diff --git a/fs/splice.c b/fs/splice.c
index 2e76dbb81a8f..5ae6b4a202df 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -100,13 +100,16 @@ static void page_cache_pipe_buf_release(struct pipe_inode_info *pipe,
  * is a page cache page, IO may be in flight.
  */
 static int page_cache_pipe_buf_confirm(struct pipe_inode_info *pipe,
-				       struct pipe_buffer *buf)
+				       struct pipe_buffer *buf, bool nonblock)
 {
 	struct page *page = buf->page;
 	int err;
 
 	if (!PageUptodate(page)) {
-		lock_page(page);
+		if (nonblock && !trylock_page(page))
+			return -EAGAIN;
+		else
+			lock_page(page);
 
 		/*
 		 * Page got truncated/unhashed. This will cause a 0-byte
@@ -498,7 +501,7 @@ static int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_des
 		if (sd->len > sd->total_len)
 			sd->len = sd->total_len;
 
-		ret = pipe_buf_confirm(pipe, buf);
+		ret = pipe_buf_confirm(pipe, buf, false);
 		if (unlikely(ret)) {
 			if (ret == -ENODATA)
 				ret = 0;
@@ -761,7 +764,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 				continue;
 			this_len = min(this_len, left);
 
-			ret = pipe_buf_confirm(pipe, buf);
+			ret = pipe_buf_confirm(pipe, buf, false);
 			if (unlikely(ret)) {
 				if (ret == -ENODATA)
 					ret = 0;
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index d2c3f16cf6b1..d63278bb0797 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -100,7 +100,8 @@ struct pipe_buf_operations {
 	 * hook. Returns 0 for good, or a negative error value in case of
 	 * error.  If not present all pages are considered good.
 	 */
-	int (*confirm)(struct pipe_inode_info *, struct pipe_buffer *);
+	int (*confirm)(struct pipe_inode_info *, struct pipe_buffer *,
+			bool nonblock);
 
 	/*
 	 * When the contents of this pipe buffer has been completely
@@ -209,11 +210,11 @@ static inline void pipe_buf_release(struct pipe_inode_info *pipe,
  * @buf:	the buffer to confirm
  */
 static inline int pipe_buf_confirm(struct pipe_inode_info *pipe,
-				   struct pipe_buffer *buf)
+				   struct pipe_buffer *buf, bool nonblock)
 {
 	if (!buf->ops->confirm)
 		return 0;
-	return buf->ops->confirm(pipe, buf);
+	return buf->ops->confirm(pipe, buf, nonblock);
 }
 
 /**
-- 
2.39.2

