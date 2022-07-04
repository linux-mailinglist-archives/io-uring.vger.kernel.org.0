Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4B0565D3B
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 19:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiGDRzR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 13:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiGDRzP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 13:55:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFEDBE38
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 10:55:14 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 6CA0F8024A;
        Mon,  4 Jul 2022 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656957314;
        bh=xQ42n6yedKh0raRG0qvd5aG8RR/vOh1QwNjBHEupE7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzrUT5IACpjohKANyRwER3wyZFoRYI2iESJmjzgh5BcaTsOP8r+RepAJpKLCSgmGg
         cpKhHvRWgEQ85IhN1q61w2QYPIK9MJIzRKRbRsXIy4T5626tYXYZPvs2aWuqY9747O
         crUY6q74CzxDF2eqVZYnhnCf9yPg2FJANE/FqPMj+lxHyOKY0IZ/pJhTSNJMPOJyHL
         0+fXVgrTjsjfpePPH6ct0d1K3Pe04NAKnKw1WA9z60Dy5802vqgFUe9NM7TjpHHpfH
         R1wDHTp5M2aNnMq6w43Pd5xc6IYPO2Ymsl1je94YwXnrF68oK1w+eTYw13nMgv8Bil
         j3HG1bSQvmZDA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 05/10] arch/aarch64: lib: Add `get_page_size()` function
Date:   Tue,  5 Jul 2022 00:54:31 +0700
Message-Id: <20220704174858.329326-6-ammar.faizi@intel.com>
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

A prep patch to add aarch64 nolibc support.

aarch64 supports three values of page size: 4K, 16K, and 64K which are
selected at kernel compilation time. Therefore, we can't hard code the
page size for this arch. Utilize open(), read() and close() syscall to
find the page size from /proc/self/auxv. For more details about the
auxv data structure, check the link below [1].

v3:
  - Split open/read/close in get_page_size() into a new function.
  - Cache the fallback value when we fail on the syscalls.
  - No need to init the static var to zero.

v2:
  - Fallback to 4K if the syscall fails.
  - Cache the page size after read as suggested by Jens.

Link: https://github.com/torvalds/linux/blob/v5.19-rc4/fs/binfmt_elf.c#L260 [1]
Link: https://lore.kernel.org/io-uring/3895dbe1-8d5f-cf53-e94b-5d1545466de1@kernel.dk
Link: https://lore.kernel.org/io-uring/8bfba71c-55d7-fb49-6593-4d0f9d9c3611@kernel.dk
Link: https://lore.kernel.org/io-uring/49ed1c4c-46ca-15c4-f288-f6808401b0ff@kernel.dk
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/aarch64/lib.h | 51 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 src/arch/aarch64/lib.h

diff --git a/src/arch/aarch64/lib.h b/src/arch/aarch64/lib.h
new file mode 100644
index 0000000..eb7e4cb
--- /dev/null
+++ b/src/arch/aarch64/lib.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef LIBURING_ARCH_AARCH64_LIB_H
+#define LIBURING_ARCH_AARCH64_LIB_H
+
+#include <elf.h>
+#include <sys/auxv.h>
+#include "../../syscall.h"
+
+static inline long __get_page_size(void)
+{
+	static const long fallback_ret = 4096;
+	Elf64_Off buf[2];
+	long ret;
+	int fd;
+
+	fd = __sys_open("/proc/self/auxv", O_RDONLY, 0);
+	if (fd < 0)
+		return fallback_ret;
+
+	while (1) {
+		ssize_t x;
+
+		x = __sys_read(fd, buf, sizeof(buf));
+		if (x < sizeof(buf)) {
+			ret = fallback_ret;
+			break;
+		}
+
+		if (buf[0] == AT_PAGESZ) {
+			ret = buf[1];
+			break;
+		}
+	}
+
+	__sys_close(fd);
+	return ret;
+}
+
+static inline long get_page_size(void)
+{
+	static long cache_val;
+
+	if (cache_val)
+		return cache_val;
+
+	cache_val = __get_page_size();
+	return cache_val;
+}
+
+#endif /* #ifndef LIBURING_ARCH_AARCH64_LIB_H */
-- 
Ammar Faizi

