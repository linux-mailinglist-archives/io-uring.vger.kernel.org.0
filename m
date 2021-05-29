Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6030E394BD0
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 13:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhE2LDO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 May 2021 07:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhE2LDO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 May 2021 07:03:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACFFC061574
        for <io-uring@vger.kernel.org>; Sat, 29 May 2021 04:01:36 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so3728227wmh.4
        for <io-uring@vger.kernel.org>; Sat, 29 May 2021 04:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOrenTYzDvcIPdldpQAo/f+S+ZXAzoBgkkBobSxFS6s=;
        b=V2MKlh0c7bvZKYmngvyqhJXUtaDqrBW8ngdCnoyZfug9E68iw0QJtU2ArFwJhKxA+m
         BrHSkzuss93+DbBoHhgtnn82Vym61ewOtxYJqqdEqAFiBhsNj95rjtnC1lb18ox7826v
         n98FDTFTWHc2RJJPd9m4pkZWyx21Ld/9/Eoc29vcOB2Bn7kQDpCvs0840FQyh+yGt5+N
         dRYQGrqniyaiuPiC/HTeEplhSsV9MFEPsiApzZvsP1wKhqdNZg9JbiKAGhpW6NpRcXgp
         MHRf9vBd+LsyKD59Hu0iY/sl6KhEZKrAJZmLgRRwrvwDdtTJMmfhTSdWp3BbfUVBbCbO
         sMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOrenTYzDvcIPdldpQAo/f+S+ZXAzoBgkkBobSxFS6s=;
        b=cVMjgs1KFxrRqosqM2Y76xbxzHiTarjqGFB8IhxCNSyxdWjK47B9fYh8jlIuA55Gi8
         O+nOQKfA9PyZlHzytkq0gRj/nBv38poI8LPWrk85kJ5aJIAO8xfwRF+X/wO2g0V1wNBm
         OTo7DUd9fbuPyRKtVyHab+830QXO3Da22NXMb4/Qj6+DJGPkas+7wRq1lmAfkKZo36ju
         ICT9k3puFTQKZyScvb1OJ6yUj+8k0JrDpEowVHJbzzCoBpMW9r8JPmA7kFmm3qHXt/cB
         S8CNBmkGXQieO1q9x4N3NJ3NWPZnj0eC3riLi3h5cufbSnHwmPOnQb+hU9QiAo008o2l
         T0QA==
X-Gm-Message-State: AOAM532LDQGd1Hy67FY3oaK4ItYviWezGKKwzcNnCJbfIVsZ+XLfvq3c
        DqcHP3SQ1zDx9OCOA3lk64JIIFC/N0c=
X-Google-Smtp-Source: ABdhPJw79UmHsvww7hiTRAdXE2nDYC3BcX4U8r3DJ4T32noFBlGQ08Qv2uXG8Cj7Q9PHMm+h1fqFRA==
X-Received: by 2002:a1c:6782:: with SMTP id b124mr17144349wmc.159.1622286095374;
        Sat, 29 May 2021 04:01:35 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.19])
        by smtp.gmail.com with ESMTPSA id 89sm5055409wri.94.2021.05.29.04.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 04:01:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>
Subject: [PATCH 5.13] io_uring: fix misaccounting fix buf pinned pages
Date:   Sat, 29 May 2021 12:01:02 +0100
Message-Id: <438a6f46739ae5e05d9c75a0c8fa235320ff367c.1622285901.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As Andres reports "... io_sqe_buffer_register() doesn't initialize imu.
io_buffer_account_pin() does imu->acct_pages++, before calling
io_account_mem(ctx, imu->acct_pages).", leading to evevntual -ENOMEM.

Initialise the field.

Reported-by: Andres Freund <andres@anarazel.de>
Fixes: 41edf1a5ec967 ("io_uring: keep table of pointers to ubufs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 903458afd56c..42380ed563c4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8228,6 +8228,7 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 {
 	int i, ret;
 
+	imu->acct_pages = 0;
 	for (i = 0; i < nr_pages; i++) {
 		if (!PageCompound(pages[i])) {
 			imu->acct_pages++;
-- 
2.31.1

