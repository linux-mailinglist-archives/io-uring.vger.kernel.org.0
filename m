Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D0595628
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 11:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiHPJ1H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 05:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiHPJ0i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 05:26:38 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E633CAC88
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 00:43:24 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x21so12417590edd.3
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 00:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=yVzqRhsA8UgsVSoAOBpYJgpjwlxlDe/nBeUWWw8GQ1U=;
        b=Lad4ZptyJtJSoMxQI2Un7L81eQnwRD2kH5hx4JIcZ4IBbTgoB5Xss2pSIeJD5w7uOW
         z03eou0pQIQafSw/ADFYhc5DqJofx0QOjxlVFhB1i87tvnyKUFLqMWG2nm/awhxrIaSQ
         NCSBovETHCvVeu0swOxhE8HMZOFHe/0N/M8j2LSWQLwtuIghNnGzpFzPSFa9fsGNt6qp
         3jqmwdjWAwjQNA6XqXKfZY3Xe4Hx7h3R8ssVVpC4qqp3RXfa4G9PDD6REWlZX1PlLnPf
         4lGmG95qlBkX87oTp5jlQVf7HrJF/B+rmv28CX0/5pajmAp2dNR6MtLYuQ+Gy5ebru2d
         8sWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=yVzqRhsA8UgsVSoAOBpYJgpjwlxlDe/nBeUWWw8GQ1U=;
        b=ycV8+6F9+jBumgNaUSNE/iqmjv+8DSBlQf8ALISX/2hE5XrN5XK+LDrrk4srygzC1h
         nIc2WH9r2M/biz/CUenQQgGMWBuejn3z4Z8wITwztgV7qFiDm3gR2F+NzjIYRzPHf7fi
         DNO0yflhU6mtQro00BX6OqX9WJpUZikQQ/mGFst5SJgLyrzJPvlT9CEgsXZ5npWnBHlG
         +7OREXm780ePsPTQyytSBDp3pK3/UVZZhZApceJ4Q5mkt0IPed9KoekniVQ0XypwjHuD
         xniMiAzZFrBqte5OiaAgMk6MY+2X9O8USCDawngWW+Pud4xwzX3ykTcugXIeS9w51uOd
         KCUw==
X-Gm-Message-State: ACgBeo3bAD/wOKSMMi0GVT5qpdY0U7eBQYktANtkvVEg6CTi9IWdh4B7
        mcarv/gtrcplu1BBWpW7FRKRkU4M7NU=
X-Google-Smtp-Source: AA6agR6LCG41lq+LAzNh2WuG7qvVYWG7aFP6Q5xciCKd1zpzeSfdDaJP2eG1R5Cocy1ZSvaYQHQa9Q==
X-Received: by 2002:a05:6402:2753:b0:43a:d6f2:9839 with SMTP id z19-20020a056402275300b0043ad6f29839mr17257050edd.73.1660635802255;
        Tue, 16 Aug 2022 00:43:22 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id e1-20020a1709062c0100b00730799724c3sm5057363ejh.149.2022.08.16.00.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 00:43:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [RFC 2/2] io_uring/net: allow to override notification tag
Date:   Tue, 16 Aug 2022 08:42:01 +0100
Message-Id: <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660635140.git.asml.silence@gmail.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
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

Considering limited amount of slots some users struggle with
registration time notification tag assignment as it's hard to manage
notifications using sequence numbers. Add a simple feature that copies
sqe->user_data of a send(+flush) request into the notification CQE it
flushes (and only when it's flushes).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/net.c                | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 20368394870e..91e7944c9c78 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -280,11 +280,15 @@ enum io_uring_op {
  *
  * IORING_RECVSEND_NOTIF_FLUSH	Flush a notification after a successful
  *				successful. Only for zerocopy sends.
+ *
+ * IORING_RECVSEND_NOTIF_COPY_TAG Copy request's user_data into the notification
+ *				  completion even if it's flushed.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_RECVSEND_NOTIF_FLUSH	(1U << 3)
+#define IORING_RECVSEND_NOTIF_COPY_TAG	(1U << 4)
 
 /* cqe->res mask for extracting the notification sequence number */
 #define IORING_NOTIF_SEQ_MASK		0xFFFFU
diff --git a/io_uring/net.c b/io_uring/net.c
index bd3fad9536ef..4d271a269979 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -858,7 +858,9 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->flags = READ_ONCE(sqe->ioprio);
 	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
-			  IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_NOTIF_FLUSH))
+			  IORING_RECVSEND_FIXED_BUF |
+			  IORING_RECVSEND_NOTIF_FLUSH |
+			  IORING_RECVSEND_NOTIF_COPY_TAG))
 		return -EINVAL;
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx = READ_ONCE(sqe->buf_index);
@@ -1024,6 +1026,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	} else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
+		if (zc->flags & IORING_RECVSEND_NOTIF_COPY_TAG)
+			notif->cqe.user_data = req->cqe.user_data;
 		io_notif_slot_flush_submit(notif_slot, 0);
 	}
 
-- 
2.37.0

