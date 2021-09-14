Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F8840B649
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 19:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhINR4u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 13:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhINR4t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 13:56:49 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE53C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 10:55:31 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id x11so348590ejv.0
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 10:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jN6EyKELT0V6t3qKCuey3xeXOkF+guaRl/8nFXZxQz4=;
        b=Zr9bzQDMc9Vb/7uVZsUi4euzqyHZvzHn4NTKgnzxqmq3g+Jpuu+EOhAfHy8z7kWo5p
         SbSQskS0LPT2+hEsBcsmUfg3wpfyx/wrv8UjbVqZ1dbf3r8JV4Xys9HKvsRD11MZ9U34
         xSN1hBoism2QeL+jmAejmmqQna2rCw6kXkMmAd5wHcS8OSBXtaqF+u2p5q6DexFn/HaB
         NUz7LYoPQNqkbcTPOzHEpiCT23Jgex9KbeN4qJcVf9Rd4xqc//cuyZe3hZzZZjAS58uz
         QZQa0VLiaZYaxS19CbxiGPxFCuKY+ZE0/+TrcuVnnFe90670PxCjN5AkecT+pZ/hc7/a
         Sf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jN6EyKELT0V6t3qKCuey3xeXOkF+guaRl/8nFXZxQz4=;
        b=u6q9uvb0qiDZU560Q2E5HrxNWUe3fXG7N2+SYsCbmk8sbPEyM04rUg/+gh7IC+nte/
         zTGGsqpkgmV9HxGjAT9OIMD2zUT3BuiXRFgizUBRwBaqlwXv7AvxHizUiGOWkbQXP2Tz
         S+o6SFBbLsTx2BRHvZ42tUK97MTG6275bHExUjJxk6SX+99Z0MHQgVbhEkpUvaLByOQ0
         BBfKk89DF/lw/bZC5E/tMKztrui1PIIBCOYxlOnxDRi159H1b/RNZT0Sd/dTPhM1fx/n
         9K/VF+30ADmVMtrcrnHuO00ohtWv2XFb+tCxaoFF/+7LbEKBhdtkWAHmEiQRwaI+Udl2
         xZug==
X-Gm-Message-State: AOAM530WMgQG6D21cupVVatMqux09Ly+dJwmX9rrZvbHRLzg1f+eRweh
        RFI3xl52PvSqvs7B3WTNM8suGgJWfzg=
X-Google-Smtp-Source: ABdhPJyyUPHAH833E+4w/94Iyc4k4v8+qTu3+4eXXnyUl9lVSQSsUq9UfEA3u+8eEglSyMudJfYlTg==
X-Received: by 2002:a17:906:9ad0:: with SMTP id ah16mr20708556ejc.43.1631642129702;
        Tue, 14 Sep 2021 10:55:29 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id z12sm3484192edx.66.2021.09.14.10.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 10:55:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2] man/io_uring_enter.2: update notes about direct open/accept
Date:   Tue, 14 Sep 2021 18:54:48 +0100
Message-Id: <e5fe9b4c3130a5402e4328d87f214a98b39e33f7.1631642033.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reflect recent changes in the man, i.e. direct open/accept now would try
to remove a file from the fixed file table if the slot they target is
already taken.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: note about replacing existing files

 man/io_uring_enter.2 | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index ad86961..6b31061 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -517,10 +517,12 @@ field is set to a positive number, the file won't be installed into the
 normal file table as usual but will be placed into the fixed file table at index
 .I file_index - 1.
 In this case, instead of returning a file descriptor, the result will contain
-either 0 on success or an error. If there is already a file registered at this
-index, the request will fail with
-.B -EBADF.
-Only io_uring has access to such files and no other syscall can use them. See
+either 0 on success or an error. If the index points to a valid empty slot, the
+installation is guaranteed to not fail. If there is already a file in the slot,
+it will be replaced, similar to
+.B IORING_OP_FILES_UPDATE.
+Please note that only io_uring has access to such files and no other syscall
+can use them. See
 .B IOSQE_FIXED_FILE
 and
 .B IORING_REGISTER_FILES.
@@ -656,10 +658,12 @@ field is set to a positive number, the file won't be installed into the
 normal file table as usual but will be placed into the fixed file table at index
 .I file_index - 1.
 In this case, instead of returning a file descriptor, the result will contain
-either 0 on success or an error. If there is already a file registered at this
-index, the request will fail with
-.B -EBADF.
-Only io_uring has access to such files and no other syscall can use them. See
+either 0 on success or an error. If the index points to a valid empty slot, the
+installation is guaranteed to not fail. If there is already a file in the slot,
+it will be replaced, similar to
+.B IORING_OP_FILES_UPDATE.
+Please note that only io_uring has access to such files and no other syscall
+can use them. See
 .B IOSQE_FIXED_FILE
 and
 .B IORING_REGISTER_FILES.
@@ -692,10 +696,12 @@ field is set to a positive number, the file won't be installed into the
 normal file table as usual but will be placed into the fixed file table at index
 .I file_index - 1.
 In this case, instead of returning a file descriptor, the result will contain
-either 0 on success or an error. If there is already a file registered at this
-index, the request will fail with
-.B -EBADF.
-Only io_uring has access to such files and no other syscall can use them. See
+either 0 on success or an error. If the index points to a valid empty slot, the
+installation is guaranteed to not fail. If there is already a file in the slot,
+it will be replaced, similar to
+.B IORING_OP_FILES_UPDATE.
+Please note that only io_uring has access to such files and no other syscall
+can use them. See
 .B IOSQE_FIXED_FILE
 and
 .B IORING_REGISTER_FILES.
-- 
2.33.0

