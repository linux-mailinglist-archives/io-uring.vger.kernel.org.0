Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F13111FDD8
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2019 06:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfLPFQb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 00:16:31 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39967 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfLPFQb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 00:16:31 -0500
Received: by mail-pg1-f196.google.com with SMTP id k25so2971178pgt.7
        for <io-uring@vger.kernel.org>; Sun, 15 Dec 2019 21:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=raUebU33vTP3/v0TWCuM1pJZd7+3rhDGAw/JrYDp+Fw=;
        b=F3fMqLM/Tn4WyQGKHDlF/WsvIFB+mSIVyE+1U1GLD7vudRu3R8iS/2vaN2fHcH43a7
         8CUjOmm33DyTpImjbS4OA60tmC7AEIo2xGeuyM4DCkj0P2olfBpon/x2t80+qaQUvDCu
         aFmHEKU5OZGokQPwJn2NTR+HLVCMYKFAu1IZjrMoxskks/JhsQHHxBAi9zvNma5rJr5j
         RSKTCVcMKxBticuiok5ciLUcbrQvVSeEx7+793kA+LO8464+ZpXKH3Z/wPbho6Jp2Y8P
         ArhNrfnnMG4rgFMyCv5ADrf6SWpJ2UMIaT6cwLqThV/MvRbHDfYFzSqht7JDJ+ZAbATj
         mWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=raUebU33vTP3/v0TWCuM1pJZd7+3rhDGAw/JrYDp+Fw=;
        b=EnjXZfYkQ9ahRcfvjeXZYBHL6PiwBvjXe9uVNIcAzOZOBiPzWynXs8mcTvCeQDPaF7
         HYXrQi6F+60oYHMEzFM065yBckKpEkYvFl5OGvY9we5+iDTE2MTgoCFGVdas4pLxgtCH
         byI6IT/HDrpzV4/4USJZXdGpnsP9jWL7L33Sy1jBb1EgoQRtJz4O/tal0BqcSYPb+Cw6
         BFl6Dpi4DKDLrFokjcdGUOIfglPYIIAMq6hDXSa6LX2/iPyhHk4aUS54kubuwVvmt+I4
         IfELpGBfa1cqcrZX7ghQWMMNBk+xeYHZUsbOBj9Sow/A/nyPgc4vPLCyHeUuvfFTuysd
         kfkQ==
X-Gm-Message-State: APjAAAXNda5YrpK9xbepcBsSTkPIWFD91VWJcTceKewB9c0QTayOibq0
        suQa9kG48Ont8uNbg5+V3pZPdjFcJgCtQw==
X-Google-Smtp-Source: APXvYqyWwf5k9EbOOq0D/tVj7tmts3tO0dWu/SGz7oxEvFKiC18d1PyT4qehSQyNfKUH96ZuzLbfnQ==
X-Received: by 2002:a63:9d07:: with SMTP id i7mr16667318pgd.344.1576473390238;
        Sun, 15 Dec 2019 21:16:30 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u2sm19554698pgc.19.2019.12.15.21.16.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 21:16:29 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix pre-prepped issue with force_nonblock == true
Message-ID: <f8431e2f-b12d-ee67-d03c-9fbd27dd2b16@kernel.dk>
Date:   Sun, 15 Dec 2019 22:16:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some of these code paths assume that any force_nonblock == true issue
is not prepped, but that's not true if we did prep as part of link setup
earlier. Check if we already have an async context allocate before
setting up a new one.

Additionally, the io_req_map_io() function is JUST for reads and writes,
not for generic use. Move it into read/write prep path, and rename it to
io_req_map_rw() to make this clear. Ditto for io_setup_async_io(), which
then becomes io_setup_async_rw().

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e01cdc8a120..476825606204 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1701,7 +1701,7 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 	return ret;
 }
 
-static void io_req_map_io(struct io_kiocb *req, ssize_t io_size,
+static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 			  struct iovec *iovec, struct iovec *fast_iov,
 			  struct iov_iter *iter)
 {
@@ -1715,13 +1715,16 @@ static void io_req_map_io(struct io_kiocb *req, ssize_t io_size,
 	}
 }
 
-static int io_setup_async_io(struct io_kiocb *req, ssize_t io_size,
+static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 			     struct iovec *iovec, struct iovec *fast_iov,
 			     struct iov_iter *iter)
 {
+	if (req->io)
+		return 0;
+
 	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
 	if (req->io) {
-		io_req_map_io(req, io_size, iovec, fast_iov, iter);
+		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
 		memcpy(&req->io->sqe, req->sqe, sizeof(req->io->sqe));
 		req->sqe = &req->io->sqe;
 		return 0;
@@ -1806,7 +1809,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
 		} else {
 copy_iov:
-			ret = io_setup_async_io(req, io_size, iovec,
+			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
@@ -1900,7 +1903,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
 		} else {
 copy_iov:
-			ret = io_setup_async_io(req, io_size, iovec,
+			ret = io_setup_async_rw(req, io_size, iovec,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
@@ -2077,6 +2080,8 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 		if (force_nonblock && ret == -EAGAIN) {
+			if (req->io)
+				return -EAGAIN;
 			copy = kmalloc(sizeof(*copy), GFP_KERNEL);
 			if (!copy) {
 				ret = -ENOMEM;
@@ -2165,6 +2170,8 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		ret = __sys_recvmsg_sock(sock, &kmsg->msg, msg, kmsg->uaddr, flags);
 		if (force_nonblock && ret == -EAGAIN) {
+			if (req->io)
+				return -EAGAIN;
 			copy = kmalloc(sizeof(*copy), GFP_KERNEL);
 			if (!copy) {
 				ret = -ENOMEM;
@@ -2272,6 +2279,8 @@ static int io_connect(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	ret = __sys_connect_file(req->file, &io->connect.address, addr_len,
 					file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
+		if (req->io)
+			return -EAGAIN;
 		io = kmalloc(sizeof(*io), GFP_KERNEL);
 		if (!io) {
 			ret = -ENOMEM;
@@ -2871,10 +2880,14 @@ static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 		ret = io_read_prep(req, &iovec, &iter, true);
+		if (!ret)
+			io_req_map_rw(req, ret, iovec, inline_vecs, &iter);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 		ret = io_write_prep(req, &iovec, &iter, true);
+		if (!ret)
+			io_req_map_rw(req, ret, iovec, inline_vecs, &iter);
 		break;
 	case IORING_OP_SENDMSG:
 		ret = io_sendmsg_prep(req, io);
@@ -2894,12 +2907,10 @@ static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
 		return 0;
 	}
 
-	if (ret < 0)
-		return ret;
+	if (!ret)
+		req->io = io;
 
-	req->io = io;
-	io_req_map_io(req, ret, iovec, inline_vecs, &iter);
-	return 0;
+	return ret;
 }
 
 static int io_req_defer(struct io_kiocb *req)

-- 
Jens Axboe

