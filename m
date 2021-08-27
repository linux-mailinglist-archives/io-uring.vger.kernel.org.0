Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65783FA006
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 21:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhH0Tdp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 15:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhH0Tdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 15:33:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE360C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 12:32:55 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u16so12031903wrn.5
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 12:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iJ//Fz1YbnS4jIlqAqNJmY4SqLFG2i9zR/iw+CamVJ4=;
        b=c0xRxVvuTU/IOkgCwT10vIO805ZZ1bKcfqLNeGG2mC5WszeFAbDCcR7L+wJSKZyEaD
         cqINqF0VXWWBWRWWmL0/8KjZjcYou6S8tYZjuv5gXtwkERGmeOrBRwuLQNcLcuKSjahw
         s4gup383RHxPLGADH4PD80YJAjLJSOMhU6kLkndfl3WYCNMZGzAyl/hwU9pv/UK7+fE/
         SaBgOBtsunAxcSOm1AwC5YuxgQJGjmef8QrrVAURv1n/6V275i8+PROQM8tS72+ChFPA
         Q13+kI+E8hK/IWLcr0aCQlQkFd6oTKHvjKT3NzA0Y6AkOQ+VOu/QvFmyikLfLZGlZ7fR
         3hOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iJ//Fz1YbnS4jIlqAqNJmY4SqLFG2i9zR/iw+CamVJ4=;
        b=gJbAy7386oYhCmllzteU2J5CVuUBDGawpqa5jYCdqS92/vyh8CgBorTath21blFPP3
         NAvbE0A0rqes9rKDMxL59LO59HEZUUGydcShUUdnPd4nDNOq3BIk2h2bLvKSM14Xn1dH
         /qG4h1gsC97ZCqAsj2wowj0OMpRroQD0J5iclkvjW5IfBGnRWNRA2gmzx0GaqXWQj2m4
         +PgZJuE27YQroYoxTfV/65JOE1TgFv1DueoIY9KuHNexJRG4WF6NFd7JvvRQcsGMjv+f
         IOliks0KTcHAtX3qN3vj8PcXimDsfbR9IkBE4kqlV0AHL9SKf/uEMw6BuZCapqYmbvYw
         LjAA==
X-Gm-Message-State: AOAM530IjAU0QP008OxJrlz26eLF9EKRgFyv/78ME+5xYkF7T79hgBDV
        9dD7L1ujBh8KhZBkIVTh2TIckJSE/40=
X-Google-Smtp-Source: ABdhPJyuWlmeIHC1i3mC5UVnk07BeZAw+qwajKtOehjPqU17TiV67R/e8a/4DJN4l8PvhqHQXyI9Zw==
X-Received: by 2002:adf:c40f:: with SMTP id v15mr8846944wrf.316.1630092774484;
        Fri, 27 Aug 2021 12:32:54 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.94])
        by smtp.gmail.com with ESMTPSA id c7sm6031025wmq.13.2021.08.27.12.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 12:32:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2] register: add tagging and buf update helpers
Date:   Fri, 27 Aug 2021 20:32:14 +0100
Message-Id: <314323bcd6d053f063181d5b900f6d8f6fb3ce6a.1630092701.git.asml.silence@gmail.com>
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

v2: update liburing.map

 src/include/liburing.h | 20 ++++++++++++
 src/liburing.map       |  4 +++
 src/register.c         | 71 ++++++++++++++++++++++++++++++++++++++++++
 test/rsrc_tags.c       |  8 +++++
 4 files changed, 103 insertions(+)

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
diff --git a/src/liburing.map b/src/liburing.map
index 012ac4e..b29aa5f 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -36,4 +36,8 @@ LIBURING_2.1 {
 	global:
 		io_uring_mlock_size_params;
 		io_uring_mlock_size;
+		io_uring_register_buffers_tags;
+		io_uring_register_buffers_update_tag;
+		io_uring_register_files_tags;
+		io_uring_register_files_update_tag;
 } LIBURING_2.0;
diff --git a/src/register.c b/src/register.c
index 994aaff..a947aec 100644
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
@@ -64,6 +118,23 @@ int io_uring_register_files_update(struct io_uring *ring, unsigned off,
 	return ret;
 }
 
+
+int io_uring_register_files_tags(struct io_uring *ring,
+				 const int *files, const __u64 *tags,
+				 unsigned nr)
+{
+	struct io_uring_rsrc_register reg = {
+		.nr = nr,
+		.data = (unsigned long)files,
+		.tags = (unsigned long)tags,
+	};
+	int ret;
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

