Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3B641F941
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 03:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhJBByg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 21:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbhJBByf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 21:54:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11F9C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 18:52:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so4185746pjb.1
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 18:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BK/ehZcFRww1Et3VMJVNkS7TLDe/BX4oXp9kvVBZLtk=;
        b=TQ+r/JRn71joKnoEVNDbFIM1VtKTWd40vR93GL4VVSeI/EwrsiF7jMIEEYgew/C3Tf
         UWptZ/LKk2AN9zsKt6m5ANudwvMquiq9j4T+5bWgzGRZNagavNQCihX7/4p+YgVR3rlU
         Env2KSmo5ziTl5ykfKA1OOQctgtOG2GL7fer8I1aFcbNhd24V+ufl0uG9qXZfn+jblfr
         dd7aiwGgBBwB5Wix7IoV9NrFqK2ySxaVR+H8GWFRBwBICemX/tl0msBqSLxRfXub0Frc
         Tr/6vTZ16YkuHAVrXCJIgmjhIN282nSbjP0JuofSGK68GbAqddIf8iYSBGvk1VzVCceQ
         rxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BK/ehZcFRww1Et3VMJVNkS7TLDe/BX4oXp9kvVBZLtk=;
        b=ip2IlLRI23pB7h/TGEz1IoSUXJFiMeA7l7Y7clahzB/t299mKRIjyB5kCsyWX6CQ5l
         taCP4tGVzP/MAi8YQ7yVYolmwRVIS65UtYubAPK99+teBgYxfAy9bnBx3t7drKMh4qK4
         UeVzHlQF3HXe4n/OA7WwGtvSYAnOFUiIqoSncDU0TkZz3xLt7tGe3FHydePaxXvO02Iu
         D5j3/yPN3OhHeOoK1stdP4HHG1FcmdL9BxpQSN28+EIhYwS6pQ6FyWlaRSOoJVJl2VzU
         MrVNcGjPLH9i7+wzbSisnxDkvvbIOMvMDaDCf+E9WsKCAqY/rKRNZBixr775XUdlGo9T
         JLHA==
X-Gm-Message-State: AOAM531Etj/Sm7R0BFY72fBzY2pEQt/LAJ14b/b1fK1YeBOWTiOkpYKQ
        RJeeXg9iBYWkw+NR88Dg1pePU3fhUO1aUnNpf+g=
X-Google-Smtp-Source: ABdhPJwpUFP+jS2QcWq6xKjIjLGKi1eWVzSnxLVHUSuYpaR4go1Tk2Q8/nKOJQbE2aVNS3cjHwmJIQ==
X-Received: by 2002:a17:902:b218:b029:11a:bf7b:1a80 with SMTP id t24-20020a170902b218b029011abf7b1a80mr13563585plr.82.1633139570422;
        Fri, 01 Oct 2021 18:52:50 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id u4sm6989804pfn.190.2021.10.01.18.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:52:50 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v3 RFC liburing 1/4] src/syscall: Implement the kernel style return value
Date:   Sat,  2 Oct 2021 08:48:26 +0700
Message-Id: <20211002014829.109096-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
References: <20211002014829.109096-1-ammar.faizi@students.amikom.ac.id>
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
cannot change their behavior. This ensures the changes only affect
liburing internal and no visible functionality changes for the users.

Then we introduce new functions with the same name (with extra
underscore as prefix, 4 underscores):
  1) `____sys_io_uring_register`
  2) `____sys_io_uring_setup`
  3) `____sys_io_uring_enter2`
  4) `____sys_io_uring_enter`

These functions do not use `errno` variable *on the caller*, they use
the kernel style return value (return a negative value of error code
when errors).

These functions are defined as `inline static` in `src/syscall.h`.
They are just a wrapper to make sure liburing internal sources do not
touch `errno` variable from C files directly.

Link: https://github.com/axboe/liburing/issues/443#issuecomment-927873932
Cc: Bedirhan KURT <windowz414@gnuweeb.org>
Suggested-by: Louvian Lyndal <louvianlyndal@gmail.com>
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 src/syscall.c | 36 ----------------------
 src/syscall.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 36 deletions(-)

diff --git a/src/syscall.c b/src/syscall.c
index 69027e5..221f0f1 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -5,47 +5,11 @@
  * Will go away once libc support is there
  */
 #include <unistd.h>
-#include <sys/syscall.h>
 #include <sys/uio.h>
 #include "liburing/compat.h"
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
diff --git a/src/syscall.h b/src/syscall.h
index 2368f83..5f7343f 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -2,7 +2,47 @@
 #ifndef LIBURING_SYSCALL_H
 #define LIBURING_SYSCALL_H
 
+#include <errno.h>
 #include <signal.h>
+#include <unistd.h>
+#include <sys/syscall.h>
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
 
@@ -17,4 +57,46 @@ int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
 int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
 			    unsigned int nr_args);
 
+
+
+/*
+ * Syscall with kernel style return value.
+ */
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
+	ret = syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
+		      flags, sig, sz);
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

