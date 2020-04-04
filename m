Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0510E19E312
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2020 07:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgDDF6f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Apr 2020 01:58:35 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:51951 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgDDF6f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Apr 2020 01:58:35 -0400
Received: from localhost (50-39-173-183.bvtn.or.frontiernet.net [50.39.173.183])
        (Authenticated sender: josh@joshtriplett.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 03DB2200005;
        Sat,  4 Apr 2020 05:58:31 +0000 (UTC)
Date:   Fri, 3 Apr 2020 22:58:19 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
Message-ID: <e598110f71a4e2346860b94e91de3e6e75a4b82a.1585978979.git.josh@joshtriplett.org>
References: <cover.1585978979.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1585978979.git.josh@joshtriplett.org>
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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/fcntl.c                       |  2 +-
 fs/file.c                        | 39 ++++++++++++++++++++++++++++++++
 fs/io_uring.c                    |  3 ++-
 fs/open.c                        |  6 +++--
 include/linux/fcntl.h            |  5 ++--
 include/linux/file.h             |  3 +++
 include/uapi/asm-generic/fcntl.h |  4 ++++
 include/uapi/linux/openat2.h     |  2 ++
 8 files changed, 58 insertions(+), 6 deletions(-)

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
index ba06140d89af..0c34206314dc 100644
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
+	if (!(flags & O_SPECIFIC_FD) || fd == -1)
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
index 719b320ede52..d4225e6f9d4c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -958,7 +958,7 @@ EXPORT_SYMBOL(open_with_fake_path);
 inline struct open_how build_open_how(int flags, umode_t mode)
 {
 	struct open_how how = {
-		.flags = flags & VALID_OPEN_FLAGS,
+		.flags = flags & VALID_OPEN_FLAGS & ~O_SPECIFIC_FD,
 		.mode = mode & S_IALLUGO,
 	};
 
@@ -1143,7 +1143,7 @@ static long do_sys_openat2(int dfd, const char __user *filename,
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
 
-	fd = get_unused_fd_flags(how->flags);
+	fd = get_specific_unused_fd_flags(how->fd, how->flags);
 	if (fd >= 0) {
 		struct file *f = do_filp_open(dfd, tmp, &op);
 		if (IS_ERR(f)) {
@@ -1193,6 +1193,8 @@ SYSCALL_DEFINE4(openat2, int, dfd, const char __user *, filename,
 	err = copy_struct_from_user(&tmp, sizeof(tmp), how, usize);
 	if (err)
 		return err;
+	if (tmp.pad != 0)
+		return -EINVAL;
 
 	/* O_LARGEFILE is only allowed for non-O_PATH. */
 	if (!(tmp.flags & O_PATH) && force_o_largefile())
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
index 58b1eb711360..50d1206b64c2 100644
--- a/include/uapi/linux/openat2.h
+++ b/include/uapi/linux/openat2.h
@@ -20,6 +20,8 @@ struct open_how {
 	__u64 flags;
 	__u64 mode;
 	__u64 resolve;
+	__s32 fd;
+	__u32 pad; /* Must be 0 in the current version */
 };
 
 /* how->resolve flags for openat2(2). */
-- 
2.26.0

