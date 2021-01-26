Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D15E304D22
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 00:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbhAZXDO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 18:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405545AbhAZUZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 15:25:29 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26276C061786;
        Tue, 26 Jan 2021 12:24:49 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d4so10416762plh.5;
        Tue, 26 Jan 2021 12:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1cudNhAMfB/FNnO4Nfbnzqpu5VBUIwtW0BBCCWOr4ao=;
        b=okEnGG//pva3FMm7+RQuqg3HjT6TuPB9G/HWJYN4D7a69egyS0VYX+j2NcX0rtqfMx
         1wZ66PW1Lp/QBlFLsjTh6++IQ/YzkyKnsqgZK5oPJU4DLZbZJK8ICOq9t3lZDdpkB1pO
         fajg2mPDaxDO8So+orz5lAgMXf6vEeSwW8KgrA+vmH4gNw33RVKwMG2y4uQzH/R7g2Ym
         /0fOM4XSuQz9a8/FSx39lySghSLAwNhk90EgWrpfB+c5OmrKqEfKhqxs/XXnCC4azjTL
         p8t61CcwzLqdmMv+Ke8sFeYU6PPsetdA1QzuB0X9TFIsLKUHFXEphvYwtjyPldGJ3oPu
         JWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1cudNhAMfB/FNnO4Nfbnzqpu5VBUIwtW0BBCCWOr4ao=;
        b=ncJQtqGe/OMI2ZpeBBOxFePTmsBh+xZCJQ2C5xxAxzUmdAw7gxYgBzw7ZjHuOgtJNh
         /j7qJh9NDAbuA797tRi5pe6pIuHPrMHYw0SJWe2eY7xgxYzuDfNMl/01mzp3Si5iIrab
         B9/Yq/TYHv19ibaYtu4hz10x/Jzl5ixgYVPgMdhssO1R7fMU4Ip9xsb5KxVcBWfUF+93
         EacgkNs6+DNNkZdBwye8lSRl103B4RugCuPC9Pw+CwQNVp7NIXR+xGZzYw9Hx82LXZbd
         /Ux99yFlDImGh6t0kVcc5kYBIb9ZI8cDnDqOTtfRbpCIF5UysF8ldwhfJGuqyP6nxQkV
         JDLQ==
X-Gm-Message-State: AOAM5335IAExN276ILR55mKIVe3aHVIdbCjsHbMXdWMm2y98a/2CfMd1
        mMuTC22b+gjA6xYz1j7Uen8=
X-Google-Smtp-Source: ABdhPJzK7Kn4mm8q2nP95CoOy5hXdg0H+PpAN9AJ0CABoyuge53sptw7H1bXl1bPLLzeM8G/GYhKsw==
X-Received: by 2002:a17:902:778e:b029:de:b475:c430 with SMTP id o14-20020a170902778eb02900deb475c430mr7872809pll.53.1611692688717;
        Tue, 26 Jan 2021 12:24:48 -0800 (PST)
Received: from localhost.localdomain (c-73-241-149-213.hsd1.ca.comcast.net. [73.241.149.213])
        by smtp.googlemail.com with ESMTPSA id u12sm18697124pgi.91.2021.01.26.12.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 12:24:48 -0800 (PST)
From:   noah <goldstein.w.n@gmail.com>
Cc:     axboe@kernel.dk, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        goldstein.w.n@gmail.com
Subject: [PATCH] io_uring: Add skip option for __io_sqe_files_update
Date:   Tue, 26 Jan 2021 15:23:28 -0500
Message-Id: <20210126202326.3143037-1-goldstein.w.n@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds support for skipping a file descriptor when using
IORING_REGISTER_FILES_UPDATE.  __io_sqe_files_update will skip fds set
to IORING_REGISTER_FILES_SKIP. IORING_REGISTER_FILES_SKIP is inturn
added as a #define in io_uring.h

Signed-off-by: noah <goldstein.w.n@gmail.com>
---
Supporting documentation and tests in liburing can be added in PR284
(https://github.com/axboe/liburing/pull/284) if this patch is applied.
    
 fs/io_uring.c                 | 3 +++
 include/uapi/linux/io_uring.h | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c307dea162b..03748faa5295 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8039,6 +8039,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
+		if (fd == IORING_REGISTER_FILES_SKIP)
+			continue;
+
 		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
 		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
 		index = i & IORING_FILE_TABLE_MASK;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f9f106c54d90..e8b481040fb3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -298,6 +298,13 @@ struct io_uring_rsrc_update {
 	__aligned_u64 data;
 };
 
+/*
+ * fd value in *((__s32 *)io_uring_rsrc_update->data)
+ */
+
+/* Skip updating fd indexes set to this value */
+#define IORING_REGISTER_FILES_SKIP  (-2)
+
 #define IO_URING_OP_SUPPORTED	(1U << 0)
 
 struct io_uring_probe_op {
-- 
2.29.2

