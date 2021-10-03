Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E3D42012B
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 12:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhJCKUn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 06:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhJCKUm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 06:20:42 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2FFC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 03:18:55 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pg10so9047656pjb.5
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 03:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MAweDbXCgivBLUGbVsmYI8Qi1lEAjMdbt3K/rExqIgg=;
        b=dHTsZ2akbOpqFjs/qf33IExM20PgUogiVWnuHnz2R+x8mwrH8AMQwcSAEPUfPTv0L7
         /G1xNWyWud0/KR75YSXoS83draNKliC4c8eIfmbAhKcRdhQ4E9Oj5VMfyD/ttsVinsnO
         IZ1AS5cJR1FAbxg7aR3SeahW/ibMzfeH08crULNBzUx7C0rXbP/3vJZ1ocfgytmHaMzE
         imVW0EZLfSFznGUrIo2uYNoYYDWui2XKypQzgij5rZpzWIfBpcj8YN1LRzunvmJBgkAS
         dYvVNDkRUKgDwv+hvde42DswEObAkgQFKFX4bVS5VtWLk9KHaxeEz8ZXESXKyZGfgJMJ
         U5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MAweDbXCgivBLUGbVsmYI8Qi1lEAjMdbt3K/rExqIgg=;
        b=tLneDVnn5gLYK7YaysAmOTT+P/zRO4m9MN/xfQPOclkGZ4i052xV1hIDjedzrPrQaw
         Jt45ZOxdXT7tY5BEXEJ8XwyJSaUJ6WVL81RtPPF5dLdH8SBjlskQvRlRTLedrzWvK8jJ
         ciorZg81dlCuciRulUGUtFhIR1f6O1PeXJ6C+P/h7DK89VfQbQs0PQUoXc+CJrSOqnot
         zIhlqBDs3zPmVkHU34uSHgfTesZyj3F79AdDIUpWd2eohTGw2BAlC4tHmE1mYVAuPM/H
         RCtTCuhWwoBPL9PSrUZ8pBkpekaNy7tra6S6iqL/bGjeh7/jWJotM4xcF+TrzM82KVl9
         OaVw==
X-Gm-Message-State: AOAM530mgkvad/UUghVbIBA+1xS4H6WPqxbMg9abAPXqedwXjzw2fyZS
        tVfoqd6sP4k2oF4slVH1Cauwwg==
X-Google-Smtp-Source: ABdhPJzjT29ahQlieaNjvpxDWEIf0NCidr8KhzE3NHF9LHFopRx3rgxTOvnmBTNS0tU6o9yOhNbzyA==
X-Received: by 2002:a17:902:e547:b0:13e:564c:bf4d with SMTP id n7-20020a170902e54700b0013e564cbf4dmr18077254plf.5.1633256334438;
        Sun, 03 Oct 2021 03:18:54 -0700 (PDT)
Received: from integral.. ([182.2.36.212])
        by smtp.gmail.com with ESMTPSA id d9sm10677290pgn.64.2021.10.03.03.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 03:18:54 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v4 RFC liburing 1/3] src/syscall: Wrap `errno` for `__sys_io_uring_{register,setup,enter{2,}}`
Date:   Sun,  3 Oct 2021 17:17:48 +0700
Message-Id: <20211003101750.156218-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211003101750.156218-1-ammar.faizi@students.amikom.ac.id>
References: <20211003101750.156218-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make it possible to remove the dependency of `errno` variable (which
comes from libc).

Currently, we expose these functions to userland:
  1) `__sys_io_uring_register`
  2) `__sys_io_uring_setup`
  3) `__sys_io_uring_enter2`
  4) `__sys_io_uring_enter`

The tests in `test/io_uring_{enter,register,setup}.c` are the examples
of it. Since the userland needs to check the `errno` value to use them
properly, this means those functions always depend on libc. So we
cannot change their behavior. Don't touch them all, this ensures the
changes only affect liburing internal and no visible functionality
changes for the users.

Then we introduce new functions with the same name (with extra
underscore as prefix, 4 underscores):
  1) `____sys_io_uring_register`
  2) `____sys_io_uring_setup`
  3) `____sys_io_uring_enter2`
  4) `____sys_io_uring_enter`

These functions do not use `errno` variable *on the caller*, they use
the kernel style return value (return a negative value of error code
when errors).

