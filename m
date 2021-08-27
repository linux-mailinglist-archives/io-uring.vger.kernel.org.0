Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28E53F9F20
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 20:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhH0Src (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 14:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhH0Src (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 14:47:32 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCDC061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:46:42 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v10so11862234wrd.4
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JoZbE44HF3QHteArenmYuH3qsX5rj1IVSgV5NSkYXUE=;
        b=CxYX98UFy0vPn5zthTVjmuZYix3klQXjPAcDSVJUN3jbktnCvabyKRJBIiqkH0sq4v
         pbbv9ch9jDD1Yz4iTjDwr0efykSm06jHH9A4Zs00tHijZp8dwbIn05LPluLgV0Ufp7/+
         EbrhJ7O2cAadLIKAGf9BeKpG/aKdav/dn5gQgPBCZ3xr+4tJUIEgAKCSGGbh636NUzX6
         aftHBZ3DwiIg4Hyz+FqmXGGZ71tmuUGk9XyZc6YGFovXe/ukym7Dq4jHSxyOVRd6qyZJ
         hkGfLxQO7B7nv+eVlFHDJ7rDZwpbvZgoXovkVjRbe6CsjUWegsP2eIiNfhUhrNYYkXJh
         irQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JoZbE44HF3QHteArenmYuH3qsX5rj1IVSgV5NSkYXUE=;
        b=KJqryVIYt9b0eH+zH3TUAXjlwS44J5GniGqHb7AvxV0bT3f9Wq5ydAmbCpeTTUBCm+
         wJajH6vI5la9guNxRJLhtYjf3hrDJtUuHSLBafnmNJmGeqT3xE8kGA7U8o2uwVWRhb9U
         W9cEXbSp2dRKUcnYfDJYNMwSqxhygAZt+svs7PWp37i4yl5Ne7ZtM97AQaQqGVDoDJOY
         BtmliA5yLvXsExHp3kZxYFhpkkSjKVnhQiSwylS+JhAbrumnTh82sGms5v4nZd5l2aZR
         HXgWDkoAQ2Nf9zRJqlLpYWiqTnbfPfujoP+YCCTRiqEOPcJpZEyITdyZjv3imd9FxZRs
         ISjA==
X-Gm-Message-State: AOAM533qBM8W79VyKYO1yNUdDBmG4y/Olj05bSiQlWQROzihHyZCl/Xs
        7aSzhz9UDEZLzYhY80PPHYtZ9c+2+wA=
X-Google-Smtp-Source: ABdhPJy6ZQeRbapdq1ncXjiPkm86CzEVc3nubKEASNlQ0VU0z8Kdg3yRXmH619fp+QMigjPcg8FsmA==
X-Received: by 2002:adf:9f51:: with SMTP id f17mr10243613wrg.301.1630090001474;
        Fri, 27 Aug 2021 11:46:41 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.94])
        by smtp.gmail.com with ESMTPSA id z19sm7189674wrg.28.2021.08.27.11.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:46:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] register: add tagging and buf update helpers
Date:   Fri, 27 Aug 2021 19:46:03 +0100
Message-Id: <f4f19901c6f925e103dea32be252763ba8a4d2d3.1630089830.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add heplers for rsrc (buffers, files) updates and registration with
tags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

tested by:
1) using with rsrc_tags test
2) expressing previous helpers with new ones + tags=NULL

 src/include/liburing.h | 20 ++++++++++++
 src/register.c         | 72 ++++++++++++++++++++++++++++++++++++++++++
 test/rsrc_tags.c       |  8 +++++
 3 files changed, 100 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 9b38d23..7b364ce 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -125,9 +125,29 @@ extern struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
 extern int io_uring_register_buffers(struct io_uring *ring,
 					const struct iovec *iovecs,
 					unsigned nr_iovecs);
+extern int io_uring_register_buffers_tags(struct io_uring *ring,
+					  const struct iovec *iovecs,
+					  const __u64 *tags,
+					  unsigned nr);
+extern int io_uring_register_buffers_update_tag(struct io_uring *ring,
+						unsigned off,
+						const struct iovec *iovecs,
+						const __u64 *tags,
+						unsigned nr);
 extern int io_uring_unregister_buffers(struct io_uring *ring);
+
 extern int io_uring_register_files(struct io_uring *ring, const int *files,
 					unsigned nr_files);
