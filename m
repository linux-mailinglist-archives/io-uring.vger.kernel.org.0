Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB0E56082D
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 19:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiF2R7u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 13:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiF2R7r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 13:59:47 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE18CD93
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:59:46 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 4D2517FC07;
        Wed, 29 Jun 2022 17:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656525586;
        bh=8rvYQ2Hh72AHYXlNPnhKEoTXHZExITmndsEjdUWGuMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+LH6j+K5Jv3tIt5NLDp6deGJNTmtbs6kFZubD8Bk25yTF3/7EUh8JPC7/4Tja78g
         t5jaUsAprYzPdbpgidJTLPA3uYmO3HS4cYePkrgvWp6O5stcH11KhRiN0blIS398I2
         iKuh6IJu9tOJNxA+73zhhQVY92vZo6lvisYTt3YmGZjUeksO4u6d0jHbk9OlU2cHa6
         rDlKTDmSxl19yzKX6Ugv6dMxfAeA5K0r0X/u/+vCNruHhbyQeIvj1WqF0jE2FHBjfw
         LpmKEkQLaaNRmUmczJ9m9gaYi3sgfkzB2NnkJWAbg2uBG/ZWy+h9lRX/L5lguwHRAV
         BC3KJiko97OBw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v2 5/8] arch/aarch64: lib: Add `get_page_size()` function
Date:   Thu, 30 Jun 2022 00:58:27 +0700
Message-Id: <20220629175255.1377052-6-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629175255.1377052-1-ammar.faizi@intel.com>
References: <20220629175255.1377052-1-ammar.faizi@intel.com>
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

v2:
  - Fallback to 4K if the syscall fails.
  - Cache the page size after read as suggested by Jens.

Link: https://github.com/torvalds/linux/blob/v5.19-rc4/fs/binfmt_elf.c#L260 [1]
Link: https://lore.kernel.org/io-uring/3895dbe1-8d5f-cf53-e94b-5d1545466de1@kernel.dk
Link: https://lore.kernel.org/io-uring/8bfba71c-55d7-fb49-6593-4d0f9d9c3611@kernel.dk
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/aarch64/lib.h | 45 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 src/arch/aarch64/lib.h

diff --git a/src/arch/aarch64/lib.h b/src/arch/aarch64/lib.h
new file mode 100644
index 0000000..adba512
--- /dev/null
+++ b/src/arch/aarch64/lib.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef LIBURING_ARCH_AARCH64_LIB_H
+#define LIBURING_ARCH_AARCH64_LIB_H
+
+#include <elf.h>
+#include <sys/auxv.h>
+#include "../../syscall.h"
+
+static inline long get_page_size(void)
+{
+	static const long fallback_ret = 4096;
+	static long cache_val = 0;
+	Elf64_Off buf[2];
+	long page_size;
+	int fd;
+
+	if (cache_val)
+		return cache_val;
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
+			page_size = fallback_ret;
+			break;
+		}
+
+		if (buf[0] == AT_PAGESZ) {
+			page_size = buf[1];
+			cache_val = page_size;
+			break;
+		}
+	}
+
+	__sys_close(fd);
+	return page_size;
+}
+
+#endif /* #ifndef LIBURING_ARCH_AARCH64_LIB_H */
-- 
Ammar Faizi

