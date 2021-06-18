Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3719A3ACB08
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 14:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhFRMeg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 08:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhFRMef (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 08:34:35 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB09C061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 05:32:26 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso5687367wmj.2
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 05:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IvFVZgy+zpXsIiaieOnVTYXup6XYW75QNhDgZypYc8w=;
        b=k9Fo6rphUlACC3d4KSnhfrAMEPuQGFAC1ZPUWIkXEVDbObIkgooQeR9FL50uoeD/L/
         UYk5VK/sg3d02wTPkpGB8goDnEyic/5BQCbLJpRxVnSqE4iubwACngX36oyiScnKo1AG
         40DDJJ8N9srgZPag5d3WDFdGsRnjKdY674PIHI+4WZr8Rw9eYlH+9D6zvWUsphBR5Igd
         I5xes6tJ6XEeQROwYyhxvknXkOmGSaAKrC5XEnAINv5CkvGsvN7xg+UkOUgS9tQxhvSC
         j38YK+oaIrpKZyGOWfy+8Ky54rUY6s32RZ22CoNgOaiAhyBKvFv/BqucdJcLo53VVSVd
         I12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IvFVZgy+zpXsIiaieOnVTYXup6XYW75QNhDgZypYc8w=;
        b=B3uChfdTaf2RcMgkn5HgaXBDFFJPOAv+lmXZ+415H3mZJqD3j6hpyQLYvpvuRni/bS
         NRak1FgODU53H2JqsG6gPmh0a5nNhv87UTxiFFpinIK+BL4F8vIdjJ3qt0ca17BLCGvs
         1Z5QvIKIYJiqaksw5/dTEmErgzxGNZ3+6JaNM+fRmwoImV+M3oGH1aJ1SM0wZMFDBjJE
         NV2ChjYopy/8yUAe0gUq7awCZMVBRA56LBDxYjVIW/+ezi/4hjEFvmUcMMs1MaANVWfi
         DoEffte7DvhomjLPrOVrg+Si3a0ZZjk8ikaf583hqgZOD4Da5nBIu7svQrBoLoLxmxr1
         lDaw==
X-Gm-Message-State: AOAM532tgpVjxyZ78aQelgDmOPjNMkcx7aPZnFDiU5PHF1lFB9HihkUl
        7BJwkS/gmWTA92xUo7qm2elxh+9NOuRU6Q==
X-Google-Smtp-Source: ABdhPJzckEdPAGxszqvCa4kVLWThhRpf0TWTe07Im0E4AjrNDG3l9XuEloHTIGOEZ4kereIM3PUf5Q==
X-Received: by 2002:a1c:a943:: with SMTP id s64mr11181637wme.10.1624019544905;
        Fri, 18 Jun 2021 05:32:24 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id r6sm8457939wrt.21.2021.06.18.05.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 05:32:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH RESEND v2 liburing] update rsrc register/update ABI and tests