+extern int io_uring_register_files_tags(struct io_uring *ring,
+					const int *files,
+					const __u64 *tags,
+					unsigned nr);
+extern int io_uring_register_files_update_tag(struct io_uring *ring,
+					      unsigned off,
+					      const int *files,
+					      const __u64 *tags,
+					      unsigned nr_files);
+
 extern int io_uring_unregister_files(struct io_uring *ring);
 extern int io_uring_register_files_update(struct io_uring *ring, unsigned off,
 					int *files, unsigned nr_files);
diff --git a/src/register.c b/src/register.c
index 994aaff..b29011a 100644
--- a/src/register.c
+++ b/src/register.c
@@ -14,6 +14,42 @@
 
 #include "syscall.h"
 
+int io_uring_register_buffers_update_tag(struct io_uring *ring, unsigned off,
+					 const struct iovec *iovecs,
+					 const __u64 *tags,
+					 unsigned nr)
+{
+	struct io_uring_rsrc_update2 up = {
+		.offset	= off,
+		.data = (unsigned long)iovecs,
+		.tags = (unsigned long)tags,
+		.nr = nr,
+	};
+	int ret;
+
+	ret = __sys_io_uring_register(ring->ring_fd,
+				      IORING_REGISTER_BUFFERS_UPDATE,
+				      &up, sizeof(up));
+	return ret < 0 ? -errno : ret;
+}
+
+int io_uring_register_buffers_tags(struct io_uring *ring,
+				   const struct iovec *iovecs,
+				   const __u64 *tags,
+				   unsigned nr)
+{
+	struct io_uring_rsrc_register reg = {
+		.nr = nr,
+		.data = (unsigned long)iovecs,
+		.tags = (unsigned long)tags,
+	};
+	int ret;
+
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS2,
+				      &reg, sizeof(reg));
+	return ret < 0 ? -errno : ret;
+}
+
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
 			      unsigned nr_iovecs)
 {
@@ -39,6 +75,24 @@ int io_uring_unregister_buffers(struct io_uring *ring)
 	return 0;
 }
 
+int io_uring_register_files_update_tag(struct io_uring *ring, unsigned off,
+					const int *files, const __u64 *tags,
+					unsigned nr_files)
+{
+	struct io_uring_rsrc_update2 up = {
+		.offset	= off,
+		.data = (unsigned long)files,
+		.tags = (unsigned long)tags,
+		.nr = nr_files,
+	};
+	int ret;
+
+	ret = __sys_io_uring_register(ring->ring_fd,
+					IORING_REGISTER_FILES_UPDATE2,
+					&up, sizeof(up));
+	return ret < 0 ? -errno : ret;
+}
+
 /*
  * Register an update for an existing file set. The updates will start at
  * 'off' in the original array, and 'nr_files' is the number of files we'll
@@ -64,6 +118,24 @@ int io_uring_register_files_update(struct io_uring *ring, unsigned off,
 	return ret;
 }
 
+
+int io_uring_register_files_tags(struct io_uring *ring,
+				 const int *files, const __u64 *tags,
+				 unsigned nr)
+{
+	struct io_uring_rsrc_register reg;
+	int ret;
+
+	memset(&reg, 0, sizeof(reg));
+	reg.nr = nr;
+	reg.data = (unsigned long)files;
+	reg.tags = (unsigned long)tags;
+
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_FILES2,
+				      &reg, sizeof(reg));
+	return ret < 0 ? -errno : ret;
+}
+
 int io_uring_register_files(struct io_uring *ring, const int *files,
 			      unsigned nr_files)
 {
diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
index 337fbb8..57b47f7 100644
--- a/test/rsrc_tags.c
+++ b/test/rsrc_tags.c
@@ -32,6 +32,10 @@ static bool check_cq_empty(struct io_uring *ring)
 	return ret == -EAGAIN;
 }
 
+/*
+ * There are io_uring_register_buffers_tags() and other wrappers,
+ * but they may change, so hand-code to specifically test this ABI.
+ */
 static int register_rsrc(struct io_uring *ring, int type, int nr,
 			  const void *arg, const __u64 *tags)
 {
@@ -52,6 +56,10 @@ static int register_rsrc(struct io_uring *ring, int type, int nr,
 	return ret ? -errno : 0;
 }
 
+/*
+ * There are io_uring_register_buffers_update_tag() and other wrappers,
+ * but they may change, so hand-code to specifically test this ABI.
+ */
 static int update_rsrc(struct io_uring *ring, int type, int nr, int off,
 			const void *arg, const __u64 *tags)
 {
-- 
2.33.0

