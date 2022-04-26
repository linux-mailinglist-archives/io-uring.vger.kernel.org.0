Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7507D510364
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 18:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353013AbiDZQh2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 12:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiDZQh1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 12:37:27 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE18162240
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 09:34:19 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id kq17so14066251ejb.4
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 09:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d4UcUWbzPRfqSh4bVDMfxb1HbauhZHzgiQB9yv1VzOA=;
        b=DgFbo+URPfol1kCT2JyLq3GBwlpmeYYRj4gZ1M8Q5U4AJRMibqI1Yo7xZ4Ps9KmE3F
         GlZvBNDl0wCM4Yr+9jyhMudcfckJHVngHKUu/zehWVBXiAdTwSrXiuyPbrUQjzYqIggF
         f5IoSQWfyUu6rHd80FhhsfbdAGJ6fgmehOrfnqS7FEJ6UPRayURlf93gCIihNWbAhC3n
         1EZV0Dt02CZI4+lC0Z0RP494v8ZST09Yvn4Vqgmz2/Cf8cLcLXlSk4vNRJGk0w/7DRsV
         9v/Wd2Q1cL7AaRdP/M7FDzh/1rPKvpPdm07kfgJTiZYTtTBtV0W93TN+/CLvyFFu831F
         jKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d4UcUWbzPRfqSh4bVDMfxb1HbauhZHzgiQB9yv1VzOA=;
        b=AK+5fhQRydPQQsY4QnAeV5cML8/jBpn/hxYtG+DyD8YpYbTI11OtqnDC05uMbgdlTb
         NKgWW3ft+LAuCe6deIksvwfdsc5t+r8z45jOV1GlE6QMFfyxfRXAgUkHzdYvAKII1tT6
         9gUvWDITOjfZP/x+OFPVf6SSok9pOyEZpM3l+L+FGIYYt7w4tzqbeTiTqaS7cqhOD+JT
         8PIIAHs7JIghHb6TSMk9PvrzFyjvpJvZkMvemI8J91u+raLoN0+X/FbTRoRdN0NsvCpy
         K8NbN57YUHFmTFHKdla7mjeiFGbk3nH8I+8FZ8gxEaVx403lTHFDEZQGivyvn7THvRWF
         QgDw==
X-Gm-Message-State: AOAM531skERLN39hANi6YX78K6YfvrxqgriDktjGz/TDxeVJo5YWcxBY
        /AcOhUserVuxVKVnG090MT8=
X-Google-Smtp-Source: ABdhPJygLlmUQ1ad+nmVJISSToOVQGvXactGVGNMrk+z6a3vGOn2PuWzGyvBMuI/4U+8T5f07aLdsQ==
X-Received: by 2002:a17:907:970c:b0:6f3:a902:9599 with SMTP id jg12-20020a170907970c00b006f3a9029599mr5539621ejc.371.1650990857641;
        Tue, 26 Apr 2022 09:34:17 -0700 (PDT)
Received: from localhost.localdomain (93-172-44-128.bb.netvision.net.il. [93.172.44.128])
        by smtp.gmail.com with ESMTPSA id l3-20020aa7cac3000000b00422c961c8c9sm6491892edt.78.2022.04.26.09.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 09:34:17 -0700 (PDT)
From:   Almog Khaikin <almogkh@gmail.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH] io_uring: replace smp_mb() with smp_mb__after_atomic() in io_sq_thread()
Date:   Tue, 26 Apr 2022 19:34:03 +0300
Message-Id: <20220426163403.112692-1-almogkh@gmail.com>
X-Mailer: git-send-email 2.36.0
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

The IORING_SQ_NEED_WAKEUP flag is now set using atomic_or() which
implies a full barrier on some architectures but it is not required to
do so. Use the more appropriate smp_mb__after_atomic() which avoids the
extra barrier on those architectures.

Signed-off-by: Almog Khaikin <almogkh@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 72cb2d50125c..1e7466079af7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8229,7 +8229,7 @@ static int io_sq_thread(void *data)
 				 * Ensure the store of the wakeup flag is not
 				 * reordered with the load of the SQ tail
 				 */
-				smp_mb();
+				smp_mb__after_atomic();
 
 				if (io_sqring_entries(ctx)) {
 					needs_sched = false;

base-commit: 6f07a54a90ee98ae13b37ac358624d7cc7e57850
-- 
2.36.0

