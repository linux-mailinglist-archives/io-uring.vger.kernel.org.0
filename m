Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301EE75CE37
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjGUQSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjGUQS1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:18:27 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A434490
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:12 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-780c89d1998so28218739f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956227; x=1690561027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0ou5k87I8sTPpRqra9CBhOtTJt5c6QaC2AAQjrnZvU=;
        b=BRMTxmI+PY4omQ235bdiMvhNB9Ce0C4YAQO7D88bN1+VRHjEB099g87e/bvfP/1YhR
         5hpT1PMNCuZ3F/8gb/DiAwM8QPNGFzTCjcjYwZwF/tpdZAEDSfg+e3YQ6yvlwwHtADKC
         NmfjXaRAmejWyQAiMtaKd23p/fO3w/y1DeeBzQUJY1xSEKaGu8dQdse9qxvi2jKG8FeL
         BTxkGLhrs9jz9T/OlYUpOIBN4UWYc7azcEoyEKe+JAwQIqChR0GcB7gRne2A6ggKOKwO
         /16n9VzKV1pfwLrpyfswYblpDYe6DS8h95HQwZWrgFxzMDKjl5R1nHa5xIVEpjuwY3g4
         Y7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956227; x=1690561027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/0ou5k87I8sTPpRqra9CBhOtTJt5c6QaC2AAQjrnZvU=;
        b=a+86x6E0/B4VhT5t67hrZBXMCbdApcAVWfotMZA9x9vk5/+zeEG3nSIt3ACsFvzEIw
         qmAlTK9QTLjTZhZZwEsDvoTTidq+zISJ9hNYiCdFfDIpYr5w1L2XLHT2e4+iy7HrqMDJ
         mtQ/C+e5paiVG+oIc+21CAFcMOXXKU4ZB2ynLEPiM6msDtrOZheDNA0MEgRMcUBCz/Ir
         YLqcOVQvb4qgyjcdI162JJya2uk3fet0PTZGCOYyJGiqZ4k4WK+3A9X4nKIPPusmRlGb
         p9hOfQ473BrYMCeSch1j+GQYyNXfOHWrqAd1XfwI/ngzlKMi1HjYDZdyT8H1JzBVYERu
         rorw==
X-Gm-Message-State: ABy/qLbM/TMKohV67odSM9kQueayrNokDkyINgLYsRMAJDLp2DEYVEjQ
        IHL1+hQqZqofB6U2sbNp45nrdw9BWQSEImOz4zg=
X-Google-Smtp-Source: APBJJlGSsWXWU4FHIUZtiYJSZA11IzqG/adw0m0igijzMWLTfMvgHAO4+Tzm08vKqUEF0hI3XCz9YA==
X-Received: by 2002:a05:6602:1a05:b0:780:c6bb:ad8d with SMTP id bo5-20020a0566021a0500b00780c6bbad8dmr2383411iob.0.1689956227115;
        Fri, 21 Jul 2023 09:17:07 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:17:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] iomap: use an unsigned type for IOMAP_DIO_* defines
Date:   Fri, 21 Jul 2023 10:16:50 -0600
Message-Id: <20230721161650.319414-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IOMAP_DIO_DIRTY shifts by 31 bits, which makes UBSAN unhappy. Clean up
all the defines by making the shifted value an unsigned value.

Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ae9046d16d71..dc9fe2ac9136 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,12 +20,12 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
-#define IOMAP_DIO_CALLER_COMP	(1 << 26)
-#define IOMAP_DIO_INLINE_COMP	(1 << 27)
-#define IOMAP_DIO_WRITE_THROUGH	(1 << 28)
-#define IOMAP_DIO_NEED_SYNC	(1 << 29)
-#define IOMAP_DIO_WRITE		(1 << 30)
-#define IOMAP_DIO_DIRTY		(1 << 31)
+#define IOMAP_DIO_CALLER_COMP	(1U << 26)
+#define IOMAP_DIO_INLINE_COMP	(1U << 27)
+#define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
+#define IOMAP_DIO_NEED_SYNC	(1U << 29)
+#define IOMAP_DIO_WRITE		(1U << 30)
+#define IOMAP_DIO_DIRTY		(1U << 31)
 
 struct iomap_dio {
 	struct kiocb		*iocb;
-- 
2.40.1

