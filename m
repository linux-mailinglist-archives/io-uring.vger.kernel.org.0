Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB5A565D38
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 19:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiGDRzF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiGDRzE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 13:55:04 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B56DE83
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 10:55:04 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 0ED13800EF;
        Mon,  4 Jul 2022 17:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656957303;
        bh=yghAnwMuF0YXLqQdTKb1gs5igNwoSinLSeS4Ea+dVM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DM8Os5OYkitsGEeYx7I5eOMwllST69W6I0E3GME5AwdqwMyEd8kMAkX++8axxc7eG
         +LXCSt5itm3dAZ4OjtI7iVRRXyh0gnh3t101xEqI9MLNWX7z9Psuop9lsfSsK6NqKV
         7EYlzQywlifRtcJ98JzwNlhfImhp6inyquQucU5oGleHkqOdvpSNnnoE7XBXAcnopu
         JS3xLvFXOCAykc3zlPU5ByBQW7nOEL/iDc/G7MoRIu6GC6OGUpN8BFLlX8833Ce1VJ
         R80luFon28vXnOiTa1TQMPawGnYw1rZqYtrmVEkT1de2Lipdz5LLpUQWWlNKdVeU+Y
         joU6Ia+8YSKuQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 02/10] arch: syscall: Add `__sys_open()` syscall
Date:   Tue,  5 Jul 2022 00:54:28 +0700
Message-Id: <20220704174858.329326-3-ammar.faizi@intel.com>
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

A prep patch to support aarch64 nolibc. We will use this to get the
page size by reading /proc/self/auxv. For some reason __NR_open is
not defined, so also define it in aarch64 syscall specific file.

v3:
  - Use __NR_openat if __NR_open is not defined.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/generic/syscall.h |  9 +++++++++
 src/arch/syscall-defs.h    | 14 ++++++++++++++
 2 files changed, 23 insertions(+)

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
index 1e8ae1b..9d4424d 100644
--- a/src/arch/syscall-defs.h
+++ b/src/arch/syscall-defs.h
@@ -3,6 +3,20 @@
 #ifndef LIBURING_ARCH_SYSCALL_DEFS_H
 #define LIBURING_ARCH_SYSCALL_DEFS_H
 
+#include <fcntl.h>
+
+static inline int __sys_open(const char *pathname, int flags, mode_t mode)
+{
+	/*
+ 	 * Some architectures don't have __NR_open, but __NR_openat.
+ 	 */
+#ifdef __NR_open
+	return __do_syscall3(__NR_open, pathname, flags, mode);
+#else
+	return __do_syscall4(__NR_openat, AT_FDCWD, pathname, flags, mode);
+#endif
+}
+
 static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
-- 
Ammar Faizi

