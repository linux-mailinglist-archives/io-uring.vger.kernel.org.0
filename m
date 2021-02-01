Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D01B30B004
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 20:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhBATFU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 14:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbhBATEh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 14:04:37 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE9EC061788
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 11:03:54 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id z6so17769472wrq.10
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 11:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VXl5IW+Z4MjrMQjp4ZuHeN4dwka783G5JKdOD0ZGTr4=;
        b=JKH9L9myCvmO0HVSmWWCwsj+cFCtbOgahXJtqb0t3gJHS9602R4z6bDrvxb68Vm2Al
         tn+f6lbRb0Rg8L08w/F4BRhg4C6SySttw+0ylBtqS+CgM508fmPIb55fEJvNO3TWa6nq
         lt3jTkSDMkxuDvJm2NsUz3Vu1xHDZjRUly3ScGDxmhM4xsSNXrtEeqYDgLgEku7v7aRi
         BHb+EyJdpNkcTa6MtdIojO45HjaSZR9+5p3Wuv5IBw264+vMTOrLIlqd7lIZ25aysvAj
         8RhDsOvw3NWs6n1SidYkOxPQaLA93xPSc+Y+oLs+u1ksTOXTO8GWBTC0UMiXm1GVfH+3
         8Deg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VXl5IW+Z4MjrMQjp4ZuHeN4dwka783G5JKdOD0ZGTr4=;
        b=ZjN7IAV6/cKnJLoT4S0A0zSM3tJjif4H7C0KX84nIk/XzI3CHSAwHT1NKJNpLdD08f
         BvvK1lqHaX9pTTNMp+zN3SrtKA1Z/5IPfypri+ND8cHO3YUE3XvJS0sHRDlG4k6Zi0vn
         8JixxZZAaH65VxBvfcQRDXsMyd0O3n+FxPOx+CZOZXDFcv3kh8+DuPyZYrxAxos9M0l8
         n2Vor71U9VrNJRLMQfj5pierVdBTzTeiBVDLSWfr/j/EskJN0OXtyJqncz+vzFTqIFaC
         v5upCwYStElOMhM/rET3kIkHtYoqawjChpXm9kHnP42K6jr+f7Tqtgnkt7v7nOclORKp
         cGnQ==
X-Gm-Message-State: AOAM530ZvjItpXPo2QHieZvoofdM78SCbmCpByrGg6o5UwUlHRJb4HR9
        o5QbfUTiUEBOq4aPstRaD3M=
X-Google-Smtp-Source: ABdhPJzbPxL7rlf/LFqrlC8bKdP2Q2H3tOXmov0SpG+8X7xTxeoMmYNxqy3hi2LICLxtKgnIQfBaMg==
X-Received: by 2002:adf:dcc8:: with SMTP id x8mr19761699wrm.234.1612206232876;
        Mon, 01 Feb 2021 11:03:52 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id h14sm182728wmq.45.2021.02.01.11.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 11:03:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/6] io_uring: simplify do_read return parsing
Date:   Mon,  1 Feb 2021 18:59:56 +0000
Message-Id: <65b7ccb995f13ac76af6790d2f22c977ec5effc8.1612205713.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612205712.git.asml.silence@gmail.com>
References: <cover.1612205712.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do_read() returning 0 bytes read (not -EAGAIN/etc.) is too important of
a case to prioritise it. Fold it into ret<0 check, so we get rid of an
extra if and make it a bit more readable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6834379c208b..6580efeaa18a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3526,7 +3526,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	else
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
-
 	/* If the file doesn't support async, just async punt */
 	no_async = force_nonblock && !io_file_supports_async(req->file, READ);
 	if (no_async)
@@ -3538,9 +3537,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 
 	ret = io_iter_do_read(req, iter);
 
-	if (!ret) {
-		goto done;
-	} else if (ret == -EIOCBQUEUED) {
+	if (ret == -EIOCBQUEUED) {
 		ret = 0;
 		goto out_free;
 	} else if (ret == -EAGAIN) {
@@ -3554,7 +3551,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
 		goto copy_iov;
-	} else if (ret < 0) {
+	} else if (ret <= 0) {
 		/* make sure -ERESTARTSYS -> -EINTR is done */
 		goto done;
 	}
-- 
2.24.0

