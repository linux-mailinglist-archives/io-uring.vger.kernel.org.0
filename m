Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0466755F266
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiF2A2l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiF2A2k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:40 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821B32DD65
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:39 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 0E54D7FC83;
        Wed, 29 Jun 2022 00:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462519;
        bh=3t9IpOHWlckPWbRMiMlxoC7Reb/Esot+xgFrYIRtRsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cpj6b30urcMoQ39J8nmVlWFqthHZHi7u6Z3+gzJjDBiLs14HVW1uZNrr4NCp6asL1
         JYf0eKp0AZtGdzEJHgfS03ccfH7f2vQabwomTxxLOGF/eyxTyiHDZ2d6VtMzT1nygG
         knPcWh1iWEL6S3XD4/u26lx2XnoywkADwrXCmvuS52rtfsc40cEqf7G/EarpUj1OAa
         IRpI26FSL85EqGgL5BJiu0SkJobb/JJa+G98l6Nf+5w9vCAC0EuX213ejXbZifGrY5
         hmC5qT2DMR3chS5pvplgGX+WV9JSRAo2MOb67s6KOMXYZ0JOPxcbBwIY6M5jR5bITr
         nz4H+6LkhPdyQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 7/9] arch/arm64: Add `get_page_size()` function
Date:   Wed, 29 Jun 2022 07:27:51 +0700
Message-Id: <20220629002028.1232579-8-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629002028.1232579-1-ammar.faizi@intel.com>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
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

This is a preparation patch to add aarch64 nolibc support.

aarch64 supports three values of page size: 4K, 16K, and 64K which are
selected at kernel compilation time. Therefore, we can't hard code the
page size for this arch. Utilize open(), read() and close() syscall to
find the page size from /proc/self/auxv. For more details about the
auxv data structure, check the link below.

Link: https://github.com/torvalds/linux/blob/v5.19-rc4/fs/binfmt_elf.c#L260
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/arm64/lib.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 src/arch/arm64/lib.h

diff --git a/src/arch/arm64/lib.h b/src/arch/arm64/lib.h
new file mode 100644
index 0000000..4dc39a8
--- /dev/null
+++ b/src/arch/arm64/lib.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef LIBURING_ARCH_ARM64_LIB_H
+#define LIBURING_ARCH_ARM64_LIB_H
+
+#include <elf.h>
+#include <sys/auxv.h>
+#include "../../syscall.h"
+
+static inline long get_page_size(void)
+{
+	Elf64_Off buf[2];
+	long page_size;
+	int fd;
+
+	fd = __sys_open("/proc/self/auxv", O_RDONLY, 0);
+	if (fd < 0)
+		return fd;
+
+	while (1) {
+		ssize_t ret;
+
+		ret = __sys_read(fd, buf, sizeof(buf));
+		if (ret < 0) {
+			page_size = -errno;
+			break;
+		}
+
+		if (ret < sizeof(buf)) {
+			page_size = -ENOENT;
+			break;
+		}
+
+		if (buf[0] == AT_PAGESZ) {
+			page_size = buf[1];
+			break;
+		}
+	}
+
+	__sys_close(fd);
+	return page_size;
+}
+
+#endif /* #ifndef LIBURING_ARCH_ARM64_LIB_H */
-- 
Ammar Faizi

