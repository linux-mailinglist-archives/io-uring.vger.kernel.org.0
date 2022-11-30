Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDCD63D956
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 16:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiK3PXc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 10:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiK3PXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 10:23:30 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633FE74639
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:28 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id h11so20345522wrw.13
        for <io-uring@vger.kernel.org>; Wed, 30 Nov 2022 07:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xWGLAE/PnAOgYj3lvRGSk5vrEcd8TmdYGVPzTcFigGU=;
        b=efSlq03EwfP1a84dMz6dT+LRTG1F0v1fY42VZHfyiteHL66yPZbS6Wia5XlZzPE3Ci
         Jrkf9lHWxWe3b+Cxsg97mHuy5UCOTMNxitLuRHaplV5XE5w3EOQuSPD13KY5ArgRpniT
         cmUQlAw4k0l5YwGQBiHPISV6kap3j7HqBgDoKq9zVKF0HQu2jc9NdwTIbnJcxIRzjrZX
         djX/HVRUtIfQCGlfR02G81v92S3r7i+B1VmtNZw+fG4LdikMU9VgHK4OHdDs/JFACNba
         6fx3zTIkFSaHC70+QUbjXPfJiieSjbJlb40f1VjfCnv7sEo4T3F39oJoz8fL0xLUknUD
         yHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xWGLAE/PnAOgYj3lvRGSk5vrEcd8TmdYGVPzTcFigGU=;
        b=ebUyRy1XebXuTPGIfdU5nG74zqGj0+awCUqVFKN3UYUubibk3wh7oavsbBXEkzgQ7l
         qZZlRkePCdG7NQvFOnBKVfMIv9jcrJaO6UasVlhJ7pI8lO/VnAM7TXvLtSIDv8+kZERt
         TF1QSJfqvX57pWGDMjKB7bfs7GhWmSqLHecgXZhEkolt9acaigBUkgBXCrOwhVZ9/fSX
         c6LDVuN06F1gj0gO5tyVyF7QobzQP48mSKCnsCtL3HpTe2V/CrBn+2OfEqFlazdbjsJe
         MSdUWKi2ah4NuGJYJi4p84J/rwmWxfaO3B5Qq5Sh5k2o/90JyGf/nLO1N0Xq5D4nIAdB
         OfHA==
X-Gm-Message-State: ANoB5pl7MZbN79Zedv8dKUwqEUJ3BvYQ7lKQxv+B2tMvSj6FkMfaM+Au
        al1OnQeGK0JQIuxUyzGveNUQKGaZDx8=
X-Google-Smtp-Source: AA0mqf4NYyJeCjts9IGtGbAazCZF+NECqo7GGDUgMO+N3RefIrTmzfOV3sCrBiPuWvJg6thfDUVT7w==
X-Received: by 2002:a5d:62c2:0:b0:242:146b:7d00 with SMTP id o2-20020a5d62c2000000b00242146b7d00mr10814885wrv.572.1669821807780;
        Wed, 30 Nov 2022 07:23:27 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:97d])
        by smtp.gmail.com with ESMTPSA id v14-20020a05600c444e00b003a1980d55c4sm6381844wmn.47.2022.11.30.07.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:23:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 9/9] io_uring: reshuffle issue_flags
Date:   Wed, 30 Nov 2022 15:21:59 +0000
Message-Id: <d6e4696c883943082d248716f4cd568f37b17a74.1669821213.git.asml.silence@gmail.com>
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

Reshuffle issue flags to keep normal flags separate from the uring_cmd
ctx-setup like flags. Shift the second type to the second byte so it's
easier to add new ones in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 0ded9e271523..29e519752da4 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -9,16 +9,15 @@
 enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
 	IO_URING_F_UNLOCKED		= 2,
+	/* the request is executed from poll, it should not be freed */
+	IO_URING_F_MULTISHOT		= 4,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 
 	/* ctx state flags, for URING_CMD */
-	IO_URING_F_SQE128		= 4,
-	IO_URING_F_CQE32		= 8,
-	IO_URING_F_IOPOLL		= 16,
-
-	/* the request is executed from poll, it should not be freed */
-	IO_URING_F_MULTISHOT		= 32,
+	IO_URING_F_SQE128		= (1 << 8),
+	IO_URING_F_CQE32		= (1 << 9),
+	IO_URING_F_IOPOLL		= (1 << 10),
 };
 
 struct io_uring_cmd {
-- 
2.38.1

