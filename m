Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F290556648C
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 10:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiGEHpd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 03:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiGEHpc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 03:45:32 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF35B12D06
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 00:45:31 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 2003F804BD;
        Tue,  5 Jul 2022 07:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1657007131;
        bh=/5qcG31eJQK5GkghLU0sdquGRMyxXYDRZ0isT3CtopU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izB1uYrZRv8hBagCxepzCJSOnqtkRwT9TCh56Y6qdqsXs1ADdmLS1naW5uFhWyYKO
         DTjkKV7XWrYLSmCF4/ZF65fuhpMHcS4nG05sSKNg3ZGbVzpPLEwSqop2FUWdkO8qv0
         riRsNBlW1taVEkEcvGlGiHzVphBPCH/3Rkd4RiknkGrWFwO0cHuOiQ3plBFFHGuiSj
         C5kR5844dOqsP1wGamWRrG4Zatvbu3u0CdqGx1mzXIrScTpY9e3TdGAFAshCcI/Oga
         Q64lkG3Xrdc7Pw+U1IiX0b9u9RgMNqVlvpqW5CFBPZmPOpCnqdcQl3YOUFv68el56U
         Z8ZekjeEM2QsA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v5 08/10] test: Add nolibc test
Date:   Tue,  5 Jul 2022 14:43:58 +0700
Message-Id: <20220705073920.367794-9-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220705073920.367794-1-ammar.faizi@intel.com>
References: <20220705073920.367794-1-ammar.faizi@intel.com>
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

Test liburing nolibc functionality. The first use case of this test is
to test get_page_size() function as we don't seem to have a test that
tests this path. This is especially important for aarch64 because we
rely on reading /proc/self/auxv rather than hard coding it like what we
do for x86 and x86-64. We may add more nolibc tests in this file in the
future.

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/Makefile |  1 +
 test/nolibc.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 test/nolibc.c

diff --git a/test/Makefile b/test/Makefile
index 9590e1e..45674c3 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -101,6 +101,7 @@ test_srcs := \
 	mkdir.c \
 	msg-ring.c \
 	multicqes_drain.c \
+	nolibc.c \
 	nop-all-sizes.c \
 	nop.c \
 	openat2.c \
diff --git a/test/nolibc.c b/test/nolibc.c
new file mode 100644
index 0000000..e996f40
--- /dev/null
+++ b/test/nolibc.c
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Test liburing nolibc functionality.
+ *
+ * Currently, supported architectures are:
+ *   1) x86
+ *   2) x86-64
+ *   3) aarch64
+ *
+ */
+#include "helpers.h"
+
+#if !defined(__x86_64__) && !defined(__i386__) && !defined(__aarch64__)
+
+/*
+ * This arch doesn't support nolibc.
+ */
+int main(void)
+{
+	return T_EXIT_SKIP;
+}
+
+#else /* #if !defined(__x86_64__) && !defined(__i386__) && !defined(__aarch64__) */
+
+#ifndef CONFIG_NOLIBC
+#define CONFIG_NOLIBC
+#endif
+
+#include <stdio.h>
+#include <unistd.h>
+#include "../src/lib.h"
+
+static int test_get_page_size(void)
+{
+	long a, b;
+
+	a = sysconf(_SC_PAGESIZE);
+	b = get_page_size();
+	if (a != b) {
+		fprintf(stderr, "get_page_size() fails, %ld != %ld", a, b);
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret = test_get_page_size();
+	if (ret)
+		return T_EXIT_FAIL;
+
+	return T_EXIT_PASS;
+}
+
+#endif /* #if !defined(__x86_64__) && !defined(__i386__) && !defined(__aarch64__) */
-- 
Ammar Faizi

