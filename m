Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A8D510717
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 20:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244326AbiDZShD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 14:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351823AbiDZShB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 14:37:01 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB9C45507
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:33:53 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id f4so492360iov.2
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 11:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4S/OdOCcrSeoB3Vknm6QSl0olntv/bkKXzOrip0JfmQ=;
        b=AhyEc2Ai8JIikdrujs6m0NBJoaqvVegvqvVhrHyZHcLQcOVjmdAJ0kRVzKWLHwl8Kr
         hxZryzvqHBl4RgLqoLxAzBZI9lcH7pEudl5j11rWT7PnTkPbp1ZRvRK0f2UKPEtBfX4t
         DJeqiyjyFjV/udTbUvsHvh/kjxJV8QdfEsiXDSFTf/NnNd1+BhfFiIYSOuUTAgVWIFyJ
         6m1xaaRcQPn2p5D2E3sqX/yRW6tBomPGPpnIdf+WAJvxbq9ucOFtCBB2VNhcPdqdWbpv
         VYYOLK8Hrw9c+o9c6xM5GfTdZfLzrz3fB+PluFA/de9vNyw/gEpgrcLRvkg038lmYOMp
         yDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4S/OdOCcrSeoB3Vknm6QSl0olntv/bkKXzOrip0JfmQ=;
        b=Z0QJ2AdcycGzy1icXi30gvb8O4foBzHdK6lP3RsFQgbJvI2wEpo2gXz6dtyoe/r6L7
         w3tUKG8mW1YM3ObhGyiicyvfgbmBAgRuxjU7kaE2Q9hCaENjf3AvMZUE9XjhJvKN2/dg
         46WM6hTCiMp8dYlQE2Edwerv8hmGawsso7Z0vj/2jye2fPyMtRvDbhYyV1MvO22HiTFH
         HSS9+Y27eS+vxbBoqvFog1Z0MYDTgibFGwBQ6kf3HfGByvpnRU3XSrFT4Ebe+9U4oN1Q
         s4OYtYbyJguP9TgWu4S0dAcxdHc69K1bT1iZeaIzubsxSUn2Xf+HWQscYDI7Ym0yB5px
         mirQ==
X-Gm-Message-State: AOAM533tOXCpLyZxzO6WXzm28t0HQycAyRtVlyPXSoaHGxn4/6lcW3aS
        7Gr7+mZ5NfolwKQy2Hf84n9vJp1XRBBdGQ==
X-Google-Smtp-Source: ABdhPJxjo36kqEtIhbxp9L4aUkHWiYCokAD7PzdSjjnjsZy4qYXXhWXXiYanJtnSkAXx7eQm7EaR0A==
X-Received: by 2002:a02:93e1:0:b0:326:7a7d:a2b0 with SMTP id z88-20020a0293e1000000b003267a7da2b0mr10189781jah.44.1650998032582;
        Tue, 26 Apr 2022 11:33:52 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o7-20020a92d387000000b002cbec1ecc60sm8227524ilo.86.2022.04.26.11.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:33:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: wire up IOSQE2_POLL_FIRST for send/sendmsg and recv/recvmsg
Date:   Tue, 26 Apr 2022 12:33:43 -0600
Message-Id: <20220426183343.150273-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426183343.150273-1-axboe@kernel.dk>
References: <20220426183343.150273-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If REQ_F_POLL_FIRST is set and we haven't polled for this request before,
go straight to checking poll status before attempting a data transfer.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eb5f77bde98d..3ae18604ed59 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5315,6 +5315,9 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
+	if ((req->flags & (REQ_F_POLLED | REQ_F_POLL_FIRST)) == REQ_F_POLL_FIRST)
+		return io_setup_async_msg(req, kmsg);
+
 	flags = req->sr_msg.msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
@@ -5357,6 +5360,9 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	int min_ret = 0;
 	int ret;
 
+	if ((req->flags & (REQ_F_POLLED | REQ_F_POLL_FIRST)) == REQ_F_POLL_FIRST)
+		return -EAGAIN;
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -5547,6 +5553,9 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
+	if ((req->flags & (REQ_F_POLLED | REQ_F_POLL_FIRST)) == REQ_F_POLL_FIRST)
+		return io_setup_async_msg(req, kmsg);
+
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		kbuf = io_recv_buffer_select(req, issue_flags);
 		if (IS_ERR(kbuf))
@@ -5604,6 +5613,9 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
+	if ((req->flags & (REQ_F_POLLED | REQ_F_POLL_FIRST)) == REQ_F_POLL_FIRST)
+		return -EAGAIN;
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
-- 
2.35.1

