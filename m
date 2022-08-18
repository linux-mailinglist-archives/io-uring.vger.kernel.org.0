Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F727598264
	for <lists+io-uring@lfdr.de>; Thu, 18 Aug 2022 13:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244432AbiHRLkj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Aug 2022 07:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiHRLkj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Aug 2022 07:40:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0432174DFB
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 04:40:38 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a4so1434724wrq.1
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 04:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=KFExPOyfJOjpQwiQ0Z7yCB7Faxe9LVLyO2Is6yaoy5E=;
        b=VeDXJ1q93ZojnwPlYsZvxU4eYKHCjfNTQBnlYgChJZgLFhKEGUsUH7NckR87HY+EOC
         xu5tCOaV2apfz+BND7ArxkNoGimTZUt7ealpthsprc4VAU6I58LXsTLkvnHJ1oX1beIC
         2t2ND7B/E/zRQV3fse3Gkyq34I0DCp1msRMpbWEBczSnCpA4HlS2eFCm74YsFQR6gd8r
         /fWR3Y4EB4fnMWGl+yAwr27D39KhY79SIlAvV7qSYSCB3vCj0DN6jg+ydmi542f/C2rW
         Ms/sPeHs0TUsZG2Ix3mRH4cb6H4frUHpnrP6Cy2dwj1m/50ap/+6eL3Lra5/1L86agAT
         MUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=KFExPOyfJOjpQwiQ0Z7yCB7Faxe9LVLyO2Is6yaoy5E=;
        b=VAtDxNMIo8Ef5woZ+bWI5qNAyqyOHbbSWLVNucxBVik1XIaKjsOXFHEY006AwIZhAG
         gT3X21Qd5RI91LmKLCLtBh/DfJSua+pyrLVNtokUsORt98y+ywANO1QPqiL4PJ+r5rcO
         fqaZ58y1DgX297hATZROISjL88MpaOpq9utKXTtZx1F2KV3HODDXeFjUPMG9vwsiLU65
         ACcAgtCemyQ+8vfcksu6SX0a8qV8cmJsxKpHSNtVYPKDWNAxyXLPCnM6vDt6NiUqh/Wu
         gPgyqx1DCfuGmw6T2asB/zhRZ+UXkFg55ysmVXOZWdlBkRAerVfAr/jBZBL3GN0kSLP5
         BW2g==
X-Gm-Message-State: ACgBeo2d4dJjBtrXDArqtq6xWJ6yW55PqUWhgfx2nx3uaoKXi/zgdU5U
        6KhXD20Gwmsy3ImAfU7/2kGezVtHbx3v5w==
X-Google-Smtp-Source: AA6agR6dtXrt/kN1/ZWwKAWfd5/C2LRzanFj2INpr8qmUUC5yMIUxbDL2wO6g4rSdSxQYYOjdcc44Q==
X-Received: by 2002:a5d:46c7:0:b0:225:2219:5e10 with SMTP id g7-20020a5d46c7000000b0022522195e10mr1441266wrs.115.1660822836165;
        Thu, 18 Aug 2022 04:40:36 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:40fa])
        by smtp.gmail.com with ESMTPSA id l17-20020a05600c4f1100b003a1980d55c4sm5705922wmq.47.2022.08.18.04.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 04:40:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-5.20] io_uring/net: use right helpers for async_data
Date:   Thu, 18 Aug 2022 12:38:34 +0100
Message-Id: <42f33b9a81dd6ae65dda92f0372b0ff82d548517.1660822636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

There is another spot where we check ->async_data directly instead of
using req_has_async_data(), which is the way to do it, fix it up.

Fixes: 43e0bbbd0b0e3 ("io_uring: add netmsg cache")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f7cbd716817f..f8cdf1dc3863 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -152,9 +152,9 @@ static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg,
 			      unsigned int issue_flags)
 {
-	struct io_async_msghdr *async_msg = req->async_data;
+	struct io_async_msghdr *async_msg;
 
-	if (async_msg)
+	if (req_has_async_data(req))
 		return -EAGAIN;
 	async_msg = io_recvmsg_alloc_async(req, issue_flags);
 	if (!async_msg) {
-- 
2.37.0

