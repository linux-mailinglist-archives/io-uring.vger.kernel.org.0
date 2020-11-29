Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9662C76FD
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgK2Aut (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729997AbgK2Aus (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:48 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544B1C061A4B;
        Sat, 28 Nov 2020 16:50:10 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y7so7722010pfq.11;
        Sat, 28 Nov 2020 16:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5QXUDMJ+aPqSy8td8tfFhwAmuSfL9+BIWKOUS4q4alQ=;
        b=G3hsakiVpY40laKPeaMBGblNZ3/Zv13HPBuBXoETeShJXDPLMTOeJZRHHTOM18hfAV
         N5EsJJJs12sXwBIIe2t7dCzTW+0jG3qjq2wGugWW5WKWcHDvgW01N0sCRM6LBOLTIwwH
         VBlv4RABSeG4oSGot4PdjE5ECNCby9hztUDbPk4ssPY9yCyp5dzwW3NwvbnM2mft5MdO
         Mb43rvrz6Ve8DhFxto4GmSt8hJ/KQbbC59JO1agJ1H2kMYjIv10J4gKNyS3MVtId0NgG
         eBbpVBkcGEBLgK9KGZR1YnOpmLZkrKsOn2+d0S8p0WoOHwMH6ZgrrRvNyp3G1B07DNRc
         iSyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5QXUDMJ+aPqSy8td8tfFhwAmuSfL9+BIWKOUS4q4alQ=;
        b=iPx61xyKO5Pg2fPH5AtYEOrYmt0ajH9hLrsXxIUHger9F5EX0v70xahzmRHRAFAmax
         rR0JhFnKpPBgH3ldjRcuSX91HcxWlIZSPOmBjtwxZRqiSNNUAJEdZwdmbBRaIWCDvkAO
         kyt9Te8F2/QedlzpFWGPr7m3xZT8i1ioW8OUWVqG0WeVZuEFzMSpY09rJudj2lIzJmDc
         4pnMO4d19b+6E92kgQqVckCpsrEbrnU/B8id6RSrWPpL20bYmX/bwV+Zc8zVbH8GVdwr
         uNwjTFIXMHlE6XX2W3eQnz5qD4JH3WJvNuCM/nK1VJ/unFTomPmP5g7ETan658n11xA/
         bJPg==
X-Gm-Message-State: AOAM533pfgbnxBNPT4q+5tq3E/mq3S1EATuoyK5sRGFbhphuAcLHmlk/
        MZDwT5RP+ExeIOR7VEwpx+hoY7o5M8/UmQ==
X-Google-Smtp-Source: ABdhPJxVhJfV3O16FYglVnrkLi5gbMDPamTFnwrPU8EwzqqxD10/vPYsQAVmhLJ4S4ZOOIwGbmraeA==
X-Received: by 2002:a17:90a:6393:: with SMTP id f19mr18811358pjj.227.1606611009301;
        Sat, 28 Nov 2020 16:50:09 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:08 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 10/13] fs/userfaultfd: add write_iter() interface
Date:   Sat, 28 Nov 2020 16:45:45 -0800
Message-Id: <20201129004548.1619714-11-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

In order to use userfaultfd with io-uring, there are two options for
extensions: support userfaultfd ioctls or provide similar functionality
through the "write" interface. The latter approach seems more compelling
as it does not require io-uring changes, and keeps all the logic of
userfaultfd where it should be. In addition it allows to provide
asynchronous completions by performing the copying/zeroing in the
faulting thread (which will be done in a later patch).

This patch enhances the userfaultfd API to provide write interface to
perform similar operations for copy/zero. The lower bits of the position
(smaller than PAGE_SHIFT) are being used to encode the required
operation: zero/copy/wake/write-protect. In the case of zeroing, the
source data is ignored and only the length is being used to determine
the size of the data that needs to be zeroed.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c                 | 96 +++++++++++++++++++++++++++++++-
 include/uapi/linux/userfaultfd.h | 14 ++++-
 2 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 7bbee2a00d37..eae6ac303951 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1140,6 +1140,34 @@ static __poll_t userfaultfd_poll(struct file *file, poll_table *wait)
 
 static const struct file_operations userfaultfd_fops;
 
+/* Open-coded version of anon_inode_getfd() to setup FMODE_PWRITE */
+static int userfaultfd_getfd(const char *name, const struct file_operations *fops,
+		     void *priv, int flags)
+{
+	int error, fd;
+	struct file *file;
+
+	error = get_unused_fd_flags(flags);
+	if (error < 0)
+		return error;
+	fd = error;
+
+	file = anon_inode_getfile(name, fops, priv, flags);
+
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto err_put_unused_fd;
+	}
+	file->f_mode |= FMODE_PWRITE;
+	fd_install(fd, file);
+
+	return fd;
+
+err_put_unused_fd:
+	put_unused_fd(fd);
+	return error;
+}
+
 static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
 				  struct userfaultfd_ctx *new,
 				  struct uffd_msg *msg)
@@ -1161,7 +1189,7 @@ static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
 		task_unlock(current);
 	}
 
