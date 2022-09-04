Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439A85AC343
	for <lists+io-uring@lfdr.de>; Sun,  4 Sep 2022 09:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiIDHi5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Sep 2022 03:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiIDHi4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Sep 2022 03:38:56 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D714620A
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 00:38:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.71.200])
        by gnuweeb.org (Postfix) with ESMTPSA id 303C4804FD;
        Sun,  4 Sep 2022 07:38:50 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662277135;
        bh=kVhMCfSnTCGom1GFmJrKOwFCKw+V0su6J6zGYu2I3Lk=;
        h=From:To:Cc:Subject:Date:From;
        b=LYXvk/SYWePgm6YYb+73Nfls4t/CcqPOWIIMuhnbNgClOV8NU0bCIuWTvYAnzTNGK
         wmtMMUo5RvMD+Wf5LFDu0OX42Fm4Sm8Mt4KGnxqVQy6pzkDgO+BXnUKtjbZMxnX7e4
         XYSONGUbXuel9LxKjZ+uXJZz2eIHl0pdGAqU29/qdtJhR3rLblTdn5Z6v//+Tk75ZV
         NEXGiftDWor1b4Xvk07435UCDVxgtPF/+1rVNdvNkrxxzCWUtwDokKNzACaQkWKxeT
         5FIMQxw79ZIhZ1WMGoK1sxX1VQBD90gdY1xslF76enSUbHT5Z2FQkzAeA4o6O9/jWg
         bhaqgsdEXkSyg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Subject: [PATCH liburing v2] liburing: Export `__NR_io_uring_{setup,enter,register}` to user
Date:   Sun,  4 Sep 2022 14:38:45 +0700
Message-Id: <20220904073817.1950991-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
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

These macros are not defined in an old <sys/syscall.h> file. Allow
liburing users to get io_uring syscall numbers by including
<liburing.h>.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

v2:
   - Fix typo in the commit message:
     s/in a old/in an old/

 src/include/liburing.h | 38 ++++++++++++++++++++++++++++++++++++++
 src/syscall.h          | 37 -------------------------------------
 2 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 6040a06..cceab6b 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -33,6 +33,44 @@
 #define uring_likely(cond)	__builtin_expect(!!(cond), 1)
 #endif
 
+
+#ifdef __alpha__
+/*
+ * alpha and mips are exception, other architectures have
+ * common numbers for new system calls.
+ */
+#ifndef __NR_io_uring_setup
+#define __NR_io_uring_setup		535
+#endif
+#ifndef __NR_io_uring_enter
+#define __NR_io_uring_enter		536
+#endif
+#ifndef __NR_io_uring_register
+#define __NR_io_uring_register		537
+#endif
+#elif defined __mips__
+#ifndef __NR_io_uring_setup
+#define __NR_io_uring_setup		(__NR_Linux + 425)
+#endif
+#ifndef __NR_io_uring_enter
+#define __NR_io_uring_enter		(__NR_Linux + 426)
+#endif
+#ifndef __NR_io_uring_register
+#define __NR_io_uring_register		(__NR_Linux + 427)
+#endif
+#else /* !__alpha__ and !__mips__ */
+#ifndef __NR_io_uring_setup
+#define __NR_io_uring_setup		425
+#endif
+#ifndef __NR_io_uring_enter
+#define __NR_io_uring_enter		426
+#endif
+#ifndef __NR_io_uring_register
+#define __NR_io_uring_register		427
+#endif
+#endif
+
+
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/src/syscall.h b/src/syscall.h
index ba008ea..f750782 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -10,45 +10,8 @@
 #include <sys/mman.h>
 #include <sys/syscall.h>
 #include <sys/resource.h>
-
 #include <liburing.h>
 
-#ifdef __alpha__
-/*
- * alpha and mips are exception, other architectures have
- * common numbers for new system calls.
- */
-#ifndef __NR_io_uring_setup
-#define __NR_io_uring_setup		535
-#endif
-#ifndef __NR_io_uring_enter
-#define __NR_io_uring_enter		536
-#endif
-#ifndef __NR_io_uring_register
-#define __NR_io_uring_register	537
-#endif
-#elif defined __mips__
-#ifndef __NR_io_uring_setup
-#define __NR_io_uring_setup		(__NR_Linux + 425)
-#endif
-#ifndef __NR_io_uring_enter
-#define __NR_io_uring_enter		(__NR_Linux + 426)
-#endif
-#ifndef __NR_io_uring_register
-#define __NR_io_uring_register	(__NR_Linux + 427)
-#endif
-#else /* !__alpha__ and !__mips__ */
-#ifndef __NR_io_uring_setup
-#define __NR_io_uring_setup		425
-#endif
-#ifndef __NR_io_uring_enter
-#define __NR_io_uring_enter		426
-#endif
-#ifndef __NR_io_uring_register
-#define __NR_io_uring_register		427
-#endif
-#endif
-
 /*
  * Don't put this below the #include "arch/$arch/syscall.h", that
  * file may need it.

base-commit: 42ee2bdb76022fc11d7a0ad8ec5cca6de73501e9
-- 
Ammar Faizi