Date:   Fri, 18 Jun 2021 13:32:05 +0100
Message-Id: <9d7b3a79c62f9867a89483933906dcec9993eb68.1624019347.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is an ABI change for not yet released buffer/files
registration/update tagging/etc. support. Update the bits.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: don't kill fictive IORING_OP_MKDIRAT (Daniele Salvatore Albano)

 src/include/liburing/io_uring.h | 19 +++++++-------
 test/rsrc_tags.c                | 46 ++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 5a3cb90..b3d588a 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -285,6 +285,7 @@ struct io_uring_params {
 #define IORING_FEAT_SQPOLL_NONFIXED	(1U << 7)
 #define IORING_FEAT_EXT_ARG		(1U << 8)
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
+#define IORING_FEAT_RSRC_TAGS		(1U << 10)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -303,8 +304,12 @@ enum {
 	IORING_UNREGISTER_PERSONALITY		= 10,
 	IORING_REGISTER_RESTRICTIONS		= 11,
 	IORING_REGISTER_ENABLE_RINGS		= 12,
-	IORING_REGISTER_RSRC			= 13,
-	IORING_REGISTER_RSRC_UPDATE		= 14,
+
+	/* extended with tagging */
+	IORING_REGISTER_FILES2			= 13,
+	IORING_REGISTER_FILES_UPDATE2		= 14,
+	IORING_REGISTER_BUFFERS2		= 15,
+	IORING_REGISTER_BUFFERS_UPDATE		= 16,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
@@ -317,14 +322,10 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
-enum {
-	IORING_RSRC_FILE		= 0,
-	IORING_RSRC_BUFFER		= 1,
-};
-
 struct io_uring_rsrc_register {
-	__u32 type;
 	__u32 nr;
+	__u32 resv;
+	__u64 resv2;
 	__aligned_u64 data;
 	__aligned_u64 tags;
 };
@@ -340,8 +341,8 @@ struct io_uring_rsrc_update2 {
 	__u32 resv;
 	__aligned_u64 data;
 	__aligned_u64 tags;
-	__u32 type;
 	__u32 nr;
+	__u32 resv2;
 };
 
 /* Skip updating fd indexes set to this value in the fd table */
diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
index 7192873..2b4890b 100644
--- a/test/rsrc_tags.c
+++ b/test/rsrc_tags.c
@@ -17,6 +17,11 @@
 
 static int pipes[2];
 
+enum {
+	TEST_IORING_RSRC_FILE		= 0,
+	TEST_IORING_RSRC_BUFFER		= 1,
+};
+
 static bool check_cq_empty(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe = NULL;
@@ -31,15 +36,18 @@ static int register_rsrc(struct io_uring *ring, int type, int nr,
 			  const void *arg, const __u64 *tags)
 {
 	struct io_uring_rsrc_register reg;
-	int ret;
+	int ret, reg_type;
 
 	memset(&reg, 0, sizeof(reg));
-	reg.type = type;
 	reg.nr = nr;
 	reg.data = (__u64)arg;
 	reg.tags = (__u64)tags;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_RSRC,
+	reg_type = IORING_REGISTER_FILES2;
+	if (type != TEST_IORING_RSRC_FILE)
+		reg_type = IORING_REGISTER_BUFFERS2;
+
+	ret = __sys_io_uring_register(ring->ring_fd, reg_type,
 					&reg, sizeof(reg));
 	return ret ? -errno : 0;
 }
@@ -48,16 +56,18 @@ static int update_rsrc(struct io_uring *ring, int type, int nr, int off,
 			const void *arg, const __u64 *tags)
 {
 	struct io_uring_rsrc_update2 up;
-	int ret;
+	int ret, up_type;
 
 	memset(&up, 0, sizeof(up));
 	up.offset = off;
 	up.data = (__u64)arg;
 	up.tags = (__u64)tags;
-	up.type = type;
 	up.nr = nr;
 
-	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_RSRC_UPDATE,
+	up_type = IORING_REGISTER_FILES_UPDATE2;
+	if (type != TEST_IORING_RSRC_FILE)
+		up_type = IORING_REGISTER_BUFFERS_UPDATE;
+	ret = __sys_io_uring_register(ring->ring_fd, up_type,
 				      &up, sizeof(up));
 	return ret < 0 ? -errno : ret;
 }
@@ -73,7 +83,7 @@ static bool has_rsrc_update(void)
 	if (ret)
 		return false;
 
-	ret = register_rsrc(&ring, IORING_RSRC_BUFFER, 1, &vec, NULL);
+	ret = register_rsrc(&ring, TEST_IORING_RSRC_BUFFER, 1, &vec, NULL);
 	io_uring_queue_exit(&ring);
 	return ret != -EINVAL;
 }
@@ -148,7 +158,7 @@ static int test_buffers_update(void)
 		tags[i] = i + 1;
 	}
 
-	ret = test_tags_generic(nr, IORING_RSRC_BUFFER, vecs, 0);
+	ret = test_tags_generic(nr, TEST_IORING_RSRC_BUFFER, vecs, 0);
 	if (ret)
 		return 1;
 
@@ -161,7 +171,7 @@ static int test_buffers_update(void)
 		perror("pipe");
 		return 1;
 	}
