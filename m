Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92872592F1D
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 14:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242251AbiHOMoH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 08:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242180AbiHOMoH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 08:44:07 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEEADEE7
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 05:44:05 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p12-20020a7bcc8c000000b003a5360f218fso7756507wma.3
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 05:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=MsasM6XB4EDhVmKSN0djCwN82ilWc2CKpoiQ2edatCs=;
        b=M2K184tVQWwrs5Msc4k/hhvFJDb1TV/9WW7WttwsbMNPzQi5b6qQ+9qVKrvCXiT7kw
         eOE/IIEzcjEsE40shJ1v7eJI4Vnyi9BcpAjSsgDN8YUhHDKVoPWGvO/4ULl0WvFLCalg
         lodR3LSkJKPBKugn6PzDRD/wGyhUGA616XR3xhsA0kWZQD8KQu3+0FXKpJpCabaDLBRV
         jqNQ4KFefLszoSq3+nYyK0QxwgBryDFG2XodcJ14T2OC2lOm54X2H3o7F/6rNTKlsaGs
         7H5l+7O8QW3sEqIxuLCbSNl+k5dgU9TjcJRmCySLL3xlterdPUO9b/A2Xo3slu+TGR8z
         2msA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=MsasM6XB4EDhVmKSN0djCwN82ilWc2CKpoiQ2edatCs=;
        b=N1CdHGT6me3HE2ctDIo5jaAfNrw4lxuh/FbUgD+oPCvcyi1ydN5HbblrLO1TQLTG18
         6+vQsjHof/vVXUqfdNqzo4WkAQAcMN0aRNfrlvpcowZR4nHEbwXNiQsqTVReyUAqGAPs
         pONsXnrKIZkA//oGkp4pX87F0TYZDASsCC2pZtGMDHY9mHMfKApi1xDZhFkPlJIr1kpw
         uxHZFvy5RAI3OI092Ps8Ixuk7nJqxcyAnP0nfWzLY3Eb6kFlT/xQMSk23BViR1Anhyxe
         jgnzUQHMOycskJee7zsR+rERAWqhJqxyM+diPS6Q15Bz64gSb0EIsSIEY9uyxtxSeohC
         35TA==
X-Gm-Message-State: ACgBeo1kbzACNPAJ3kfI0LE4V+WJDtPtw7ylq+pGPJMnkuIGWj3cEcxK
        HxIBuuIhxnRBJandWUPqgb5uLrLQVhw=
X-Google-Smtp-Source: AA6agR4irOPzacWr0/RDZa3n40DiReXvyWUNJmaRGe6U0oh4RTdNY5c5VYaT0lPgGDytoHvisKc+SQ==
X-Received: by 2002:a05:600c:b57:b0:3a5:3c06:f287 with SMTP id k23-20020a05600c0b5700b003a53c06f287mr15861073wmr.148.1660567444234;
        Mon, 15 Aug 2022 05:44:04 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:5fc6])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c154d00b003a54fffa809sm10296109wmg.17.2022.08.15.05.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 05:44:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-5.20 2/3] io_uring/net: improve zc addr import error handling
Date:   Mon, 15 Aug 2022 13:42:01 +0100
Message-Id: <b8aae61f4c3ddc4da97c1da876bb73871f352d50.1660566179.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660566179.git.asml.silence@gmail.com>
References: <cover.1660566179.git.asml.silence@gmail.com>
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

We may account memory to a memcg of a request that didn't even got to
the network layer. It's not a bug as it'll be routinely cleaned up on
flush, but it might be confusing for the userspace.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 2129562bfd9f..f7cbd716817f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -977,6 +977,14 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
+	if (zc->addr) {
+		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
+		if (unlikely(ret < 0))
+			return ret;
+		msg.msg_name = (struct sockaddr *)&address;
+		msg.msg_namelen = zc->addr_len;
+	}
+
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		ret = io_import_fixed(WRITE, &msg.msg_iter, req->imu,
 					(u64)(uintptr_t)zc->buf, zc->len);
@@ -992,14 +1000,6 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 			return ret;
 	}
 
-	if (zc->addr) {
-		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
-		if (unlikely(ret < 0))
-			return ret;
-		msg.msg_name = (struct sockaddr *)&address;
-		msg.msg_namelen = zc->addr_len;
-	}
-
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		msg_flags |= MSG_DONTWAIT;
-- 
2.37.0

