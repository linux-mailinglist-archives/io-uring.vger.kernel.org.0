Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B0C37F671
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 13:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhEMLJx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 07:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbhEMLI5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 07:08:57 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693F2C0613ED;
        Thu, 13 May 2021 04:07:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gx5so39279921ejb.11;
        Thu, 13 May 2021 04:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H5ufUdciyHNunf66c4+mL4mjtug3gg99c7/FCESGMYA=;
        b=NlXC3pUAM3uhoj9BxuapUdiujatIp8C5JVqFk7wK82cOd4Q/8XBHyqPye0AJl5zYh1
         S7Etiqa5TpdXm/SzaGGkomVWAyVlcz06uOcJcIYVvY73RO8LivumRB3YLxEIwbH7RFwu
         bZ9VRv9gjotBxXKUe1pz58tQ8PrAN9bPp7tmjlW2xCLqlcHSNbWGhk4vzyIsg1++Fnjf
         3Bn3pdnrk0wlFxkfYQYueBfvfxyu3HEM1upJGtbEttgKbnhsbbKSuCDOliOM7v7EgZRa
         kxcev7N5N596P5zTVUZakfsFcT8Ev3al+t5gjBMnRgD74fYWUimweqjGu9p0sdUxn+qR
         hVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H5ufUdciyHNunf66c4+mL4mjtug3gg99c7/FCESGMYA=;
        b=XXmzIA0o5/yKpA7xfDzKXP4UPDQL+a5TEeiPdk3uEKWR0mOCLM5F3VAA7P2ULb/LSA
         H5TFKwJbPOFT1FFs44qwYy8ylGKXSruSSuzcqRJkj5x4qwjeVztjFWJMe0Z4Ok8EQoYr
         6QIs/z1WdlDl1Kk1dE+p8u2SVDJz/kCPdTflqsKHMoiRpx0hqZ62HadjM401PI3H7sCC
         cSqrIPjPH3w6TXtxPS0cmd3FVBL7bjnOhCKlcVm8hn/4nfeE5aLJGNVplMA5MRogm+yX
         ASNR43QC9g+LMsgPDiP0PCDlLAH7I0q+PP7PD3rO+OsdOX6Z/uAQ9TukWeFRjwi4rBY3
         w4lw==
X-Gm-Message-State: AOAM531iuBdxtxKBqqPqZqv2iI4xhAs0AxUlTxbO9mECh6+zWTQtRp5T
        EF5TFWmHKcE8nXvvToLj2G0urslyZIyLCA==
X-Google-Smtp-Source: ABdhPJxaMVVhGKCnrOR9Cdb6xCwRWwMoVsUI/o3t1W1R1gb5xxcm4M8cewO2P+6SgMtFFBlj3h3llg==
X-Received: by 2002:a17:906:a1c5:: with SMTP id bx5mr44394684ejb.166.1620904066069;
        Thu, 13 May 2021 04:07:46 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id bn7sm1670864ejb.111.2021.05.13.04.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:07:45 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v4 6/6] fs: make do_linkat() take struct filename
Date:   Thu, 13 May 2021 18:06:12 +0700
Message-Id: <20210513110612.688851-7-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513110612.688851-1-dkadashev@gmail.com>
References: <20210513110612.688851-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with do_renameat2, do_unlinkat, do_mknodat, etc.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---

Several things concern me about this change:

* Separation of getname_uflags() that uses the AT_EMPTY_PATH flag, and
  the capability / permissions check for that AT_EMPTY_PATH flag;
* Ugly new = ERR_PTR(error); to avoid double free;

Feedback / hints on better approaches will be really appreciated.

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

