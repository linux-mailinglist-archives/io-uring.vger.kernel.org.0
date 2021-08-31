Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630103FCB88
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240048AbhHaQbv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 12:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhHaQbv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 12:31:51 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2BAC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:30:55 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso2629271wmg.4
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+3TZOJ8nTwkQwWf7+2KcYnjAZrmMahAO5x12+wmE16I=;
        b=R4fv73Cvdxkh3f0B1zeb32bDLlzPCypqGtYalNn97o7BWmHUUEUnpzXOnHBgzFh7wu
         mr+kxTzjBFc18LJcCBqZ861u8+XcvIYLFGoxllRPu/EkNNFhZNDccMKgLaY34xn2h8R/
         SkNUG3N5Wo3dp8aP9F4Bqqr3RK7dB5icl01AMsuydb/hyF5lyppDroc5fySoqDcPfVse
         Nx6Cv1ve1lZUE7ZDw5Ece66OCvUS0deO6IxHBpb93LsF+sdkSitLyTVeyL5MYizr98cK
         I3IwLpwg51oQNMW8NqiHm5n435yK4VphZu0fiy735LT6b9jgcCb/hF6Okp2bOssWizXR
         laIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+3TZOJ8nTwkQwWf7+2KcYnjAZrmMahAO5x12+wmE16I=;
        b=Q/HUB/UDatsQ22+Q7C261K5MB9QLUxV6outmhbF76zBCC3DttHbnRRPtgLzLH/bEEz
         KPYrifQh6Kjq8O4kIPOeuxiKZs7RrMRgKBPexrS7GOqdO6+DHtiOVL7n2Fko/BlidciE
         PnSg88/IWrzUQkNEmaZ6ZWssd+obJTUrzM6FWtC/2fMHFe7+lRsCZt8KYNy9dbzgC/i8
         Ci29S8u80Z8Vw4QZ6IyIEkM/9b9Dpoyu/7JgM89gNbdDyuEg21ZRJzVfyJ0PNW2Y/K81
         OQ11vzFtuEoz4uCsrgENvgMU4ikyCFCnDS7W9umfHgv5q92bQDMAaOWGV2XeI1kz6uIj
         opvg==
X-Gm-Message-State: AOAM530cxTX6cqCO86kAoD5/qTTGspQ3g7FP6n52u6vjlg2DKZP7lYwp
        A6aNOXy9m5d5unn4yqz2z4CGmhJxD2A=
X-Google-Smtp-Source: ABdhPJw6FZheQ0p5uSV5W7aKyESYI8BFFRjWykfojiqJPJy/zPlMdGDdUBh8qNkDU9G/6kXqeuiU8w==
X-Received: by 2002:a1c:f008:: with SMTP id a8mr5131924wmb.83.1630427454252;
        Tue, 31 Aug 2021 09:30:54 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id n4sm22403209wro.81.2021.08.31.09.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 09:30:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: use helpers for direct open/accept
Date:   Tue, 31 Aug 2021 17:30:13 +0100
Message-Id: <d720255e0861688541efb812318f9423ee01e2a3.1630427247.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1630427247.git.asml.silence@gmail.com>
References: <cover.1630427247.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For the test to be less confusing, use helpers in tests that place new
files right into the fixed file table.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/accept.c  |  7 ++++---
 test/openat2.c | 27 +++++++++++++++------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index 21db14f..0c69b98 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -65,9 +65,10 @@ static int accept_conn(struct io_uring *ring, int fd, bool fixed)
 	int ret, fixed_idx = 0;
 
 	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
-	if (fixed)
-		sqe->file_index = fixed_idx + 1;
+	if (!fixed)
+		io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
+	else
+		io_uring_prep_accept_direct(sqe, fd, NULL, NULL, 0, fixed_idx);
 
 	ret = io_uring_submit(ring);
 	assert(ret != -1);
