Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE0711C03E
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2019 00:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLKXDR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Dec 2019 18:03:17 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34193 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLKXDR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Dec 2019 18:03:17 -0500
Received: by mail-pl1-f196.google.com with SMTP id x17so192336pln.1
        for <io-uring@vger.kernel.org>; Wed, 11 Dec 2019 15:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mfMO8dkgWWLYZyQIXkfLpWfHeN71CMIHFUznmbaNYm4=;
        b=H/6KH2GV1X4wIDdg3Ltf4MegWbUshKPCRcvcBwobG8nh8b6kvl1uyWulQZt+5rHe3/
         FYE1p2ahZSCAu5Rc7i9UDrB0gScZ1ur/QoCHSy70mjCAOs2E0gsivuBEvupxxyuZf64o
         LFXVfppSWGC5EnrvRUUuOHi3HenuM5IhlOgwkX/XxvHFkPcAoAxvdjuevo0kmzUEeIqz
         feIAqAPj8YPbFoo6gmqPEl3HhP3Fx6A8MfiF0yvcHPYzi8GK2TxfYomckMFZdQjiuVeA
         ZMUZjLBdTTxf4fWNLGX0XaBFJ1zBiMlARlLNT6OGuKcFNsFz+jXdk65miCk9M54j6Tfr
         ZBdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mfMO8dkgWWLYZyQIXkfLpWfHeN71CMIHFUznmbaNYm4=;
        b=CThIyuoi4SW5Ubw2mWVDVYtz7tSXh3rPYd2GiUmulX0nXJAS7uXiJueUR9+SHAUFpP
         Hbz4VfeLW5/rx9Emb8RJGfYSCWqU8hn9BoYZPeFy7jj4h7PEDMcYsOE5cFYJT+fN1oVM
         rCn+HUxc0yoZO/rMsmIoGkbLDaYIbOi91Nbg4g9siYo/PCEHBScRc/+HMJkFUHrcol6F
         0nVi3yX2ywJ0GXS0FUCBbuG2CgtmrjnCFIssJ87Zd1azEq93SiFV2FTU4jk2rVwbZ3Qp
         Xzle+ExU45qaivdudoXJRS9ppouN8OCaGORYKsCgkzi07CuV8TWgB7sLuqZAobWA5Jt5
         J+cA==
X-Gm-Message-State: APjAAAV5rQvX5PUzRZqMUK0sdGJHvOsB8EHqDw82zNuPL9cVUfPxX+4b
        rdDkiIdwronKGo5zChD8ac6kEcccBfAirw==
X-Google-Smtp-Source: APXvYqzOCsKMlZma4+bZ7mC5jt9B821q3eMM8RPW9koT0bPoeJT7yCHSruAsXdruevdE1vCLr5fQIw==
X-Received: by 2002:a17:90a:3586:: with SMTP id r6mr6270655pjb.36.1576105395168;
        Wed, 11 Dec 2019 15:03:15 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id d65sm4282288pfa.159.2019.12.11.15.03.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 15:03:14 -0800 (PST)
Subject: Re: [PATCH] io_uring: ensure we return -EINVAL on unknown opcode
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <17ab20b1-4b57-5f5f-e29a-fa7302a17044@kernel.dk>
Message-ID: <2f5bbabc-1644-c501-5943-1a1320e2c453@kernel.dk>
Date:   Wed, 11 Dec 2019 16:03:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <17ab20b1-4b57-5f5f-e29a-fa7302a17044@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/11/19 3:55 PM, Jens Axboe wrote:
> If we submit an unknown opcode and have fd == -1, io_op_needs_file()
> will return true as we default to needing a file. Then when we go and
> assign the file, we find the 'fd' invalid and return -EBADF. We really
> should be returning -EINVAL for that case, as we normally do for
> unsupported opcodes.
> 
> Change io_op_needs_file() to have the following return values:
> 
> 0   - does not need a file
> 1   - does need a file
> < 0 - error value
> 
> and use this to pass back the right value for this invalid case.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Wrong patch attached, here's the right one... Sorry about that.


commit 9e3aa61ae3e01ce1ce6361a41ef725e1f4d1d2bf
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Dec 11 15:55:43 2019 -0700

    io_uring: ensure we return -EINVAL on unknown opcode
    
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

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42de210be631..9b1833fedc5c 100644
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
 
@@ -3092,7 +3099,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned flags;
-	int fd;
+	int fd, ret;
 
 	flags = READ_ONCE(req->sqe->flags);
 	fd = READ_ONCE(req->sqe->fd);
@@ -3100,8 +3107,9 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 	if (flags & IOSQE_IO_DRAIN)
 		req->flags |= REQ_F_IO_DRAIN;
 
-	if (!io_op_needs_file(req->sqe))
-		return 0;
+	ret = io_op_needs_file(req->sqe);
+	if (ret <= 0)
+		return ret;
 
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

