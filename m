Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9634C565E00
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiGDTc3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 15:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiGDTc1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 15:32:27 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4393A21B0
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 12:32:27 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 3DBB880286;
        Mon,  4 Jul 2022 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656963146;
        bh=/ZM+1WP/d8NrhReu0jKB1r2savxNdRerPeQ5ZmjG5jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVW8bjptrUDx80BkqVXcJ+IvXSfvHBCYEPi98W+tm5VxGdenAhuQmQxapUu6ly+NT
         NXIr262wpISIFisqrr1jJRXHh/bkRQQAXTZxkimaFtY6boK04r9B4MQBp2/5Fz11DC
         vogmE9RF8o3BCfdBPzASw+ogP34bXFh2HJ12B7i8m1KNAuyQT/VUQILc3WM4PYKilJ
         qnSJISd68BZ0gdc7rqdI7O0pTv2KV+3GA0+URzvK26nOAgXz3yJxBWr9ROluPTj1aL
         a6NWx6axZFDPn3l9+Thk4yo+qtTeLIWM30F+ONPn8B9B7UW6bklb/v7EACdwgaUPeo
         B/Ypjh9YSrisA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v4 03/10] arch: syscall: Add `__sys_read()` syscall
Date:   Tue,  5 Jul 2022 02:31:48 +0700
Message-Id: <20220704192827.338771-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220704192827.338771-1-ammar.faizi@intel.com>
References: <20220704192827.338771-1-ammar.faizi@intel.com>
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
page size by reading /proc/self/auxv.

v2:
  - Fix return type, __sys_read() returns ssize_t, not int.

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/generic/syscall.h | 7 +++++++
 src/arch/syscall-defs.h    | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/src/arch/generic/syscall.h b/src/arch/generic/syscall.h
index 71b2234..22252a1 100644
--- a/src/arch/generic/syscall.h
+++ b/src/arch/generic/syscall.h
@@ -50,6 +50,13 @@ static inline int __sys_open(const char *pathname, int flags, mode_t mode)
 	return (ret < 0) ? -errno : ret;
 }
 
+static inline ssize_t __sys_read(int fd, void *buffer, size_t size)
+{
+	ssize_t ret;
+	ret = read(fd, buffer, size);
+	return (ret < 0) ? -errno : ret;
+}
+
 static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
diff --git a/src/arch/syscall-defs.h b/src/arch/syscall-defs.h
index 9d4424d..bde69fa 100644
--- a/src/arch/syscall-defs.h
+++ b/src/arch/syscall-defs.h
@@ -17,6 +17,11 @@ static inline int __sys_open(const char *pathname, int flags, mode_t mode)
 #endif
 }
 
+static inline ssize_t __sys_read(int fd, void *buffer, size_t size)
+{
+	return (ssize_t) __do_syscall3(__NR_read, fd, buffer, size);
+}
+
 static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
-- 
Ammar Faizi

