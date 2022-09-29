Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF43D5EFF3A
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 23:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiI2VYZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 17:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiI2VYY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 17:24:24 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C3FD8E11
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 14:24:24 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k3-20020a05600c1c8300b003b4fa1a85f8so1326486wms.3
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 14:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0oDJG5St1aewbD4VVM0usOD2Nw4X6zWahuhRNiu1go4=;
        b=LpzKSqCX/LJtMUiwLgLB0UGNx4Gvry2KEpDCgnc5Kdt5IwSnw2RMdGmj8bxM+8VAlN
         wABLAgx1xbyrgNhoQHCDr6vM6GYcoBamVGy95jCS3CM4gEUVnrxVBlLvXUaOrVHdkQKz
         BD9wZ8/sfzXZS6QpbAQNw0iCAKEAWoJKHyhdrBVJ1cYUJa97qf2Oitl/K1XM9/wbAcZS
         GqvMDhk4rd328Tqq+2qDN1kWlIREQfVZgflCHmfn6BaYvzwsNYjc9DiTO7F18FjAgxJn
         2uAA6kWyPh95Pq1XCDYfhzgXr40D+qQFNmXzE1piXQKYhUOnIpgKzQlJVvjQ2E2FxW2f
         0/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0oDJG5St1aewbD4VVM0usOD2Nw4X6zWahuhRNiu1go4=;
        b=tFiLm1BJcGpMqaLpLuVqkUg9qcECeRHXQDgzQhtfEU3FtNdptxnjTv1JlsPeIHV4bI
         vzAwKKKzMk61LfE7rMIMnYiEnoVvoqh/7nUfjmTDNASoQwDzuBxH2GzIDmRBdAs1qj0S
         +Ypj43MAQ0pkCpKzG1Xb+Uh8wFgM+sU04FhVkhRWhdFvBVfv2DMY4s2jShhe5tqWW+0t
         szU47v8W65W70VKuNloQq7Ap63id1lbjKjSuWx3RkF+7AgQ3ZZbVWp6OW52xhBVh5SHP
         n24O0tgDvJGRoHUl0WY5JNoXJFANKc/bsIV/49E6vuvMoonH1/dyUNBIZ4EMzr5tri+a
         GR/Q==
X-Gm-Message-State: ACrzQf1pF4y8nW9P0RDnsBNQ76dzP/bt60x+vRYI7s1oTskJqWaCdw1Z
        j4l+FpWqjBM3KzAltZouB/IrRnvIweI=
X-Google-Smtp-Source: AMsMyM6Acbo7DnLBm9WQE89ZISDHJpeUtuCasGdLtzwZNqd2T6+BqMkNEEheVO73fymgC/h8Db2PaQ==
X-Received: by 2002:a05:600c:3b1a:b0:3b4:858b:aef1 with SMTP id m26-20020a05600c3b1a00b003b4858baef1mr3793519wms.193.1664486662216;
        Thu, 29 Sep 2022 14:24:22 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id x24-20020a05600c189800b003b4727d199asm435023wmp.15.2022.09.29.14.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 14:24:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/2] io_uring/net: don't update msg_name if not provided
Date:   Thu, 29 Sep 2022 22:23:18 +0100
Message-Id: <97d49f61b5ec76d0900df658cfde3aa59ff22121.1664486545.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664486545.git.asml.silence@gmail.com>
References: <cover.1664486545.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_sendmsg_copy_hdr() may clear msg->msg_name if the userspace didn't
provide it, we should retain NULL in this case.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 9ada9da02d04..604eac5f7a34 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -164,7 +164,8 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	}
 	req->flags |= REQ_F_NEED_CLEANUP;
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
-	async_msg->msg.msg_name = &async_msg->addr;
+	if (async_msg->msg.msg_name)
+		async_msg->msg.msg_name = &async_msg->addr;
 	/* if were using fast_iov, set it to the new one */
 	if (!kmsg->free_iov) {
 		size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
-- 
2.37.2

