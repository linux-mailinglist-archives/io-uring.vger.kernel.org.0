Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C21693B2F
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 00:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBLXlC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 18:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBLXlB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 18:41:01 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B80F774;
        Sun, 12 Feb 2023 15:40:57 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.88.204])
        by gnuweeb.org (Postfix) with ESMTPSA id D425A8309B;
        Sun, 12 Feb 2023 23:40:53 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1676245256;
        bh=Q3x1ZpBxGYFXsgv+rQ4DgddHXDhSps4z+opjFHYAgz4=;
        h=From:To:Cc:Subject:Date:From;
        b=UuVVP4pagvf6aC4j99K6xpLvt86AVyTP2U9/tRRB7r4uofQLe2ITqSfsKzj/1K+X8
         +0eHt0H7PzMQRtcTdfRi3ayCpcRCV+KAzoY8SzHUlX7eRdRsizjfKs8/Uu7Qa7N1Dp
         5LPx9EA/CmTBe7rNvUpiLJEOtIxCKGNtqkKEo+z6UCODCM55Ti5nIkbg5jGnRFYBmS
         712xLq5gQmUD39o204FpgNQLdFZTG1gOJoHLYisWk8saTk+uuHbJqrD5psVvXeWqRf
         3EtmCrV8Kxsh86r8V8H78eKsHbTitjvkwaOGE5H/ouWE0SulKqSQM21mIXN2zmb6nl
         P7crNrTeLe7+A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Sam James <sam@gentoo.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing] tests: Don't use error.h because it's not portable
Date:   Mon, 13 Feb 2023 06:40:46 +0700
Message-Id: <20230212234046.902869-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sam reports that building liburing tests on Gentoo is broken due to
'#include <error.h>':
```
  x86_64-gentoo-linux-musl-gcc -D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ \
  -I../src/include/ -include ../config-host.h -pipe -march=native \
  -fno-diagnostics-color -O2 -Wno-unused-parameter -Wno-sign-compare \
  -Wstringop-overflow=0 -Warray-bounds=0 -DLIBURING_BUILD_TEST -o \
  single-issuer.t single-issuer.c helpers.o -Wl,-O1 -Wl,--as-needed \
  -Wl,--defsym=__gentoo_check_ldflags__=0 -L../src/ -luring -lpthread

  single-issuer.c:8:10: fatal error: error.h: No such file or directory
      8 | #include <error.h>
        |          ^~~~~~~~~
```
This header is a GNU extension for glibc. It doesn't exist in musl libc.
Don't use error.h to make it portable.

Fixes: https://github.com/axboe/liburing/issues/786
Bug: https://bugs.gentoo.org/888956
Reported-by: Sam James <sam@gentoo.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/defer-taskrun.c |  1 -
 test/poll.c          |  7 ++++---
 test/send-zerocopy.c |  1 -
 test/single-issuer.c | 43 ++++++++++++++++++++++++++++---------------
 4 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/test/defer-taskrun.c b/test/defer-taskrun.c
index 4ae79792274ac723..bcc59a47b24c3e24 100644
--- a/test/defer-taskrun.c
+++ b/test/defer-taskrun.c
@@ -4,7 +4,6 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>
-#include <error.h>
 #include <sys/eventfd.h>
 #include <signal.h>
 #include <poll.h>
diff --git a/test/poll.c b/test/poll.c
index 1b8b416887a9c44f..325c4f57cfc1b1c4 100644
--- a/test/poll.c
+++ b/test/poll.c
@@ -11,7 +11,6 @@
 #include <signal.h>
 #include <poll.h>
 #include <sys/wait.h>
-#include <error.h>
 #include <assert.h>
 
 #include "helpers.h"
