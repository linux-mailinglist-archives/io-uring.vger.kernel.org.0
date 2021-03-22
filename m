Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE61334366B
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 02:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhCVBu1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 21:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhCVBuL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 21:50:11 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B4EC061763
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 18:50:09 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso2447893wmq.1
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 18:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=r7kiDGvgp2k/ExGTTySec3yzp7DdcNmV30oJ+q4eaU8=;
        b=pz2cJRPL2vN1RwoClwktPn/zyxzFOcY7GU+IWmeHgyRkJjB10YeLBNdV1gc5YkN07V
         YwK8GzCpQe42mV/K+Kb2H2vUOmhJJ0iynjWG0aiHps8FiV4JahhExGol0hkfNi1RCsQY
         Qo3W2F9rh9dg0PdMGqdTnTaUpw6ur3H+o+qE9X66mim0mHvU6IXi+R+DdZQuqgwNPXFl
         /Ng0Q/M2IcGZYMYkRuTFtKg7XKgkjuzsmP8SXQnnnDY7UP7Y6Df8cFbb2uq8ML92a5VU
         9mrLgB00ggrvoDIxW54E58AF4XPYv/aQJe9fcu7q8ny13mjCAviBGIp3clybEUqZNm6R
         VvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r7kiDGvgp2k/ExGTTySec3yzp7DdcNmV30oJ+q4eaU8=;
        b=JXT2COGApr06SPSxg9wpCv8syTw+2WCDz16pKBNrKZwztN8ZchUGxjr3+HCDjJhtti
         Y7jZM6VjGGv3x0vlAhD41NFGjugif759WWxWco8mLmabth9Mipu6rmncDbO3U0Y9ebS3
         xXeD8/ECAozhWzg9O0l+cCciEbwH8wNYMD6bIMlFfb1FZs85BSSvuL6Qwkn+mSgSkuRF
         4tEOrnpwnFRv8aRTuUQroLJfJKwbhWYFcYPE+SMSzuhM3vFgTEZuxHq3YMSYYtLYAB18
         tXfMnf9alkued5k/hXCC6vAYNRUwGtckur0MWbzQjlaGCkOGeNgXactwoCt84cwVGkIp
         Hb0w==
X-Gm-Message-State: AOAM530g2PSryGcTv0o4Bi98vikUpxcMWM1nEeWRhVfGwF7Gbk5xzNVh
        nnhnh7Hn4p5J2LRERaSj5PxeqPRkQ8eVsw==
X-Google-Smtp-Source: ABdhPJyRUzt4yegjzmYA9dMjFqwLGfBGGtQSBibqtO31yA9zNv+yjr8/Mr+rCBQ1ktCvBd9AWdS6Kw==
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr13969292wmq.45.1616377808735;
        Sun, 21 Mar 2021 18:50:08 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id x13sm17653138wrt.75.2021.03.21.18.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 18:50:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: don't skip file_end_write() on reissue
Date:   Mon, 22 Mar 2021 01:45:59 +0000
Message-Id: <32af9b77c5b874e1bee1a3c46396094bd969e577.1616366969.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616366969.git.asml.silence@gmail.com>
References: <cover.1616366969.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't miss to call kiocb_end_write() from __io_complete_rw() on reissue.
Shouldn't be much of a problem as the function actually does some work
only for ISREG, and NONBLOCK won't be reissued.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f52fe924a11..a00e8a40e44c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2524,13 +2524,12 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 {
 	int cflags = 0;
 
+	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
+		kiocb_end_write(req);
 	if ((res == -EAGAIN || res == -EOPNOTSUPP) && io_rw_reissue(req))
 		return;
 	if (res != req->result)
 		req_set_fail_links(req);
-
-	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
-		kiocb_end_write(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_rw_kbuf(req);
 	__io_req_complete(req, issue_flags, res, cflags);
-- 
2.24.0

