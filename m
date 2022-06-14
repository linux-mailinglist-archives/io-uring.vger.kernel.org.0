Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79E854B6D3
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 18:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350547AbiFNQwd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 12:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347101AbiFNQv4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 12:51:56 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92A744A39
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 09:51:54 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a15so12086094wrh.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bpz2H2uL6fwUuLZIR0Rv8LzJ0bYssJU2SnKsu8OMW0E=;
        b=U5niuB8SCrmkEV+lIWf3w/7IGjTwJmBkxz54KLIc/9ihYDFIwBkUbg/Bagij+ySLBA
         9Io2j9tTAHvlzDgRaVk4hfmb7K4Z9TRQJVx2At8Dlwk0DleNCP0VYqi4ZeZ8wjlkqgID
         dzUDf1QmsmnAMMbz6Fty+yD1nnVXdrJidMSpusqI04cj3wjPChhkc7kG+vTvOeIuqtYx
         46hJju56pas/pjLvffIUukwSp9f2tYF+50OmZI4Puk9+jCZiKSVCn4jYifx9dNl7hPp4
         1JLFVcun3t6nUM8PEPjejQo+G9qjYz31/CmCdn3d+zEqf01zKQHaKrOhcs/Kq7zF8m4N
         okCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bpz2H2uL6fwUuLZIR0Rv8LzJ0bYssJU2SnKsu8OMW0E=;
        b=x57mRTTwO4hPm7T6dCBp9g/Ztbnrdu5nqTSx7JZArpEaLiEwgMykZZyC9M+OmutIC7
         bUaYPQbRmsf1ZZEmpGgVpZ1KDM9ZyYSsyQ43Ec04FkV99ReA7UdzSs7NcLD91T3RkXrO
         rlS89KhIa6dUrn0Lvyqd0qZwAKkHTwtBvDTqcyNB1+gnHV/wsqi8UDwPQJdmELaTGIMO
         e9Kd/UF93qKZyGxRDy6XgGn2egMias0LIJrvcsaxBvbxGq14+XAWrI6O3r+7LIwV77vd
         VtkloTQHOdNEiF8lqsrxn5Mj0BSt15Lo2FbQGTBlchkc/yOaLLF2rSTpNB6uNXQf6v4e
         tuIw==
X-Gm-Message-State: AJIora8MirEJBSHSArbpspILrL9zkLsE2yBM0gg6VYAEabCvZCfjumjC
        jJxUEYqh5ICwLV4m5U31t/LsOBztFA7jhg==
X-Google-Smtp-Source: AGRyM1uUAgpXLf3DS9HKH/Xbh6NvvaiwLl85m4XXMDZ2v9bTG57sgmQaM+s7Gi88hs2DX4XvGZKv0w==
X-Received: by 2002:a05:6000:1686:b0:219:b932:ffba with SMTP id y6-20020a056000168600b00219b932ffbamr5933704wrd.227.1655225513058;
        Tue, 14 Jun 2022 09:51:53 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id z16-20020adfec90000000b0020cff559b1dsm12648966wrn.47.2022.06.14.09.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 09:51:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 1/3] Revert "io_uring: support CQE32 for nop operation"
Date:   Tue, 14 Jun 2022 17:51:16 +0100
Message-Id: <5ff623d84ccb4b3f3b92a3ea41cdcfa612f3d96f.1655224415.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655224415.git.asml.silence@gmail.com>
References: <cover.1655224415.git.asml.silence@gmail.com>
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

This reverts commit 2bb04df7c2af9dad5d28771c723bc39b01cf7df4.

CQE32 nops were used for debugging and benchmarking but it doesn't
target any real use case. Revert it, we can return it back if someone
finds a good way to use it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca6170a66e62..bf556f77d4ab 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -784,12 +784,6 @@ struct io_msg {
 	u32 len;
 };
 
-struct io_nop {
-	struct file			*file;
-	u64				extra1;
-	u64				extra2;
-};
-
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -994,7 +988,6 @@ struct io_kiocb {
 		struct io_msg		msg;
 		struct io_xattr		xattr;
 		struct io_socket	sock;
-		struct io_nop		nop;
 		struct io_uring_cmd	uring_cmd;
 	};
 
@@ -5268,14 +5261,6 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	/*
-	 * If the ring is setup with CQE32, relay back addr/addr
-	 */
-	if (req->ctx->flags & IORING_SETUP_CQE32) {
-		req->nop.extra1 = READ_ONCE(sqe->addr);
-		req->nop.extra2 = READ_ONCE(sqe->addr2);
-	}
-
 	return 0;
 }
 
@@ -5296,11 +5281,7 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (!(req->ctx->flags & IORING_SETUP_CQE32))
-		__io_req_complete(req, issue_flags, 0, cflags);
-	else
-		__io_req_complete32(req, issue_flags, 0, cflags,
-				    req->nop.extra1, req->nop.extra2);
+	__io_req_complete(req, issue_flags, 0, cflags);
 	return 0;
 }
 
-- 
2.36.1

