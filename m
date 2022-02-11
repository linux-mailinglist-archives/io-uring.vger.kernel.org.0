Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114104B297C
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 16:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349624AbiBKP6b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 10:58:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344108AbiBKP6b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 10:58:31 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180471A8
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 07:58:30 -0800 (PST)
Received: from integral2.. (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 978C17E29B;
        Fri, 11 Feb 2022 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644595109;
        bh=pIgR+8EOiw0OSPjmi2yf4U3u/rYstb0Z690vhZ40ZFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klN/Li4RreRvcDIhFLWVDi4KmGqoUxhbWiN3x532eo3Jp6U3NYSaEK+2sYqilNgRg
         tRTmwdSVN4TANVClxQ9/XBvPByFUl5/aVFD1rTgRvK2PbcDOOHfMWyMVSvW92TRM3/
         3wnvyQQlYzxIJP0pI+KzObuDkaidPZsrEpNixyGN965dUHBxvOodw3XtnRpMrbbUhW
         8wHry7lZ447zkR05rzV7aMEKvvfgKn9YmswOkuCzJS2+2bfv6OdwCT3U6JvzN7kRXy
         cW9XOmxhA6KLyHNIoKWurXjE8/TtdoDpdd/fllVYEAjzjsuO+sOUhnIsx5OR6dO9dB
         gUlpt503jUi3Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Nugra <richiisei@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 1/4] arch/generic: Create arch generic syscall wrappers
Date:   Fri, 11 Feb 2022 22:57:50 +0700
Message-Id: <20220211155753.143698-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
References: <20220211155753.143698-1-ammarfaizi2@gnuweeb.org>
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

From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

This is a preparation for refactoring the syscall wrappers.

This creates a new file src/arch/generic/syscall.h. This file
contains libc syscall wrappers for architectures that don't
have arch specific code. In the next patches, we will include
this file from src/syscall.h.

It aims to reduce the usage of #ifdef/#endif that occurs in
every function in src/syscall.h file. Also, it will make the
arch specific code structure cleaner and easier to manage.

Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Co-authored-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/generic/syscall.h | 83 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100644 src/arch/generic/syscall.h

diff --git a/src/arch/generic/syscall.h b/src/arch/generic/syscall.h
new file mode 100644
index 0000000..7136290
--- /dev/null
+++ b/src/arch/generic/syscall.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef LIBURING_ARCH_GENERIC_SYSCALL_H
+#define LIBURING_ARCH_GENERIC_SYSCALL_H
+
+static inline int ____sys_io_uring_register(int fd, unsigned opcode,
+					    const void *arg, unsigned nr_args)
+{
+	int ret;
+	ret = syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int ____sys_io_uring_setup(unsigned entries,
+					 struct io_uring_params *p)
+{
+	int ret;
+	ret = syscall(__NR_io_uring_setup, entries, p);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
+					  unsigned min_complete, unsigned flags,
+					  sigset_t *sig, int sz)
+{
+	int ret;
+	ret = syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags,
+		      sig, sz);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
+					 unsigned min_complete, unsigned flags,
+					 sigset_t *sig)
+{
+	return ____sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
+				       _NSIG / 8);
+}
+
+static inline void *uring_mmap(void *addr, size_t length, int prot, int flags,
+			       int fd, off_t offset)
+{
+	void *ret;
+	ret = mmap(addr, length, prot, flags, fd, offset);
+	return (ret == MAP_FAILED) ? ERR_PTR(-errno) : ret;
+}
+
+static inline int uring_munmap(void *addr, size_t length)
+{
+	int ret;
+	ret = munmap(addr, length);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int uring_madvise(void *addr, size_t length, int advice)
+{
+	int ret;
+	ret = madvise(addr, length, advice);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int uring_getrlimit(int resource, struct rlimit *rlim)
+{
+	int ret;
+	ret = getrlimit(resource, rlim);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int uring_setrlimit(int resource, const struct rlimit *rlim)
+{
+	int ret;
+	ret = setrlimit(resource, rlim);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int uring_close(int fd)
+{
+	int ret;
+	ret = close(fd);
+	return (ret < 0) ? -errno : ret;
+}
+
+#endif /* #ifndef LIBURING_ARCH_GENERIC_SYSCALL_H */
-- 
2.32.0

