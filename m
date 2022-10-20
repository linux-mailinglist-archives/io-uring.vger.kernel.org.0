Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08F1605F68
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 13:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiJTLxI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 07:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJTLxI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 07:53:08 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7913F7B584
        for <io-uring@vger.kernel.org>; Thu, 20 Oct 2022 04:53:07 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.253.183.172])
        by gnuweeb.org (Postfix) with ESMTPSA id 8307481161;
        Thu, 20 Oct 2022 11:53:04 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1666266787;
        bh=PzznPjZ0LbFEEazJSAMQHo+lgL2uwM7RwvTOadd9yB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0/R14q5VKHUWBK4V247GAzC/KG2wBYuQ+7bUfUPBiHqAdCNizTPlwVUZAlOMflkm
         Oe3x/DBSHqgwnSDb5nvHl9Qd5JGcgNNpG2SQhRCNBoOs3VyTZMTPfIoltrAq0Gf0Yr
         C8ap3WaeG9aZ1bBVGHV2B4dp+OdjI8644c1kMkqJi3ZwO4IWnG1Sa7LDCOa6zXvEsP
         rnPpV/iCLxyzeFAcD9Mk2kySQQ4RwxOPHDv3B2q873tu2q91rRPiOuRq32jNDJp0tk
         Ikuum2Fn8nfACAa93L8zIl+qkPO/mXtKCNegTee+S9X7vIy3QvVJJRt7eh8w12HHhM
         n7Z+56p9QNeGQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@meta.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v1 1/3] liburing: Clean up `-Wshorten-64-to-32` warnings from clang
Date:   Thu, 20 Oct 2022 18:52:04 +0700
Message-Id: <20221020114814.63133-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020114814.63133-1-ammar.faizi@intel.com>
References: <20221020114814.63133-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Dylan Yudaken <dylany@fb.com>

liburing has a couple of int shortening issues found by clang. Clean
them all. This cleanup is particularly useful for build systems that
include these files and run with that error enabled.

Link: https://lore.kernel.org/io-uring/20221019145042.446477-1-dylany@meta.com
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/syscall-defs.h |  4 ++--
 src/register.c          |  5 ++++-
 src/setup.c             | 12 ++++++------
 src/syscall.h           |  4 ++--
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/src/arch/syscall-defs.h b/src/arch/syscall-defs.h
index 4afb2af..7660574 100644
--- a/src/arch/syscall-defs.h
+++ b/src/arch/syscall-defs.h
@@ -11,9 +11,9 @@ static inline int __sys_open(const char *pathname, int flags, mode_t mode)
 	 * Some architectures don't have __NR_open, but __NR_openat.
 	 */
 #ifdef __NR_open
-	return __do_syscall3(__NR_open, pathname, flags, mode);
+	return (int)__do_syscall3(__NR_open, pathname, flags, mode);
 #else
-	return __do_syscall4(__NR_openat, AT_FDCWD, pathname, flags, mode);
+	return (int)__do_syscall4(__NR_openat, AT_FDCWD, pathname, flags, mode);
 #endif
 }
 
diff --git a/src/register.c b/src/register.c
index 0a2e5af..912851a 100644
--- a/src/register.c
+++ b/src/register.c
@@ -277,8 +277,11 @@ int io_uring_enable_rings(struct io_uring *ring)
 int io_uring_register_iowq_aff(struct io_uring *ring, size_t cpusz,
 			       const cpu_set_t *mask)
 {
+	if (cpusz >= (1U << 31))
+		return -EINVAL;
+
 	return __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_IOWQ_AFF,
-				       mask, cpusz);
+				mask, (int)cpusz);
 }
 
 int io_uring_unregister_iowq_aff(struct io_uring *ring)
diff --git a/src/setup.c b/src/setup.c
index 21283eb..1885731 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -248,29 +248,29 @@ __cold void io_uring_free_probe(struct io_uring_probe *probe)
 	uring_free(probe);
 }
 
-static inline int __fls(int x)
+static inline int __fls(unsigned long x)
 {
 	if (!x)
 		return 0;
-	return 8 * sizeof(x) - __builtin_clz(x);
+	return 8 * sizeof(x) - __builtin_clzl(x);
 }
 
 static unsigned roundup_pow2(unsigned depth)
 {
-	return 1UL << __fls(depth - 1);
+	return 1U << __fls(depth - 1);
 }
 
-static size_t npages(size_t size, unsigned page_size)
+static size_t npages(size_t size, long page_size)
 {
 	size--;
 	size /= page_size;
-	return __fls(size);
+	return __fls((int)size);
 }
 
 #define KRING_SIZE	320
 
 static size_t rings_size(struct io_uring_params *p, unsigned entries,
-			 unsigned cq_entries, unsigned page_size)
+			 unsigned cq_entries, long page_size)
 {
 	size_t pages, sq_size, cq_size;
 
diff --git a/src/syscall.h b/src/syscall.h
index f750782..c61d572 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -23,9 +23,9 @@ static inline void *ERR_PTR(intptr_t n)
 	return (void *) n;
 }
 
-static inline intptr_t PTR_ERR(const void *ptr)
+static inline int PTR_ERR(const void *ptr)
 {
-	return (intptr_t) ptr;
+	return (int) (intptr_t)ptr;
 }
 
 static inline bool IS_ERR(const void *ptr)
-- 
Ammar Faizi

