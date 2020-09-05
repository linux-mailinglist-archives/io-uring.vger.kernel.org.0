Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D81425E978
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 19:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgIERih (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 13:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbgIERie (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 13:38:34 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5640C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 10:38:34 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id n3so6202957pjq.1
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 10:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fn9/lKBSgrMzNby4mzPDI28J/z7bxKwR2SAr9ZNONXk=;
        b=qZoAa8psB/dfKWch2iDnaXN7J7kUoPk+rOFglw/4J4K37uxslBy04XVAMt+JklkNI7
         WdLIM3i/UyWr4Y6HKYEPDBBtRPA8O3eR8KHkJ4b7JPUoaiOOgmnpTUgW7GoVTTYNN4jZ
         d9XHPfA9cWUla3NRs5A7YopdD4t0UhZEDolgqorZm7zhupQzdRlQ+2zKUamOdCSAP47Z
         BJaEz/bo/Ih/1534q4me/h88e4peK6RWwLG1hWrvGVrbBIDtrMINvE03XIqjitv3yI5w
         txH7UpT+2L+tv86rvmJi4g1k2Oo5WmwgXQyetm+rBAbqLrkMDMXOyR2bUNU6xFbiMcrp
         feRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fn9/lKBSgrMzNby4mzPDI28J/z7bxKwR2SAr9ZNONXk=;
        b=fIgXr7Au5dGkN+UK5iOkbFVZFf6PF8X5GBgO83MzcjaVAlwIIDUn+tBuTi+auBR9Ko
         5zm+rW/t0HFq+skwoySx39lyjcov8qLQ7UdT+DGciXtZdRQb30tbXNSt0b91VYi55awa
         7FxQRCFIlLtsYNBrDwm1K/6A0FWBcrJjlx6C9xECzgSAk7rZJH+iybWnG3SlsrbtKR+I
         ZC0v0lu335l6VKejYMTSKkc2aSrs0sWnn3xzOT6BwvKMl6dm/CmQvncgvDjyPG+8nf8A
         3IXjoIzYUigklMp3oS3v9rjOZlX0JlsAtc8cLsvyYV4ppvB0HF2j8Hp40f64fK2I3LBp
         lKDw==
X-Gm-Message-State: AOAM530Wp89zsZ3QrPivWOTq3d5KmQCi5t1JZIcXb/ywoFRVPfGuceEU
        LAs6wZ9izDmTA/i5JRqoefBRxLQ3qNfj1W7s
X-Google-Smtp-Source: ABdhPJwhovvRjeyHxGqXtyZsPmhZof2q/BWEy3eDyQT6wKCXV2eo+rKxFRs0tuxIwTXwEzubiawshw==
X-Received: by 2002:a17:902:e789:: with SMTP id cp9mr13306636plb.215.1599327508594;
        Sat, 05 Sep 2020 10:38:28 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y128sm9814958pfy.74.2020.09.05.10.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 10:38:27 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jann Horn <jannh@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: enable file table usage for SQPOLL rings
Message-ID: <35aa7095-cb41-1ef4-1e3d-75e3e54656e8@kernel.dk>
Date:   Sat, 5 Sep 2020 11:38:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now that SQPOLL supports non-registered files and grabs the file table,
we can relax the restriction on open/close/accept/connect and allow
them on a ring that is setup with IORING_SETUP_SQPOLL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Jann, I seem to recall some discussion on closing of files being tricky
with this, maybe you can refresh my memory? If so, we could just
continue excluding IORING_OP_CLOSE for this.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9e989911a921..94cce793a17f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3593,7 +3593,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (unlikely(sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
@@ -4014,7 +4014,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	io_req_init_async(req);
 	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
 	    sqe->rw_flags || sqe->buf_index)
@@ -4500,7 +4500,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
 
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->len || sqe->buf_index)
 		return -EINVAL;
@@ -4541,7 +4541,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_connect *conn = &req->connect;
 	struct io_async_ctx *io = req->io;
 
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
 		return -EINVAL;

-- 
Jens Axboe

