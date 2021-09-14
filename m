Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F75A40B40B
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhINQCa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 12:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbhINQC2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 12:02:28 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F67C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 09:01:10 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id q3so20718948edt.5
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 09:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CTJAD9o6G4PHBGQ28beasG0zp1JjtngE4Yzd3AhAT/0=;
        b=GT2+01oRRLq1QUjWULdAlUZePnZpA+Z+VSRnKFmOqR6vhh5ZrsSWHjSVjfg5SjFQML
         qkhufhKYYNJfpUPM5Jx0H5DgTx+/BMwm6pqB7hKTn7Xu2UVfILNjU7jWIWjiKH2ZF7dA
         QUVEmEspECPdXbw3Ki2/xoffNNrNP3OdRs+Q5aZZ7RnhpQjkS/P3QFZMZxoAT0SelCTl
         ebpXpjpfdvkY++3gn0BgVFUWagGStcpcBFEJNL/kmMOUMqkMsd84vjOYh+841qJIrJo5
         vJ3c2Mi2mLIrYNCqMYFJrXimJAKyeHXjxieARICZm2KOXE8j5k8hBNP5Zhso341hbETV
         yHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CTJAD9o6G4PHBGQ28beasG0zp1JjtngE4Yzd3AhAT/0=;
        b=UzXUjkMMJniyC/CONsldeEdt/JH2zdWOXGksWd+aOH619OE45LvgplyaD+FuueSM5T
         S8MK8XwzCqIsw1eZg2/vgzlr4YUZYaXUH1gbl/2MT0ZZOM8yDF2NFwITTV6OMd8R2xmy
         AR0bO3GpIKnflAEwPw+Ivn+HBho8uh6cVZ+RkEiUzjuUVNhESjUfQbGG7wK9vvz8Sugs
         WmkOVODSRNhYL1VZJElMiqbV2reLyu1kSW9rY3QkxHSFL5BLxOheVFsuVT91ZlH72VjK
         R7dpmgaDHzbwphDFKOnNQGemTUvrdfKRie1Ia51+m96ouQL/uBFdidi2pkw7Cgd4cSrY
         7frQ==
X-Gm-Message-State: AOAM532hoJEGU2MCFUTk1JT2RsAUJYQS4t52J/tX1UjsyzhyBT4xomX1
        LbqcDDdd31mR2uGi0uRr+XRxPlhWTrQ=
X-Google-Smtp-Source: ABdhPJyZve8y7LDN3RzKsyLSyxrymcV5qAW4AXJoU25/mm7sjF/BFC67IQ8hva4ZSYkKMqxiyLy+Tg==
X-Received: by 2002:a05:6402:5:: with SMTP id d5mr20141017edu.359.1631635269149;
        Tue, 14 Sep 2021 09:01:09 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id r16sm5748161edt.15.2021.09.14.09.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 09:01:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] man/io_uring_enter.2: update notes about direct open/accept
Date:   Tue, 14 Sep 2021 17:00:14 +0100
Message-Id: <b988dc36ebe655dc5b67e02c7916bd1c68c27421.1631635202.git.asml.silence@gmail.com>
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
 man/io_uring_enter.2 | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index ad86961..037f31e 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -517,10 +517,9 @@ field is set to a positive number, the file won't be installed into the
 normal file table as usual but will be placed into the fixed file table at index
 .I file_index - 1.
 In this case, instead of returning a file descriptor, the result will contain
-either 0 on success or an error. If there is already a file registered at this
-index, the request will fail with
-.B -EBADF.
-Only io_uring has access to such files and no other syscall can use them. See
+either 0 on success or an error. If the index points to a valid empty slot, the
+installation is guaranteed to not fail. Please note that only io_uring has
+access to such files and no other syscall can use them. See
 .B IOSQE_FIXED_FILE
 and
 .B IORING_REGISTER_FILES.
@@ -656,10 +655,9 @@ field is set to a positive number, the file won't be installed into the
 normal file table as usual but will be placed into the fixed file table at index
 .I file_index - 1.
 In this case, instead of returning a file descriptor, the result will contain
-either 0 on success or an error. If there is already a file registered at this
-index, the request will fail with
-.B -EBADF.
-Only io_uring has access to such files and no other syscall can use them. See
+either 0 on success or an error. If the index points to a valid empty slot, the
+installation is guaranteed to not fail. Please note that only io_uring has
+access to such files and no other syscall can use them. See
 .B IOSQE_FIXED_FILE
 and
 .B IORING_REGISTER_FILES.
@@ -692,10 +690,9 @@ field is set to a positive number, the file won't be installed into the
 normal file table as usual but will be placed into the fixed file table at index
 .I file_index - 1.
 In this case, instead of returning a file descriptor, the result will contain
-either 0 on success or an error. If there is already a file registered at this
-index, the request will fail with
-.B -EBADF.
-Only io_uring has access to such files and no other syscall can use them. See
+either 0 on success or an error. If the index points to a valid empty slot, the
+installation is guaranteed to not fail. Please note that only io_uring has
+access to such files and no other syscall can use them. See
 .B IOSQE_FIXED_FILE
 and
 .B IORING_REGISTER_FILES.
-- 
2.33.0

