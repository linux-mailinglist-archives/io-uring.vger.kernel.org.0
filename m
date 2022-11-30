Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5790563D954
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiK3PXb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiK3PX3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:29 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40117721C
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:27 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id y16so7873030wrm.2
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ApsC/V76AtmxJR1f/OYmi6DVMVs28z9+ywbUb2PrgXo=;
        b=d8hTzTUUinEhuT7VLFyqOCUWC/9EerJ5vFt768HF26WXNJ/q2GQSx0OrUC5ZSH2BlS
         mWWKakLsRCu54BzqTUnhpcNGuHRP9W7vEEllFoeshM00rFiksZ0wmbc/Q5SKY86xFNMr
         6PcI4vIEckQ0nEKt+1Ymda1CaTQdO5WvVkvFDtf+9Qcy886uc64+YHnLXYJXwtbPFNmP
         V1TrIOjbvFRzR+mIMwr7IkygbFGdyBQFC8vqYP/y2taooS6Xk5IRQ59tGXiRcr/9EpHj
         KGvRYLf4dvsVvTC3Vu2NsyBlh7XRvu87nCETR2ySsQVerlSbAy3Ak0L6LZjiwPz5FgjQ
         AY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ApsC/V76AtmxJR1f/OYmi6DVMVs28z9+ywbUb2PrgXo=;
        b=mKlCwLFupgW3kTwq6++OkcCbUJ66qgbovhivsOMEBzafLPfZ3vS2qJTU1NTrym2cZN
         H2ttY/7Co58Y1isiaz+Pe0G5IKzHjGItGzc48qKOfSI1bewJwwo8J97EruyOZR3QJ1Xw
         0M5IplvDjEoI6Q7xb5Iyl/Vyfd5nvrn5uUPdg3XhpGUP4iQHjfQqtzpUnwZGpNwScaf5
         fTbpuTQ7jGQxPWb/BgVbPIa/5QeWC15vCqSsEOBMra4A0hKnG7O9IJOtocOFSuFOS2U2
         bbe6MH+uQqNDkrt+V9qsCyPuqGPGNsvqzxwIe7YyuX3qke4QXR8jGPZAqjeKrfjQsymb
         MACw==
X-Gm-Message-State: ANoB5pnwAAq1tZLT9VmVasGuk6E1QzUOsogkW3+t9ILt1vwfO7VObGsd
        rBMxFKFQKi3JtcpwH2Fa4pvwn1/6W2c=
X-Google-Smtp-Source: AA0mqf5MrKHEmra6ouulUajNwyzTyIq2kvAmxTvoNxPhkzNqVQZoL0s+x3bzsQ4iCvxtWvCyvl709w==
X-Received: by 2002:adf:ed89:0:b0:242:2115:3fc8 with SMTP id c9-20020adfed89000000b0024221153fc8mr5833829wro.78.1669821806364;
        Wed, 30 Nov 2022 07:23:26 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 7/9] io_uring: improve rsrc quiesce refs checks
Date:   Wed, 30 Nov 2022 15:21:57 +0000
Message-Id: <d21283e9f88a77612c746ed526d86fe3bfb58a70.1669821213.git.asml.silence@gmail.com>
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

Do a little bit of refactoring of io_rsrc_ref_quiesce(), flat the data
refs checks and so get rid of a conditional weird unlock-else-break
construct.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 133608200769..b36d32534165 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -330,17 +330,14 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret) {
 			mutex_lock(&ctx->uring_lock);
-			if (atomic_read(&data->refs) > 0) {
-				/*
-				 * it has been revived by another thread while
-				 * we were unlocked
-				 */
-				mutex_unlock(&ctx->uring_lock);
-			} else {
+			if (atomic_read(&data->refs) <= 0)
 				break;
-			}
+			/*
+			 * it has been revived by another thread while
+			 * we were unlocked
+			 */
+			mutex_unlock(&ctx->uring_lock);
 		}
-
 reinit:
 		atomic_inc(&data->refs);
 		/* wait for all works potentially completing data->done */
-- 
2.38.1

