Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739AC1B36CA
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 07:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgDVFUM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 01:20:12 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:36779 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVFUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 01:20:11 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id CE2DFC0008;
        Wed, 22 Apr 2020 05:20:05 +0000 (UTC)
Date:   Tue, 21 Apr 2020 22:20:03 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-man@vger.kernel.org
Subject: [PATCH v5 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
Message-ID: <9873b8bd7d14ff8cd2a5782b434b39f076679eeb.1587531463.git.josh@joshtriplett.org>
References: <cover.1587531463.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1587531463.git.josh@joshtriplett.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inspired by the X protocol's handling of XIDs, allow userspace to select
the file descriptor opened by openat2, so that it can use the resulting
file descriptor in subsequent system calls without waiting for the
response to openat2.

In io_uring, this allows sequences like openat2/read/close without
waiting for the openat2 to complete. Multiple such sequences can
overlap, as long as each uses a distinct file descriptor.

Add a new O_SPECIFIC_FD open flag to enable this behavior, only accepted
by openat2 for now (ignored by open/openat like all unknown flags). Add
an fd field to struct open_how (along with appropriate padding, and
verify that the padding is 0 to allow replacing the padding with a field
in the future).

The file table has a corresponding new function
get_specific_unused_fd_flags, which gets the specified file descriptor
if O_SPECIFIC_FD is set (and the fd isn't -1); otherwise it falls back
to get_unused_fd_flags, to simplify callers.

The specified file descriptor must not already be open; if it is,
get_specific_unused_fd_flags will fail with -EBUSY. This helps catch
userspace errors.

When O_SPECIFIC_FD is set, and fd is not -1, openat2 will use the
specified file descriptor rather than finding the lowest available one.

Test program:

    #include <err.h>
    #include <fcntl.h>
    #include <stdio.h>
    #include <unistd.h>

    int main(void)
    {
        struct open_how how = {
	    .flags = O_RDONLY | O_SPECIFIC_FD,
	    .fd = 42
	};
        int fd = openat2(AT_FDCWD, "/dev/null", &how, sizeof(how));
        if (fd < 0)
            err(1, "openat2");
        printf("fd=%d\n", fd); // prints fd=42
        return 0;
    }

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/fcntl.c                                    |  2 +-
 fs/file.c                                     | 39 +++++++++++++++++++
 fs/io_uring.c                                 |  3 +-
 fs/open.c                                     |  8 +++-
 include/linux/fcntl.h                         |  5 ++-
 include/linux/file.h                          |  3 ++
 include/uapi/asm-generic/fcntl.h              |  4 ++
 include/uapi/linux/openat2.h                  |  3 ++
 tools/testing/selftests/openat2/helpers.c     |  2 +-
 tools/testing/selftests/openat2/helpers.h     | 21 +++++++---
 .../testing/selftests/openat2/openat2_test.c  | 35 ++++++++++++++++-
 11 files changed, 111 insertions(+), 14 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 2e4c0fa2074b..0357ad667563 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1033,7 +1033,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ !=
 		HWEIGHT32(
 			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
 			__FMODE_EXEC | __FMODE_NONOTIFY));
diff --git a/fs/file.c b/fs/file.c
index ba06140d89af..0674c3a2d3a5 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -567,6 +567,45 @@ void put_unused_fd(unsigned int fd)
 
 EXPORT_SYMBOL(put_unused_fd);
 
+int __get_specific_unused_fd_flags(unsigned int fd, unsigned int flags,
+				   unsigned long nofile)
+{
+	int ret;
+	struct fdtable *fdt;
+	struct files_struct *files = current->files;
+
+	if (!(flags & O_SPECIFIC_FD) || fd == UINT_MAX)
+		return __get_unused_fd_flags(flags, nofile);
+
+	if (fd >= nofile)
+		return -EBADF;
+
+	spin_lock(&files->file_lock);
+	ret = expand_files(files, fd);
+	if (unlikely(ret < 0))
+		goto out_unlock;
+	fdt = files_fdtable(files);
+	if (fdt->fd[fd]) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+	__set_open_fd(fd, fdt);
+	if (flags & O_CLOEXEC)
+		__set_close_on_exec(fd, fdt);
+	else
+		__clear_close_on_exec(fd, fdt);
+	ret = fd;
+
+out_unlock:
+	spin_unlock(&files->file_lock);
+	return ret;
+}
+
+int get_specific_unused_fd_flags(unsigned int fd, unsigned int flags)
+{
+	return __get_specific_unused_fd_flags(fd, flags, rlimit(RLIMIT_NOFILE));
+}
+
 /*
  * Install a file pointer in the fd array.
  *
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 358f97be9c7b..4a69e1daf3fe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2997,7 +2997,8 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	if (ret)
 		goto err;
 
-	ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
+	ret = __get_specific_unused_fd_flags(req->open.how.fd,
+			req->open.how.flags, req->open.nofile);
 	if (ret < 0)
 		goto err;
 
diff --git a/fs/open.c b/fs/open.c
index 719b320ede52..54b2782dfa7a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -962,6 +962,8 @@ inline struct open_how build_open_how(int flags, umode_t mode)
 		.mode = mode & S_IALLUGO,
 	};
 
+	/* O_SPECIFIC_FD doesn't work in open calls that use build_open_how. */
+	how.flags &= ~O_SPECIFIC_FD;
 	/* O_PATH beats everything else. */
 	if (how.flags & O_PATH)
 		how.flags &= O_PATH_FLAGS;
@@ -989,6 +991,10 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
 		return -EINVAL;
 	if (how->resolve & ~VALID_RESOLVE_FLAGS)
 		return -EINVAL;
+	if (how->__padding != 0)
+		return -EINVAL;
+	if (!(flags & O_SPECIFIC_FD) && how->fd != 0)
+		return -EINVAL;
 
 	/* Deal with the mode. */
 	if (WILL_CREATE(flags)) {
@@ -1143,7 +1149,7 @@ static long do_sys_openat2(int dfd, const char __user *filename,
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
 
-	fd = get_unused_fd_flags(how->flags);
+	fd = get_specific_unused_fd_flags(how->fd, how->flags);
 	if (fd >= 0) {
 		struct file *f = do_filp_open(dfd, tmp, &op);
 		if (IS_ERR(f)) {
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 7bcdcf4f6ab2..728849bcd8fa 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -10,7 +10,7 @@
 	(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | \
 	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
-	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
+	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_SPECIFIC_FD)
 
 /* List of all valid flags for the how->upgrade_mask argument: */
 #define VALID_UPGRADE_FLAGS \
@@ -23,7 +23,8 @@
 
 /* List of all open_how "versions". */
 #define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
-#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0
+#define OPEN_HOW_SIZE_VER1	32 /* added fd and pad */
+#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER1
 
 #ifndef force_o_largefile
 #define force_o_largefile() (!IS_ENABLED(CONFIG_ARCH_32BIT_OFF_T))
diff --git a/include/linux/file.h b/include/linux/file.h
index b67986f818d2..a63301864a36 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -87,6 +87,9 @@ extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
 extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
 extern int get_unused_fd_flags(unsigned flags);
+extern int __get_specific_unused_fd_flags(unsigned int fd, unsigned int flags,
+	unsigned long nofile);
+extern int get_specific_unused_fd_flags(unsigned int fd, unsigned int flags);
 extern void put_unused_fd(unsigned int fd);
 extern unsigned int increase_min_fd(unsigned int num);
 
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 9dc0bf0c5a6e..d3de5b8b3955 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -89,6 +89,10 @@
 #define __O_TMPFILE	020000000
 #endif
 
+#ifndef O_SPECIFIC_FD
+#define O_SPECIFIC_FD	01000000000	/* open as specified fd */
+#endif
+
 /* a horrid kludge trying to make sure that this will fail on old kernels */
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)      
diff --git a/include/uapi/linux/openat2.h b/include/uapi/linux/openat2.h
index 58b1eb711360..dcbf9dc333b5 100644
--- a/include/uapi/linux/openat2.h
+++ b/include/uapi/linux/openat2.h
@@ -15,11 +15,14 @@
  * @flags: O_* flags.
  * @mode: O_CREAT/O_TMPFILE file mode.
  * @resolve: RESOLVE_* flags.
+ * @fd: Specific file descriptor to use, for O_SPECIFIC_FD.
  */
 struct open_how {
 	__u64 flags;
 	__u64 mode;
 	__u64 resolve;
+	__u32 fd;
+	__u32 __padding; /* Must be zeroed */
 };
 
 /* how->resolve flags for openat2(2). */
diff --git a/tools/testing/selftests/openat2/helpers.c b/tools/testing/selftests/openat2/helpers.c
index 5074681ffdc9..b6533f0b1124 100644
--- a/tools/testing/selftests/openat2/helpers.c
+++ b/tools/testing/selftests/openat2/helpers.c
@@ -98,7 +98,7 @@ void __attribute__((constructor)) init(void)
 	struct open_how how = {};
 	int fd;
 
-	BUILD_BUG_ON(sizeof(struct open_how) != OPEN_HOW_SIZE_VER0);
+	BUILD_BUG_ON(sizeof(struct open_how) != OPEN_HOW_SIZE_VER1);
 
 	/* Check openat2(2) support. */
 	fd = sys_openat2(AT_FDCWD, ".", &how);
diff --git a/tools/testing/selftests/openat2/helpers.h b/tools/testing/selftests/openat2/helpers.h
index a6ea27344db2..d38818033b45 100644
--- a/tools/testing/selftests/openat2/helpers.h
+++ b/tools/testing/selftests/openat2/helpers.h
@@ -24,28 +24,37 @@
 #endif /* SYS_openat2 */
 
 /*
- * Arguments for how openat2(2) should open the target path. If @resolve is
- * zero, then openat2(2) operates very similarly to openat(2).
+ * Arguments for how openat2(2) should open the target path. If only @flags and
+ * @mode are non-zero, then openat2(2) operates very similarly to openat(2).
  *
- * However, unlike openat(2), unknown bits in @flags result in -EINVAL rather
- * than being silently ignored. @mode must be zero unless one of {O_CREAT,
- * O_TMPFILE} are set.
+ * However, unlike openat(2), unknown or invalid bits in @flags result in
+ * -EINVAL rather than being silently ignored. @mode must be zero unless one of
+ * {O_CREAT, O_TMPFILE} are set.
  *
  * @flags: O_* flags.
  * @mode: O_CREAT/O_TMPFILE file mode.
  * @resolve: RESOLVE_* flags.
+ * @fd: Specific file descriptor to use, for O_SPECIFIC_FD.
  */
 struct open_how {
 	__u64 flags;
 	__u64 mode;
 	__u64 resolve;
+	__u32 fd;
+	__u32 __padding; /* Must be zeroed */
 };
 
+/* List of all open_how "versions". */
 #define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
-#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0
+#define OPEN_HOW_SIZE_VER1	32 /* added fd and pad */
+#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER1
 
 bool needs_openat2(const struct open_how *how);
 
+#ifndef O_SPECIFIC_FD
+#define O_SPECIFIC_FD  01000000000
+#endif
+
 #ifndef RESOLVE_IN_ROOT
 /* how->resolve flags for openat2(2). */
 #define RESOLVE_NO_XDEV		0x01 /* Block mount-point crossings
diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index b386367c606b..f999b4bb0dc2 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -40,7 +40,7 @@ struct struct_test {
 	int err;
 };
 
-#define NUM_OPENAT2_STRUCT_TESTS 7
+#define NUM_OPENAT2_STRUCT_TESTS 8
 #define NUM_OPENAT2_STRUCT_VARIATIONS 13
 
 void test_openat2_struct(void)
@@ -52,6 +52,9 @@ void test_openat2_struct(void)
 		{ .name = "normal struct",
 		  .arg.inner.flags = O_RDONLY,
 		  .size = sizeof(struct open_how) },
+		{ .name = "v0 struct",
+		  .arg.inner.flags = O_RDONLY,
+		  .size = OPEN_HOW_SIZE_VER0 },
 		/* Bigger struct, with zeroed out end. */
 		{ .name = "bigger struct (zeroed out)",
 		  .arg.inner.flags = O_RDONLY,
@@ -155,7 +158,7 @@ struct flag_test {
 	int err;
 };
 
-#define NUM_OPENAT2_FLAG_TESTS 23
+#define NUM_OPENAT2_FLAG_TESTS 31
 
 void test_openat2_flags(void)
 {
@@ -223,6 +226,30 @@ void test_openat2_flags(void)
 		{ .name = "invalid how.resolve and O_PATH",
 		  .how.flags = O_PATH,
 		  .how.resolve = 0x1337, .err = -EINVAL },
+
+		/* O_SPECIFIC_FD tests */
+		{ .name = "O_SPECIFIC_FD",
+		  .how.flags = O_RDONLY | O_SPECIFIC_FD, .how.fd = 42 },
+		{ .name = "O_SPECIFIC_FD if fd exists",
+		  .how.flags = O_RDONLY | O_SPECIFIC_FD, .how.fd = 2,
+		  .err = -EBUSY },
+		{ .name = "O_SPECIFIC_FD with fd -1",
+		  .how.flags = O_RDONLY | O_SPECIFIC_FD, .how.fd = -1 },
+		{ .name = "fd without O_SPECIFIC_FD",
+		  .how.flags = O_RDONLY, .how.fd = 42,
+		  .err = -EINVAL },
+		{ .name = "fd -1 without O_SPECIFIC_FD",
+		  .how.flags = O_RDONLY, .how.fd = -1,
+		  .err = -EINVAL },
+		{ .name = "existing fd without O_SPECIFIC_FD",
+		  .how.flags = O_RDONLY, .how.fd = 2,
+		  .err = -EINVAL },
+		{ .name = "Non-zero padding with O_SPECIFIC_FD",
+		  .how.flags = O_RDONLY | O_SPECIFIC_FD, .how.fd = 42,
+		  .how.__padding = 42, .err = -EINVAL },
+		{ .name = "Non-zero padding without O_SPECIFIC_FD",
+		  .how.flags = O_RDONLY,
+		  .how.__padding = 42, .err = -EINVAL },
 	};
 
 	BUILD_BUG_ON(ARRAY_LEN(tests) != NUM_OPENAT2_FLAG_TESTS);
@@ -268,6 +295,10 @@ void test_openat2_flags(void)
 			if (!(test->how.flags & O_LARGEFILE))
 				fdflags &= ~O_LARGEFILE;
 			failed |= (fdflags != test->how.flags);
+
+			if (test->how.flags & O_SPECIFIC_FD
+			    && test->how.fd != -1)
+				failed |= (fd != test->how.fd);
 		}
 
 		if (failed) {
-- 
2.26.2