These functions are defined as `static inline` in `src/syscall.h`.
They are just a wrapper to make sure liburing internal sources do not
touch `errno` variable from C files directly. We need to make C files
not to touch the `errno` variable to support build without libc.

Link: https://github.com/axboe/liburing/issues/443#issuecomment-927873932
Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Suggested-by: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/syscall.c | 43 +++------------------------
 src/syscall.h | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 39 deletions(-)

diff --git a/src/syscall.c b/src/syscall.c
index 69027e5..5923fbb 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -11,41 +11,6 @@
 #include "liburing/io_uring.h"
 #include "syscall.h"
 
-#ifdef __alpha__
-/*
- * alpha and mips are exception, other architectures have
- * common numbers for new system calls.
- */
-# ifndef __NR_io_uring_setup
-#  define __NR_io_uring_setup		535
-# endif
-# ifndef __NR_io_uring_enter
-#  define __NR_io_uring_enter		536
-# endif
-# ifndef __NR_io_uring_register
-#  define __NR_io_uring_register	537
-# endif
-#elif defined __mips__
-# ifndef __NR_io_uring_setup
-#  define __NR_io_uring_setup           (__NR_Linux + 425)
-# endif
-# ifndef __NR_io_uring_enter
-#  define __NR_io_uring_enter           (__NR_Linux + 426)
-# endif
-# ifndef __NR_io_uring_register
-#  define __NR_io_uring_register        (__NR_Linux + 427)
-# endif
-#else /* !__alpha__ and !__mips__ */
-# ifndef __NR_io_uring_setup
-#  define __NR_io_uring_setup		425
-# endif
-# ifndef __NR_io_uring_enter
-#  define __NR_io_uring_enter		426
-# endif
-# ifndef __NR_io_uring_register
-#  define __NR_io_uring_register	427
-# endif
-#endif
 
 int __sys_io_uring_register(int fd, unsigned opcode, const void *arg,
 			    unsigned nr_args)
@@ -59,15 +24,15 @@ int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p)
 }
 
 int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
-			 unsigned flags, sigset_t *sig, int sz)
+			  unsigned flags, sigset_t *sig, int sz)
 {
-	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
-			flags, sig, sz);
+	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags,
+		       sig, sz);
 }
 
 int __sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
 			 unsigned flags, sigset_t *sig)
 {
 	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
-					_NSIG / 8);
+				     _NSIG / 8);
 }
diff --git a/src/syscall.h b/src/syscall.h
index 2368f83..f7f63aa 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -2,7 +2,49 @@
 #ifndef LIBURING_SYSCALL_H
 #define LIBURING_SYSCALL_H
 
+#include <errno.h>
 #include <signal.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/resource.h>
+
+#ifdef __alpha__
+/*
+ * alpha and mips are exception, other architectures have
+ * common numbers for new system calls.
+ */
+# ifndef __NR_io_uring_setup
+#  define __NR_io_uring_setup		535
+# endif
+# ifndef __NR_io_uring_enter
+#  define __NR_io_uring_enter		536
+# endif
+# ifndef __NR_io_uring_register
+#  define __NR_io_uring_register	537
+# endif
+#elif defined __mips__
+# ifndef __NR_io_uring_setup
+#  define __NR_io_uring_setup           (__NR_Linux + 425)
+# endif
+# ifndef __NR_io_uring_enter
+#  define __NR_io_uring_enter           (__NR_Linux + 426)
+# endif
+# ifndef __NR_io_uring_register
+#  define __NR_io_uring_register        (__NR_Linux + 427)
+# endif
+#else /* !__alpha__ and !__mips__ */
+# ifndef __NR_io_uring_setup
+#  define __NR_io_uring_setup		425
+# endif
+# ifndef __NR_io_uring_enter
+#  define __NR_io_uring_enter		426
+# endif
+# ifndef __NR_io_uring_register
+#  define __NR_io_uring_register	427
+# endif
+#endif
+
 
 struct io_uring_params;
 
@@ -17,4 +59,43 @@ int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
 int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
 			    unsigned int nr_args);
 
+
+
+static inline int ____sys_io_uring_register(int fd, unsigned opcode,
+					    const void *arg, unsigned nr_args)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int ____sys_io_uring_setup(unsigned entries,
+					 struct io_uring_params *p)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_setup, entries, p);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
+					  unsigned min_complete, unsigned flags,
+					  sigset_t *sig, int sz)
+{
+	int ret;
+
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
 #endif
-- 
2.30.2

