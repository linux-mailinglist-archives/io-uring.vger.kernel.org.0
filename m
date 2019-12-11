Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7D11C029
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2019 23:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLKWzd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Dec 2019 17:55:33 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36376 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLKWzd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Dec 2019 17:55:33 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so53391pfb.3
        for <io-uring@vger.kernel.org>; Wed, 11 Dec 2019 14:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=7Hd8W1+nWXMViJfqeedC6aKs5x9dDoAQQi4uGVeFLFM=;
        b=EZgoGPtyn4wobZLcnSuYlbno+1NmfEmEsr7ry5VqixhyVofp6irR9QPTbw96Ke6Zd2
         xrHsJqsGyl1yFcTTlyn+fddEIEWjyPAUgV7TYTvk2vTLy0eQWtGYcr1QV5+mMPNjO+oR
         8ywzv8K/lUZLumS3hkJl4jCg5yU4xeGrl8doJ8+Juzyz1pfiliVRo131lQERrfr92oU+
         d2RncZ43RbH/gWfG9HUyqHYrfj5iw7lb8JTkir4aI/I0JdM9qfemoSgH/z+Muf53kabL
         QqEvPYVU7pU4LTWz9PbZXhgkYdY8sXTQ1/7Ltbm6juPwjMjtM4mP8xWjGOG5Mj2NDtkI
         q8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=7Hd8W1+nWXMViJfqeedC6aKs5x9dDoAQQi4uGVeFLFM=;
        b=pwHtX6mI/okl12XacZT/6LiIugue/PE9X8R6uB12AY3Z7kaDP3H6scd7rGW2mAFIlD
         cdKp6BssaPDfLi0ZY2PBHwFhV9buP/Sre8+D6/ztby8UEsRUD8tMb+y0d43MHP4XBGzm
         7jO1Xo9x9QRPw5P9xZFjhXqv2xg+ZXiO9sRaWlO5EpOas68JKoTmdZw9VgzkIai1QyMQ
         q3IrvRGhX4wVz1QTS0CzQnt2EO6RsdveVLRhMMDvsCtXwYk+9wg2xsdlV9B/lTvaLNoW
         Bukut2TegD1P4R9zotcIgulyV3BajugWBFCyP4nHLXMm4uGCx1BNaLDB/OyclTt6JSnY
         +IAQ==
X-Gm-Message-State: APjAAAVIHFbnI1lZG1Vy9BNrbdjTyEUGmkg1h27Ga/ZE0r9WGMLHhUgC
        NjPD6hfkG0Qh+brTWMWunR59s5clguZ7HQ==
X-Google-Smtp-Source: APXvYqzfX9T4TTngSLhVkFQLcCAsI+Ewb0JblnmCL03mQOFkt7iitFyLCQAPD8+3QrhUB1VgwHES3A==
X-Received: by 2002:a63:1106:: with SMTP id g6mr6878988pgl.13.1576104932345;
        Wed, 11 Dec 2019 14:55:32 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e188sm4356220pfe.113.2019.12.11.14.55.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 14:55:31 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure we return -EINVAL on unknown opcode
Message-ID: <17ab20b1-4b57-5f5f-e29a-fa7302a17044@kernel.dk>
Date:   Wed, 11 Dec 2019 15:55:30 -0700
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

If we submit an unknown opcode and have fd == -1, io_op_needs_file()
will return true as we default to needing a file. Then when we go and
assign the file, we find the 'fd' invalid and return -EBADF. We really
should be returning -EINVAL for that case, as we normally do for
unsupported opcodes.

Change io_op_needs_file() to have the following return values:

0   - does not need a file
1   - does need a file
< 0 - error value

and use this to pass back the right value for this invalid case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42de210be631..d9641b6ccd4a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3062,7 +3062,12 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	}
 }
 
-static bool io_op_needs_file(const struct io_uring_sqe *sqe)
+static bool io_req_op_valid(int op)
+{
+	return op >= IORING_OP_NOP && op < IORING_OP_LAST;
+}
+
+static int io_op_needs_file(const struct io_uring_sqe *sqe)
 {
 	int op = READ_ONCE(sqe->opcode);
 
@@ -3073,9 +3078,11 @@ static bool io_op_needs_file(const struct io_uring_sqe *sqe)
 	case IORING_OP_TIMEOUT_REMOVE:
 	case IORING_OP_ASYNC_CANCEL:
 	case IORING_OP_LINK_TIMEOUT:
-		return false;
+		return 0;
 	default:
-		return true;
+		if (io_req_op_valid(op))
+			return 1;
+		return -EINVAL;
 	}
 }
 
@@ -3100,8 +3107,9 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 	if (flags & IOSQE_IO_DRAIN)
 		req->flags |= REQ_F_IO_DRAIN;
 
-	if (!io_op_needs_file(req->sqe))
-		return 0;
+	fd = io_op_needs_file(req->sqe);
+	if (fd <= 0)
+		return fd;
 
 	if (flags & IOSQE_FIXED_FILE) {
 		if (unlikely(!ctx->file_table ||
@@ -3312,7 +3320,6 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 		io_queue_sqe(req);
 }
 
-
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK)
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ea231366f5fd..a3300e1b9a01 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -58,23 +58,28 @@ struct io_uring_sqe {
 #define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
 
-#define IORING_OP_NOP		0
-#define IORING_OP_READV		1
-#define IORING_OP_WRITEV	2
-#define IORING_OP_FSYNC		3
-#define IORING_OP_READ_FIXED	4
-#define IORING_OP_WRITE_FIXED	5
-#define IORING_OP_POLL_ADD	6
-#define IORING_OP_POLL_REMOVE	7
-#define IORING_OP_SYNC_FILE_RANGE	8
-#define IORING_OP_SENDMSG	9
-#define IORING_OP_RECVMSG	10
-#define IORING_OP_TIMEOUT	11
-#define IORING_OP_TIMEOUT_REMOVE	12
-#define IORING_OP_ACCEPT	13
-#define IORING_OP_ASYNC_CANCEL	14
-#define IORING_OP_LINK_TIMEOUT	15
-#define IORING_OP_CONNECT	16
+enum {
+	IORING_OP_NOP,
+	IORING_OP_READV,
+	IORING_OP_WRITEV,
+	IORING_OP_FSYNC,
+	IORING_OP_READ_FIXED,
+	IORING_OP_WRITE_FIXED,
+	IORING_OP_POLL_ADD,
+	IORING_OP_POLL_REMOVE,
+	IORING_OP_SYNC_FILE_RANGE,
+	IORING_OP_SENDMSG,
+	IORING_OP_RECVMSG,
+	IORING_OP_TIMEOUT,
+	IORING_OP_TIMEOUT_REMOVE,
+	IORING_OP_ACCEPT,
+	IORING_OP_ASYNC_CANCEL,
+	IORING_OP_LINK_TIMEOUT,
+	IORING_OP_CONNECT,
+
+	/* this goes last, obviously */
+	IORING_OP_LAST,
+};
 
 /*
  * sqe->fsync_flags

-- 
Jens Axboe