diff --git a/test/openat2.c b/test/openat2.c
index afc30a0..7838c05 100644
--- a/test/openat2.c
+++ b/test/openat2.c
@@ -14,7 +14,7 @@
 #include "liburing.h"
 
 static int test_openat2(struct io_uring *ring, const char *path, int dfd,
-			int fixed_slot)
+			bool direct, int fixed_index)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -28,8 +28,11 @@ static int test_openat2(struct io_uring *ring, const char *path, int dfd,
 	}
 	memset(&how, 0, sizeof(how));
 	how.flags = O_RDWR;
-	io_uring_prep_openat2(sqe, dfd, path, &how);
-	sqe->file_index = fixed_slot;
+
+	if (!direct)
+		io_uring_prep_openat2(sqe, dfd, path, &how);
+	else
+		io_uring_prep_openat2_direct(sqe, dfd, path, &how, fixed_index);
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
@@ -45,7 +48,7 @@ static int test_openat2(struct io_uring *ring, const char *path, int dfd,
 	ret = cqe->res;
 	io_uring_cqe_seen(ring, cqe);
 
-	if (fixed_slot && ret > 0) {
+	if (direct && ret > 0) {
 		close(ret);
 		return -EINVAL;
 	}
@@ -72,7 +75,7 @@ static int test_open_fixed(const char *path, int dfd)
 		return -1;
 	}
 
-	ret = test_openat2(&ring, path, dfd, 1);
+	ret = test_openat2(&ring, path, dfd, true, 0);
 	if (ret == -EINVAL) {
 		printf("fixed open isn't supported\n");
 		return 1;
@@ -114,7 +117,7 @@ static int test_open_fixed(const char *path, int dfd)
 		return -1;
 	}
 
-	ret = test_openat2(&ring, path, dfd, 1);
+	ret = test_openat2(&ring, path, dfd, true, 0);
 	if (ret != -EBADF) {
 		fprintf(stderr, "bogus double register %d\n", ret);
 		return -1;
@@ -134,7 +137,7 @@ static int test_open_fixed_fail(const char *path, int dfd)
 		return -1;
 	}
 
-	ret = test_openat2(&ring, path, dfd, 1);
+	ret = test_openat2(&ring, path, dfd, true, 0);
 	if (ret != -ENXIO) {
 		fprintf(stderr, "install into not existing table, %i\n", ret);
 		return 1;
@@ -146,19 +149,19 @@ static int test_open_fixed_fail(const char *path, int dfd)
 		return -1;
 	}
 
-	ret = test_openat2(&ring, path, dfd, 2);
+	ret = test_openat2(&ring, path, dfd, true, 1);
 	if (ret != -EINVAL) {
 		fprintf(stderr, "install out of bounds, %i\n", ret);
 		return 1;
 	}
 
-	ret = test_openat2(&ring, path, dfd, (1u << 16));
+	ret = test_openat2(&ring, path, dfd, true, (1u << 16));
 	if (ret != -EINVAL) {
 		fprintf(stderr, "install out of bounds or u16 overflow, %i\n", ret);
 		return 1;
 	}
 
-	ret = test_openat2(&ring, path, dfd, (1u << 16) + 1);
+	ret = test_openat2(&ring, path, dfd, true, (1u << 16) + 1);
 	if (ret != -EINVAL) {
 		fprintf(stderr, "install out of bounds or u16 overflow, %i\n", ret);
 		return 1;
@@ -196,7 +199,7 @@ int main(int argc, char *argv[])
 	if (do_unlink)
 		t_create_file(path_rel, 4096);
 
-	ret = test_openat2(&ring, path, -1, 0);
+	ret = test_openat2(&ring, path, -1, false, 0);
 	if (ret < 0) {
 		if (ret == -EINVAL) {
 			fprintf(stdout, "openat2 not supported, skipping\n");
@@ -206,7 +209,7 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
-	ret = test_openat2(&ring, path_rel, AT_FDCWD, 0);
+	ret = test_openat2(&ring, path_rel, AT_FDCWD, false, 0);
 	if (ret < 0) {
 		fprintf(stderr, "test_openat2 relative failed: %d\n", ret);
 		goto err;
-- 
2.33.0

