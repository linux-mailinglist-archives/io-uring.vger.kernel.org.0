Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44B37432CB
	for <lists+io-uring@lfdr.de>; Fri, 30 Jun 2023 04:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjF3Cjj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jun 2023 22:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjF3Cjj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jun 2023 22:39:39 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9892728
        for <io-uring@vger.kernel.org>; Thu, 29 Jun 2023 19:39:38 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-78625caa702so58244439f.1
        for <io-uring@vger.kernel.org>; Thu, 29 Jun 2023 19:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1688092778; x=1690684778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uKaP+4fImfzesSn9cazOg/1bXa2PJ6V9gLRwtOj1Pl4=;
        b=YmY1PHsEb+rZJJUcJQ8Os+rZynXIEvkA1UvONFMSGf9LSO7qcmT9tu7cs1YZrHok6L
         17dBmMKrc+36VPXu/H4fEX3b7sJX/nMtE5e/eUG/ElNbv15BJuI8t2syCFmBgaQFoDdY
         1qJpnc+QQwDLsj0T2FavUi9GncOu4KUPRFkN7GV9Pq6XzxaDtwu8Q+NJXMwDEKFIAnbw
         76oLH7RvX3iTsSn92hxOJc5PV9Kk9ta8soPylEG0csDo8ktqCqRpGtEZein9AqxSFOPp
         snZDEOVwMezpk0ZPhVilpqM1Ys8T6Dz7RhDbptOB+kDdB51uJC8No6Tj+vDRxs2Igpf/
         62gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688092778; x=1690684778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uKaP+4fImfzesSn9cazOg/1bXa2PJ6V9gLRwtOj1Pl4=;
        b=eLA+JxcIZ/Y6ll2d9yCxbO9TFOCKZwMwnwO3rDRJIK5liWrpIOyeQLVhwGetG4mhuk
         i64VlD3ARn6Aocp7Qh0dbcFsNQu2UoX1PHCty7xiv3j9IVbXfVZY/AwfCaqJLtA8vWZ5
         qmM9zjQ+DGAYJkwoerxUHwpKq58Kjjp/cRNfYjRQ3DZ7233xS2Hog18RCZQRxgp2ZZO2
         ChRoBbt1oRyO0tzowxDnDivy+1WfH3hKEMauTdXK2Kv0w3fyNcAp2SbmrCKqw/P2oImf
         a9SWC0pVLjuEW2OIbq9c+8c6V2Yuujwv9HgWui5PyR8h/mCeksB9vWdGQzxHQ7ZjwHX/
         ilkg==
X-Gm-Message-State: AC+VfDzRjeqJPiRvUFf6uan/punl2Ho2nF/y7sFWqDLVS+W5sqME0R9F
        Lt8CphgFITjK3IAsEhoAOO3Y8A==
X-Google-Smtp-Source: ACHHUZ6+Nbliw+37MM3uxu/hXV8Og4Xs8g5RxrD0nJ0AzqpFmkF6sY9TEVhcMtjGTxr31Fw1LQmicA==
X-Received: by 2002:a6b:6f07:0:b0:786:26f0:3092 with SMTP id k7-20020a6b6f07000000b0078626f03092mr1481752ioc.3.1688092777877;
        Thu, 29 Jun 2023 19:39:37 -0700 (PDT)
Received: from localhost (fwdproxy-atn-003.fbsv.net. [2a03:2880:10ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id f11-20020a056638118b00b0042b03d40279sm870577jas.80.2023.06.29.19.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 19:39:37 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, David Wei <davidhwei@meta.com>
Subject: [PATCH] test/io_uring_setup: Fix include path to syscall.h
Date:   Thu, 29 Jun 2023 19:39:37 -0700
Message-Id: <20230630023937.509981-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

From "../syscall.h" to "../src/syscall.h" which is consistent with the
rest of the tests.

Signed-off-by: David Wei <davidhwei@meta.com>
---
 test/io_uring_setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/io_uring_setup.c b/test/io_uring_setup.c
index 2e95418..22bc401 100644
--- a/test/io_uring_setup.c
+++ b/test/io_uring_setup.c
@@ -17,7 +17,7 @@
 #include "liburing.h"
 #include "helpers.h"
 
-#include "../syscall.h"
+#include "../src/syscall.h"
 
 /* bogus: setup returns a valid fd on success... expect can't predict the
    fd we'll get, so this really only takes 1 parameter: error */
-- 
2.34.1

