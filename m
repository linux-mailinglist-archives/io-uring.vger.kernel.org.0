Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B32C30F469
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbhBDN7a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbhBDN45 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:56:57 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89A2C0617A7
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:04 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v15so3613157wrx.4
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=89HK5/jlI+y6ZuAAaTISzxZLDIPIT1N+s0fBQAaJATs=;
        b=kcbycUzezQiPiQ3vrVsQ8PYr828v8IjPScJPUrdSIdBTQCA5xOJsPtcVNdTAIWslJv
         qnIyEqxCJp71RW2xLlZCFSftEv3tBheHWyDy69jL/Q/HqdpBmxa8W/2ejyD653B778LS
         lk9aX3WxnONFC6sIL1kjLvocN8xl20pMgO7RJl3U8bIJU8ZRZ8Bn3Fw+2V1W4VIfF5yl
         TlPADghhV8Z0reHZasrdtEnRhz03d3F/3JLy4uLRHORfh7tmmHKljl5NgOR2YFmdD70R
         xPptuCiGeE+pwM87G+h3C/+VnsilzsA60wTPU6C/wTfNubGbxkEcrdX1zLcWDr+DhQk/
         LwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89HK5/jlI+y6ZuAAaTISzxZLDIPIT1N+s0fBQAaJATs=;
        b=t9hTBYJs1oFhLkifUYw5ojpqrLJ4UDho3xoGuNAkcofp5+CUmhw/uizKjyeFlJmCma
         WbnLdsSzroVUikGKgd+D5Cv97jRIveZwOJpdPoTKn3bHF7VqXj0J6fynWi/Pg+VCwdcY
         uAUJQ+DfzsDFi2BffPSsSrU8G4GaBTi791goWuuG11HSPzPR4I3oydMXhD74UI6cVT7g
         oNSesX6wjJAkI6Snln8Ybq0AdD3SCJpX+bRi3HOGMJLuXe0MqkbeZ90ujgYjCzXPnIja
         hTlXXkoWtWY8eVEfArjUufIDeBRvPaWRw9u59eGx9lKqG/WUJJKhY+ngufc00lx8A8Aq
         b13w==
X-Gm-Message-State: AOAM5325v6iBf1cyucpxXGqQb1R93ewF8yhywx24jr8m/XNQlF34Vhjt
        oC86vznkqlovK2Yu6sJnP4hhWWw8AYZgrQ==
X-Google-Smtp-Source: ABdhPJwT0THsqvpqViTqeAFUZTfVBAlPm5HPkkWUlHsWpqMVVMsjiYrz+VM6wz4a2xA8gk009/Gemw==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr9361905wrz.86.1612446963525;
        Thu, 04 Feb 2021 05:56:03 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 04/13] io_uring: refactor io_read for unsupported nowait
Date:   Thu,  4 Feb 2021 13:51:59 +0000
Message-Id: <08a95dbcc8a60003e8b8900e194d3ec4fb59188e.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

!io_file_supports_async() case of io_read() is hard to read, it jumps
somewhere in the middle of the function just to do async setup and fail
on a similar check. Call io_setup_async_rw() directly for this case,
it's much easier to follow.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dcb9e937daa3..866e0ea83dbe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3506,7 +3506,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t io_size, ret, ret2;
-	bool no_async;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3527,9 +3526,12 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
 	/* If the file doesn't support async, just async punt */
-	no_async = force_nonblock && !io_file_supports_async(req->file, READ);
-	if (no_async)
-		goto copy_iov;
+	if (force_nonblock && !io_file_supports_async(req->file, READ)) {
+		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
+		if (!ret)
+			return -EAGAIN;
+		goto out_free;
+	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
 	if (unlikely(ret))
@@ -3568,8 +3570,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		ret = ret2;
 		goto out_free;
 	}
-	if (no_async)
-		return -EAGAIN;
 	rw = req->async_data;
 	/* it's copied and will be cleaned with ->io */
 	iovec = NULL;
-- 
2.24.0

