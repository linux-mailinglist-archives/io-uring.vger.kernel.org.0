Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F1C4DC9D5
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 16:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiCQP0i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Mar 2022 11:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiCQP0h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Mar 2022 11:26:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF65205BD6
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 08:25:20 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so5128459wme.5
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 08:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wzaRoDlYuVEf+zX/WuXO3wocT+C8OBaRxnSr3ElskLk=;
        b=QVs+66PB8zXTZObTC/AIs4I9pUQIu62ApDz+WbmiYXCxZuO5YEyR0VGfnlAXVcm8O3
         EigAHplByw5tYsmK3Hq+jnw0wQjtRJp/HzwxRm+Ffjas/7ckTw0zkE9PDvK2AOa0zV5M
         b9L+2ovKGntJs7c4/jLXhPw1sjWhb/hFImNn/Q868N6ktQgAWnkgCp3/e8GAJbEYH3tx
         Jd25LclPmgB97V+Xj3jq3zGlTJMQDofwclNoim19/cyILcnXAK90Ca9r7NZ4Q7OCsKCU
         CNmeo/jsgGm1ziWChwk2+yq7UUNWt1tCeCi+17QVmHmch+w4VXzOjOIhuF9z5jzEQmeE
         EGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wzaRoDlYuVEf+zX/WuXO3wocT+C8OBaRxnSr3ElskLk=;
        b=fcuOrO6WEhKih8tS89gjoRZNopFwEThj18qk9K6g9zx52tn/FdAP6Qs/8RiNPGmH19
         ltQas06x9Y4LMjXA1J+7Q9eHgv51V3kteM3qxq9QXcoFu3/Unw9ktl/HOHYu8TlfwPmo
         OuQiE9gob3qseXHVPSDsWWduKUzoS8HF+nbjjvIDr3ib7MfaPq29pxz1il6UlDipnlno
         nAsjntVWMghNizbdo8d4GIBN74Uzg5JKy1KvhP3yi0NxYCKwJZOin7cRofhc8b2IVEyq
         jB8mpX4v+/FwhWsdVmPa90bacWbvhg3NA7rK+GNnKflPNPqaI8c+aGWI2GpXHWD39urd
         aCYw==
X-Gm-Message-State: AOAM531rUQ/BjIZ99+0wPUHovnX6Gx7Oh7105C7q9Zg9cuS6ELTApq2o
        JeKf/aEza0gDXvJE7xJ7RktuF6R5KlQ=
X-Google-Smtp-Source: ABdhPJxU/sZtX0/cnPSUNg57reYHaSxfrPy9jgStWFysFfEW1KOx6zePjueom9/tQehjkexXJzLBaw==
X-Received: by 2002:a7b:c148:0:b0:388:7ff8:9d17 with SMTP id z8-20020a7bc148000000b003887ff89d17mr12225313wmi.45.1647530719278;
        Thu, 17 Mar 2022 08:25:19 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-41.dab.02.net. [82.132.230.41])
        by smtp.gmail.com with ESMTPSA id e1-20020a05600c108100b00389cdb3372csm4385806wmd.26.2022.03.17.08.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 08:25:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] man: clarifications about direct open/accept
Date:   Thu, 17 Mar 2022 15:23:34 +0000
Message-Id: <4b6736f6da309756027b00f3b294417eb1832506.1647530578.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Direct open/accept replaces files for slots that are taken, so it's not
necessary to use sparse file tables. Update on that, mention the
replacing mechanism, and add a note about possible compitability issues
for raw io_uring API users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_prep_accept.3  | 17 +++++++++++------
 man/io_uring_prep_openat.3  | 17 +++++++++++------
 man/io_uring_prep_openat2.3 | 17 +++++++++++------
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/man/io_uring_prep_accept.3 b/man/io_uring_prep_accept.3
index 0fa2466..2942619 100644
--- a/man/io_uring_prep_accept.3
+++ b/man/io_uring_prep_accept.3
@@ -52,13 +52,18 @@ field should use the direct descriptor value rather than the regular file
 descriptor. Direct descriptors are managed like registered files.
 
 If the direct variant is used, the application must first have registered
-a sparse file table using
+a file table using
 .BR io_uring_register_files (3)
-of the appropriate size. A sparse table is one where each element is first
-registered with a value of
-.B -1.
-Once registered, a direct accept request may use any sparse entry in that
-table, as long as it is within the size of the registered table.
+of the appropriate size. Once registered, a direct accept request may use any
+entry in that table, as long as it is within the size of the registered table.
+If a specified entry already contains a file, the file will first be removed
+from the table. It's consistent with the behavior of updating an existing
+file with
+.BR io_uring_register_files_update(3).
+Note that old kernels don't check the SQE
+.I file_index
+field, which is not a problem for liburing helpers, but users of the raw io_uring
+interface need to zero SQEs to avoid unexpected behavior.
 
 This function prepares an async
 .BR accept4 (2)
diff --git a/man/io_uring_prep_openat.3 b/man/io_uring_prep_openat.3
index c5710be..b34a6aa 100644
--- a/man/io_uring_prep_openat.3
+++ b/man/io_uring_prep_openat.3
@@ -54,13 +54,18 @@ field should use the direct descriptor value rather than the regular file
 descriptor. Direct descriptors are managed like registered files.
 
 If the direct variant is used, the application must first have registered
-a sparse file table using
+a file table using
 .BR io_uring_register_files (3)
-of the appropriate size. A sparse table is one where each element is first
-registered with a value of
-.B -1.
-Once registered, a direct open request may use any sparse entry in that
-table, as long as it is within the size of the registered table.
+of the appropriate size. Once registered, a direct accept request may use any
+entry in that table, as long as it is within the size of the registered table.
+If a specified entry already contains a file, the file will first be removed
+from the table. It's consistent with the behavior of updating an existing
+file with
+.BR io_uring_register_files_update(3).
+Note that old kernels don't check the SQE
+.I file_index
+field, which is not a problem for liburing helpers, but users of the raw io_uring
+interface need to zero SQEs to avoid unexpected behavior.
 
 This function prepares an async
 .BR openat (2)
diff --git a/man/io_uring_prep_openat2.3 b/man/io_uring_prep_openat2.3
index 672fd7c..a985ff1 100644
--- a/man/io_uring_prep_openat2.3
+++ b/man/io_uring_prep_openat2.3
@@ -55,13 +55,18 @@ field should use the direct descriptor value rather than the regular file
 descriptor. Direct descriptors are managed like registered files.
 
 If the direct variant is used, the application must first have registered
-a sparse file table using
+a file table using
 .BR io_uring_register_files (3)
-of the appropriate size. A sparse table is one where each element is first
-registered with a value of
-.B -1.
-Once registered, a direct open request may use any sparse entry in that
-table, as long as it is within the size of the registered table.
+of the appropriate size. Once registered, a direct accept request may use any
+entry in that table, as long as it is within the size of the registered table.
+If a specified entry already contains a file, the file will first be removed
+from the table. It's consistent with the behavior of updating an existing
+file with
+.BR io_uring_register_files_update(3).
+Note that old kernels don't check the SQE
+.I file_index
+field, which is not a problem for liburing helpers, but users of the raw io_uring
+interface need to zero SQEs to avoid unexpected behavior.
 
 This function prepares an async
 .BR openat2 (2)
-- 
2.35.1

