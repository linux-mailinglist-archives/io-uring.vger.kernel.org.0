Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A619912819F
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2019 18:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTRrq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Dec 2019 12:47:46 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:38509 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLTRrq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Dec 2019 12:47:46 -0500
Received: by mail-il1-f194.google.com with SMTP id f5so8654795ilq.5
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 09:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=toYbZ9nsYURizkZNrcDLJ0JCrFbz/r75TjxzKNeXVAQ=;
        b=DSsuF2RCz9cCuMSuHdv62qT3C54RJ7zF8K7yiCzE5Cfzx2Q+PnMnWyMcsLFtQ8N6sv
         3DATJdTWGwJNeBSDlcdqnE8Lr4xWpVZItveCyAiJh3HF40fPvcoZACcH3fJEXbBpqRAG
         bIhWQKTNf7rYTTHk61zDm9cOg4mQcZZrDhHnfnk2UY9+ZZUoxXylsPi8UnxuFTE18wPs
         i+fOBVoaz5zMs1nMvBao6I5u+xEeTQAt0CyYQDm66YqPQnUXn1c7PaVDjtXqAcABzoaS
         qrvDj2Wscy14vsNfuRRb8VYlLID/fJfYF38A9nVHruCTDybCqpr7WrYe7ZHzUr80rvq/
         fGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=toYbZ9nsYURizkZNrcDLJ0JCrFbz/r75TjxzKNeXVAQ=;
        b=m/k2CiGSCorUWqWjAA8w317I3bY1l4UyVXP0mQ0NfDQTWzrGf0ZWqRyJ+blsFZ5xRm
         W9sSfNqludOP0edWfP9ER+TOXuj8Xp49FaGrO2FsbeXK9dmsByeB2iLsNnq5ByIwgGHu
         r8b8HOPydU3cskWVMkEc1uDr++Se8robiQhMR/DIdifSoRNBBVID8ePR6k/wX+XlmcY8
         insly30au7dYrAwjbXg3t8VoIXCaW+hNwjPnnEhnryUlk9HTiFfxDR1VWJDYoEAXkU18
         llHSSeuJnK//use/WgEmtZvVbgJtiQT7eo8vL1ObxcyXEG0wnSl6U4gorC3+gOM3W24D
         8WLw==
X-Gm-Message-State: APjAAAXYpYM1FWRgzasv6loIgd5P5DshRbvDXIx9DWaTx6fYcqoq+pl8
        sC06fMFk33Xjm3HWHTZMkIeih4KaNasBiQ==
X-Google-Smtp-Source: APXvYqwB0e35NQaIOh63Ed9EjhaQ0Qmxn3rqyL8evlBQ3DmDLqLSe1zrV5R4sYQ76Eywffb9G8ZFXg==
X-Received: by 2002:a92:1553:: with SMTP id v80mr13774973ilk.49.1576864065273;
        Fri, 20 Dec 2019 09:47:45 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j88sm4969677ilf.83.2019.12.20.09.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:47:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] io_uring: use u64_to_user_ptr() consistently
Date:   Fri, 20 Dec 2019 10:47:36 -0700
Message-Id: <20191220174742.7449-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220174742.7449-1-axboe@kernel.dk>
References: <20191220174742.7449-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use it in some spots, but not consistently. Convert the rest over,
makes it easier to read as well.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f084e3cf835..7a23d2351be2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2157,7 +2157,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 	unsigned flags;
 
 	flags = READ_ONCE(sqe->msg_flags);
-	msg = (struct user_msghdr __user *)(unsigned long) READ_ONCE(sqe->addr);
+	msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	io->msg.iov = io->msg.fast_iov;
 	return sendmsg_copy_msghdr(&io->msg.msg, msg, flags, &io->msg.iov);
 #else
@@ -2239,7 +2239,7 @@ static int io_recvmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 	unsigned flags;
 
 	flags = READ_ONCE(sqe->msg_flags);
-	msg = (struct user_msghdr __user *)(unsigned long) READ_ONCE(sqe->addr);
+	msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	io->msg.iov = io->msg.fast_iov;
 	return recvmsg_copy_msghdr(&io->msg.msg, msg, flags, &io->msg.uaddr,
 					&io->msg.iov);
@@ -2273,8 +2273,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		else if (force_nonblock)
 			flags |= MSG_DONTWAIT;
 
-		msg = (struct user_msghdr __user *) (unsigned long)
-			READ_ONCE(sqe->addr);
+		msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 		if (req->io) {
 			kmsg = &req->io->msg;
 			kmsg->msg.msg_name = &addr;
@@ -2331,9 +2330,8 @@ static int io_accept_prep(struct io_kiocb *req)
 	if (sqe->ioprio || sqe->len || sqe->buf_index)
 		return -EINVAL;
 
-	accept->addr = (struct sockaddr __user *)
-				(unsigned long) READ_ONCE(sqe->addr);
-	accept->addr_len = (int __user *) (unsigned long) READ_ONCE(sqe->addr2);
+	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	req->flags |= REQ_F_PREPPED;
 	return 0;
@@ -2407,7 +2405,7 @@ static int io_connect_prep(struct io_kiocb *req, struct io_async_ctx *io)
 	struct sockaddr __user *addr;
 	int addr_len;
 
-	addr = (struct sockaddr __user *) (unsigned long) READ_ONCE(sqe->addr);
+	addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	addr_len = READ_ONCE(sqe->addr2);
 	return move_addr_to_kernel(addr, addr_len, &io->connect.address);
 #else
@@ -4702,7 +4700,7 @@ static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
 		if (copy_from_user(&ciov, &ciovs[index], sizeof(ciov)))
 			return -EFAULT;
 
-		dst->iov_base = (void __user *) (unsigned long) ciov.iov_base;
+		dst->iov_base = u64_to_user_ptr((u64)ciov.iov_base);
 		dst->iov_len = ciov.iov_len;
 		return 0;
 	}
-- 
2.24.1

