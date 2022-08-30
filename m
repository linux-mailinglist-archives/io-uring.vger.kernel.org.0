Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BF65A5898
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 02:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiH3A45 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 20:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiH3A44 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 20:56:56 -0400
Received: from linux.gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1450F86B58;
        Mon, 29 Aug 2022 17:56:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [68.183.184.174])
        by linux.gnuweeb.org (Postfix) with ESMTPSA id 67919374E9A;
        Tue, 30 Aug 2022 00:56:52 +0000 (UTC)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 1/7] syscall: Make io_uring syscall arguments consistent
Date:   Tue, 30 Aug 2022 07:56:37 +0700
Message-Id: <20220830005122.885209-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830005122.885209-1-ammar.faizi@intel.com>
References: <20220830005122.885209-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Make the arguments of io_uring syscalls consistent with what is said in
the manpage. No functional change is intended.

Link: https://lore.kernel.org/io-uring/CADUfDZpE_gPyfN=dLKB6nu-++ZKyebpWTvYGNOmdP1-c_BLZZA@mail.gmail.com
Link: https://lore.kernel.org/io-uring/CADUfDZr0mPn_REb24aEPa477T+CYeoV5hcbURqX9kazCUqRp4A@mail.gmail.com
Suggested-by: Caleb Sander <csander@purestorage.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/generic/syscall.h | 19 ++++++++++---------
 src/arch/syscall-defs.h    | 19 ++++++++++---------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/src/arch/generic/syscall.h b/src/arch/generic/syscall.h
index 5a172e1..00730e0 100644
--- a/src/arch/generic/syscall.h
+++ b/src/arch/generic/syscall.h
@@ -5,15 +5,15 @@
 
 #include <fcntl.h>
 
-static inline int __sys_io_uring_register(int fd, unsigned opcode,
-					  const void *arg, unsigned nr_args)
+static inline int __sys_io_uring_register(unsigned int fd, unsigned int opcode,
+					  const void *arg, unsigned int nr_args)
 {
 	int ret;
 	ret = syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int __sys_io_uring_setup(unsigned entries,
+static inline int __sys_io_uring_setup(unsigned int entries,
 				       struct io_uring_params *p)
 {
 	int ret;
@@ -21,9 +21,10 @@ static inline int __sys_io_uring_setup(unsigned entries,
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int __sys_io_uring_enter2(int fd, unsigned to_submit,
-					unsigned min_complete, unsigned flags,
-					sigset_t *sig, int sz)
+static inline int __sys_io_uring_enter2(unsigned int fd, unsigned int to_submit,
+					unsigned int min_complete,
+					unsigned int flags, sigset_t *sig,
+					size_t sz)
 {
 	int ret;
 	ret = syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags,
@@ -31,9 +32,9 @@ static inline int __sys_io_uring_enter2(int fd, unsigned to_submit,
 	return (ret < 0) ? -errno : ret;
 }
 
-static inline int __sys_io_uring_enter(int fd, unsigned to_submit,
-				       unsigned min_complete, unsigned flags,
-				       sigset_t *sig)
+static inline int __sys_io_uring_enter(unsigned int fd, unsigned int to_submit,
+				       unsigned int min_complete,
+				       unsigned int flags, sigset_t *sig)
 {
 	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
 				     _NSIG / 8);
diff --git a/src/arch/syscall-defs.h b/src/arch/syscall-defs.h
index 374aa0d..4afb2af 100644
--- a/src/arch/syscall-defs.h
+++ b/src/arch/syscall-defs.h
@@ -61,30 +61,31 @@ static inline int __sys_close(int fd)
 	return (int) __do_syscall1(__NR_close, fd);
 }
 
-static inline int __sys_io_uring_register(int fd, unsigned opcode,
-					  const void *arg, unsigned nr_args)
+static inline int __sys_io_uring_register(unsigned int fd, unsigned int opcode,
+					  const void *arg, unsigned int nr_args)
 {
 	return (int) __do_syscall4(__NR_io_uring_register, fd, opcode, arg,
 				   nr_args);
 }
 
-static inline int __sys_io_uring_setup(unsigned entries,
+static inline int __sys_io_uring_setup(unsigned int entries,
 				       struct io_uring_params *p)
 {
 	return (int) __do_syscall2(__NR_io_uring_setup, entries, p);
 }
 
-static inline int __sys_io_uring_enter2(int fd, unsigned to_submit,
-					unsigned min_complete, unsigned flags,
-					sigset_t *sig, int sz)
+static inline int __sys_io_uring_enter2(unsigned int fd, unsigned int to_submit,
+					unsigned int min_complete,
+					unsigned int flags, sigset_t *sig,
+					size_t sz)
 {
 	return (int) __do_syscall6(__NR_io_uring_enter, fd, to_submit,
 				   min_complete, flags, sig, sz);
 }
 
-static inline int __sys_io_uring_enter(int fd, unsigned to_submit,
-				       unsigned min_complete, unsigned flags,
-				       sigset_t *sig)
+static inline int __sys_io_uring_enter(unsigned int fd, unsigned int to_submit,
+				       unsigned int min_complete,
+				       unsigned int flags, sigset_t *sig)
 {
 	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
 				     _NSIG / 8);
-- 
Ammar Faizi

