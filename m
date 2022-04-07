Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD0C4F7F4D
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 14:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245350AbiDGMm4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 08:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbiDGMmt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 08:42:49 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2246255228
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 05:40:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j12so7673121wrb.5
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 05:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l5D0l4TcBBhXbK2CAa1jxU32GbirvdNWV9/RyG72lsw=;
        b=C0FtMZEs1VAtjDqiXzHBVDcrAuDmEmmLSqUOs3WxSloh1WagTEpfOiUh37ij1EMomI
         GZ2JT391HYuiLqILefS5yy85yP5TztRumBYsnklhias3Q83nmyKPothom2WAMW2oUtFq
         0bOlRLNCNSOgm5OAVc1M1YLgerkxQXhFoZLJ8GbOBeCJppBstOQRMKR+k3k3x3fKinqX
         GXqz/zlDzcSgaJBLIRP9LFhzpMBcV+D0ijhwVGKKKuBVFXQeSq6FkAEFEPBOaSwOORLZ
         /nwaLp2mGqziDZ/jXXbFTUWqP8Ipn6g9oQc2srjYIV2iX0LTVdvnax2Fa/gj3w151YmE
         KaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l5D0l4TcBBhXbK2CAa1jxU32GbirvdNWV9/RyG72lsw=;
        b=Mpy660gc7pl9g0Mz9dtXpbB86Cvs5Ta9pchWVuSQ9sBH0g1cEFLynPf+yjA64+Ng5J
         AMLcEfmV7dKzd/cJEr9Fgi+U5SVpN5vl5T4U3EP7F3nNgUvgJWBDy7mVvhmfHNopi/z4
         n4bJsPYVazXGBRg+4WeSi/vLhfag/z9aLflNKL58EIUYoBO+rIdVGdhga+5s+F/IB2Ec
         GmTopUy4V1IErOFHAc9jA+muNDFBpNlTxtDG2BqEue9VkhNYtz+uM/PpRF/+rju8ucIQ
         1RYvCnXaWe3ee1TF/fahPq0wrVtZohGt9PA8ekm0uf0Fe9EKrZR27u9sFdjFuYXW+Gfs
         DHFQ==
X-Gm-Message-State: AOAM533l5aX9oatVFxRKR9hsbOE1JJch53UVEkaJyYKadQZAGoo1se+E
        kTRysjObcmmXgiCOjGT/3w93/JYobaE=
X-Google-Smtp-Source: ABdhPJw0nQIZxLLLrNT1beK0knErH/FS31Yr/8wQWeO0zNEe+6n+YAldT8E8DmExLXfRdBQzd2VilA==
X-Received: by 2002:a05:6000:186d:b0:204:110a:d832 with SMTP id d13-20020a056000186d00b00204110ad832mr10588506wri.47.1649335247471;
        Thu, 07 Apr 2022 05:40:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm9354781wmq.40.2022.04.07.05.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 05:40:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/5] io_uring: rename io_sqe_file_register
Date:   Thu,  7 Apr 2022 13:40:05 +0100
Message-Id: <d5091518883786969e244d2f0854a47bbdaa5061.1649334991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649334991.git.asml.silence@gmail.com>
References: <cover.1649334991.git.asml.silence@gmail.com>
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

Rename io_sqe_file_register(), so the name better reflects what the
function is doing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2545d0e9e239..714a3797c678 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8596,7 +8596,7 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
  * files because otherwise they can't form a loop and so are not interesting
  * for GC.
  */
-static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file)
+static int io_scm_file_account(struct io_ring_ctx *ctx, struct file *file)
 {
 #if defined(CONFIG_UNIX)
 	struct sock *sk = ctx->ring_sock->sk;
@@ -8829,7 +8829,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto fail;
 		}
-		ret = io_sqe_file_register(ctx, file);
+		ret = io_scm_file_account(ctx, file);
 		if (ret) {
 			fput(file);
 			goto fail;
@@ -8897,7 +8897,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
 		needs_switch = true;
 	}
 
-	ret = io_sqe_file_register(ctx, file);
+	ret = io_scm_file_account(ctx, file);
 	if (!ret) {
 		*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 		io_fixed_file_set(file_slot, file);
@@ -9013,7 +9013,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			err = io_sqe_file_register(ctx, file);
+			err = io_scm_file_account(ctx, file);
 			if (err) {
 				fput(file);
 				break;
-- 
2.35.1

