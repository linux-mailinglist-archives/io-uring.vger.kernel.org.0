Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FBA73BD1F
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjFWQtU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjFWQsb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:31 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C1F295B
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b5079b8cb3so1764345ad.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538900; x=1690130900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikHYZC63ffUOiMeB1sgmZexCpeBnqjH4Ml2zN5xiDow=;
        b=nYFxLmQX/iYEZsBtBVP/PIrWS3WvnrB2bAbW7XzMFAf7CnPUiPiWymNcCuZPJbZf4V
         jPS4bP0e0YDCETek+Lm0tPRpRW82/VDjyKPezQt1ZZVK+R8pJYJAG8vVAoqjyHNcGFWd
         8gCAHrXXBu9O179a3i+gZYKhxYmAePzIZXDcHldJBx0yX7QgGMiQBF5mwZWP86QVNuc5
         fyYv9GBt0OZvykm1M2q5bs7eySLXe+qQWVXus3UbvuavyVjWC9OaG3G0QEFjGt+9xMM9
         B2NsLBTmJyhTPBCbI2k/dp9+Xd3Bk7cdyi9wthT1oafo1rD1pcdHG6QyOsmsN+UKi/3c
         fHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538900; x=1690130900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikHYZC63ffUOiMeB1sgmZexCpeBnqjH4Ml2zN5xiDow=;
        b=dcP2Gtev2yCqorsZfgSl7i8zZbjR0Q1IY5602jY9/22R+eZ9/wzjFloJyDuPYNt6w1
         7cFDd6S5QUtg32OubAzBYMZ+yBIF1PNTDEiJZLnK1khU+a7ZGtOAGHg8dyJ01UdsEJ19
         LIkNYXlfB1R0W4aJveR3RNJyzvONSvA22ptlf4HnVTmZRZanuwgBs48DWXueqUH4/K1D
         lHgEUtrkk7H7ok16nUNGYVpgFAzn/te946e2v6PZD06nWhNcEzHg/x0uZhnGBWX29J0i
         miT7x7+EaKpOC04uhWzyGeXyv5R67PZ8mnaZekts47IZ3s0zAFea0RLpyiy7m66L9Qhf
         9klQ==
X-Gm-Message-State: AC+VfDyY6n5F4zgEZLtNdhF19NTYo2y8/A8FCtYUZs3mi4Ox/iOLNR62
        QFf2StoG1NKshq6zkrsLPO1OJSpqMzaRX5WxzRM=
X-Google-Smtp-Source: ACHHUZ4xSzuaNlQGDQEMQU02nItqUXJyDzP3bCE+TQdSfP8j5P1dk3Yq90RJaNTSVlKsumtqZ+wq1Q==
X-Received: by 2002:a17:902:ecc6:b0:1b1:9272:55e2 with SMTP id a6-20020a170902ecc600b001b1927255e2mr26608571plh.3.1687538900202;
        Fri, 23 Jun 2023 09:48:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring/cancel: wire up IORING_ASYNC_CANCEL_OP for sync cancel
Date:   Fri, 23 Jun 2023 10:48:04 -0600
Message-Id: <20230623164804.610910-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230623164804.610910-1-axboe@kernel.dk>
References: <20230623164804.610910-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allow usage of IORING_ASYNC_CANCEL_OP through the sync cancelation
API as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  4 +++-
 io_uring/cancel.c             | 11 ++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index af3b862fa905..7fbd57f4c2ff 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -699,7 +699,9 @@ struct io_uring_sync_cancel_reg {
 	__s32				fd;
 	__u32				flags;
 	struct __kernel_timespec	timeout;
-	__u64				pad[4];
+	__u8				opcode;
+	__u8				pad[7];
+	__u64				pad2[3];
 };
 
 /*
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index d91116b032eb..7b23607cf4af 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -265,17 +265,22 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_uring_sync_cancel_reg sc;
 	struct fd f = { };
 	DEFINE_WAIT(wait);
-	int ret;
+	int ret, i;
 
 	if (copy_from_user(&sc, arg, sizeof(sc)))
 		return -EFAULT;
 	if (sc.flags & ~CANCEL_FLAGS)
 		return -EINVAL;
-	if (sc.pad[0] || sc.pad[1] || sc.pad[2] || sc.pad[3])
-		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(sc.pad); i++)
+		if (sc.pad[i])
+			return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(sc.pad2); i++)
+		if (sc.pad2[i])
+			return -EINVAL;
 
 	cd.data = sc.addr;
 	cd.flags = sc.flags;
+	cd.opcode = sc.opcode;
 
 	/* we can grab a normal file descriptor upfront */
 	if ((cd.flags & IORING_ASYNC_CANCEL_FD) &&
-- 
2.40.1

