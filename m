Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED74A6371DB
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 06:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKXFql (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 00:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKXFqk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 00:46:40 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B95C68A9
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 21:46:39 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 7DD9881709;
        Thu, 24 Nov 2022 05:46:36 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669268799;
        bh=po0Ui+1bsqgq0rpqMMRSwDHS0WRi99bILLgkyxdVK/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mk88+lUl300qHePcGlJhSeL7DK5dcFL4/BNIHGBgN28IygYHc6B79dAlk/zKTnw/K
         3DiOF4Jz1o35mrpxWx79XPsslYarXDVXoOg1q3smE4O7JyAf3014ralubIjrqE1d4u
         K99mCNZWpfVkpI60Pn3+ecxUwn91Mjl/Je7yPogfhqvAk0eaVzam2GFECe7vwcR4+s
         37+5WBEQdzlTLePSwrJtuF1e0qSNrP/yb4pCHA31C+11Dpue/l5glNU6ID+nbuWklE
         lHK5ssi9eVFaiWwOhZ9gijK3cM6LFeAd+Jq5gBOm8YpTDsVs4C4gYkrozExxVz02Mk
         XdNkgHstr9ZOQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org
Subject: [RFC PATCH liburing v1 1/2] nolibc: Do not define `memset()` function in liburing
Date:   Thu, 24 Nov 2022 12:46:15 +0700
Message-Id: <20221124054345.3752171-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124054345.3752171-1-ammar.faizi@intel.com>
References: <20221124054345.3752171-1-ammar.faizi@intel.com>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

liburing has its own memset() in nolibc.c. liburing nolibc can be
linked to apps that use libc. libc has an optimized version of memset()
function.

Alviro reports that he found the memset() from liburing replaces the
optimized memset() from libc when he compiled liburing statically.

A simple reproducer:

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  int main(void)
  {
          static const size_t len = 1024ul  1024ul  1024ul * 4ul;
          char *p;

          p = malloc(len);
          __asm__ volatile ("":"+m"(p));
          memset(p, 0, len);
          __asm__ volatile ("":"+m"(p));
          return 0;
  }

Compile liburing with:

  # Build liburing nolibc.
  ./configure --nolibc;
  make -j8;

  # Without liburing, memset() comes from libc (good)
  gcc x.c -o x;
  objdump -d x;

  # With liburing.a, memset() comes from liburing (bad)
  gcc x.c -o x src/liburing.a;
  objdump -d x;

When we statically link liburing, the linker will choose the statically
linked memset() over the dynamically linked memset() that the libc
provides.

Change the function name to __uring_memset() and define a macro
memset() as:

   #define memset(PTR, C, LEN) __uring_memset(PTR, C, LEN)

when CONFIG_NOLIBC is enabled so we don't have to touch the callers.

Fixes: f48ee3168cdc325233825603269f304d348d323c ("Add nolibc build support")
Reported-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/lib.h    | 5 +++++
 src/nolibc.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/lib.h b/src/lib.h
index f347191..5a9b87c 100644
--- a/src/lib.h
+++ b/src/lib.h
@@ -37,6 +37,7 @@
 #define __hot			__attribute__((__hot__))
 #define __cold			__attribute__((__cold__))
 
+void *__uring_memset(void *s, int c, size_t n);
 void *__uring_malloc(size_t len);
 void __uring_free(void *p);
 
@@ -58,4 +59,8 @@ static inline void uring_free(void *ptr)
 #endif
 }
 
+#ifdef CONFIG_NOLIBC
+#define memset(PTR, C, LEN)	__uring_memset(PTR, C, LEN)
+#endif
+
 #endif /* #ifndef LIBURING_LIB_H */
diff --git a/src/nolibc.c b/src/nolibc.c
index 9a04ead..3207e33 100644
--- a/src/nolibc.c
+++ b/src/nolibc.c
@@ -7,7 +7,7 @@
 #include "lib.h"
 #include "syscall.h"
 
-void *memset(void *s, int c, size_t n)
+void *__uring_memset(void *s, int c, size_t n)
 {
 	size_t i;
 	unsigned char *p = s;
-- 
Ammar Faizi

