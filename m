Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCFB566498
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 10:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiGEHpP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 03:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiGEHpO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 03:45:14 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FE812D06
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 00:45:13 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id C56F3801E6;
        Tue,  5 Jul 2022 07:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1657007113;
        bh=aWHzBpvLN2HYJbYqDk3KmU1XjFfnCdTXUT14Tux6Ons=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvx9V5V9Co8LeOhmfWsnCf2Texkivu9iF29OAKPPcIDY6IJThJtZcPe/xtjDNMIkR
         1EIb335QIwaLEbVhgUI4e9d+Pj/NQ1o2UpIy3RGWZfISy/0WbgzIOi1dbnE298hQ4D
         csd6aKvTYXnKSWVBFvrxvToXXIy5yZ+KPGfrKcgYHrawJrDaSnDpAdO26PD49vOdTL
         E+bUHuOV6tKsSyxFWMHvzK8FB5Ciwo5HH5tS5Zum9BQW8th2VPBF1pPFK18sm7vcyh
         A720YCulFza6y29XemXP1B4tQZ1Cb/rJTtj+Y2cb/ZCkssJgXyFR7iBaqMkVrL2HDe
         +RVXSrbJSiD1Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v5 03/10] arch: syscall: Add `__sys_read()` syscall
Date:   Tue,  5 Jul 2022 14:43:53 +0700
Message-Id: <20220705073920.367794-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220705073920.367794-1-ammar.faizi@intel.com>
References: <20220705073920.367794-1-ammar.faizi@intel.com>
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
index d38b5f3..df90e0d 100644
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

