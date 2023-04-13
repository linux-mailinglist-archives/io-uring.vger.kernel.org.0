Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE1B6E0FFD
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDMO3A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjDMO27 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:28:59 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE381BEA
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w24so4776205wra.10
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396136; x=1683988136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZ6XYc0QFzHpE95+bN9/BCuZ1pRcCn/sTnnsdjAOM5A=;
        b=pB1/rGfDoSs/7iMDT5URWO3rI+s/iGF9Ma478V5Z0f1lI7v29GnXl1MMnV6CDLaBuG
         xah4xIp/3iGMSA7avZuDlKwT57bhEzsW4UjV/+rJZMWKZhtpBQNTG+gMgngv5LV9l+XU
         PpdHuynEYZEvLrYfmPtTCNYZNg4dEDLKT3USqE+S2sQkfnutuz7D10EYJAZ7hKpNBScl
         soWVii1ROsa4BpTLH/M7qPOGv9eqW01MoxXIDf+ze57nnQj5xnPaewCKB3B/WKtCF9tn
         nOdQitfUr0YaLwdbtNqBYzXLn5ariC/aD1Dconn8HbbRH3htcwN6adVj+0Ki7Ge+Y+Oz
         7Elg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396136; x=1683988136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nZ6XYc0QFzHpE95+bN9/BCuZ1pRcCn/sTnnsdjAOM5A=;
        b=A58ygA4WJqWiSnYd7mn2ywnsd8ZcziV9R3ACEqnunjZGxre8gY7uvXxCcCWPZYlcFg
         FhtkWQEFSpUfs2TdVUC+2LVp26W9fybXS96QwWpQ1OfDkqMi+Yua0i+aaOpy+R2yXyMi
         FrjqnDHZVSONg5z0SiqvMxdpWDYeK6+4my0fXAuWCBjoA5IbALK3l+tNkiI/kqp8RHVi
         wTxd4vQe5zWx+NR5j3No9ABsALoAgyIbs8r1LOQN+xvjxrolgYxORwnSu0hhH//W3X1l
         /xJbibD9axcubcNTu/4I44efwh6FayJ/4K+QHpnDBuFPJNIiOgn82YOFGNmqcWf1eRhW
         Vn5g==
X-Gm-Message-State: AAQBX9ec9e9ycqyna6FY1z8J+is0Cyf10JvFYciWlb/9nxdboDNnLjws
        ZK58FViPcqcDj6oDcBNaz4xMvJTw8q8=
X-Google-Smtp-Source: AKy350ZR/uVJUllFbPqE2MZw7MO57hgEblUSEFa9CdHOGUN8h0aW7kPu72mcggpigp3gOBgzblMx5Q==
X-Received: by 2002:a05:6000:1292:b0:2d2:5971:68b0 with SMTP id f18-20020a056000129200b002d2597168b0mr1525076wrx.22.1681396136192;
        Thu, 13 Apr 2023 07:28:56 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 03/10] io_uring/rsrc: refactor io_rsrc_ref_quiesce
Date:   Thu, 13 Apr 2023 15:28:07 +0100
Message-Id: <65bc876271fb16bf550a53a4c76c91aacd94e52e.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Refactor io_rsrc_ref_quiesce() by moving the first mutex_unlock(),
so we don't have to have a second mutex_unlock() further in the loop.
It prepares us to the next patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5fc9d10743e0..d7e7528f7159 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -272,8 +272,8 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		return 0;
 
 	data->quiesce = true;
-	mutex_unlock(&ctx->uring_lock);
 	do {
+		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig(ctx);
 		if (ret < 0) {
 			mutex_lock(&ctx->uring_lock);
@@ -285,18 +285,10 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			}
 			break;
 		}
-		ret = wait_for_completion_interruptible(&data->done);
-		if (!ret) {
-			mutex_lock(&ctx->uring_lock);
-			if (!data->refs)
-				break;
-			/*
-			 * it has been revived by another thread while
-			 * we were unlocked
-			 */
-			mutex_unlock(&ctx->uring_lock);
-		}
-	} while (1);
+		wait_for_completion_interruptible(&data->done);
+		mutex_lock(&ctx->uring_lock);
+		ret = 0;
+	} while (data->refs);
 	data->quiesce = false;
 
 	return ret;
-- 
2.40.0

