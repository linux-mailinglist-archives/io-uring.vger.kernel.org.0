Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F64310204
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 02:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhBEBCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 20:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbhBEBCg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 20:02:36 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A3FC06178A
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 17:01:55 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id p15so5708688wrq.8
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 17:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iU8RgkbjaidScL5FmNO5qxugyn2l8qV1L/AOm98Zz6Y=;
        b=gpJA6N8quXuIL38hHApcv0JeL2DOBi/D/Wnz48ER9slAmhyWQjKZHL92BlNoaK7/AM
         b41L+uuKs6mVWpmnouJOl7b6bs0JZsze5WUy4aaak2NJ9wnDj/YkgLhRL7uQwJjUBNsP
         9VwCbpExtvP2ahEDj8cWpy11uLXbLoLIgPrzwXC6QPg2UlkE9uAQta6mTxUabLPFFHR1
         ukb774wD91d/NZTXYp8SPBdT7sSfKwkEJ5itVxtpGqgq1czAtKB8WcEQQGcH5yDkej3J
         I3LAs9SpyIdEvToziBB3Gy6NDDD1MSo7K0huvlMQm/Fo1Wm0EfXyFiFb8gT2zDEK6sg5
         ixoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iU8RgkbjaidScL5FmNO5qxugyn2l8qV1L/AOm98Zz6Y=;
        b=YbzKCo5KyD1KJRVUKujYE2pqfXaljiVs24FfLv08JFZastACuJRbJu9ocd1RN4iWy2
         Mpkdfbr5ezi3y4/0fsc6mZxZ7PYm9VySXB0N0m+EZMcjSWQ4/neuMPGyuBFCrxk0h3bo
         4YvFrB0VPvISz6egm7dPxRf7Xx6zyCr47zZHUBnZ2zcBqG3Nklc76d2s4byx2k3vq2pA
         i/mQbUaK40DAJ/7NtnYGbkP962Iz4Vv9JILEVT4dIM+fWUVwWNpTn+pxR7uzB5Wf5IJy
         QuywpGaPfJ+X3Z4s5FHF2+kQytABNa7ZJ7nh3SIMUoUs9+4zUxVr5wwdSPJRnbuCdLGH
         Tm/A==
X-Gm-Message-State: AOAM532lgc/BNIPUDhnp2Xi+Zv2lAucOwFqaqgtJc0ItZKJ6h6JWVFLU
        yHCPmbyAPE/KM+3c0smJdqQFfA4xkLbRgA==
X-Google-Smtp-Source: ABdhPJwnKWCVgz6tzDGigSwgONSnvRmNhDflTCT+1J/eepm31wUWUhWm9eK3fXDL2ssatYu5Z6FhIA==
X-Received: by 2002:a5d:62c1:: with SMTP id o1mr1955227wrv.275.1612486914448;
        Thu, 04 Feb 2021 17:01:54 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id i18sm10853199wrn.29.2021.02.04.17.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 17:01:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: clean iov usage for recvmsg buf select
Date:   Fri,  5 Feb 2021 00:57:59 +0000
Message-Id: <9d2ee25d701a37533d84f2d79b966330dc51a5ac.1612486458.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612486458.git.asml.silence@gmail.com>
References: <cover.1612486458.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't pretend we don't know that REQ_F_BUFFER_SELECT for recvmsg always
uses fast_iov -- clean up confusing intermixing kmsg->iov and
kmsg->fast_iov for buffer select.

Also don't init iter with garbage in __io_recvmsg_copy_hdr() only for it
to be set shortly after in io_recvmsg().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39bc1df9bb64..e07a7fa15cfa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4701,11 +4701,9 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (iov_len > 1)
 			return -EINVAL;
-		if (copy_from_user(iomsg->iov, uiov, sizeof(*uiov)))
+		if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
 			return -EFAULT;
-		sr->len = iomsg->iov[0].iov_len;
-		iov_iter_init(&iomsg->msg.msg_iter, READ, iomsg->iov, 1,
-				sr->len);
+		sr->len = iomsg->fast_iov[0].iov_len;
 		iomsg->iov = NULL;
 	} else {
 		ret = __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
@@ -4748,7 +4746,6 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 		if (clen < 0)
 			return -EINVAL;
 		sr->len = clen;
-		iomsg->iov[0].iov_len = clen;
 		iomsg->iov = NULL;
 	} else {
 		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
@@ -4855,7 +4852,8 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->iov,
+		kmsg->fast_iov[0].iov_len = req->sr_msg.len;
+		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
 				1, req->sr_msg.len);
 	}
 
-- 
2.24.0

