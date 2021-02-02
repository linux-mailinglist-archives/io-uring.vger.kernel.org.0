Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E27430B9D1
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 09:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhBBI0F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 03:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbhBBIZs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 03:25:48 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14471C06174A;
        Tue,  2 Feb 2021 00:25:07 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id p21so26699670lfu.11;
        Tue, 02 Feb 2021 00:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lFdu/ZokN33D/jhCZc3HT0HiT7qadN9okxjTgLv9qVs=;
        b=UVO5ZEkSSMEwsZ11MPl3c4coTIc4PhkWh4f+9Dyqccii8EuII2qfX295s2V7tzkEco
         0QYRo2GONAspiiM6WPGdcTPVUjX+CAassy66vuk/TeTUBafQSZJGF04vzmpKcwZ1nn2N
         3aTIaxsymzXx0fA3CgMUTP1mUwXhQZwDlQPcieXfmfkaghZ7y14NEJSkNoUJUwXAu5bW
         CEGZY4D8OqzC3sYJWnGqAavg3Z+Kj5SMAamK88BtDc9UWy+Z/6U92z2B9FElkRkbHY6+
         SjvLhmFMmr51LSGT31tOWAvuj/NRboMNBIuYGfPlZIpnnfkR8CxeiQzZCwpL69kAmBjH
         P4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lFdu/ZokN33D/jhCZc3HT0HiT7qadN9okxjTgLv9qVs=;
        b=e86OWLLVNgGuEhnzyxj++6fjV6+xrZtKEq2J7YyxzHyyM9POU7qatj6BOXYuYc+2rQ
         21pjAqqqAFX3/u/d6dEo/LAW8mGQaWDsBMlTAhFksKBciIIkJbpA6ObIaa+PA7ui9Yrg
         1jJsbhhOS5QDETvsIyXzB3LGw8WediM/DO5ewSxsZlDuD7Z2436eWffo+sWLp9fr40E/
         yJulRnX0G2nEjAY1RGVASJaVyIzXGfuuGNq8IgV+eBRVtAsZ/gR3gqR7fXiKc5S0K/+U
         siYp7YCiPZaLw2hhvSgbwpOkHxbuxIJCFNixfzN+5IY9aGOMgLRZeJbNRlQT9TKAdRz9
         DLvw==
X-Gm-Message-State: AOAM531WjryXFtufK/S3Ub/Rlr5630MPmBxDDqXXho/aJlMuw5aFHkO2
        JaOca3QMrdE44iuz0lwdKyo=
X-Google-Smtp-Source: ABdhPJz6Hk3zVrX0A4kRRBBZUQEkAGPe+te2e7VMrfjcDmq55GTh75XYDT+9bG98oOR24wNiIjZk9Q==
X-Received: by 2002:ac2:550c:: with SMTP id j12mr9900000lfk.619.1612254305619;
        Tue, 02 Feb 2021 00:25:05 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id t6sm4195857ljd.112.2021.02.02.00.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:25:05 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 1/2] fs: make do_mkdirat() take struct filename
Date:   Tue,  2 Feb 2021 15:23:52 +0700
Message-Id: <20210202082353.2152271-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202082353.2152271-1-dkadashev@gmail.com>
References: <20210202082353.2152271-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, and
update the three callers to do the same. This is heavily based on
commit dbea8d345177 ("fs: make do_renameat2() take struct filename").

This behaves like do_unlinkat() and do_renameat2().

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/internal.h |  1 +
 fs/namei.c    | 25 +++++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index c6c85f6ad598..b10005dfaa48 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -76,6 +76,7 @@ long do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
+long do_mkdirat(int dfd, struct filename *name, umode_t mode);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index 4cae88733a5c..3657bdf1aafc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3431,7 +3431,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-static struct dentry *filename_create(int dfd, struct filename *name,
+static struct dentry *__filename_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3487,7 +3487,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		error = err2;
 		goto fail;
 	}
-	putname(name);
 	return dentry;
 fail:
 	dput(dentry);
@@ -3502,6 +3501,16 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	return dentry;
 }
 
+static inline struct dentry *filename_create(int dfd, struct filename *name,
+				struct path *path, unsigned int lookup_flags)
+{
+	struct dentry *res = __filename_create(dfd, name, path, lookup_flags);
+
+	if (!IS_ERR(res))
+		putname(name);
+	return res;
+}
+
 struct dentry *kern_path_create(int dfd, const char *pathname,
 				struct path *path, unsigned int lookup_flags)
 {
@@ -3654,15 +3663,18 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
+long do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
+	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3676,17 +3688,18 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+	putname(name);
 	return error;
 }
 
 SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(dfd, pathname, mode);
+	return do_mkdirat(dfd, getname(pathname), mode);
 }
 
 SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 {
-	return do_mkdirat(AT_FDCWD, pathname, mode);
+	return do_mkdirat(AT_FDCWD, getname(pathname), mode);
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
-- 
2.30.0

