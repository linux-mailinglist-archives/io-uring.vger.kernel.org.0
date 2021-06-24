Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E69A3B2D87
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhFXLRg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbhFXLRf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:35 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAE7C06175F;
        Thu, 24 Jun 2021 04:15:15 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id k8so7217718lja.4;
        Thu, 24 Jun 2021 04:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vv6DVh3tEsvpayNYC4FRBkF8ClCa9cXNvJfjsWO+/EA=;
        b=Ore1rgw05VR+TEHM/j4REJ3EYQoTY1iS68M1HC2lRAh6EDKZZXtwpSrqibsD5l6vwn
         Ct6/GpDjVnshk8c+FDxx1stgtFGDtORB8o5tPd7H7CjFIIip/BNyANiBtrOy9/OPvNXO
         UMMohMffagpuWtoz2WUIq5ng6K10QouafaHyJp7QncMYLXc/4yqvARsdhI1h3vnakDqA
         L3sjuLf3FoNwEFkXZNJvzW33PuhW7sBMLblgEJUs/pm//dY9YGfOEGv0leoUfxPJbG/d
         eGsB/RytYTUJjZkF5WdeWAvMa1p1oFeKhctGOtZv8JkA6f5NBiS9jNcsXj1s3PMG0bUl
         qNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vv6DVh3tEsvpayNYC4FRBkF8ClCa9cXNvJfjsWO+/EA=;
        b=WWUtZ8zTbnZZmQDjBFA6MIVH+pf0x6upqLIz4khgCbWfD5nQuox3ZYQ2MUo8ckbTVV
         O8I2ZNAWD2AlUQDaAyi+cwf12U6Jv/s6oKfo5vRlKRBGIcA901qKD2L3sb7Vq06a3xMC
         +tDS6RiS5M5p8YpV3kMAkp0mQfFQ4M45DlGz8YOzd1Td6e+p2daHXCIG3OrPP8RPJHV7
         Qw2pajeGvBrrML5HOF9UWLbcg64/GHpmRGTtWbLfE5UlKeRNAw5a7K4dil/NnogT36t7
         U/tQ/WWx2JQ58pNd/99QccFtJPqsGl/qkEsQ/Dcy14HyLRebPMzcWCstK8tNSAXy7DtL
         uCTA==
X-Gm-Message-State: AOAM530TiKhEq6kvMbHzO6EaoaY6xk/PweWN+4/ww0rxKw/Dn8YAIvSN
        RvFpzBexThjdmDeYPQWE6afx3fuCby4lYw==
X-Google-Smtp-Source: ABdhPJwNPwqBU/dG7BIaGIoPMIlaXPpy51wHOQNCXSPGQ9IyK+YyQ/i9JpmqRDzCOz/TB3zfGMCuYQ==
X-Received: by 2002:a2e:2e14:: with SMTP id u20mr3564651lju.12.1624533313716;
        Thu, 24 Jun 2021 04:15:13 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:13 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 6/9] fs: make do_linkat() take struct filename
Date:   Thu, 24 Jun 2021 18:14:49 +0700
Message-Id: <20210624111452.658342-7-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
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
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
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

