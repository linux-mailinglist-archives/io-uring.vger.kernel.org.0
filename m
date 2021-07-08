Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FB53BF59C
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhGHGh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhGHGhz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:37:55 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74E4C06175F;
        Wed,  7 Jul 2021 23:35:13 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bu12so7675078ejb.0;
        Wed, 07 Jul 2021 23:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AVmhH06SyxapkboM9opDUcgHzjT4U95zTavxicpRMho=;
        b=AYncr8Sy8xfEpe8yQAiHsMwSyzZHYdGzamYEMucX441Y7NS7zBkXu1ssAOU8WnB6eY
         Q+fh7uwc7vEsr48sNB9JIQ+7Xn0S5kcCUOx20mOErokElKcCYHd2WiqWZkdZ7j+0St37
         AcgVngCnE2hDJJThgaQOYkduCROyRJNlkgF53HHXaidOOWxl8P+U+vomx3dhBhN6R4rU
         N1iPNo8dzisFIk42ZaGwUIGVjRrRBxWUiAsTOgyi7VtltgBGKK2OH7D95N29o36NquGi
         23tI/uGDAgrKgqtIevgd/dQZcWawnxYegcoDBPqDH/XvpTDgDZjdsZ3mfaq1Fex0zMY0
         7wOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AVmhH06SyxapkboM9opDUcgHzjT4U95zTavxicpRMho=;
        b=cGdxE/CIx5Hi+Dq6FmTK9fec19j1LP71J5mWiVGOY3CVsTOXoC64Ggq6dbM61WK1WD
         crYlxIBXm9/P0U1Jbtm9Q34GyCeBxfpknwwKlzmbz+0vQttnLUSxfsSBOrttlgdTE4za
         R0Z54NIi7SucVA1l7dUyWa+skGAjRXgmWuv7lElak9uPFZtW6XzT9NSFTuYWXkX6Ya3I
         knuC1IwxR21XAC8APW/9HIz7SN6Q3975w6deuDik3aeGAkT6AoUOidm8HiJTkvVlcrpj
         3HqK8kQOigBEElH13rlpWcP3+xWSVsVOWS8E63mN2vW646yvcJizglo9JOqrprIfdN1T
         4ySA==
X-Gm-Message-State: AOAM531vahHDunWwPsVPqfxrPIRQEWH/7yF7O+QtYJpsrHeXV4cEeDi1
        0zpZ2ATSrrko2VniO6zNS5Y=
X-Google-Smtp-Source: ABdhPJz9OsdMxDoYL6Xhw5hG2L9Z+k50d9PNIS+N5Bo36GfNNwOIVyEBjwzG0ZehGal6pMbxNoK9nA==
X-Received: by 2002:a17:907:c20:: with SMTP id ga32mr29226012ejc.7.1625726112512;
        Wed, 07 Jul 2021 23:35:12 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:12 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 03/11] namei: make do_mkdirat() take struct filename
Date:   Thu,  8 Jul 2021 13:34:39 +0700
Message-Id: <20210708063447.3556403-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h |  1 +
 fs/namei.c    | 26 +++++++++++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 6aeae7ef3380..848e165ef0f1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -77,6 +77,7 @@ long do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct user_namespace *mnt_userns, struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
+long do_mkdirat(int dfd, struct filename *name, umode_t mode);
 
 /*
  * namespace.c
diff --git a/fs/namei.c b/fs/namei.c
index 2995b3695724..54d5f19ee1ce 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3563,7 +3563,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-static struct dentry *filename_create(int dfd, struct filename *name,
+static struct dentry *__filename_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3579,7 +3579,7 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	 */
 	lookup_flags &= LOOKUP_REVAL;
 
-	error = filename_parentat(dfd, name, lookup_flags, path, &last, &type);
+	error = __filename_parentat(dfd, name, lookup_flags, path, &last, &type);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3632,6 +3632,15 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	return dentry;
 }
 
+static inline struct dentry *filename_create(int dfd, struct filename *name,
+				struct path *path, unsigned int lookup_flags)
+{
+	struct dentry *res = __filename_create(dfd, name, path, lookup_flags);
+
+	putname(name);
+	return res;
+}
+
 struct dentry *kern_path_create(int dfd, const char *pathname,
 				struct path *path, unsigned int lookup_flags)
 {
@@ -3822,7 +3831,7 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
+long do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -3830,9 +3839,10 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
+	dentry = __filename_create(dfd, name, &path, lookup_flags);
+	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
+		goto out_putname;
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
@@ -3848,17 +3858,19 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+out_putname:
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
 
 /**
-- 
2.30.2

