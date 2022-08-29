Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E915A4154
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 05:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiH2DI6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Aug 2022 23:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiH2DIi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Aug 2022 23:08:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62543E751;
        Sun, 28 Aug 2022 20:08:29 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.68.216])
        by gnuweeb.org (Postfix) with ESMTPSA id F2F4780B02;
        Mon, 29 Aug 2022 03:08:01 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661742484;
        bh=Z7kyL4CPsonKNtyPyqtiWRmBHktsZUsNF8lJjZBwrNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDVfYCXmPmtSGtGj0BMvWCnefkUGPjdqFfqt8IYLlecg1BDuHlLsLeJzdM+u5OHsx
         GYeiQX5bEN9FMJ3Itg0qV3x6BGEv3OvWaPhoIBDvcg8MCxVzohBWjKKrTgCh3K+kho
         rStT1NdDVHxc6SwWvykGXxLXF8/DzovRkGCmf6Jxf42IY4UqK7XmIsY7ycHDMpDrbZ
         zQuGTBbxc1eY26ffswl0xXXehVpn47RWZzaDhRyTgo64i4fgefF5lihBK+labrIPYW
         Gv/HnHDG/c6OqC16lm9EktExfN7CqNkq6uj8NO1B2KHuL5Cho/v4OrK6SVAOL1gSeZ
         fuaPoRb22dCmw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 4/4] test/io_uring_{enter,setup,register}: Use the exported syscall functions
Date:   Mon, 29 Aug 2022 10:07:39 +0700
Message-Id: <20220829030521.3373516-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220829030521.3373516-1-ammar.faizi@intel.com>
References: <20220829030521.3373516-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

These tests use the internal definition of __sys_io_uring* functions.
A previous commit exported new functions that do the same thing with
those __sys_io_uring* functions. Test the exported functions instead of
the internal functions.

No functional change is intended.

Cc: Caleb Sander <csander@purestorage.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/io_uring_enter.c    | 10 +++++-----
 test/io_uring_register.c | 34 ++++++++++++++++------------------
 test/io_uring_setup.c    |  4 ++--
 3 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/test/io_uring_enter.c b/test/io_uring_enter.c