-	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, new,
+	fd = userfaultfd_getfd("[userfaultfd]", &userfaultfd_fops, new,
 			      O_RDWR | (new->flags & UFFD_SHARED_FCNTL_FLAGS));
 
 	if (files != NULL) {
@@ -1496,6 +1524,69 @@ static __always_inline int validate_range(struct mm_struct *mm,
 	return 0;
 }
 
+ssize_t userfaultfd_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct userfaultfd_wake_range range;
+	struct userfaultfd_ctx *ctx = file->private_data;
+	size_t len = iov_iter_count(from);
+	__u64 dst = iocb->ki_pos & PAGE_MASK;
+	unsigned long mode = iocb->ki_pos & ~PAGE_MASK;
+	bool zeropage;
+	__s64 ret;
+
+	BUG_ON(len == 0);
+
+	zeropage = mode & UFFDIO_WRITE_MODE_ZEROPAGE;
+
+	ret = -EINVAL;
+	if (mode & ~(UFFDIO_WRITE_MODE_DONTWAKE | UFFDIO_WRITE_MODE_WP |
+		     UFFDIO_WRITE_MODE_ZEROPAGE))
+		goto out;
+
+	mode = mode & (UFFDIO_WRITE_MODE_DONTWAKE | UFFDIO_WRITE_MODE_WP);
+
+	/*
+	 * Keep compatibility with zeropage ioctl, which does not allow
+	 * write-protect and dontwake.
+	 */
+	if (zeropage &&
+	    (mode & (UFFDIO_WRITE_MODE_DONTWAKE | UFFDIO_WRITE_MODE_WP)) ==
+	     (UFFDIO_WRITE_MODE_DONTWAKE | UFFDIO_WRITE_MODE_WP))
+		goto out;
+
+	ret = -EAGAIN;
+	if (READ_ONCE(ctx->mmap_changing))
+		goto out;
+
+	ret = validate_range(ctx->mm, &dst, len);
+	if (ret)
+		goto out;
+
+	if (mmget_not_zero(ctx->mm)) {
+		if (zeropage)
+			ret = mfill_zeropage(ctx->mm, dst, from,
+					     &ctx->mmap_changing);
+		else
+			ret = mcopy_atomic(ctx->mm, dst, from,
+					   &ctx->mmap_changing, mode);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+	if (ret < 0)
+		goto out;
+
+	/* len == 0 would wake all */
+	range.len = ret;
+	if (!(mode & UFFDIO_COPY_MODE_DONTWAKE)) {
+		range.start = dst;
+		wake_userfault(ctx, &range);
+	}
+out:
+	return ret;
+}
+
 static inline bool vma_can_userfault(struct vm_area_struct *vma,
 				     unsigned long vm_flags)
 {
@@ -2197,6 +2288,7 @@ static const struct file_operations userfaultfd_fops = {
 	.release	= userfaultfd_release,
 	.poll		= userfaultfd_poll,
 	.read_iter	= userfaultfd_read_iter,
+	.write_iter	= userfaultfd_write_iter,
 	.unlocked_ioctl = userfaultfd_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.llseek		= noop_llseek,
@@ -2248,7 +2340,7 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 
 	ctx->files = get_files_struct(current);
 
-	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, ctx,
+	fd = userfaultfd_getfd("[userfaultfd]", &userfaultfd_fops, ctx,
 			      O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (fd < 0) {
 		mmdrop(ctx->mm);
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 4eeba4235afe..943e50b41742 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -28,7 +28,8 @@
 			   UFFD_FEATURE_MISSING_SHMEM |		\
 			   UFFD_FEATURE_SIGBUS |		\
 			   UFFD_FEATURE_THREAD_ID |		\
-			   UFFD_FEATURE_POLL)
+			   UFFD_FEATURE_POLL |			\
+			   UFFD_FEATURE_WRITE)
 
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
@@ -177,6 +178,9 @@ struct uffdio_api {
 	 * UFFD_FEATURE_POLL polls upon page-fault if the feature is requested
 	 * instead of descheduling. This feature should only be enabled for
 	 * low-latency handlers and when CPUs are not overcomitted.
+	 *
+	 * UFFD_FEATURE_WRITE allows to use the write interface for copy and
+	 * zeroing of pages in addition to the ioctl interface.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -188,6 +192,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_SIGBUS			(1<<7)
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
 #define UFFD_FEATURE_POLL			(1<<9)
+#define UFFD_FEATURE_WRITE			(1<<10)
 	__u64 features;
 
 	__u64 ioctls;
@@ -264,4 +269,11 @@ struct uffdio_writeprotect {
 	__u64 mode;
 };
 
+/*
+ * Write modes to be use with UFFDIO_SET_WRITE_MODE ioctl.
+ */
+#define UFFDIO_WRITE_MODE_DONTWAKE		UFFDIO_COPY_MODE_DONTWAKE
+#define UFFDIO_WRITE_MODE_WP			UFFDIO_COPY_MODE_WP
+#define UFFDIO_WRITE_MODE_ZEROPAGE		((__u64)1<<2)
+
 #endif /* _LINUX_USERFAULTFD_H */
-- 
2.25.1

