Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE735A58A4
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 02:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiH3A5c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 20:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiH3A5R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 20:57:17 -0400
Received: from linux.gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0C78E4CD;
        Mon, 29 Aug 2022 17:57:10 -0700 (PDT)
Received: from localhost.localdomain (unknown [68.183.184.174])
        by linux.gnuweeb.org (Postfix) with ESMTPSA id 3535B374F19;
        Tue, 30 Aug 2022 00:57:06 +0000 (UTC)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 6/7] test/io_uring_{enter,setup,register}: Use the exported syscall functions
Date:   Tue, 30 Aug 2022 07:56:42 +0700
Message-Id: <20220830005122.885209-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830005122.885209-1-ammar.faizi@intel.com>
References: <20220830005122.885209-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

Reviewed-by: Caleb Sander <csander@purestorage.com>
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

