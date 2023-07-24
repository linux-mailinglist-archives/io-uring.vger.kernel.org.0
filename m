Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E340B7602BD
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 00:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjGXWzU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 18:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjGXWzT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 18:55:19 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F601B8
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bb91c20602so3392625ad.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239318; x=1690844118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVeLYS33nnc1708rDqfbQibRM29ZHSZOxWFzkowQIMY=;
        b=ykm9gWdurj0xOxNjjFoGt7mW+OF9Gw/mBBQYDdfmgAR63NziZCw7JWsImTNuRnwqQo
         Wa1aZQ8/c6v82ktiGrh8sftd+3evkOvwVSYT8EuHB0ykswG2vdvFhgDu67fczpcRPwmn
         DRFxhrtpDi+H7zZy0A5D0sjP93cQYLEZE4vhxnhA/7bDs1VI2cayrOp5LJdJN4v2f5Rt
         /j/RKgIBYDUYcz+Wa8NLZcr39bRM/paQtfR6K2cNHC/QiYD/u6s6Uk6dr4CIiIeEwFSI
         DgBH9UNr3jaCGYG61cc8CciPApi+Q7wQJOCJ0SdmTPBHxayNs9nRH6rM51+6gYeaxbJM
         gn9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239318; x=1690844118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eVeLYS33nnc1708rDqfbQibRM29ZHSZOxWFzkowQIMY=;
        b=SiLzw4ylc3lWV06zcrMvJKQYKN+5T10Rj9cU6vTWKyAoQmIn26E0KVK0HhadTJq+QD
         UCkSZQxgrmj9Xg8tt+gk2vfbs7NhMef+RgNJFuZStzx3mCkmD9/FC6lvQMosVBgAFWku
         yeqh6xE3I+HVeZgNZzFad9qXZnxTcyeWkta6fBMg7Xn/Sl3bztz4AWhajeOgNNilhGLl
         Hx53WY3ytHtXt6dV2WKkSsYlXHUN8+nEtH9LtVO2MxozvW41xS3CEDoRNbbhsObXhEJ9
         lyjv5E5a8PBr3b6N9QlcB1IIq/OySAsLwrImEj++Fa+5Q8GcnIqbrnuY87PTVqI2lHAP
         1RZg==
X-Gm-Message-State: ABy/qLbQBKr1f5cGDYofuJyCfKnDM10/qp/o5xxXYofSRnjOq641iNSs
        OazscoJuY7JXK8uMgiiSTpucHpIilWkXHREz+QQ=
X-Google-Smtp-Source: APBJJlGftuzyUY14869rqyzSOwXATOafJNKRe47t9tts3Omzk/El6tbEHeyUXO9Zpn43CHB8fY3Tlg==
X-Received: by 2002:a17:902:dad2:b0:1b8:9fc4:2733 with SMTP id q18-20020a170902dad200b001b89fc42733mr14708729plx.3.1690239317766;
        Mon, 24 Jul 2023 15:55:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] iomap: use an unsigned type for IOMAP_DIO_* defines
Date:   Mon, 24 Jul 2023 16:55:05 -0600
Message-Id: <20230724225511.599870-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
References: <20230724225511.599870-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IOMAP_DIO_DIRTY shifts by 31 bits, which makes UBSAN unhappy. Clean up
all the defines by making the shifted value an unsigned value.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 0ce60e80c901..7d627d43d10b 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,10 +20,10 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
-#define IOMAP_DIO_WRITE_FUA	(1 << 28)
-#define IOMAP_DIO_NEED_SYNC	(1 << 29)
-#define IOMAP_DIO_WRITE		(1 << 30)
-#define IOMAP_DIO_DIRTY		(1 << 31)
+#define IOMAP_DIO_WRITE_FUA	(1U << 28)
+#define IOMAP_DIO_NEED_SYNC	(1U << 29)
+#define IOMAP_DIO_WRITE		(1U << 30)
+#define IOMAP_DIO_DIRTY		(1U << 31)
 
 struct iomap_dio {
 	struct kiocb		*iocb;
-- 
2.40.1

