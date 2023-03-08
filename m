Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AFD6AFD40
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 04:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCHDKm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 22:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCHDKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 22:10:39 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021F3A6BDC
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 19:10:39 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id bo22so15326451pjb.4
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 19:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678245038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpOYI77LDBDSfPAfwwRt1IR4K3PYUasWejfFHEWKzrs=;
        b=28A1NjE30HTD+asdxPYf8DzArFMcDjuiPdxuZMzIxfeDsw7pDY5se8eryy8cWFVHfm
         jjwmTkIhTe2nCW+769jYilH2PSiDQZbhznHzbA20FqrCYz2sdSikQV8Uaml031aPa8tW
         3bmyxFUpaZyVQ1GCWPiEJUn36QANvNy17SYBljOfW6f2k832AhkKg7gJ8udbx/34bBQD
         Jf1tTe+sUjRoupjef+6PO5eVImawNPAzfLOv4jOiShmfGz6fRFCIqp/GtO3pojm5IzXh
         oNYWnr3YxGhRMT7RRHJbo/8BokHhIUl/flLjVqd2J8fYKJ7OCYBvubrH+KGnGERYRNiO
         dixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678245038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kpOYI77LDBDSfPAfwwRt1IR4K3PYUasWejfFHEWKzrs=;
        b=yd4SIYmJ89AySeIiEjjJN/ZJpXNXUM1MHtWND03pZLcozQUU6QLFueW/c3AUkNCs8K
         +WbtohvzGji3dlVON3EZK/8hVA6yflye2/bjRA26Nrcyfs4K/0L7Q9EBIoeqejdPoG9w
         7M+1DAmYuRXAgj1QHvSXlFWa+2gahoTy4Zhd86tHKKVIDi4A9ak/j0KmOf2UmxFkCdAu
         8/a3nt2blj1REgGlie00nZpujf0Z7foQEg9T8sCfdea/v4UcWRcf47H6D3Pg44QtR3Rx
         XHPlYq+pmUmN9qmjxsFzzxWe0klgsQfAeZ3WSOPlpwJtOBBA4YoQLJWKuMyitquPmn0p
         STbw==
X-Gm-Message-State: AO0yUKVxWXme0qpbMJTgFjesWk0J2vmVOm9zxi0yktFDnsJFGng6edIZ
        gHj6nyb2SluqHK2qV0xTuFa8kazdvRjpn2u8s3E=
X-Google-Smtp-Source: AK7set9P/NvInaGn9QDKHdaeF4xOJEM57oUTET3ZmNIBvpz6ZjXYEssRa+eP6vFHJhPaurfm6lvLJw==
X-Received: by 2002:a17:90a:9805:b0:230:dc97:9da2 with SMTP id z5-20020a17090a980500b00230dc979da2mr12906048pjo.1.1678245038157;
        Tue, 07 Mar 2023 19:10:38 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id o44-20020a17090a0a2f00b0023440af7aafsm7995806pjo.9.2023.03.07.19.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 19:10:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] pipe: enable handling of IOCB_NOWAIT
Date:   Tue,  7 Mar 2023 20:10:32 -0700
Message-Id: <20230308031033.155717-3-axboe@kernel.dk>
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

In preparation for enabling FMODE_NOWAIT for pipes, ensure that the read
and write path handle it correctly. This includes the pipe locking,
page allocation for writes, and confirming pipe buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/pipe.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 340f253913a2..10366a6cb5b6 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -108,6 +108,16 @@ static inline void __pipe_unlock(struct pipe_inode_info *pipe)
 	mutex_unlock(&pipe->mutex);
 }
 
+static inline bool __pipe_trylock(struct pipe_inode_info *pipe, bool nonblock)
+{
+	if (!nonblock) {
+		__pipe_lock(pipe);
+		return true;
+	}
+
+	return mutex_trylock(&pipe->mutex);
+}
+
 void pipe_double_lock(struct pipe_inode_info *pipe1,
 		      struct pipe_inode_info *pipe2)
 {
@@ -234,6 +244,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 	struct file *filp = iocb->ki_filp;
 	struct pipe_inode_info *pipe = filp->private_data;
 	bool was_full, wake_next_reader = false;
+	const bool nonblock = iocb->ki_flags & IOCB_NOWAIT;
 	ssize_t ret;
 
 	/* Null read succeeds. */
@@ -241,7 +252,8 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 		return 0;
 
 	ret = 0;
-	__pipe_lock(pipe);
+	if (!__pipe_trylock(pipe, nonblock))
+		return -EAGAIN;
 
 	/*
 	 * We only wake up writers if the pipe was full when we started
@@ -297,7 +309,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 				chars = total_len;
 			}
 
-			error = pipe_buf_confirm(pipe, buf, false);
+			error = pipe_buf_confirm(pipe, buf, nonblock);
 			if (error) {
 				if (!ret)
 					ret = error;
@@ -342,7 +354,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 			break;
 		if (ret)
 			break;
-		if (filp->f_flags & O_NONBLOCK) {
+		if (filp->f_flags & O_NONBLOCK || nonblock) {
 			ret = -EAGAIN;
 			break;
 		}
@@ -423,12 +435,14 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t chars;
 	bool was_empty = false;
 	bool wake_next_writer = false;
+	const bool nonblock = iocb->ki_flags & IOCB_NOWAIT;
 
 	/* Null write succeeds. */
 	if (unlikely(total_len == 0))
 		return 0;
 
-	__pipe_lock(pipe);
+	if (!__pipe_trylock(pipe, nonblock))
+		return -EAGAIN;
 
 	if (!pipe->readers) {
 		send_sig(SIGPIPE, current, 0);
@@ -461,7 +475,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 
 		if ((buf->flags & PIPE_BUF_FLAG_CAN_MERGE) &&
 		    offset + chars <= PAGE_SIZE) {
-			ret = pipe_buf_confirm(pipe, buf, false);
+			ret = pipe_buf_confirm(pipe, buf, nonblock);
 			if (ret)
 				goto out;
 
@@ -493,9 +507,13 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 			int copied;
 
 			if (!page) {
-				page = alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
+				gfp_t gfp = __GFP_HIGHMEM | __GFP_ACCOUNT;
+
+				if (!nonblock)
+					gfp |= GFP_USER;
+				page = alloc_page(gfp);
 				if (unlikely(!page)) {
-					ret = ret ? : -ENOMEM;
+					ret = ret ? : nonblock ? -EAGAIN : -ENOMEM;
 					break;
 				}
 				pipe->tmp_page = page;
@@ -547,7 +565,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 			continue;
 
 		/* Wait for buffer space to become available. */
-		if (filp->f_flags & O_NONBLOCK) {
+		if (filp->f_flags & O_NONBLOCK || nonblock) {
 			if (!ret)
 				ret = -EAGAIN;
 			break;
-- 
2.39.2

