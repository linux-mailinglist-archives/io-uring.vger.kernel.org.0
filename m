Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D0221A9C4
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 23:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGIVez (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 17:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgGIVez (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 17:34:55 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95AEC08C5CE
        for <io-uring@vger.kernel.org>; Thu,  9 Jul 2020 14:34:54 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4B2qFm1xKhzvjc1; Thu,  9 Jul 2020 23:34:52 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     io-uring@vger.kernel.org
Subject: [PATCH] test/statx: verify against statx(2) on all archs
Date:   Thu,  9 Jul 2020 23:34:52 +0200
Message-Id: <20200709213452.21290-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use __NR_statx in do_statx and unconditionally use it to check the
result on all architectures, not just x86_64. This relies on the
fact that __NR_statx should be defined if struct statx and STATX_ALL are
available as well.

Don't fail the test if the statx syscall returns EOPNOTSUPP though.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 test/statx.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/test/statx.c b/test/statx.c
index a397593f7c11..d354d19fb095 100644
--- a/test/statx.c
+++ b/test/statx.c
@@ -15,13 +15,11 @@
 
 #include "liburing.h"
 
-#if defined(__x86_64)
 static int do_statx(int dfd, const char *path, int flags, unsigned mask,
 		    struct statx *statxbuf)
 {
-	return syscall(332, dfd, path, flags, mask, statxbuf);
+	return syscall(__NR_statx, dfd, path, flags, mask, statxbuf);
 }
-#endif
 
 static int create_file(const char *file, size_t size)
 {
@@ -42,14 +40,16 @@ static int create_file(const char *file, size_t size)
 	return ret != size;
 }
 
+static int statx_syscall_supported(void)
+{
+	return errno == EOPNOTSUPP ? 0 : -1;
+}
+
 static int test_statx(struct io_uring *ring, const char *path)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
-	struct statx x1;
-#if defined(__x86_64)
-	struct statx x2;
-#endif
+	struct statx x1, x2;
 	int ret;
 
 	sqe = io_uring_get_sqe(ring);
@@ -74,15 +74,13 @@ static int test_statx(struct io_uring *ring, const char *path)
 	io_uring_cqe_seen(ring, cqe);
 	if (ret)
 		return ret;
-#if defined(__x86_64)
 	ret = do_statx(-1, path, 0, STATX_ALL, &x2);
 	if (ret < 0)
-		return -1;
+		return statx_syscall_supported();
 	if (memcmp(&x1, &x2, sizeof(x1))) {
 		fprintf(stderr, "Miscompare between io_uring and statx\n");
 		goto err;
 	}
-#endif
 	return 0;
 err:
 	return -1;
@@ -92,10 +90,7 @@ static int test_statx_fd(struct io_uring *ring, const char *path)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
-	struct statx x1;
-#if defined(__x86_64)
-	struct statx x2;
-#endif
+	struct statx x1, x2;
 	int ret, fd;
 
 	fd = open(path, O_RDONLY);
@@ -128,16 +123,14 @@ static int test_statx_fd(struct io_uring *ring, const char *path)
 	io_uring_cqe_seen(ring, cqe);
 	if (ret)
 		return ret;
-#if defined(__x86_64)
 	memset(&x2, 0, sizeof(x2));
 	ret = do_statx(fd, "", AT_EMPTY_PATH, STATX_ALL, &x2);
 	if (ret < 0)
-		return -1;
+		return statx_syscall_supported();
 	if (memcmp(&x1, &x2, sizeof(x1))) {
 		fprintf(stderr, "Miscompare between io_uring and statx\n");
 		goto err;
 	}
-#endif
 	return 0;
 err:
 	return -1;
-- 
2.27.0

