Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA7C42024C
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 17:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhJCPhJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 11:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhJCPhI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 11:37:08 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79087C0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 08:35:20 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 66so13812029pgc.9
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 08:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MAweDbXCgivBLUGbVsmYI8Qi1lEAjMdbt3K/rExqIgg=;
        b=Dc/rqsFfckl8KcQL0INO3QByme59f+QKmuWTPh2StZeuzPTJr4ofE0aT7PpAKAsVFi
         lv2EpSxLxCjAqpnCSIlAN7SRD392JM4kuhSa+/Yc0XFdZpYUQK5tJlfpgra59BW2/xwv
         WhEyKeiL/PgrEJKFcp1OFmN5EsQodl2acI1XcSyUorwRA4tP2n1GHtOVcVbl2lBxridm
         ZP8dJ4TJ/s6LW8AIVXZbTIHXo7hbMSkddv0XAPDeCDiGsYN0CIF7wJihINxmEG47OSOU
         pjkvMaVesX5/lcdqw9pQlZmOBhYajtMPCr530L0/uvHea/tCY/k8ZLHYZeBwcCu8oUsg
         j25Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MAweDbXCgivBLUGbVsmYI8Qi1lEAjMdbt3K/rExqIgg=;
        b=yMRGOGM66pd9LUzvtoOTzKGo3vlp9tYJjOgYNctqsVK3AUVXabxALvCiJ9shFKgQPE
         dd/VFq/gGLUDFg0OCsmi6SVNcgi5BdL5lVxc6c4z1h6yBzJi0piVNNN8Zy44quCuXqBv
         VAokFrKyM+ghJ8gy2e3nW2nqW5CVhxyykiTuGBJ6/IYvz2fB7KMxY8NfOrczMJA6vVjo
         R5o/mLbgbjT3vwxKXsrIPCfAbxMRITyHXL2lAnfsJJLILSUuYWU5bK8Fwsf8/50RCfyF
         hnz+hgPI04HaaY8QgUi/MDpVe5ldMBq5xxOz52lV2GAsdlsHN5lbrAI2h4zJFzac4RWc
         9F5w==
X-Gm-Message-State: AOAM531s/Jm7zHxiFSHOGDkQ7r9GnLVDgpU5BXnLW9PgEBrNXuZyY7au
        TYGerSZveYS6LtPnLvJB0A9/BkHXuQODl9KU
X-Google-Smtp-Source: ABdhPJxqbS8wqMXPj7JbGkrnGg3Hyc/bIpC/byo2YrNIA5y/K6BYfyHwWPm+0+loWx0+jOebXYIc5g==
X-Received: by 2002:a63:9d4c:: with SMTP id i73mr6984129pgd.216.1633275319983;
        Sun, 03 Oct 2021 08:35:19 -0700 (PDT)
Received: from integral.. ([182.2.73.133])
        by smtp.gmail.com with ESMTPSA id y42sm2625075pfa.203.2021.10.03.08.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 08:35:19 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v5 liburing 1/3] src/syscall: Wrap `errno` for `__sys_io_uring_{register,setup,enter{2,}}`
Date:   Sun,  3 Oct 2021 22:34:26 +0700
Message-Id: <20211003153428.369258-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
References: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
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

