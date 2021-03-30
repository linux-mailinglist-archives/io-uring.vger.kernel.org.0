Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1356D34E0F9
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 08:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhC3GBR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 02:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhC3GAp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 02:00:45 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4E9C061762;
        Mon, 29 Mar 2021 23:00:44 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id v15so21972852lfq.5;
        Mon, 29 Mar 2021 23:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JwROeegWkdODKVv6qZWwI8EA184sTShpBe/vCXlorak=;
        b=UJxvvBqz5bl8G7NT6kKSOQDKLyXmtJbjqyJlobuZhqjr8z5zgO2SICPXO8P96LnKA2
         8BkdKF/oPoayORmPLS3sptL4cxWeRXMMHxy+/E/QMV7GT2Tcz3YEyXctTy1abtHaN7HY
         abrg2E+wjtg+AzJgyU98zF2BnSwANn+yJMmWQUJWYmE7dqj0WqqXp0W7zfEdi3eDBuVW
         xwZOf9lCGlKc/F2eHUcKzSYiQfvgkSl/btjfEwZcXR2d0oJBHINQD31WedOswdoWgHN7
         DbIU1rk23Hmre529UGODIRslprL9x1kvYYHRNZyVJc5aBn5fWLeGqc/mb798nSgu9ioY
         X0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JwROeegWkdODKVv6qZWwI8EA184sTShpBe/vCXlorak=;
        b=d6X0Td6hrt2BlyQHuVOSfmospYDgI9f9L9i/SKp1ut1MVzHUkT2JtmGMjV6MmNsh0I
         TxPO5yji+OawslkuNoU3LAEM3m4MpooqS1gK+jaY7E4+K1MvDInl4gDgjsTG/u977CRx
         IDPD67vIqkJJKE54ZM2GYq7UFHUa3o+vgW2wHF8rOox1N7Z4h2x2O7lot6Iapvrpc07I
         aviUHgUKB/uCH7arMCdp/yymhTtTNnMJH7h0v8j0UkjuFJXfQf641y3VeqIlhm1qG7rS
         0BsXsDOnRdE9Ra7igWuIeLQmTvb5/0hm4nW3Xyn9CZ/pgpsiv4YQ6kJJrxyPb4IZy3uo
         VI/A==
X-Gm-Message-State: AOAM532Ey6C5E1Pb59k2T8JXGJKetBHB4MW/WBKIXmdZp/2RpUX9JsiR
        90ZPekC5Dl9oAneyqVxHDb8=
X-Google-Smtp-Source: ABdhPJx2Xmi12CPyHphDdORgzz5equIfy63s9f/Y8Est4G6m+K2dmdr9BT2GXwktbdb4f5zdPHUe9g==
X-Received: by 2002:ac2:5fa2:: with SMTP id s2mr18478955lfe.486.1617084043413;
        Mon, 29 Mar 2021 23:00:43 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id e6sm2050089lfj.96.2021.03.29.23.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 23:00:43 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
Date:   Tue, 30 Mar 2021 12:59:56 +0700
Message-Id: <20210330055957.3684579-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330055957.3684579-1-dkadashev@gmail.com>
References: <20210330055957.3684579-1-dkadashev@gmail.com>
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
index 216f16e74351..bfdc3128bf8d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3560,7 +3560,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-static struct dentry *filename_create(int dfd, struct filename *name,
+static struct dentry *__filename_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3616,7 +3616,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		error = err2;
 		goto fail;
 	}
-	putname(name);
 	return dentry;
 fail:
 	dput(dentry);
@@ -3631,6 +3630,16 @@ static struct dentry *filename_create(int dfd, struct filename *name,
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
@@ -3821,15 +3830,18 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
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
 
@@ -3847,17 +3859,18 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
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

