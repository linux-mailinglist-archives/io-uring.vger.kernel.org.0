Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF7E63D955
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiK3PXc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiK3PXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:30 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCCC5EFA6
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:28 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id h11so20345458wrw.13
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPQcyF5lmjBVrKqNjL4bPYHAxb/9EgcVHkxUrf7lda0=;
        b=hvOavoZmHuqCxBchdRPgTfoed/sCVO+B3rz/VscC4No5erA/KnTgg2FUBdFcpYOdwt
         jA4XUaX3+mqa/2RU+vOnpjzWV0XVegJvHOo0uT+bdx4YKa71ZiDroroQpojcp4PlH8eE
         G4AS5f0JHYftJlVx4PGrYYLL1WlffWN9Zgp0j6Dq2u+zBTdi/xWeZB51KsEFKUgZGq+3
         1qrOdCSbQQq2y5XQLUe+TXmzrT6NzqYyEjTZ5P6NswgmoPYD8IwZGJ6kvsky5EuNBz+u
         IOUcmpuQTNg8f9GuG/YfmfMQ6leLLfCKpWFgyWoIxi1celJNKYrKw8Eay1avYH+quftH
         wKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PPQcyF5lmjBVrKqNjL4bPYHAxb/9EgcVHkxUrf7lda0=;
        b=KfANJ1TngpkdEkqlKMqNBK0grqOCi8HyBQE0POvyJQMEg5XPprW6993Bh4ede8mp2x
         hlCCZNFa5fzG7dJRAO6DdVxVIJxbtcl4QhYhfcqVALrIy0r22mxsZfYW1d46qh46C38h
         uAj1I3LCsYPzcx2MR9FzDks8huoQXcMiM8FruUJRlJf10TPkblgj3lmOyvIC2jmTUfCM
         9oqMkVoHv3gTeigC0K3czlmoGbO/NK4Ocg2Cob1XurYj0SV3uR5bFaRs920N31OK48fR
         EViN+gE8x6xcTNvB4JLciOUGgoFkRrxj0Bnhd9O8dT8gi7mcVop32fI5Opp+ncXQaXEG
         +Ipg==
X-Gm-Message-State: ANoB5pldVfYFarewJ5YJDT8x2nTWFE5/J7014RoDPE1WajD3ePP06YPx
        Bu1sPeOuQ6pXypTf7Yl1sItL7jRhs/A=
X-Google-Smtp-Source: AA0mqf7/zdIoBXnaWrVHkHl5gdhQi5WJr3yYoChkZUMlCg3+0v/46XhExB5z/nRmLInrpiqC2LPWLw==
X-Received: by 2002:a5d:544c:0:b0:242:65d:c39a with SMTP id w12-20020a5d544c000000b00242065dc39amr16385825wrv.99.1669821807063;
        Wed, 30 Nov 2022 07:23:27 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 8/9] io_uring: don't reinstall quiesce node for each tw
Date:   Wed, 30 Nov 2022 15:21:58 +0000
Message-Id: <3895d3344164cd9b3a0bbb24a6e357e20a13434b.1669821213.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669821213.git.asml.silence@gmail.com>
References: <cover.1669821213.git.asml.silence@gmail.com>
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

There is no need to reinit data and install a new rsrc node every time
we get a task_work, it's detrimental, just execute it and conitnue
waiting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b36d32534165..d25309400a45 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -309,22 +309,27 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 	/* As we may drop ->uring_lock, other task may have started quiesce */
 	if (data->quiesce)
 		return -ENXIO;
+	ret = io_rsrc_node_switch_start(ctx);
+	if (ret)
+		return ret;
+	io_rsrc_node_switch(ctx, data);
+
+	/* kill initial ref, already quiesced if zero */
+	if (atomic_dec_and_test(&data->refs))
+		return 0;
 
 	data->quiesce = true;
+	mutex_unlock(&ctx->uring_lock);
 	do {
-		ret = io_rsrc_node_switch_start(ctx);
-		if (ret)
-			break;
-		io_rsrc_node_switch(ctx, data);
-
-		/* kill initial ref, already quiesced if zero */
-		if (atomic_dec_and_test(&data->refs))
-			break;
-		mutex_unlock(&ctx->uring_lock);
-
 		ret = io_run_task_work_sig(ctx);
-		if (ret < 0)
-			goto reinit;
+		if (ret < 0) {
+			atomic_inc(&data->refs);
+			/* wait for all works potentially completing data->done */
+			flush_delayed_work(&ctx->rsrc_put_work);
+			reinit_completion(&data->done);
+			mutex_lock(&ctx->uring_lock);
+			break;
+		}
 
 		flush_delayed_work(&ctx->rsrc_put_work);
 		ret = wait_for_completion_interruptible(&data->done);
@@ -338,14 +343,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 			 */
 			mutex_unlock(&ctx->uring_lock);
 		}
-reinit:
-		atomic_inc(&data->refs);
-		/* wait for all works potentially completing data->done */
-		flush_delayed_work(&ctx->rsrc_put_work);
-		reinit_completion(&data->done);
-
-		mutex_lock(&ctx->uring_lock);
-	} while (ret >= 0);
+	} while (1);
 	data->quiesce = false;
 
 	return ret;
-- 
2.38.1

