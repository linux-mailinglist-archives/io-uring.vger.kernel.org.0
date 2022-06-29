Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DB455F262
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiF2A22 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiF2A22 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:28 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9B1220C5
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:27 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 973327FE70;
        Wed, 29 Jun 2022 00:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462507;
        bh=MXth1xu2tuAlKa4FtMyb3VUpFNE681275yqlUL+dsfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/T1RPwQIoIr5zM0uBWllw2md8R6w6uVLIE8Gs8Ena3w7o5Bv7ZocSyKUfSUVp2L/
         Rp+zMVrsymrrZN7qflB2B0ZYTPss0/qEnQLD9tKXcvA5IIanK09BMLBUnXlMHCMxPT
         LxoiMOBGMoOQxbLywQ4afwBWwWV55/dnejMALM7gZzJra0u7ru0at7FUCloiL4ZrYz
         KeOgz0L/4PAxoVyN0JhBteDlUksyNeh8jKihiXc2UGsy7n/NAXFIlSiCR8iHZFHHnS
         8TKjNOj2mivfHIMrodGQaL922HNecT0sSiq3SR8TyzOnrQ0QLVyxIGBoVBcNN7Y5cM
         Sv7uZ573qMOrg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 4/9] arch: syscall: Add `__sys_read()` syscall
Date:   Wed, 29 Jun 2022 07:27:48 +0700
Message-Id: <20220629002028.1232579-5-ammar.faizi@intel.com>
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
page size by reading /proc/self/auxv.

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
index 0f67446..4b5ba40 100644
--- a/src/arch/syscall-defs.h
+++ b/src/arch/syscall-defs.h
@@ -10,6 +10,11 @@ static inline int __sys_open(const char *pathname, int flags, mode_t mode)
 	return (int) __do_syscall3(__NR_open, pathname, flags, mode);
 }
 
+static inline int __sys_read(int fd, void *buffer, size_t size)
+{
+	return (int) __do_syscall3(__NR_read, fd, buffer, size);
+}
+
 static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
-- 
Ammar Faizi

