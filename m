Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C359B172A04
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 22:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgB0VUb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 16:20:31 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40505 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgB0VUb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Feb 2020 16:20:31 -0500
Received: by mail-il1-f196.google.com with SMTP id i7so876552ilr.7
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2020 13:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=T+HNUdp6iVPQ4XlGs+Xm2q+92L9RyhuWLZqCsOQMmwk=;
        b=Anp9HqU2n2N3CNor61j3YP29cfoGu8NpfuQIXkQRnp3+zicEbTKvet6f+i9pl3X8Ye
         xwe/eVApkX/l9UvhqeDf29wpCUqzkvOKEUo3eW93+nKef7YDf3gAMsDGCTMaKk/pcmsM
         SnNlUfLtrOUqP+HQ6Xw32IXFtU1+7ONQ6/Oq6/LDK4W2bvrZNAdBWOv+/JtHd8PXO5MV
         TadMm/luAXjTYBGv8QnxnZ0NnA8NoZv9wJD6s7r9Bab1iUQPiE33qMGWhEUL+N13TvMt
         cpeaUvYgUZLmdZ045rvFhFHKPB+p8e3cr/Np8ubGJ0Kf2poqzksy5MHZSubqUdkjawEi
         dkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=T+HNUdp6iVPQ4XlGs+Xm2q+92L9RyhuWLZqCsOQMmwk=;
        b=i9XtNJG+AXdhwFvgSPBGklzetw3hx2ch0r1DQlMkftGtk4OfNDhWTtAlkHV2RMHcvF
         hP2zs49cBYhwT6bztDEH/++EaXr9IN5V0FWKeVsvn53RRE2OX2algfdes3uvYhPUm0WC
         1Rbkv+oSAARR0DH7qxj3B7B99D0uS13SBl2y231UqrzPtlBW6VhnDCQzSix3dktb26yT
         Rzr3UuVMZ3pTu+zVx+ng+LOWnghbQobxDsZ94lvF6dgYUCVtdj5okCOLvIjuNSJ6ixDK
         F6KMDchG7w4Dt4NbUfxpLNxWDpUyHaA4BROXG+bhFLmo03r74CAWAJpCjqQPfRS/krt7
         NJNQ==
X-Gm-Message-State: APjAAAWdDijGVHEpAwok7ck5oJRU5Qwp9Qj8SjmVOWyM5OeqYbXH/BD7
        a40luxfGk3FsHyoMEUa/hv8V7ENhB3g=
X-Google-Smtp-Source: APXvYqw1JVglma8TJh7IWZZ5MVMyXHjFy+T6Ke09nTRHJZ90I2QoPk8E3DeocDJUwkddkdw6SX3LSw==
X-Received: by 2002:a92:60f:: with SMTP id x15mr1204355ilg.181.1582838430073;
        Thu, 27 Feb 2020 13:20:30 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q88sm2283885ilk.60.2020.02.27.13.20.29
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2020 13:20:29 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix 32-bit compatability with sendmsg/recvmsg
Message-ID: <fb12e854-7853-e8ec-6fd8-b8ddd9fa7978@kernel.dk>
Date:   Thu, 27 Feb 2020 14:20:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We must set MSG_CMSG_COMPAT if we're in compatability mode, otherwise
the iovec import for these commands will not do the right thing and fail
the command with -EINVAL.

Found by running the test suite compiled as 32-bit.

Cc: stable@vger.kernel.org
Fixes: aa1fa28fc73e ("io_uring: add support for recvmsg()")
Fixes: 0fa03c624d8f ("io_uring: add support for sendmsg()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05eea06f5421..6a595c13e108 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3001,6 +3001,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+
 	if (!io || req->opcode == IORING_OP_SEND)
 		return 0;
 	/* iovec is already imported */
@@ -3153,6 +3158,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+
 	if (!io || req->opcode == IORING_OP_RECV)
 		return 0;
 	/* iovec is already imported */

-- 
Jens Axboe

