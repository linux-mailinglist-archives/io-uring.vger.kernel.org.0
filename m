Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8383179261
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 15:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCDOgK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 09:36:10 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41293 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDOgK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 09:36:10 -0500
X-Originating-IP: 50.39.173.182
Received: from localhost (50-39-173-182.bvtn.or.frontiernet.net [50.39.173.182])
        (Authenticated sender: josh@joshtriplett.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 02A4760002;
        Wed,  4 Mar 2020 14:36:07 +0000 (UTC)
Date:   Wed, 4 Mar 2020 06:36:05 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] fs: Support setting a minimum fd for "lowest available
 fd" allocation
Message-ID: <20200304143605.GA407707@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some applications want to prevent the usual "lowest available fd"
allocation from allocating certain file descriptors. For instance, they
may want to prevent allocation of a closed fd 0, 1, or 2 other than via
dup2/dup3, or reserve some low file descriptors for other purposes.

System calls that allocate a specific file descriptor, such as
dup2/dup3, ignore this minimum.

exec resets the minimum fd, to prevent one program from interfering with
another program's expectations about fd allocation.

Test program:

    #include <err.h>
    #include <fcntl.h>
    #include <stdio.h>
    #include <sys/prctl.h>

    int main(int argc, char *argv[])
    {
        if (prctl(PR_SET_MIN_FD, 100, 0, 0, 0) < 0)
            err(1, "prctl");
        int fd = open("/dev/null", O_RDONLY);
        if (fd < 0)
            err(1, "open");
        printf("%d\n", fd); // prints 100
        return 0;
    }

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/file.c                  | 29 +++++++++++++++++++++++------
 include/linux/fdtable.h    |  1 +
 include/linux/file.h       |  2 ++
 include/uapi/linux/prctl.h |  4 ++++
 kernel/sys.c               | 10 ++++++++++
 5 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index a364e1a9b7e8..1b79d4ddedb2 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -286,7 +286,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	spin_lock_init(&newf->file_lock);
 	newf->resize_in_progress = false;
 	init_waitqueue_head(&newf->resize_wait);
-	newf->next_fd = 0;
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
 	new_fdt->close_on_exec = newf->close_on_exec_init;
@@ -295,6 +294,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt->fd = &newf->fd_array[0];
 
 	spin_lock(&oldf->file_lock);
+	newf->next_fd = newf->min_fd = oldf->min_fd;
 	old_fdt = files_fdtable(oldf);
 	open_files = count_open_files(old_fdt);
 
@@ -487,9 +487,7 @@ int __alloc_fd(struct files_struct *files,
 	spin_lock(&files->file_lock);
 repeat:
 	fdt = files_fdtable(files);
-	fd = start;
-	if (fd < files->next_fd)
-		fd = files->next_fd;
+	fd = max3(start, files->min_fd, files->next_fd);
 
 	if (fd < fdt->max_fds)
 		fd = find_next_fd(fdt, fd);
@@ -514,7 +512,7 @@ int __alloc_fd(struct files_struct *files,
 		goto repeat;
 
 	if (start <= files->next_fd)
-		files->next_fd = fd + 1;
+		files->next_fd = max(fd + 1, files->min_fd);
 
 	__set_open_fd(fd, fdt);
 	if (flags & O_CLOEXEC)
@@ -550,7 +548,7 @@ static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = files_fdtable(files);
 	__clear_open_fd(fd, fdt);
-	if (fd < files->next_fd)
+	if (fd < files->next_fd && fd >= files->min_fd)
 		files->next_fd = fd;
 }
 
@@ -679,6 +677,7 @@ void do_close_on_exec(struct files_struct *files)
 
 	/* exec unshares first */
 	spin_lock(&files->file_lock);
+	files->min_fd = 0;
 	for (i = 0; ; i++) {
 		unsigned long set;
 		unsigned fd = i * BITS_PER_LONG;
@@ -860,6 +859,24 @@ bool get_close_on_exec(unsigned int fd)
 	return res;
 }
 
+void set_min_fd(unsigned int min_fd)
+{
+	struct files_struct *files = current->files;
+	spin_lock(&files->file_lock);
+	files->min_fd = min_fd;
+	spin_unlock(&files->file_lock);
+}
+
+unsigned int get_min_fd(void)
+{
+	struct files_struct *files = current->files;
+	unsigned int min_fd;
+	spin_lock(&files->file_lock);
+	min_fd = files->min_fd;
+	spin_unlock(&files->file_lock);
+	return min_fd;
+}
+
 static int do_dup2(struct files_struct *files,
 	struct file *file, unsigned fd, unsigned flags)
 __releases(&files->file_lock)
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index f07c55ea0c22..d1980443d8b3 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -60,6 +60,7 @@ struct files_struct {
    */
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
 	unsigned int next_fd;
+	unsigned int min_fd; /* min for "lowest available fd" allocation */
 	unsigned long close_on_exec_init[1];
 	unsigned long open_fds_init[1];
 	unsigned long full_fds_bits_init[1];
diff --git a/include/linux/file.h b/include/linux/file.h
index c6c7b24ea9f7..358202f5951e 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -85,6 +85,8 @@ extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
 extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
+extern void set_min_fd(unsigned int min_fd);
+extern unsigned int get_min_fd(void);
 extern int get_unused_fd_flags(unsigned flags);
 extern void put_unused_fd(unsigned int fd);
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 07b4f8131e36..d0a9ebf46872 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -238,4 +238,8 @@ struct prctl_mm_map {
 #define PR_SET_IO_FLUSHER		57
 #define PR_GET_IO_FLUSHER		58
 
+/* Minimum file descriptor for automatic "lowest available fd" allocation */
+#define PR_SET_MIN_FD			59
+#define PR_GET_MIN_FD			60
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index f9bc5c303e3f..5ab301e97218 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2513,6 +2513,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 
 		error = (current->flags & PR_IO_FLUSHER) == PR_IO_FLUSHER;
 		break;
+	case PR_SET_MIN_FD:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		set_min_fd((int)arg2);
+		break;
+	case PR_GET_MIN_FD:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = put_user(get_min_fd(), (int __user *)arg2);
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
2.25.1

