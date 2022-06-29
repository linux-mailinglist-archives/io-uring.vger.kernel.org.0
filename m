Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6265755F261
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiF2A20 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiF2A2Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:25 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6120322B03
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:24 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id B1CC17FD04;
        Wed, 29 Jun 2022 00:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462504;
        bh=EEi2haoxNhLN0yY3nzLrm6Y7Q5tS1uuPWrI/84vA0Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7ppUYaKHlQYhSox/HbeP+4+aY4E64HnSfqylFk/XPWYC/7kQocOvQ4k9SCsPuprD
         CncHkmcpmXF6k0jWxv5re3mlT3mP5fja9BPAI6jkVBfBnzFTOiB0zTdZd3EHwLTqNV
         9aiTd2rsIto3DgPazGH11iiE+Vk/YOTsxYW3yQCuV9bbsFGf/QYQVjcB5qvYLv0q54
         apbLGHZRZ69rqA0I8nPUOlBra4YTnN4MQ5XsBiNUhTlks2n0pmduOaSly4233n8G20
         PFWtYGwAQemDyadrNoIKYZzTiV4MOFpz/NXBRqens3lwSHlBC5Jx8yIe5jn6jfeA0y
         bP4L9nftSrA1g==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 3/9] arch: syscall: Add `__sys_open()` syscall
Date:   Wed, 29 Jun 2022 07:27:47 +0700
Message-Id: <20220629002028.1232579-4-ammar.faizi@intel.com>
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

A prep patch to support aarch64 nolibc. We will use this to get the
page size by reading /proc/self/auxv. For some reason __NR_open is
not defined, so also define it in aarch64 syscall specific file.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/aarch64/syscall.h | 4 ++++
 src/arch/generic/syscall.h | 9 +++++++++
 src/arch/syscall-defs.h    | 7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/src/arch/aarch64/syscall.h b/src/arch/aarch64/syscall.h
index c0ab7e2..5e26714 100644
--- a/src/arch/aarch64/syscall.h
+++ b/src/arch/aarch64/syscall.h
@@ -84,6 +84,10 @@
 			"r" (x4), "r"(x5));				\
 })
 
+#ifndef __NR_open
+#define __NR_open 	0x400
+#endif
+
 #include "../syscall-defs.h"
 
 #else /* #if defined(__aarch64__) */
diff --git a/src/arch/generic/syscall.h b/src/arch/generic/syscall.h
index fa93064..71b2234 100644
--- a/src/arch/generic/syscall.h
+++ b/src/arch/generic/syscall.h
@@ -7,6 +7,8 @@
 #ifndef LIBURING_ARCH_GENERIC_SYSCALL_H
 #define LIBURING_ARCH_GENERIC_SYSCALL_H
 
+#include <fcntl.h>
+
 static inline int ____sys_io_uring_register(int fd, unsigned opcode,
 					    const void *arg, unsigned nr_args)
 {
@@ -41,6 +43,13 @@ static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
 				       _NSIG / 8);
 }
 
+static inline int __sys_open(const char *pathname, int flags, mode_t mode)
+{
+	int ret;
+	ret = open(pathname, flags, mode);
+	return (ret < 0) ? -errno : ret;
+}
+
 static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
diff --git a/src/arch/syscall-defs.h b/src/arch/syscall-defs.h
index 1e8ae1b..0f67446 100644
--- a/src/arch/syscall-defs.h
+++ b/src/arch/syscall-defs.h
@@ -3,6 +3,13 @@
 #ifndef LIBURING_ARCH_SYSCALL_DEFS_H
 #define LIBURING_ARCH_SYSCALL_DEFS_H
 
+#include <fcntl.h>
+
+static inline int __sys_open(const char *pathname, int flags, mode_t mode)
+{
+	return (int) __do_syscall3(__NR_open, pathname, flags, mode);
+}
+
 static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
-- 
Ammar Faizi

