Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6164DBCD8
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350319AbiCQCGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358423AbiCQCGQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:06:16 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEF91EADB
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:00 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m12so4852579edc.12
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bb98qC6bDW05x2jyG6wIMmqqaKxr+V1j9h9eZBM3j7c=;
        b=g/Vck5OJxU0NNxemNXarV/x2mAdMIZevXD36uPQZe4pJeGQRMgp2md2stBsHX+slQ9
         jYMCXp3Fn7PkbadsZkGLhlyY0V+t6lTWdBXBaDKvFIEsO53IIWoR29tcHNT34JfyEMwb
         rM1iSyZ/3f/Ix3RfBKBkN/CFojursQwZdev2YARkOcoU1uTCbVrgH7DE4ax5xiHZDNyW
         uI2SHU+o6Xq87P/uEM7nABpVUWMVBDrEJVNrlfnPejNYnhU7Jbqy/7pqxRe1RQwLHZVi
         laAwL8H6DgrHb/Vu2Zpq1pESQd7272j2x2oXM3RM6bB7ShL/gxovFC88HbmFdgHJAXVW
         Hu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bb98qC6bDW05x2jyG6wIMmqqaKxr+V1j9h9eZBM3j7c=;
        b=XTVHhinPl4TcldmMYatQ1bukbdDDf/ObEBT2pvpRcB4ENJ5lzGHaDVer036gWoALv6
         EJWl4SSwhJya2D+3AC+Bu2xMEQoq3ph4wZB1qS5GLnzAMt/Vp9eagBGoFXbEazNOOahH
         ZWesYd/mKW70xlbNXx5I2cwuJvgKN/2YX7LzL8rTfJ8cjbsJU7glA+T1WIgY5nTVuKCD
         Y5i16shFlG6H2inyjB24CHbxo7TDi2WjU3RCGGKGe7Y0fU7M+0w47DP4zOYY4GNO15jt
         QMYkj1pb9foFP5WrJe4oGT7rH5vPj/d6KxC+AcxuMAZ3Un4JGC1mL1k1jzIM9/Wwgp/7
         IoeQ==
X-Gm-Message-State: AOAM533/aIlTh5TXDWqvaAhWC09tGhqL7J1VE2TCOPZHX8ahUGm1ss/L
        u/SZzLFPIZ++DHocmuM51gE1UbC2oJxtIw==
X-Google-Smtp-Source: ABdhPJzjS5PWfl5LU9g6Rjndy3YsdMsAKkvppWhjJjdl1FC+ikS8Fyd/AwW4xBjpVRpuA2GG/LclrA==
X-Received: by 2002:a05:6402:42d4:b0:412:c26b:789 with SMTP id i20-20020a05640242d400b00412c26b0789mr2187205edc.232.1647482698828;
        Wed, 16 Mar 2022 19:04:58 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.67])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7df9a000000b00416b3005c4bsm1876048edy.46.2022.03.16.19.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 19:04:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/7] io_uring: extend provided buf return to fails
Date:   Thu, 17 Mar 2022 02:03:38 +0000
Message-Id: <a4880106fcf199d5810707fe2d17126fcdf18bc4.1647481208.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647481208.git.asml.silence@gmail.com>
References: <cover.1647481208.git.asml.silence@gmail.com>
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

It's never a good idea to put provided buffers without notifying the
userspace, it'll lead to userspace leaks, so add io_put_kbuf() in
io_req_complete_failed(). The fail helper is called by all sorts of
requests, but it's still safe to do as io_put_kbuf() will return 0 in
for all requests that don't support and so don't expect provided buffers.

btw, remove some code duplication from kiocb_done().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4b12aa7d107..bbbbf889dfd8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2116,7 +2116,7 @@ static inline void io_req_complete(struct io_kiocb *req, s32 res)
 static void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
 	req_set_fail(req);
-	io_req_complete_post(req, res, 0);
+	io_req_complete_post(req, res, io_put_kbuf(req, 0));
 }
 
 static void io_req_complete_fail_submit(struct io_kiocb *req)
@@ -3225,14 +3225,10 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
-		if (io_resubmit_prep(req)) {
+		if (io_resubmit_prep(req))
 			io_req_task_queue_reissue(req);
-		} else {
-			req_set_fail(req);
-			req->result = ret;
-			req->io_task_work.func = io_req_task_complete;
-			io_req_task_work_add(req, false);
-		}
+		else
+			io_req_task_queue_fail(req, ret);
 	}
 }
 
-- 
2.35.1

