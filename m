Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06905167E4
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354799AbiEAVA1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354803AbiEAVAZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0D718398
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:56:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so12715591pjb.3
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wBaw7EbU2XYCca04gCDqp7BVD9BHo5H3NsGva6Uo7Q8=;
        b=ote70rrK33JV4Ofxq37gxDMeQ1pJjrEeer9nyzN/xo8V24xJ2bYVI+6Wm7L81YPRHa
         teVbSRmy30vKcZz6Cf5EhQ+YF6QoYrZhfjFEiWaI0RRMpTV16XTr1OxJCUZrqEA7hAJu
         izGX33Jb3a3VOOj3MQLt/PEbhxdkT+50/Y5zYNYHcZJcpw8MzP7LOrTHyHzK/N6JgION
         diFBuu96jHncO7rHY9RJcHdMePzZU9aYxG3PIMYSATuPm/1kWzQhwvD+h0UtUlH7qTTR
         qUACItm0teY1bbsL4KcO7di3/HNy71ZtaiwNddiIdVXXyiOM7Gx6T/K03ijD31sM1XsC
         LMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wBaw7EbU2XYCca04gCDqp7BVD9BHo5H3NsGva6Uo7Q8=;
        b=6e4XyST9T7dCltXckrMjCaoZA1SLtee/qp0i3JBrb/+wufTvaCKufS3gw0Qb/C3E+t
         1Z2HYm5XLE8i4iw1GD9DkEDOu018oBEnoQp7HNESBuE3QCdnPDigbKRRlMgFSi2syHD3
         1upIPiCAwkp4QU+UpQD1z3ZKpL+NSFqF0Qp5+uo0k3A+AP1t3X1PpQgzeOAvsswkvgq2
         DhXNlzjrzi9pmwLekUbwf7UOTzr6brSa7VfXxwamAhOEiEMS8He0fQdy/q+UdnT7vFUO
         C4Xb4taqx7jdwMtyohya3DMQNW/XjEjRtSVxvMFR8t820cciHN/aw7M4870KebgujVl4
         Rszw==
X-Gm-Message-State: AOAM531Wgss9JpGm73uG5dWFdxV3kaYoalyMxDqByBJRcM0FhbeMJAl8
        5jz4Jo2Xn4oWGOmp7Fg8KwXVZkBkUdCkuw==
X-Google-Smtp-Source: ABdhPJz5SAgexqw3ZT5nir0H/jB+0cawPU8BmcSUCIjBAHNffOiQHG2doF55+0jqBPyAqwgXaPCTww==
X-Received: by 2002:a17:903:124b:b0:15e:84d0:ded6 with SMTP id u11-20020a170903124b00b0015e84d0ded6mr8709013plh.141.1651438618381;
        Sun, 01 May 2022 13:56:58 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:56:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/16] io_uring: use 'sr' vs 'req->sr_msg' consistently
Date:   Sun,  1 May 2022 14:56:39 -0600
Message-Id: <20220501205653.15775-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For all of send/sendmsg and recv/recvmsg we have the local 'sr' variable,
yet some cases still use req->sr_msg which sr points to. Use 'sr'
consistently.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12f61ce429dc..38bd5dfb4160 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5725,7 +5725,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
@@ -5780,7 +5780,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
@@ -5957,19 +5957,18 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		kmsg->fast_iov[0].iov_len = req->sr_msg.len;
-		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
-				1, req->sr_msg.len);
+		kmsg->fast_iov[0].iov_len = sr->len;
+		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
+				sr->len);
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = sr->msg_flags;
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
-	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
-					kmsg->uaddr, flags);
+	ret = __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg, kmsg->uaddr, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock)
 			return io_setup_async_msg(req, kmsg);
@@ -6031,7 +6030,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
 
-	flags = req->sr_msg.msg_flags;
+	flags = sr->msg_flags;
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
-- 
2.35.1

