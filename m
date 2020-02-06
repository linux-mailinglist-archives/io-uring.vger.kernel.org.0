Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185601549B4
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 17:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBFQwE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 11:52:04 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45598 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgBFQwE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 11:52:04 -0500
Received: by mail-ed1-f67.google.com with SMTP id v28so6652853edw.12;
        Thu, 06 Feb 2020 08:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SJxFgsecqtei72spXgyrudIkZIJGgELlpouGAqZ4/us=;
        b=tFT94kInRIvGnjurirgdAOKPn+CQH1ryOj12OD0drFnemVonOKNuX9RNNbDT9RrO5I
         180vflqSELjgRysD/U+RFVKDuCexZXcHF5x2ge0bm8cJqKjIAFQBregPcgPVtG29tZkN
         drFMkXqR9JYfBuz1nqLdxqgStVNL88M0bt8iwSjH9EiNCD6TNw8Plr3HPuxU9dfRDuKp
         kLtdmiP/9bDm7iP8utNCx7QVGxDIM/L5P/JXDf//wl9JMZg0hNyI4zHLR8epruHzUkuD
         Dh0soyOnpFT0SOmaptgECWpVuPvz3y0jAyw0G78oDBCvzVaSEX2uhBtt44sUwXnjU41P
         DiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SJxFgsecqtei72spXgyrudIkZIJGgELlpouGAqZ4/us=;
        b=g49qy9REz5XeMpVehLQWzoW2C+3Jh4D7pVehlMaXSl+a+yc+2PObbsc26XEzU2/Ksa
         iVIwXp+QYQWPHtmCvDvnvWgP6tlV22wyfLycVipYoI7pqSVSHxu49J2qmx/YVuWpxnUj
         UoePPchEgOLFnVUB7pVyQx+7IiFLqZ9QnjJy8Dohf+guRjz+1peYj9kp+IHTAerI0/Cv
         gHKUb3p9Cj+ni0tGsdDox5YMPYQbSEzHCTQxi4dm7lBU1szDqyfUf/elMoqTiOorRA3Y
         zi4WQ3QHsLpBC8xwmlcuC9vREGGyQj4i44NFZMinZl1+4ccQnd6SyWiLNZGa1UPU+91s
         lH2A==
X-Gm-Message-State: APjAAAXxpahrIzHIwm7uDfd7aQanjHbb4AiHSIgY3aDsy8KOZyF8YOEF
        JixT2k5X+Boax466Y9Nro4I=
X-Google-Smtp-Source: APXvYqy+auJcYYJdToXmFqwPTZvEXE1DfEJIG7HuQmqsu4zH/qi96tHhVCFSqjY66+CHfw3ZUF3NRg==
X-Received: by 2002:a05:6402:1e1:: with SMTP id i1mr3854649edy.338.1581007922255;
        Thu, 06 Feb 2020 08:52:02 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id y4sm7015ejp.50.2020.02.06.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 08:52:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix deferred req iovec leak
Date:   Thu,  6 Feb 2020 19:51:16 +0300
Message-Id: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After defer, a request will be prepared, that includes allocating iovec
if needed, and then submitted through io_wq_submit_work() but not custom
handler (e.g. io_rw_async()/io_sendrecv_async()). However, it'll leak
iovec, as it's in io-wq and the code goes as follows:

io_read() {
	if (!io_wq_current_is_worker())
		kfree(iovec);
}

Put all deallocation logic in io_{read,write,send,recv}(), which will
leave the memory, if going async with -EAGAIN.

It also fixes a leak after failed io_alloc_async_ctx() in
io_{recv,send}_msg().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 47 ++++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bff7a03e873f..ce3dbd2b1b5c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2143,17 +2143,6 @@ static int io_alloc_async_ctx(struct io_kiocb *req)
 	return req->io == NULL;
 }
 
-static void io_rw_async(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct iovec *iov = NULL;
-
-	if (req->io->rw.iov != req->io->rw.fast_iov)
-		iov = req->io->rw.iov;
-	io_wq_submit_work(workptr);
-	kfree(iov);
-}
-
 static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 			     struct iovec *iovec, struct iovec *fast_iov,
 			     struct iov_iter *iter)
@@ -2166,7 +2155,6 @@ static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 
 		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
 	}
-	req->work.func = io_rw_async;
 	return 0;
 }
 
@@ -2253,8 +2241,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 		}
 	}
 out_free:
-	if (!io_wq_current_is_worker())
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -2359,8 +2346,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		}
 	}
 out_free:
-	if (!io_wq_current_is_worker())
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -2955,19 +2941,6 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
-#if defined(CONFIG_NET)
-static void io_sendrecv_async(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct iovec *iov = NULL;
-
-	if (req->io->rw.iov != req->io->rw.fast_iov)
-		iov = req->io->msg.iov;
-	io_wq_submit_work(workptr);
-	kfree(iov);
-}
-#endif
-
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_NET)
@@ -3036,17 +3009,19 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		if (force_nonblock && ret == -EAGAIN) {
 			if (req->io)
 				return -EAGAIN;
-			if (io_alloc_async_ctx(req))
+			if (io_alloc_async_ctx(req)) {
+				if (kmsg && kmsg->iov != kmsg->fast_iov)
+					kfree(kmsg->iov);
 				return -ENOMEM;
+			}
 			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
-			req->work.func = io_sendrecv_async;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
 
-	if (!io_wq_current_is_worker() && kmsg && kmsg->iov != kmsg->fast_iov)
+	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
@@ -3180,17 +3155,19 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		if (force_nonblock && ret == -EAGAIN) {
 			if (req->io)
 				return -EAGAIN;
-			if (io_alloc_async_ctx(req))
+			if (io_alloc_async_ctx(req)) {
+				if (kmsg && kmsg->iov != kmsg->fast_iov)
+					kfree(kmsg->iov);
 				return -ENOMEM;
+			}
 			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
-			req->work.func = io_sendrecv_async;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
 
-	if (!io_wq_current_is_worker() && kmsg && kmsg->iov != kmsg->fast_iov)
+	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
-- 
2.24.0

