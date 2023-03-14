Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2C46B9A15
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 16:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjCNPnh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 11:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjCNPnc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 11:43:32 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A536E62853
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 08:42:52 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id s7so1233029ilv.12
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 08:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678808530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3FVhcqNffmfR5JCmg47xgwx5RA3GsCizvE3AY6V6/M=;
        b=yb1EKM8V8tRfeCVAglluf4yfTQXoJ0BfzotzgCGLkbQX6VDsv+dZk7QpnAJ8Fe9W5Z
         oFLXjyDH+LpMxZScMml4HKXC4K9AOlrCeukAi35l9D1pv0RwroIJRsIFeN5+jk0TowL7
         FFOKezYGSJeS+9jhnygOFqDIJS+Y3ljwwGsLkQxYfKcfqypMswDAQ3rWlztGcHFnUG/9
         dzrBURRCGOg/ClXofbHC9pvFanZ587E/zgforYw6stuQRbJxjqKPVRqeIEAHxx3MaW8k
         vXP8sf5Zzr+DWRMQOmsikydnDF+4LKtYZE+8OM6pMIDMYWAJ2Hd8r/8jsME5KkuLEEnT
         2jbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E3FVhcqNffmfR5JCmg47xgwx5RA3GsCizvE3AY6V6/M=;
        b=WWOWmonVRx//r9Gqf2mt90XdO7xyIhR04qyLyIrj0sEZrYp5EZTy4k51Jm9h72BeWE
         YSL7n5WhLwVKw7LtCnyGdAYgoHFHaQ+peNsy+AbXT0A4pqpNr24qHZvQJdkDmXJa80X4
         A217oFP2lp2uA71EsPYsOa8T6UEXkNfprkYt9vQffZHQEZnyxygCK16pWVREDIy7Ow3l
         LT+vuKe73G9rgwwCQBCWtL+LWCN3oWaOSeQevEsTggSy5rzUzyo5ZUUL7HMWhXUzaG3N
         zHMnSgFpFAsmAZg+0OPO36Nwn74efAGB1fdtz4lmx41fa6jYyK1OJ7+jaE0c1Vow9SkL
         pPlw==
X-Gm-Message-State: AO0yUKUketeAB4ocjo2RUCGaA0Aq9qoXk/VQx6DzU5JVg68g4Twi7UIJ
        EQT4Q75p+qcz7DILI+pItzXhziAroHZFAjXf7teW7Q==
X-Google-Smtp-Source: AK7set9P4LeTrGDzUavLg5g2GgFP6N6RZonNdfvCtsjldCGyDmcHY8Zk5oGt3RhETk3T8MiPhhbjQQ==
X-Received: by 2002:a92:b10d:0:b0:319:9153:3750 with SMTP id t13-20020a92b10d000000b0031991533750mr9874768ilh.1.1678808530072;
        Tue, 14 Mar 2023 08:42:10 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u9-20020a02cb89000000b003b0692eb199sm867929jap.20.2023.03.14.08.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:42:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     brauner@kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 2/3] pipe: enable handling of IOCB_NOWAIT
Date:   Tue, 14 Mar 2023 09:42:02 -0600
Message-Id: <20230314154203.181070-3-axboe@kernel.dk>
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

In preparation for enabling FMODE_NOWAIT for pipes, ensure that the read
and write path handle it correctly. This includes the pipe locking,
page allocation for writes, and confirming pipe buffers.

Acked-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/pipe.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 340f253913a2..dc00b20e56c8 100644
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
 
@@ -493,9 +507,18 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 			int copied;
 
 			if (!page) {
-				page = alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
+				gfp_t gfp = __GFP_HIGHMEM | __GFP_ACCOUNT |
+					    __GFP_HARDWALL;
+				int this_ret = -EAGAIN;
+
+				if (!nonblock) {
+					this_ret = -ENOMEM;
+					gfp |= GFP_USER;
+				}
+				page = alloc_page(gfp);
 				if (unlikely(!page)) {
-					ret = ret ? : -ENOMEM;
+					if (!ret)
+						ret = this_ret;
 					break;
 				}
 				pipe->tmp_page = page;
@@ -547,7 +570,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 			continue;
 
 		/* Wait for buffer space to become available. */
-		if (filp->f_flags & O_NONBLOCK) {
+		if (filp->f_flags & O_NONBLOCK || nonblock) {
 			if (!ret)
 				ret = -EAGAIN;
 			break;
-- 
2.39.2