-	ret = register_rsrc(&ring, IORING_RSRC_BUFFER, nr, vecs, tags);
+	ret = register_rsrc(&ring, TEST_IORING_RSRC_BUFFER, nr, vecs, tags);
 	if (ret) {
 		fprintf(stderr, "rsrc register failed %i\n", ret);
 		return 1;
@@ -180,7 +190,7 @@ static int test_buffers_update(void)
 	assert(ret == -EAGAIN);
 
 	vecs[buf_idx].iov_base = tmp_buf2;
-	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, buf_idx,
+	ret = update_rsrc(&ring, TEST_IORING_RSRC_BUFFER, 1, buf_idx,
 			  &vecs[buf_idx], &tags[buf_idx]);
 	if (ret != 1) {
 		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
@@ -226,7 +236,7 @@ static int test_buffers_empty_buffers(void)
 		return 1;
 	}
 
-	ret = register_rsrc(&ring, IORING_RSRC_BUFFER, nr, vecs, NULL);
+	ret = register_rsrc(&ring, TEST_IORING_RSRC_BUFFER, nr, vecs, NULL);
 	if (ret) {
 		fprintf(stderr, "rsrc register failed %i\n", ret);
 		return 1;
@@ -235,7 +245,7 @@ static int test_buffers_empty_buffers(void)
 	/* empty to buffer */
 	vecs[1].iov_base = tmp_buf;
 	vecs[1].iov_len = 10;
-	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, 1, &vecs[1], NULL);
+	ret = update_rsrc(&ring, TEST_IORING_RSRC_BUFFER, 1, 1, &vecs[1], NULL);
 	if (ret != 1) {
 		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
 		return 1;
@@ -244,14 +254,14 @@ static int test_buffers_empty_buffers(void)
 	/* buffer to empty */
 	vecs[0].iov_base = 0;
 	vecs[0].iov_len = 0;
-	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, 0, &vecs[0], NULL);
+	ret = update_rsrc(&ring, TEST_IORING_RSRC_BUFFER, 1, 0, &vecs[0], NULL);
 	if (ret != 1) {
 		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
 		return 1;
 	}
 
 	/* zero to zero is ok */
-	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, 2, &vecs[2], NULL);
+	ret = update_rsrc(&ring, TEST_IORING_RSRC_BUFFER, 1, 2, &vecs[2], NULL);
 	if (ret != 1) {
 		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
 		return 1;
@@ -260,7 +270,7 @@ static int test_buffers_empty_buffers(void)
 	/* empty buf with non-zero len fails */
 	vecs[3].iov_base = 0;
 	vecs[3].iov_len = 1;
-	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, 3, &vecs[3], NULL);
+	ret = update_rsrc(&ring, TEST_IORING_RSRC_BUFFER, 1, 3, &vecs[3], NULL);
 	if (ret >= 0) {
 		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
 		return 1;
@@ -312,7 +322,7 @@ static int test_files(int ring_flags)
 		tags[i] = i + 1;
 	}
 
-	ret = test_tags_generic(nr, IORING_RSRC_FILE, files, ring_flags);
+	ret = test_tags_generic(nr, TEST_IORING_RSRC_FILE, files, ring_flags);
 	if (ret)
 		return 1;
 
@@ -321,7 +331,7 @@ static int test_files(int ring_flags)
 		printf("ring setup failed\n");
 		return 1;
 	}
-	ret = register_rsrc(&ring, IORING_RSRC_FILE, nr, files, tags);
+	ret = register_rsrc(&ring, TEST_IORING_RSRC_FILE, nr, files, tags);
 	if (ret) {
 		fprintf(stderr, "rsrc register failed %i\n", ret);
 		return 1;
@@ -343,7 +353,7 @@ static int test_files(int ring_flags)
 	/* non-zero tag with remove update is disallowed */
 	tag = 1;
 	fd = -1;
-	ret = update_rsrc(&ring, IORING_RSRC_FILE, 1, off + 1, &fd, &tag);
+	ret = update_rsrc(&ring, TEST_IORING_RSRC_FILE, 1, off + 1, &fd, &tag);
 	assert(ret);
 
 	io_uring_queue_exit(&ring);
-- 
2.31.1

