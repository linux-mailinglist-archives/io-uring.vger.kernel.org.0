Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD687071A0
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 21:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjEQTM2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 15:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjEQTMX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 15:12:23 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFCEAD0A
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:12 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-76c6e795650so179939f.1
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684350731; x=1686942731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SM0dEJvoZTNqWby0NsDJcypvoJnqRDOoMK+FyUUukzU=;
        b=NlE+DJBMpjyDexZMA7pqgO6hwPVCwf+/nLNMaUDQwW0ig3/dpS2TNDyQXX4e0tCHht
         MeSRPZpRi7s8iUGayu52Ta9eozJP0DPQhZ7xGSRRPUZZvbLzaCMSZDgfG7xxFI/rho2S
         Qp1eC1GsV/uuFJFHl5KpUaa957wYDM8MuS3JmlUb73+SAM1gtnm8Er4COHFavFzzdpDY
         xgRD46Pn0l1wbW4bggflUctLut7trJYohpuGdUkyocjtJdnUgXpZyLe9F2icOIW2GDNt
         D5MK25tBofFaefuqbs3stMInK/aEPDzirBILA+A5Sk9OR1r/4eN5uoOOP9ReaE1/QBqb
         mBLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350731; x=1686942731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SM0dEJvoZTNqWby0NsDJcypvoJnqRDOoMK+FyUUukzU=;
        b=hplL40smVzQlebbWf0c/1K8dgCSSbvEE/iGKzgIPfC1cEfLwi8whaAl1r92TkJMT2m
         YjsBRJRRxn3pKaiUDYTmXrWxVbxBTc99I1Ua35QB33R7Ap4H+yTz7ubWq3XZEBwSyPFL
         7f4YyXoZ5/k0P0XQXmk1zKN/84NGtm2MAR6MQnXDiqdsalX0dIBakNXx5oXIc1Ck4Tqu
         D4VRjIaVWHY9+D3yO+bTY2uBfW+kshbMUrRqhYTlXlQGElfOYsgMITyWImWD3lC9j2Vn
         55n4BjZbNIroyjeoM0CdbD1k1xm0/6di9ZAHDJ0r9rGxRMWa8VOop4eNXE77yWfQc5NF
         8ukw==
X-Gm-Message-State: AC+VfDxv2BFsK0AEE9KqxKg5qDZw9OshZ3PcRSxqA3KaTChJzKbhgRKb
        9+baaQ1SIDZzt7r5oaU4kDySrIrmlV0Y7kivwho=
X-Google-Smtp-Source: ACHHUZ75fFQ8k4IBs08/y8BiOp4MbSeRs9WfRWRZeZnEhfZAg6mqnBG1raC9s6MEdXXaGL17WbmDVQ==
X-Received: by 2002:a92:60b:0:b0:338:4b36:5097 with SMTP id x11-20020a92060b000000b003384b365097mr610804ilg.1.1684350730951;
        Wed, 17 May 2023 12:12:10 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b16-20020a92db10000000b0033827a77e24sm628996iln.50.2023.05.17.12.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:12:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/net: initialize struct msghdr more sanely for io_recv()
Date:   Wed, 17 May 2023 13:12:00 -0600
Message-Id: <20230517191203.2077682-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230517191203.2077682-1-axboe@kernel.dk>
References: <20230517191203.2077682-1-axboe@kernel.dk>
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

We only need to clear the input fields on the first invocation, not
when potentially doing a retry.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 89e839013837..08fe42673b75 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -860,6 +860,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
+	msg.msg_name = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_control = NULL;
+	msg.msg_get_inq = 1;
+	msg.msg_controllen = 0;
+	msg.msg_iocb = NULL;
+	msg.msg_ubuf = NULL;
+
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -874,14 +882,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		goto out_free;
 
-	msg.msg_name = NULL;
-	msg.msg_namelen = 0;
-	msg.msg_control = NULL;
-	msg.msg_get_inq = 1;
 	msg.msg_flags = 0;
-	msg.msg_controllen = 0;
-	msg.msg_iocb = NULL;
-	msg.msg_ubuf = NULL;
 
 	flags = sr->msg_flags;
 	if (force_nonblock)
-- 
2.39.2

