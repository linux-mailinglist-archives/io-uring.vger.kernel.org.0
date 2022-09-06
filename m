Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E979D5AF099
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiIFQhM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 12:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238981AbiIFQgs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 12:36:48 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F5825C2
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 09:13:12 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 29so10752394edv.2
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 09:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=YAbMgM01V49HxL5Pe0OgAVzIDluMWHFxnOBMGiW49oI=;
        b=EqG2gLIQy8gC+HLZSSbid/4SsX4Ye5XmNtumXjC2pS8el2rxLbisBbRT7XDFcBEOok
         LMWn2lE4Is8riZxBRBnzaB0gwWGZZGI2oyhBjS3XQxOKtPiQf9TcQCrsetx5UsYuJooR
         /LRwLHEQAN08SW+KG7aIRWP0xCu6VWqKmK2du/+HETjeMXNo1rSF1OBalVX9B75r8PWb
         mHMRKAeU8ifNUBDKNCU/7AhnacoX5QH6hnOXssreb2V0GzFKLi7J4B81xsswLXZ26Bc0
         aDJ2c+/PIhB/cxfgRYShFxuuMQFYMi7FZ+bDiOJjGnFw7XBkl4NONI1bl9kREKam8zgL
         gARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=YAbMgM01V49HxL5Pe0OgAVzIDluMWHFxnOBMGiW49oI=;
        b=fqDHGQi9TTZb9azo8lsToJXQLEOaUdOlsWJaXsZfDWpfFiJSXp1mYBaXG6OWuqbmJx
         Q5hX4VUzQA+7WDM7NiBAYIKXX/1QIagfHbyiH7kiQ6OVkzvyP0hWQSpmlxrg7AgZqEA0
         RmlX+O4hSw8upsicNs6Kp7e7f5sNqLy3QrP65qx67nCnDsVuW90nH5O626KITsZwCg9N
         3buvZpTGngZQn/++IFun7WjrZe0OKFy1999dU29FawncDbCXR2JX/hmSA9UqgJgUdlgp
         bw9k+P+MNKMWd9TVt6/4LBskdVDyMFFMwmqQ6pbyVSGnCjLwxJS51J7inYiuxy/i1XZ+
         3Ufg==
X-Gm-Message-State: ACgBeo1fYnKBQIVWhEMKC/Vc/hU8kjg+jEWUH6dfst845pqk4PcvsBjk
        sxHv2/0FcBey+NqkSIYzQc3AvSgmpLw=
X-Google-Smtp-Source: AA6agR4bWXEGrlsuFeqsvm54BgXA2M8jw3hHeJbkT7iFwuvlg+6bZQEpcF5TnLNVZjP7RLXfs7+uTQ==
X-Received: by 2002:a05:6402:42c3:b0:43d:682f:c0ca with SMTP id i3-20020a05640242c300b0043d682fc0camr48050019edc.334.1662480791214;
        Tue, 06 Sep 2022 09:13:11 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:1bab])
        by smtp.gmail.com with ESMTPSA id kw16-20020a170907771000b007512bf1b7ecsm6556385ejc.118.2022.09.06.09.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 09:13:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: recycle kbuf recycle on tw requeue
Date:   Tue,  6 Sep 2022 17:11:17 +0100
Message-Id: <a19bc9e211e3184215a58e129b62f440180e9212.1662480490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662480490.git.asml.silence@gmail.com>
References: <cover.1662480490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When we queue a request via tw for execution it's not going to be
executed immediately, so when io_queue_async() hits IO_APOLL_READY
and queues a tw but doesn't try to recycle/consume the buffer some other
request may try to use the the buffer.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f9be9b7eb654..b9640ad5069f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1728,6 +1728,7 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
+		io_kbuf_recycle(req, 0);
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-- 
2.37.2

