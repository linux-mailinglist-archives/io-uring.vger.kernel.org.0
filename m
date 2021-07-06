Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926E83BD721
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhGFMwb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241581AbhGFMwJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:09 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D21C0613DF;
        Tue,  6 Jul 2021 05:49:30 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id y42so2836055lfa.3;
        Tue, 06 Jul 2021 05:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bXHmKGf9s34tUbivjGry2QpdM+WhLY3D95j9pn9YUQc=;
        b=JrL4KSYaIUc7Hos/tqCB8qqClVieoxzVDEd4PusBL+22wmzJsPOBSdeS1XSIKoroYI
         xcUkyStadhRxxWWHnbScZuXe3uuj94D7UcbAUR60Bmuhg4tXYhX6973GcKa5xnqXpitJ
         lkK2AY8GT6jFXg4ltEjT78FArBBrsFjl3c/vxZYVYFJeAtWjBS74zMPBWfMCtKjQQKeU
         U/MMT2TzOFYKrawe9EgzO4xVkSBGLDBNRV8M3VqXmJy+d4I7iNqX830D+Yuy23ivDZGV
         2kwCDKlH1igMJfWp6DbzYL6tJcv9dSSM+GHOSW8PffbN5nitCSgHZGlBfJkkrMcRf/lI
         lEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bXHmKGf9s34tUbivjGry2QpdM+WhLY3D95j9pn9YUQc=;
        b=uf0dgjmSUMiVA6Qrbl1Owl6T5Z0N8wcmZNaspnn688hFdRkMzm+u5NHRl/wL5jgbcU
         c5eQtQhzGQUtAIqV0ZUYzNJ3D6kKAHSDUgsq92kx/WoO3htMKHaiun9XRYytpyjyt+dJ
         FYMN631Z319fnDoAJdIzrPZjdpqyNXzzJnLLbKvYJvnwL4X8rV6GWXNrrb3LTwgUtmkY
         eFCb31p5ayiPyS3PcPaK2U8KjtAQiTblHfEyTpJRiIAp3PyBX0OFmIktZ/K/LTN91Ew9
         wMGeMo8S1oePTdHMWjJBERHDep3YQExyjBT0LHGJudA6U7gEfCSbH8B7NBvFUSY+3M7v
         D7/w==
X-Gm-Message-State: AOAM53110W9FbMUdYYUDvkYPIGTV0oJpNgB2XM5dhNMujAyg+0TOnHsh
        9xRbj2zB4Y4bdiG/rFhAvZQ=
X-Google-Smtp-Source: ABdhPJyLadfVOw66hPLNY4hfAGcQzZXS1jSOJpdaOn0YHvkxP5OVqcx2GdRaZEk4w8Pzwb7YGYFzUA==
X-Received: by 2002:a05:6512:32c9:: with SMTP id f9mr14570902lfg.638.1625575768458;
        Tue, 06 Jul 2021 05:49:28 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:28 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 07/10] fs: make do_linkat() take struct filename
Date:   Tue,  6 Jul 2021 19:48:58 +0700
Message-Id: <20210706124901.1360377-8-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with do_renameat2, do_unlinkat, do_mknodat, etc.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 57 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 70a3c5124db3..0a2731f7ef71 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2450,7 +2450,7 @@ static int path_lookupat(struct nameidata *nd, unsigned flags, struct path *path
 	return err;
 }
 
-int filename_lookup(int dfd, struct filename *name, unsigned flags,
+static int __filename_lookup(int dfd, struct filename *name, unsigned flags,
 		    struct path *path, struct path *root)
 {
 	int retval;
@@ -2472,7 +2472,18 @@ int filename_lookup(int dfd, struct filename *name, unsigned flags,
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
+		// On error `new` is freed by __filename_create, set to NULL to
+		// signal that we do not have to free it below
+		new = NULL;
+		goto out_putpath;
+	}
 
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
@@ -4408,8 +4424,12 @@ static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
 		how |= LOOKUP_REVAL;
 		goto retry;
 	}
-out:
+out_putpath:
 	path_put(&old_path);
+out_putnames:
+	putname(old);
+out_putnew:
+	putname(new);
 
 	return error;
 }
@@ -4417,12 +4437,13 @@ static int do_linkat(int olddfd, const char __user *oldname, int newdfd,
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