@@ -19,8 +18,10 @@
 
 static void do_setsockopt(int fd, int level, int optname, int val)
 {
-	if (setsockopt(fd, level, optname, &val, sizeof(val)))
-		error(1, errno, "setsockopt %d.%d: %d", level, optname, val);
+	if (setsockopt(fd, level, optname, &val, sizeof(val))) {
+		fprintf(stderr, "setsockopt %d.%d: %d\n", level, optname, val);
+		exit(T_EXIT_FAIL);
+	}
 }
 
 static bool check_cq_empty(struct io_uring *ring)
diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index ab56397aca230dcc..86a31cd6403283a8 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -4,7 +4,6 @@
 #include <stdint.h>
 #include <assert.h>
 #include <errno.h>
-#include <error.h>
 #include <limits.h>
 #include <fcntl.h>
 #include <unistd.h>
diff --git a/test/single-issuer.c b/test/single-issuer.c
index a014baabc758f4fa..2b3e8d50e615e705 100644
--- a/test/single-issuer.c
+++ b/test/single-issuer.c
@@ -5,7 +5,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
-#include <error.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 
@@ -55,14 +54,20 @@ static int try_submit(struct io_uring *ring)
 	if (ret < 0)
 		return ret;
 
-	if (ret != 1)
-		error(1, ret, "submit %i", ret);
+	if (ret != 1) {
+		fprintf(stderr, "submit %i\n", ret);
+		exit(T_EXIT_FAIL);
+	}
 	ret = io_uring_wait_cqe(ring, &cqe);
-	if (ret)
-		error(1, ret, "wait fail %i", ret);
+	if (ret) {
+		fprintf(stderr, "wait fail %i\n", ret);
+		exit(T_EXIT_FAIL);
+	}
 
-	if (cqe->res || cqe->user_data != 42)
-		error(1, ret, "invalid cqe");
+	if (cqe->res || cqe->user_data != 42) {
+		fprintf(stderr, "invalid cqe %i\n", cqe->res);
+		exit(T_EXIT_FAIL);
+	}
 
 	io_uring_cqe_seen(ring, cqe);
 	return 0;
@@ -104,8 +109,10 @@ int main(int argc, char *argv[])
 	/* test that the first submitter but not creator can submit */
 	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
 					    IORING_SETUP_R_DISABLED);
-	if (ret)
-		error(1, ret, "ring init (2) %i", ret);
+	if (ret) {
+		fprintf(stderr, "ring init (2) %i\n", ret);
+		exit(T_EXIT_FAIL);
+	}
 
 	if (!fork_t()) {
 		io_uring_enable_rings(&ring);
@@ -120,8 +127,10 @@ int main(int argc, char *argv[])
 	/* test that only the first enabler can submit */
 	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER |
 					    IORING_SETUP_R_DISABLED);
-	if (ret)
-		error(1, ret, "ring init (3) %i", ret);
+	if (ret) {
+		fprintf(stderr, "ring init (3) %i\n", ret);
+		exit(T_EXIT_FAIL);
+	}
 
 	io_uring_enable_rings(&ring);
 	if (!fork_t()) {
@@ -135,8 +144,10 @@ int main(int argc, char *argv[])
 
 	/* test that anyone can submit to a SQPOLL|SINGLE_ISSUER ring */
 	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER|IORING_SETUP_SQPOLL);
-	if (ret)
-		error(1, ret, "ring init (4) %i", ret);
+	if (ret) {
+		fprintf(stderr, "ring init (4) %i\n", ret);
+		exit(T_EXIT_FAIL);
+	}
 
 	ret = try_submit(&ring);
 	if (ret) {
@@ -155,8 +166,10 @@ int main(int argc, char *argv[])
 
 	/* test that IORING_ENTER_REGISTERED_RING doesn't break anything */
 	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
-	if (ret)
-		error(1, ret, "ring init (5) %i", ret);
+	if (ret) {
+		fprintf(stderr, "ring init (5) %i\n", ret);
+		exit(T_EXIT_FAIL);
+	}
 
 	if (!fork_t()) {
 		ret = try_submit(&ring);

base-commit: 7b09481f27fa86e8828f774ddca92ce14f14fafe
-- 
Ammar Faizi

