Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E45179759
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgCDSAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:00:23 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:41756 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgCDSAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:00:23 -0500
Received: by mail-il1-f194.google.com with SMTP id q13so2583004ile.8
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OQANzf4AsJHIArl7XwS5BVPEqWhfqBGF/4glLUl4VS8=;
        b=YoesxpaiJ5S6C7t+JTcjTwtEHxTuTkpnKDhp0rZc2ozqxPU4HBcHTd1COqHArUGjrA
         7lGer79IWcZnhhcxo8DCBDhi38VUfoqy8vVsztsCBAQpvR6BC/Kg+CPHVq0iVo5VECfP
         CEiQeuyx1RDnko0Y1PPEaXQ21U90X9Z9f+w0bFsqso0u4JALXHld4naXRVudfzGPq2t4
         F1mELCPKSBoc3y1/gCZe28dzvq4lHV0wOYYu+gwvQryBwKldTU2mr5qX5ydqw6clxjw/
         XKbA39GChvovS5SKmkZb4gwuFJFAoknQg98B8Dva25GYCsyi/rO6MkPjcepoLVr3lTY9
         3Qkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OQANzf4AsJHIArl7XwS5BVPEqWhfqBGF/4glLUl4VS8=;
        b=brPPwPQeLlbTM9c205XrzYqnTjW1Jo3Z0RWsl+O6L9f33QIZGpG3qllfDyu9iie3ld
         +iYzsTadBvGFGxx+md31FhLAG+PrCyhLPWt5aM0LbtGAyNzE1MqDk8K19yUV7gCkStP+
         lFgSRMEkVRq8/8+s6f2A1gHEe9rN+zySLg3zn6xl89a4gx7cQGteqQCQxGojKYL/m00K
         e/C29EqiXgEbnj/7+0ZGUPBvPEhpW0vgPiuwvc6lMuSWEmCryHKcp6qgSDCLGT6QSaJl
         wcrFfIBki5so67zMnzSRz9/H3826+sy049FPK+/QdUhgVWPIuHx1jGypxA/Xk762jtpQ
         ptRQ==
X-Gm-Message-State: ANhLgQ0ZmYiBLbPwskj38Vyv5AuxWys2V81kQCoVYfqloq39ZvI6dr2D
        s4RTu2p5klSDQV3SWJP/j3YBLUWnDhc=
X-Google-Smtp-Source: ADFU+vue856cjA7LUwHVEUDVD0rsjOpB+UNEBVGislg6h/SQJJ0/4hdryJ4j0j76j8RHih6rV5mMAA==
X-Received: by 2002:a92:d691:: with SMTP id p17mr3883849iln.273.1583344820358;
        Wed, 04 Mar 2020 10:00:20 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p23sm6715187ioo.54.2020.03.04.10.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:00:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, josh@joshtriplett.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] fs: openat2: Extend open_how to allow userspace-selected fds
Date:   Wed,  4 Mar 2020 11:00:11 -0700
Message-Id: <20200304180016.28212-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304180016.28212-1-axboe@kernel.dk>
References: <20200304180016.28212-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

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
        struct open_how how = { .flags = O_RDONLY | O_SPECIFIC_FD, .fd = 42 };
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
 fs/file.c                        | 33 ++++++++++++++++++++++++++++++++
 fs/io_uring.c                    |  2 +-
 fs/open.c                        |  6 ++++--
 include/linux/fcntl.h            |  5 +++--
 include/linux/file.h             |  1 +
 include/uapi/asm-generic/fcntl.h |  4 ++++
 include/uapi/linux/openat2.h     |  2 ++
 8 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 9bc167562ee8..1396bf8d9357 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1031,7 +1031,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ !=
 		HWEIGHT32(
 			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
 			__FMODE_EXEC | __FMODE_NONOTIFY));
diff --git a/fs/file.c b/fs/file.c
index a364e1a9b7e8..1986d82fcf8f 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -564,6 +564,39 @@ void put_unused_fd(unsigned int fd)
 
 EXPORT_SYMBOL(put_unused_fd);
 
+int get_specific_unused_fd_flags(unsigned int fd, unsigned flags)
+{
+	int ret;
+	struct fdtable *fdt;
+	struct files_struct *files = current->files;
+
+	if (!(flags & O_SPECIFIC_FD) || fd == -1)
+		return get_unused_fd_flags(flags);
+
+	if (fd >= rlimit(RLIMIT_NOFILE))
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
 /*
  * Install a file pointer in the fd array.
  *
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6b32f45d3612..0fcd6968cf0f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2962,7 +2962,7 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	if (ret)
 		goto err;
 
-	ret = get_unused_fd_flags(req->open.how.flags);
+	ret = get_specific_unused_fd_flags(req->open.how.fd, req->open.how.flags);
 	if (ret < 0)
 		goto err;
 
diff --git a/fs/open.c b/fs/open.c
index 0788b3715731..570166eb11eb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -961,7 +961,7 @@ EXPORT_SYMBOL(open_with_fake_path);
 inline struct open_how build_open_how(int flags, umode_t mode)
 {
 	struct open_how how = {
-		.flags = flags & VALID_OPEN_FLAGS,
+		.flags = flags & VALID_OPEN_FLAGS & ~O_SPECIFIC_FD,
 		.mode = mode & S_IALLUGO,
 	};
 
@@ -1144,7 +1144,7 @@ static long do_sys_openat2(int dfd, const char __user *filename,
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
 
-	fd = get_unused_fd_flags(how->flags);
+	fd = get_specific_unused_fd_flags(how->fd, how->flags);
 	if (fd >= 0) {
 		struct file *f = do_filp_open(dfd, tmp, &op);
 		if (IS_ERR(f)) {
@@ -1194,6 +1194,8 @@ SYSCALL_DEFINE4(openat2, int, dfd, const char __user *, filename,
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
index c6c7b24ea9f7..2bf699b36506 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -87,6 +87,7 @@ extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
 extern int get_unused_fd_flags(unsigned flags);
 extern void put_unused_fd(unsigned int fd);
+extern int get_specific_unused_fd_flags(unsigned int fd, unsigned flags);
 
 extern void fd_install(unsigned int fd, struct file *file);
 
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
2.25.1

