Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08D73999B4
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhFCFUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFCFUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:20:49 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F864C061763;
        Wed,  2 Jun 2021 22:19:05 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b11so5638802edy.4;
        Wed, 02 Jun 2021 22:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/6gjdhgoWsNs8yhzShxT5LW5mWmiDjbTWTCS2K2k6hw=;
        b=qZwGEcKJKf7fFx/7QMmkVo49tnEFODFvLpvknTX70ik+O5mToLdvt/KNxLoBSUSifv
         tvpzRlofU5jkJBBuPW/iK25nwdFeaow/LGNmyaSWZAn+jGQaxszyz2U7rVzioesvouJg
         1gkaA6E4PU5ERfBtGYb58NO6yloO7PAUPgoK/DNTAHE3lXVN5UtLF19llDnv2DnMgCe0
         IvkQxXN+fJbu4NWw1ijpp8EdiPsq3y9uWLZrP94iP+E4p2N2pWUm+0jDKIQnLmmF5rEh
         l1kP6jtdnP3UIh691esjYzaGuYz7WcVrPjJo752lCkRQykIjLmatUG+0p0cTDmCWXOEq
         RW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/6gjdhgoWsNs8yhzShxT5LW5mWmiDjbTWTCS2K2k6hw=;
        b=b48RGrDQpG6/Xk7bgEQIHglGktmrc/CB1j09YvoK6rY8j402fLefG9EmrpVDRrCOEI
         Bu5vps5/0nhoSSLNyCzC7OKbanPDhunMnQLfmh8lzW42DXuPEZEQRLWUM1FwYGWYWZLh
         8t2K2oTRePM5LN8pU27waTT1qQlL20itUHKg3BFT/gDIKAfTGsyLKzhtutWNNyHWsdeF
         YwPYYYQIPYDyXIrzK+eZ/zgEXqLfEe0EGJJ0zS3aKXePfgFknVlA4ZQzW6PUSPGn62Op
         QZ1G8eUIA0FRGPeMbsqS7fpS43z8qihuXxS2Jo2guPiXvvgNIh7eVqTQHJpvhIfmVctJ
         N9pw==
X-Gm-Message-State: AOAM531Q2xTdP39nBWyaaNZEYSeg7IiKzorILqGMihFlogslogm0nzBm
        etRdxONKTa4eYyCXlbXKRik=
X-Google-Smtp-Source: ABdhPJx7dW1So4NaV3x8lKR0UwkjqmHbIVb/kA1eOrZNjUJ927m07GJzE1lNMupQfRA9YOhBZ97rAw==
X-Received: by 2002:a05:6402:274b:: with SMTP id z11mr23872798edd.225.1622697543867;
        Wed, 02 Jun 2021 22:19:03 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:19:03 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 06/10] fs: make do_linkat() take struct filename
Date:   Thu,  3 Jun 2021 12:18:32 +0700
Message-Id: <20210603051836.2614535-7-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with do_renameat2, do_unlinkat, do_mknodat, etc.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 59 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 010455938826..07b1619dd343 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2447,7 +2447,7 @@ static int path_lookupat(struct nameidata *nd, unsigned flags, struct path *path
 	return err;
 }
 
-int filename_lookup(int dfd, struct filename *name, unsigned flags,
+static int __filename_lookup(int dfd, struct filename *name, unsigned flags,
 		    struct path *path, struct path *root)
 {
 	int retval;
@@ -2469,7 +2469,18 @@ int filename_lookup(int dfd, struct filename *name, unsigned flags,
 		audit_inode(name, path->dentry,
 			    flags & LOOKUP_MOUNTPOINT ? AUDIT_INODE_NOEVAL : 0);
 	restore_nameidata();
-	putname(name);
+	if (retval)
+		putname(name);
+	return retval;
+}
+
+int filename_lookup(int dfd, struct filename *name, unsigned flags,
+		    struct path *path, struct path *root)
+{
+	int retval = __filename_lookup(dfd, name, flags, path, root);
+
+	if (!retval)
+		putname(name);
 	return retval;
 }
 
@@ -4346,8 +4357,8 @@ EXPORT_SYMBOL(vfs_link);
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
-	      const char __user *newname, int flags)
+static int do_linkat(int olddfd, struct filename *old, int newdfd,
+	      struct filename *new, int flags)
 {
 	struct user_namespace *mnt_userns;
 	struct dentry *new_dentry;
@@ -4356,31 +4367,36 @@ static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 	int how = 0;
 	int error;
 
-	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
-		return -EINVAL;
+	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0) {
+		error = -EINVAL;
+		goto out_putnames;
+	}
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH
 	 * This ensures that not everyone will be able to create
 	 * handlink using the passed filedescriptor.
 	 */
-	if (flags & AT_EMPTY_PATH) {
-		if (!capable(CAP_DAC_READ_SEARCH))
-			return -ENOENT;
-		how = LOOKUP_EMPTY;
+	if (flags & AT_EMPTY_PATH && !capable(CAP_DAC_READ_SEARCH)) {
+		error = -ENOENT;
+		goto out_putnames;
 	}
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
 retry:
-	error = user_path_at(olddfd, oldname, how, &old_path);
+	error = __filename_lookup(olddfd, old, how, &old_path, NULL);
 	if (error)
-		return error;
+		goto out_putnew;
 
-	new_dentry = user_path_create(newdfd, newname, &new_path,
+	new_dentry = __filename_create(newdfd, new, &new_path,
 					(how & LOOKUP_REVAL));
 	error = PTR_ERR(new_dentry);
-	if (IS_ERR(new_dentry))
-		goto out;
+	if (IS_ERR(new_dentry)) {
+		// On error `new` is freed by __filename_create, prevent extra freeing
+		// below
+		new = ERR_PTR(error);
+		goto out_putpath;
+	}
 
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
@@ -4408,8 +4424,14 @@ static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
+out_putpath:
 	path_put(&old_path);
+out_putnames:
+	if (!IS_ERR(old))
+		putname(old);
+out_putnew:
+	if (!IS_ERR(new))
+		putname(new);
 
 	return error;
 }
@@ -4417,12 +4439,13 @@ static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname, int, flags)
 {
-	return do_linkat(olddfd, oldname, newdfd, newname, flags);
+	return do_linkat(olddfd, getname_uflags(oldname, flags),
+		newdfd, getname(newname), flags);
 }
 
 SYSCALL_DEFINE2(link, const char __user *, oldname, const char __user *, newname)
 {
-	return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
+	return do_linkat(AT_FDCWD, getname(oldname), AT_FDCWD, getname(newname), 0);
 }
 
 /**
-- 
2.30.2

