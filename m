Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CF630B416
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhBBA0V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBBA0U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:20 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4FAC061573
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:40 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v15so18596692wrx.4
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=89HK5/jlI+y6ZuAAaTISzxZLDIPIT1N+s0fBQAaJATs=;
        b=q942/AOXMueHPbJBDWipBXkXCY/v9FgoVxX05jXnfOlZTZeiFgLEsvqTHpl3kSYn99
         y/CcnEfRc3fE0PgCZA8nx6A3eEi7tWzsx7Aw0pW2/joA3TP/aGTEAK5otphIegdnRSjF
         X3W/gXMNJhbSAwKaXdGNENskI4BxNdB2Dovai8CYxiTu51sJ7fNQZZp4FVu3Rkc7g+3d
         t6PH5tHdorpmpbQ2XoxSg56lvNcJB3PxXFN5HOM3UfFAcic2vCm4RQRfKJrLb8pbo8T3
         RCu8D+6/b6HbLB+9un2ZuIKdz/5fCeuyBLQDr5f1miIa1LoRZMW/gVBsV5eu2s/iaA+y
         xU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89HK5/jlI+y6ZuAAaTISzxZLDIPIT1N+s0fBQAaJATs=;
        b=jLv5aAx3vXsBCLRtz6q2KCL5WeRPSZcxgfzvYeYJQkS9N84oFARSUx2dMJM+rUxQfL
         j1e3fQ29fFb0seS2JehfCYkQASZkFxw8OvRQJ4TtMxyoXo7uQRtVTCtN7sszMMmCiUWb
         x2XDVsChKwqxSUIqIwMwdYlvzo9nxqs8ubNYStW6uxHGAl/XPDiZKlvZtMuSdRz8fmtM
         dxrnTX/dIUSchlbIldhUOxzS9vtDbKacJ8FA1W4NhNi/xFdNVn1MQxf1KupCykOKShq2
         UErEHYg8qBmI52E21As3t2AJsvgRGY4yG6W891uqv3Adapss/Q/O0jRu99XinQOA7fBP
         KpmQ==
X-Gm-Message-State: AOAM530xBvBpjhxoHrbJ8Kxl0MYdpAVwHcZgMbW/nqYo80Mwbmfafa4+
        74dKGIW4GPHGVL5rxHJqFmA=
X-Google-Smtp-Source: ABdhPJxEFZ+zp71730lRtq4SSEymu5z4z6OgegK5LZ1K1cw/acO2y50sAgvWCFteZZ3I3PyrHUp3AQ==
X-Received: by 2002:a5d:4a50:: with SMTP id v16mr20854636wrs.241.1612225539010;
        Mon, 01 Feb 2021 16:25:39 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/8] io_uring: refactor io_read for unsupported nowait
Date:   Tue,  2 Feb 2021 00:21:42 +0000
Message-Id: <144560906a019b5239947f64fd9f0f9848e46edb.1612223954.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
References: <cover.1612223953.git.asml.silence@gmail.com>
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

