Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DAA37F666
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 13:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhEMLIw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 07:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhEMLIj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 07:08:39 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F01C061763;
        Thu, 13 May 2021 04:07:29 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g14so30545355edy.6;
        Thu, 13 May 2021 04:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xp1EXKPrsRbSPLaqx+abK9C+016qOT2YFPeg3T/SDS4=;
        b=RZnBGIi3PQv8eXFUTP+ecVHxsowC/V5O63Z9O6wKV2/qo9wymDIQC9+Y6WD0mYDKsq
         udTGBoXlvMGB9uVbipAZWA0p/VK+vSraAfQActjo7hXVcK0Hl0v4RqtL7Ez9sZ9qhKwK
         iWb8IprWDg4fxdbDsc/HqaX6LGN94GjHuwzSUx69h78Xx+VMtys4iVE+Sqf120ecCqK/
         +WHUdIN2H22vvZ750Mr42gJXJ4dYgIhnUX4LtWgMtrrN8mvu7RuvNrj3nUqX8UMHTs/g
         bTS7FMvCm1R9bu2DLt0QruPkbz55N7vyaZLLkTzYErxKaqte4tkHBkoKV33WnBdG2IKA
         MUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xp1EXKPrsRbSPLaqx+abK9C+016qOT2YFPeg3T/SDS4=;
        b=EjbqlnSILS6AAIblV947axbAhdiEBYc1LKDcbSw4s/rnWWj1Q47yVqLoKW8KSwIuDK
         2EkzD18LihhCOGtq/RD17TDoRky7VQUbiLAl28Il4BnfONZAs++e7pFCxQoqLvEPmeOa
         l7LyLjX/aCWKnpskxXbGWCiB34qfuQGjgIKhnRDtMYboJEkMbsGz98mpTJsyxYbKafVF
         cNeAcoh2+bFRawxTaagt4K4rAEuhq0iqSmtH37NauFbg7uaL0UOJuGPgOavuwBqxkFmQ
         JFAuoJtzBy5Gd6cbkKc1V2ouw8omDeyKgR9H6CU8XYY0QD9b1s9bqdVWSd9VRoRDSCuJ
         os8w==
X-Gm-Message-State: AOAM533uA7qSFv7VIHDmIwf3Erdnlet9KenEXkQBTTrq/xAiL4TExeiR
        sZ4SgejZEYZRVX5SIi5QQUt4PW0IbtCOGw==
X-Google-Smtp-Source: ABdhPJyhZcypHYMaYYlYOa15TeCF7xGVkQPIxsfRTJAGH0Z5KB2RRBuO8rJFxw7d52LnimLPSXnZxA==
X-Received: by 2002:a05:6402:498:: with SMTP id k24mr10374882edv.80.1620904048115;
        Thu, 13 May 2021 04:07:28 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id bn7sm1670864ejb.111.2021.05.13.04.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:07:27 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v4 1/6] fs: make do_mkdirat() take struct filename
Date:   Thu, 13 May 2021 18:06:07 +0700
Message-Id: <20210513110612.688851-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513110612.688851-1-dkadashev@gmail.com>
References: <20210513110612.688851-1-dkadashev@gmail.com>
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

