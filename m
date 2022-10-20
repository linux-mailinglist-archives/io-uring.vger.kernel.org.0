Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C1C605533
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiJTBvK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiJTBvJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:51:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E96160218
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:07 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b12so27810410edd.6
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5hVbP21WvWp4Tbq/Evw+Inc3Y3dB3jO1JQfJ1VE0qQ=;
        b=FEH7PdTFU1R91EbloQeYsJ3+6hZtuv7pKo+zgFlh2oq6wWrlMdBaw+qDUuQ1WsYEt6
         8wrbfXhqWoqxfpOxG0s6BkyDVmURdtrW1MTLreof8y6TqAGlA7mtyMrZY8YYqajGrzqD
         pVYeVyFG0LVJ7XfOmhkFHHLvaQSUCvL6BbSM6QV0/9iMG1fVrpoWlSz2oS9OeLRKCJKY
         xdkujSUjP+IChx2DAn/KYgPc+4KsXs+gH/wS5flxMAjOw41NApI0pWYZSd0AB8zUv1iX
         JDsJK9lWiwsbAssl9M3LZNWZwmYwNBmBZlDKSvKdSCoxNdF/kbY4Td21cEglMyjGXwxf
         WPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V5hVbP21WvWp4Tbq/Evw+Inc3Y3dB3jO1JQfJ1VE0qQ=;
        b=sB1jkgSq6KpI0jGf9LrHWkWesI/bXHUaXc7WWNS3oLhLM6rn8mhPhlnJ/67x0+VG74
         VF210xCPYjgxtSrsfTLPPyXnUaMEKZFClaqNvxTdNM+AZ5xDY7UCH30LeRWtn6+97oyV
         Ow5jRTG2g5FVY2cBwbQmTWlg8mp56ocgcsSm95pfOLOVlqLyCEJjYQ2aV5tz5nyUCd5I
         5GL4s9d8QhbskVLwTQp05CSE6CRSjwHyJ8gaAutcxg1m/L3Cx9xMEnBiEXV6xFC9t/rJ
         6yjXg4U7JpultIMa6z7sUgEH11SrKgVKxO1LMi0ugZNhHy1EMmB4lsPYHpOx31xM1UrS
         UqDA==
X-Gm-Message-State: ACrzQf008ryIhETK+FsFuQQZ67IjbUw5b9KbZxWRCHYBeXstL5V+s/k5
        dwrBbvy6qdrabXu1G8tFvwyt6EzbRZE=
X-Google-Smtp-Source: AMsMyM5eJ2O+J3T6MPQVYAJ6eH+M8dFrx5FgiR0eua4QL9p5r0aLzn/s2nZ00t11+QfhJpe6M7yMJw==
X-Received: by 2002:aa7:c04f:0:b0:457:1b08:d056 with SMTP id k15-20020aa7c04f000000b004571b08d056mr10481186edo.146.1666230665535;
        Wed, 19 Oct 2022 18:51:05 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a50ff0d000000b00451319a43dasm11318420edu.2.2022.10.19.18.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:51:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing for-next 5/5] tests: test poll_first
Date:   Thu, 20 Oct 2022 02:49:55 +0100
Message-Id: <ea489a5ada8b5ef24e039715713f325541267ca0.1666230529.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666230529.git.asml.silence@gmail.com>
References: <cover.1666230529.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 010bf50..1403fd5 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -265,6 +265,7 @@ struct send_conf {
 	bool zc;
 	bool iovec;
 	bool long_iovec;
+	bool poll_first;
 	int buf_index;
 	struct sockaddr_storage *addr;
 };
@@ -375,6 +376,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		sqe->user_data = i;
 		if (conf->force_async)
 			sqe->flags |= IOSQE_ASYNC;
+		if (conf->poll_first)
+			sqe->ioprio |= IORING_RECVSEND_POLL_FIRST;
 		if (i != nr_reqs - 1)
 			sqe->flags |= IOSQE_IO_LINK;
 	}
@@ -463,7 +466,7 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 2048; i++) {
+		for (i = 0; i < 4096; i++) {
 			bool regbuf;
 
 			conf.buf_index = i & 3;
@@ -476,6 +479,7 @@ static int test_inet_send(struct io_uring *ring)
 			conf.zc = i & 256;
 			conf.iovec = i & 512;
 			conf.long_iovec = i & 1024;
+			conf.poll_first = i & 2048;
 			conf.tcp = tcp;
 			regbuf = conf.mix_register || conf.fixed_buf;
 
-- 
2.38.0

