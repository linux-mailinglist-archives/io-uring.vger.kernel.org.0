Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C596B9A12
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjCNPne (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 11:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjCNPn1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 11:43:27 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C30ABAD5
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 08:42:51 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b5so6594286iow.0
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 08:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678808529; x=1681400529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=liEFlhj9atWxP2u7wDB3eK25KtuisU4QO9XIRpFBzUc=;
        b=aUk4rMr3O34KcutFdLv2Z4dSVeYNire/xwDMd+7M4e/YT0lB1swSwGg5tvQHH3I1Rl
         hHbtMGlhGrqPiyMgIWt/+LwGHsgjPwBHd78vswIR9N3TKxAg8zvURRj6XrDBzNgzucrG
         3v3MSL3PmWkDnVlj5tnRsQGcCTpjO3koQ8PLFGDjj0xLru6tscK2NemnoRuCCcfR6px8
         DLDulZeQDqlY484OstVTzmhQlI4T2TZMpUxqDFvHLbw4WPuuG41DegBKO3K5sFVVSySl
         Hx4E1X+JZFTXDPNrsqzDCrGSUquLg+y+jWvPyC/fTUyJ1Ldghbl60XJ0NXf1XIlUmhhz
         vnGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808529; x=1681400529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=liEFlhj9atWxP2u7wDB3eK25KtuisU4QO9XIRpFBzUc=;
        b=Nz1H1riKW/+c6rnWD4KR5LWSw+n+ci5p71hhCk6dxohPyDizm6PkncK3hr2kE/WapH
         q5V+ZLIoRAPaV19RP9gvnPBca8H3kfSAE9AHRzYX4ube8mDDTZ8XxtNrs6HqSKwfUUlH
         DXk3FnEnOEq6PViOcSwxHatHolj1b1pCGvgbLCWFYwzoHs8TY7mVatBjRbnc2mVVmk2x
         eVYeEpXfuLGOce41KCn3WN4xqT1Rc3Imu/R1Nfl9rlhOsuhrjYUMlEC4KLNLHeKMmoMs
         gZ0x9aqaUrxiWUbmZHZpzQEn0U2vVruOsOVt4kcWLLWvmo7YJNcEoAlJV7jQWMEIRJBV
         7FpA==
X-Gm-Message-State: AO0yUKVXBnSaWzYWFOUr55KMA+JJxDUlNFJc6I0vIo/NnDAM16SLRU/H
        iQE+wmIqmniUwQyujuZaLw6dKk2/TW62g3yjyzObqQ==
X-Google-Smtp-Source: AK7set8frZ4yBNFKjne/psikbHfSc8IFowJLBufPfBna7UvIK53NeKtZa98q/eYiR+l6QH/nz0uv2A==
X-Received: by 2002:a6b:5d10:0:b0:752:dcbc:9f12 with SMTP id r16-20020a6b5d10000000b00752dcbc9f12mr662265iob.2.1678808528945;
        Tue, 14 Mar 2023 08:42:08 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u9-20020a02cb89000000b003b0692eb199sm867929jap.20.2023.03.14.08.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:42:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     brauner@kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 1/3] fs: add 'nonblock' parameter to pipe_buf_confirm() and fops method
Date:   Tue, 14 Mar 2023 09:42:01 -0600
Message-Id: <20230314154203.181070-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314154203.181070-1-axboe@kernel.dk>
References: <20230314154203.181070-1-axboe@kernel.dk>
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

Acked-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
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
index 2c3dec2b6dfa..130ee1052588 100644
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

