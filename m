Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BB95A58A5
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 02:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiH3A5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 20:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiH3A5H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 20:57:07 -0400
Received: from linux.gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE398A1C0;
        Mon, 29 Aug 2022 17:57:02 -0700 (PDT)
Received: from localhost.localdomain (unknown [68.183.184.174])
        by linux.gnuweeb.org (Postfix) with ESMTPSA id 439F8374EE2;
        Tue, 30 Aug 2022 00:56:58 +0000 (UTC)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 3/7] man: Clarify "man 2" entry for io_uring syscalls
Date:   Tue, 30 Aug 2022 07:56:39 +0700
Message-Id: <20220830005122.885209-4-ammar.faizi@intel.com>
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

io_uring_enter(), io_uring_register(), and io_uring_setup() are not
declared in `<linux/io_uring.h>` (and never were). A previous commit
adds the implementation of these functions in liburing. Change the
include header to `<liburing.h>`. Then clarify that those functions
don't intentionally set the `errno` variable. Instead they return
a negative error code when the syscall fails.

Side note: On architectures _other_ than x86, x86-64, and aarch64, those
functions _do_ set the `errno`. This is because the syscall is done via
libc. Users should not rely on this behavior as it may change in the
future when nolibc support is expanded to other architectures.

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

