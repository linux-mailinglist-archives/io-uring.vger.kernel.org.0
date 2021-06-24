Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835063B2D7E
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhFXLR3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhFXLR2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:28 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD19EC061756;
        Thu, 24 Jun 2021 04:15:08 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j4so9591922lfc.8;
        Thu, 24 Jun 2021 04:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QyHp2xzhpqD2nwO3PN1Ayttz+R1SUObrYVCQMwaBZ6w=;
        b=eJK9CfMbWMp6gtZmvXaI3nDqd6lQ3xbY9bkfRIqlhIZn2Mp5hwFkFY1XG6yfXrEBLr
         IYCDVF8JnN+CeRenQfeqEsZhXjFHZ6KeJ2dX4UbuLY192Xx5z5m6t+I3mP+sQqgCWTYv
         SfZW3XqRE7nkMjvcWHtj720bevxV8fvKHc6Mo3Srvqu7v9ceQ8bPlMMawa9Z02ix7RD3
         oEbNvodYBsbhbbEXZlOyNC4OKZMJg0Htxg4BmjmXnrlBAAidXPHDkxxrl4zwpoedhqu+
         Cm2Jr3w9A8BuMzCK5tIQhPavr1qRnXoDM0ApKmYHle3fSgfZVMj1HRNIhxigSNuA72C0
         KZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QyHp2xzhpqD2nwO3PN1Ayttz+R1SUObrYVCQMwaBZ6w=;
        b=QVU1+rYzqW98CuVw8Halu2rE+olLDz+AxJ6nYf4fYxpqd8oHBdZToLSVDDVxCnTE5R
         sRcKKtTu84+80kAPHsqjkEX9pVMvO96GzxEf6Cd839RoYe1R0umaVGKa6vZ1kksAIGQi
         Xc5ClIz2tg6CMxYX1aUksDvIxpd3iP67OfaC166fhU/CXJd5ML0WTtY7lNWyZOf/1Sy+
         1g6ThFC0XA4IKjOBUGv9/fblltWfdRmvihf0nS9ADfLM3XctBkQvJVPpcH5gda//eWm5
         yinGyCQH2iNHV3d2wYlPkUSZQXz8tTmR6hvpQnDyruZV2M2kjbshvqyh8B3y+xx0Ideb
         H4fA==
X-Gm-Message-State: AOAM532eg+3s+4+Y5IotEXNuHFpIB0WRztnCzIxFVACLgdbVIh1nEYha
        AsIBo8JVG1Ikw1QB6mFB26Q=
X-Google-Smtp-Source: ABdhPJwhEj2g3NjgyIlvNxFXWPGYkuxNOZEP90SZf3jlOawlDx6cRT0158+Q+oFMh1TMlGQFf3c9Gg==
X-Received: by 2002:ac2:4d2d:: with SMTP id h13mr3500292lfk.456.1624533307170;
        Thu, 24 Jun 2021 04:15:07 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:06 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 1/9] fs: make do_mkdirat() take struct filename
Date:   Thu, 24 Jun 2021 18:14:44 +0700
Message-Id: <20210624111452.658342-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
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
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h |  1 +
 fs/namei.c    | 22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

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
index 79b0ff9b151e..49317c018341 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3556,7 +3556,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-static struct dentry *filename_create(int dfd, struct filename *name,
+static struct dentry *__filename_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3612,7 +3612,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		error = err2;
 		goto fail;
 	}
-	putname(name);
 	return dentry;
 fail:
 	dput(dentry);
@@ -3627,6 +3626,16 @@ static struct dentry *filename_create(int dfd, struct filename *name,
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
@@ -3817,7 +3826,7 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
+long do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -3825,7 +3834,7 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
+	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3843,17 +3852,18 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
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
 
 /**
-- 
2.30.2

