Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1381E565D3F
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 19:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbiGDRz3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 13:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiGDRz1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 13:55:27 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87239DFF2
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 10:55:25 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id A8C7A7FC8C;
        Mon,  4 Jul 2022 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656957325;
        bh=qeJm1bXOu6klaDCaHOGajmdgN7Yjd2MtzUuZCCYVGsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTTns6l7N+DsVj4xmuZC1HqIoLaQYRx0iHsClCYdqSNHT9fY6sUaELE8pY9PNt/SZ
         yG408b1vlEbNqAM7SemsYVOspAkTjL9hC1YLd6Sdm7v1aT7pK7eIxSx1Oip+8WnhWQ
         iL7OyDxc7z/42HAdxbLqq1Hrslp4RINb9SXiCeAv4fqKUmEHmq2rsoFl1cg4Vm2x1c
         bkBirWSxWaOxOIwMifvvupyQfCdr74qZL48nzAsgTgC24p5Cwsil043yKkoWQBdUUl
         hYAq90j0jLJrzsKJo7nfwbT3/YfPfp8xBbO3PPw72olPk6qgkw9oymDzOvOzhDbRmz
         TziI/OXVn+G/Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 08/10] test: Add nolibc test
Date:   Tue,  5 Jul 2022 00:54:34 +0700
Message-Id: <20220704174858.329326-9-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220704174858.329326-1-ammar.faizi@intel.com>
References: <20220704174858.329326-1-ammar.faizi@intel.com>
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

This test is used to test liburing nolibc functionality. The first use
case is test get_page_size() function, especially for aarch64 which
relies on reading /proc/self/auxv. We don't seem to have a test that
tests that function, so let's do it here.

We may add more nolibc tests in this file in the future.

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

