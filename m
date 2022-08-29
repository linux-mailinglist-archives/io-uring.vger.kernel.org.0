Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D2C5A4152
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 05:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiH2DIi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Aug 2022 23:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiH2DIY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Aug 2022 23:08:24 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141EF3ECDF;
        Sun, 28 Aug 2022 20:08:06 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.68.216])
        by gnuweeb.org (Postfix) with ESMTPSA id 237D280B1A;
        Mon, 29 Aug 2022 03:07:55 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661742478;
        bh=ivRuXH0B3moNqjOeBRddyAEgMfDZLseE8xHqimkLSzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnVr8pfap+KMag0EwUAcZvK37dpAYosZgdNjT/f6VBMnFqvp2jLLxM6p109CKyT/f
         irZY0E07TiRlZacarpNfe90b22sk0uMFSXRWof7RocUzLwLu+t7OtqTynIKSMHnAaA
         Pm98zLlA8/O9MBv3CTdkG8nkbQBkvp+T8EqwPw0POpMRZaI3OcCAsTD1T4pw70OKBM
         oc4u0vRGufHPz+GvmTnnfR3bJOy0CuSxsYIC+4CteEwuj3Rj7G4O7hosTSj6qOdqYq
         zWWP2ofTY7xAlc/YPVpkt90joDawe/IdevvOX/UfOg40eojqUxQcfVEJkdSd5bO0B1
         CwHSwEXweHgTQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 2/4] man: Clarify "man 2" entry for io_uring syscalls
Date:   Mon, 29 Aug 2022 10:07:37 +0700
Message-Id: <20220829030521.3373516-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220829030521.3373516-1-ammar.faizi@intel.com>
References: <20220829030521.3373516-1-ammar.faizi@intel.com>
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

io_uring_enter(), io_uring_register(), io_uring_setup() are not
declared in `<linux/io_uring.h>` and never were. Plus, these
functions don't intentionally set the `errno` variable. Reflect this
fact in the manpage.

Side note: On architectures other than x86, x86-64, and aarch64, those
functions _do_ set the `errno`, this is because the syscall is done via
libc as we don't yet have nolibc support for the mentioned archs. Users
should not rely on this behavior.

Cc: Caleb Sander <csander@purestorage.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_enter.2    | 9 ++++-----
 man/io_uring_register.2 | 9 ++++-----
 man/io_uring_setup.2    | 8 +++-----
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 6bfe9c9..05f9f72 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -8,7 +8,7 @@
 io_uring_enter \- initiate and/or complete asynchronous I/O
 .SH SYNOPSIS
 .nf
-.BR "#include <linux/io_uring.h>"
+.BR "#include <liburing.h>"
 .PP
 .BI "int io_uring_enter(unsigned int " fd ", unsigned int " to_submit ,
 .BI "                   unsigned int " min_complete ", unsigned int " flags ,
@@ -1299,11 +1299,10 @@ completion queue entry (see section
 rather than through the system call itself.
 
 Errors that occur not on behalf of a submission queue entry are returned via the
-system call directly. On such an error,
-.B -1
-is returned and
+system call directly. On such an error, a negative error code is returned. The
+caller should not rely on
 .I errno
-is set appropriately.
+variable.
 .PP
 .SH ERRORS
 These are the errors returned by
diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index 6c440b9..6791375 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -8,7 +8,7 @@
 io_uring_register \- register files or user buffers for asynchronous I/O 
 .SH SYNOPSIS
 .nf
-.BR "#include <linux/io_uring.h>"
+.BR "#include <liburing.h>"
 .PP
 .BI "int io_uring_register(unsigned int " fd ", unsigned int " opcode ,
 .BI "                      void *" arg ", unsigned int " nr_args );
@@ -583,11 +583,10 @@ Available since 5.18.
 
 On success,
 .BR io_uring_register ()
-returns 0.  On error,
-.B -1
-is returned, and
+returns 0.  On error, a negative error code is returned. The caller should not
+rely on
 .I errno
-is set accordingly.
+variable.
 
 .SH ERRORS
 .TP
diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 0a5fa92..32a9e2e 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -9,7 +9,7 @@
 io_uring_setup \- setup a context for performing asynchronous I/O
 .SH SYNOPSIS
 .nf
-.BR "#include <linux/io_uring.h>"
+.BR "#include <liburing.h>"
 .PP
 .BI "int io_uring_setup(u32 " entries ", struct io_uring_params *" p );
 .fi
@@ -566,11 +566,9 @@ or
 .BR io_uring_enter (2)
 system calls.
 
-On error,
-.B -1
-is returned and
+On error, a negative error code is returned. The caller should not rely on
 .I errno
-is set appropriately.
+variable.
 .PP
 .SH ERRORS
 .TP
-- 
Ammar Faizi

