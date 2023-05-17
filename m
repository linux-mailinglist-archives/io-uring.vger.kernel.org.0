Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D86C7071A3
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjEQTMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 15:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjEQTMa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 15:12:30 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E57A5D1
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:15 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-76c6ba5fafaso7279239f.1
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684350734; x=1686942734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSHgpsawUu5gp9G1ICYLSm0Yw+4JMWG54aNinBgLm1Q=;
        b=rPWTS/7OTVM0SsAcsZH9eMEwqU7lHxdsuePaEQG8lsKaxpInFtgXjC0Q4CSrYtTGWn
         CsIrBS4vfMw9Dxkl7pRQ9c4Uhd2yRMOKRZsoVX95Pb+fD97e4MiMWHyE+0QVc2tiqvL5
         uCuS412P3yMtlLeRRvaaneaLe0n16dn8YfOwJtcmSDHum04GFTIFqlkUCwJZR2vWaHiU
         RTkHa7M419/KUd6jQQJGp6+WxYgBmtQsRalLK3/Yk+YDqMa3mlJv+vNArLnypWMR6RWr
         S95VSRvdCFhiprSpCiBzDWSfiCNbSbN1Hw9qvQgO+IMsM5B4goZ35Ye9TpdRY0ptPbJ9
         q9IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350734; x=1686942734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VSHgpsawUu5gp9G1ICYLSm0Yw+4JMWG54aNinBgLm1Q=;
        b=dk0GZzQhA8T30I0xCr/wMxUkyGnXISKmAf0acYIkC4wkMnENXTjQzH0GaH1LCmJjNk
         mVSu0x2euNXtZepfa/zoVsECVimCWxH6+/DYv2/d8pBPDuo5epeP5F/s/M/kIgr1zJRI
         UyFBVFqqVeb/WVe+fZ0piybXS2NY9f8p4h254KWBxS1+VmkQ7NECb0JDB8UXGZm6DseC
         cPd23ZNAROr4RCMHRQSqvpzrfD+plYQjyaweNx0V3N8e8Tl+Y1iScgoKEbmvlEji+beS
         pI7PV/U2Qt042tYTdoQOBCSFzIfv7nWoU2m3Cgy5UgLqhw4JzBBBm8UfLmNYymXkk6zq
         qaLw==
X-Gm-Message-State: AC+VfDxYt3i6z/sM66gF9jQjCM5zwciYPn22XG/aFAV61ZC6qTAtdJ4W
        8QtI2l+S2iP9vF+zRzckEEmuajy3bP6USbwTlHw=
X-Google-Smtp-Source: ACHHUZ6sGEOVnBUSUVwUeh5hZmCalH2JBttwK5v5kRqvHgHzN7nmH4W6hvf/Le6KRS51iq/pqbq4Pg==
X-Received: by 2002:a92:300b:0:b0:332:f7a:4347 with SMTP id x11-20020a92300b000000b003320f7a4347mr1828436ile.3.1684350734062;
        Wed, 17 May 2023 12:12:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b16-20020a92db10000000b0033827a77e24sm628996iln.50.2023.05.17.12.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:12:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/net: initalize msghdr->msg_inq to known value
Date:   Wed, 17 May 2023 13:12:01 -0600
Message-Id: <20230517191203.2077682-3-axboe@kernel.dk>
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

We can't currently tell if ->msg_inq was set when we ask for msg_get_inq,
initialize it to -1U so we can tell apart if it was set and there's
no data left, or if it just wasn't set at all by the protocol.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 08fe42673b75..45f9c3046d67 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -785,6 +785,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	kmsg->msg.msg_get_inq = 1;
+	kmsg->msg.msg_inq = -1U;
 	if (req->flags & REQ_F_APOLL_MULTISHOT)
 		ret = io_recvmsg_multishot(sock, sr, kmsg, flags,
 					   &mshot_finished);
@@ -821,7 +822,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		io_kbuf_recycle(req, issue_flags);
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (kmsg->msg.msg_inq)
+	if (kmsg->msg.msg_inq && kmsg->msg.msg_inq != -1U)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (!io_recv_finish(req, &ret, cflags, mshot_finished, issue_flags))
@@ -882,6 +883,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		goto out_free;
 
+	msg.msg_inq = -1U;
 	msg.msg_flags = 0;
 
 	flags = sr->msg_flags;
@@ -923,7 +925,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		io_kbuf_recycle(req, issue_flags);
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (msg.msg_inq)
+	if (msg.msg_inq && msg.msg_inq != -1U)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (!io_recv_finish(req, &ret, cflags, ret <= 0, issue_flags))
-- 
2.39.2