index 67cc8c5..ecd54ff 100644
--- a/test/io_uring_enter.c
+++ b/test/io_uring_enter.c
@@ -38,7 +38,7 @@ static int expect_fail(int fd, unsigned int to_submit,
 {
 	int ret;
 
-	ret = __sys_io_uring_enter(fd, to_submit, min_complete, flags, sig);
+	ret = io_uring_enter(fd, to_submit, min_complete, flags, sig);
 	if (ret >= 0) {
 		fprintf(stderr, "expected %s, but call succeeded\n", strerror(-error));
 		return 1;
@@ -62,7 +62,7 @@ static int try_io_uring_enter(int fd, unsigned int to_submit,
 		return expect_fail(fd, to_submit, min_complete, flags, sig,
 				   expect);
 
-	ret = __sys_io_uring_enter(fd, to_submit, min_complete, flags, sig);
+	ret = io_uring_enter(fd, to_submit, min_complete, flags, sig);
 	if (ret != expect) {
 		fprintf(stderr, "Expected %d, got %d\n", expect, ret);
 		return 1;
@@ -211,8 +211,8 @@ int main(int argc, char **argv)
 	/* fill the sq ring */
 	sq_entries = ring.sq.ring_entries;
 	submit_io(&ring, sq_entries);
-	ret = __sys_io_uring_enter(ring.ring_fd, 0, sq_entries,
-					IORING_ENTER_GETEVENTS, NULL);
+	ret = io_uring_enter(ring.ring_fd, 0, sq_entries,
+			     IORING_ENTER_GETEVENTS, NULL);
 	if (ret < 0) {
 		fprintf(stderr, "io_uring_enter: %s\n", strerror(-ret));
 		status = 1;
@@ -246,7 +246,7 @@ int main(int argc, char **argv)
 	 */
 	io_uring_smp_store_release(sq->ktail, ktail);
 
-	ret = __sys_io_uring_enter(ring.ring_fd, 1, 0, 0, NULL);
+	ret = io_uring_enter(ring.ring_fd, 1, 0, 0, NULL);
 	/* now check to see if our sqe was dropped */
 	if (*sq->kdropped == dropped) {
 		fprintf(stderr, "dropped counter did not increase\n");
diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index 4609354..dd4af7c 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -36,17 +36,17 @@ static int expect_fail(int fd, unsigned int opcode, void *arg,
 {
 	int ret;
 
-	ret = __sys_io_uring_register(fd, opcode, arg, nr_args);
+	ret = io_uring_register(fd, opcode, arg, nr_args);
 	if (ret >= 0) {
 		int ret2 = 0;
 
 		fprintf(stderr, "expected %s, but call succeeded\n", strerror(error));
 		if (opcode == IORING_REGISTER_BUFFERS) {
-			ret2 = __sys_io_uring_register(fd,
-					IORING_UNREGISTER_BUFFERS, 0, 0);
+			ret2 = io_uring_register(fd, IORING_UNREGISTER_BUFFERS,
+						 0, 0);
 		} else if (opcode == IORING_REGISTER_FILES) {
-			ret2 = __sys_io_uring_register(fd,
-					IORING_UNREGISTER_FILES, 0, 0);
+			ret2 = io_uring_register(fd, IORING_UNREGISTER_FILES, 0,
+						 0);
 		}
 		if (ret2) {
 			fprintf(stderr, "internal error: failed to unregister\n");
@@ -66,7 +66,7 @@ static int new_io_uring(int entries, struct io_uring_params *p)
 {
 	int fd;
 
-	fd = __sys_io_uring_setup(entries, p);
+	fd = io_uring_setup(entries, p);
 	if (fd < 0) {
 		perror("io_uring_setup");
 		exit(1);
@@ -186,15 +186,14 @@ static int test_max_fds(int uring_fd)
 	 */
 	nr_fds = UINT_MAX;
 	while (nr_fds) {
-		ret = __sys_io_uring_register(uring_fd, IORING_REGISTER_FILES,
-						fd_as, nr_fds);
+		ret = io_uring_register(uring_fd, IORING_REGISTER_FILES, fd_as,
+					nr_fds);
 		if (ret != 0) {
 			nr_fds /= 2;
 			continue;
 		}
 		status = 0;
-		ret = __sys_io_uring_register(uring_fd, IORING_UNREGISTER_FILES,
-						0, 0);
+		ret = io_uring_register(uring_fd, IORING_UNREGISTER_FILES, 0, 0);
 		if (ret < 0) {
 			ret = errno;
 			errno = ret;
@@ -230,7 +229,7 @@ static int test_memlock_exceeded(int fd)
 	iov.iov_base = buf;
 
 	while (iov.iov_len) {
-		ret = __sys_io_uring_register(fd, IORING_REGISTER_BUFFERS, &iov, 1);
+		ret = io_uring_register(fd, IORING_REGISTER_BUFFERS, &iov, 1);
 		if (ret < 0) {
 			if (errno == ENOMEM) {
 				iov.iov_len /= 2;
@@ -244,8 +243,7 @@ static int test_memlock_exceeded(int fd)
 			free(buf);
 			return 1;
 		}
-		ret = __sys_io_uring_register(fd, IORING_UNREGISTER_BUFFERS,
-						NULL, 0);
+		ret = io_uring_register(fd, IORING_UNREGISTER_BUFFERS, NULL, 0);
 		if (ret != 0) {
 			fprintf(stderr, "error: unregister failed with %d\n", errno);
 			free(buf);
@@ -283,14 +281,14 @@ static int test_iovec_nr(int fd)
 
 	/* reduce to UIO_MAXIOV */
 	nr = UIO_MAXIOV;
-	ret = __sys_io_uring_register(fd, IORING_REGISTER_BUFFERS, iovs, nr);
+	ret = io_uring_register(fd, IORING_REGISTER_BUFFERS, iovs, nr);
 	if (ret && (errno == ENOMEM || errno == EPERM) && geteuid()) {
 		fprintf(stderr, "can't register large iovec for regular users, skip\n");
 	} else if (ret != 0) {
 		fprintf(stderr, "expected success, got %d\n", errno);
 		status = 1;
 	} else {
-		__sys_io_uring_register(fd, IORING_UNREGISTER_BUFFERS, 0, 0);
+		io_uring_register(fd, IORING_UNREGISTER_BUFFERS, 0, 0);
 	}
 	free(buf);
 	free(iovs);
@@ -344,7 +342,7 @@ static int test_iovec_size(int fd)
 		 */
 		iov.iov_base = buf;
 		iov.iov_len = 2*1024*1024;
-		ret = __sys_io_uring_register(fd, IORING_REGISTER_BUFFERS, &iov, 1);
+		ret = io_uring_register(fd, IORING_REGISTER_BUFFERS, &iov, 1);
 		if (ret < 0) {
 			if (ret == -ENOMEM)
 				printf("Unable to test registering of a huge "
@@ -356,8 +354,8 @@ static int test_iovec_size(int fd)
 				status = 1;
 			}
 		} else {
-			ret = __sys_io_uring_register(fd,
-					IORING_UNREGISTER_BUFFERS, 0, 0);
+			ret = io_uring_register(fd, IORING_UNREGISTER_BUFFERS,
+						0, 0);
 			if (ret < 0) {
 				fprintf(stderr, "io_uring_unregister: %s\n",
 					strerror(-ret));
diff --git a/test/io_uring_setup.c b/test/io_uring_setup.c
index 67d5f4f..d945421 100644
--- a/test/io_uring_setup.c
+++ b/test/io_uring_setup.c
@@ -102,7 +102,7 @@ try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect)
 {
 	int ret;
 
-	ret = __sys_io_uring_setup(entries, p);
+	ret = io_uring_setup(entries, p);
 	if (ret != expect) {
 		fprintf(stderr, "expected %d, got %d\n", expect, ret);
 		/* if we got a valid uring, close it */
@@ -164,7 +164,7 @@ main(int argc, char **argv)
 
 	/* read/write on io_uring_fd */
 	memset(&p, 0, sizeof(p));
-	fd = __sys_io_uring_setup(1, &p);
+	fd = io_uring_setup(1, &p);
 	if (fd < 0) {
 		fprintf(stderr, "io_uring_setup failed with %d, expected success\n",
 		       -fd);
-- 
Ammar Faizi

