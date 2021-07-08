Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A13BF599
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhGHGh6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhGHGhy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:37:54 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31748C061574;
        Wed,  7 Jul 2021 23:35:12 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m1so6878730edq.8;
        Wed, 07 Jul 2021 23:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xqr2s+A/IvkPLe4a4IGu4i1RJV8tZqdSAJM7YR4tQUc=;
        b=Z7PULl/kYg2CKG9qU+YNq0TR0becYkza367q1SIWKV8jmnDum9LHd/RqwwK//Oqeu5
         NbpbrFl02TRm7HWrz47gijxTj54YKpLBQG9IxL+q3eqpFxcjLTOYLH6gooUf4fYRt1Ia
         gI4z2mfdLy6AYjRgbSNvU3+/4cHurKj/0VBH1ATCiSID2rn0YXUnH0O8GxKnmvXq9Dtq
         kYKFwaRZj52QKj/E8d/tJT8bza3rJeMSeFVCt8+zzd4/+YUGnKnmqN5WCrRBpZmoQjCv
         9EaL1hp1WDiTqPpo4Sb1dtqvie//OGetH+iOsMkdWjB3rB6qt3BbWnhp0EKHLfiRFOLR
         l78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xqr2s+A/IvkPLe4a4IGu4i1RJV8tZqdSAJM7YR4tQUc=;
        b=BQwUwagVoK69pYrb2py3mes/pmYcsICy5lRjQ5p/PF7oA0v4o0ikDuGBNHUEcoAm9s
         vJtp6dRGDNwc+DT2cqSTycSW41kDhXRYJST7MXmjhKaTIxlMGwBu/UvZVH6N1dRz97RI
         pmfL5QmABah7Nz42QVMwNdd0kbv80B7f4KW99/U6PTPiVgTbHuwNub5zrDTYjbFaJSdJ
         tGSZutFU3B2070si/lLw8fz/eOrsEO6ahCli3oq2V025sg2PyR2vqEIyNyoyA6cfzsNA
         kdoMPMcJdBN8ci7n96IfxaLTLO/VdlGEcZVQykT7QJFU+eDClhS7ea544VhECF3UuUlf
         uD+w==
X-Gm-Message-State: AOAM5307DaXQ170/mfgsdPPzey0qRxgJBEyyz0WvCqOTMcMLOBD1DcoF
        +VnBQ6opXfC2N4GZgmLJpOU=
X-Google-Smtp-Source: ABdhPJzANfThhYznnK3tlNi+j263lDlyi+hX30mDP6Vr3HRdQXO0x+AgleWHpoB5Rb/tGN0HP5B59A==
X-Received: by 2002:a50:9b06:: with SMTP id o6mr36664976edi.284.1625726110855;
        Wed, 07 Jul 2021 23:35:10 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:10 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 02/11] namei: change filename_parentat() calling conventions
Date:   Thu,  8 Jul 2021 13:34:38 +0700
Message-Id: <20210708063447.3556403-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since commit 5c31b6cedb675 ("namei: saner calling conventions for
filename_parentat()") filename_parentat() had the following behavior WRT
the passed in struct filename *:

* On error the name is consumed (putname() is called on it);
* On success the name is returned back as the return value;

Now there is a need for filename_create() and filename_lookup() variants
that do not consume the passed filename, and following the same "consume
the name only on error" semantics is proven to be hard to reason about
and result in confusing code.

Hence this preparation change splits filename_parentat() into two: one
that always consumes the name and another that never consumes the name.
This will allow to implement two filename_create() variants in the same
way, and is a consistent and hopefully easier to reason about approach.

Link: https://lore.kernel.org/io-uring/CAOKbgA7MiqZAq3t-HDCpSGUFfco4hMA9ArAE-74fTpU+EkvKPw@mail.gmail.com/
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 108 ++++++++++++++++++++++++++---------------------------
 1 file changed, 53 insertions(+), 55 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 70caf4ef1134..2995b3695724 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2485,7 +2485,7 @@ static int path_parentat(struct nameidata *nd, unsigned flags,
 	return err;
 }
 
-static struct filename *filename_parentat(int dfd, struct filename *name,
+static int __filename_parentat(int dfd, struct filename *name,
 				unsigned int flags, struct path *parent,
 				struct qstr *last, int *type)
 {
@@ -2493,7 +2493,7 @@ static struct filename *filename_parentat(int dfd, struct filename *name,
 	struct nameidata nd;
 
 	if (IS_ERR(name))
-		return name;
+		return PTR_ERR(name);
 	set_nameidata(&nd, dfd, name);
 	retval = path_parentat(&nd, flags | LOOKUP_RCU, parent);
 	if (unlikely(retval == -ECHILD))
@@ -2504,29 +2504,34 @@ static struct filename *filename_parentat(int dfd, struct filename *name,
 		*last = nd.last;
 		*type = nd.last_type;
 		audit_inode(name, parent->dentry, AUDIT_INODE_PARENT);
-	} else {
-		putname(name);
-		name = ERR_PTR(retval);
 	}
 	restore_nameidata();
-	return name;
+	return retval;
+}
+
+static int filename_parentat(int dfd, struct filename *name,
+				unsigned int flags, struct path *parent,
+				struct qstr *last, int *type)
+{
+	int retval = __filename_parentat(dfd, name, flags, parent, last, type);
+
+	putname(name);
+	return retval;
 }
 
 /* does lookup, returns the object with parent locked */
 struct dentry *kern_path_locked(const char *name, struct path *path)
 {
-	struct filename *filename;
 	struct dentry *d;
 	struct qstr last;
-	int type;
+	int type, error;
 
-	filename = filename_parentat(AT_FDCWD, getname_kernel(name), 0, path,
+	error = filename_parentat(AT_FDCWD, getname_kernel(name), 0, path,
 				    &last, &type);
-	if (IS_ERR(filename))
-		return ERR_CAST(filename);
+	if (error)
+		return ERR_PTR(error);
 	if (unlikely(type != LAST_NORM)) {
 		path_put(path);
-		putname(filename);
 		return ERR_PTR(-EINVAL);
 	}
 	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
@@ -2535,7 +2540,6 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 		inode_unlock(path->dentry->d_inode);
 		path_put(path);
 	}
-	putname(filename);
 	return d;
 }
 
@@ -3575,9 +3579,9 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	 */
 	lookup_flags &= LOOKUP_REVAL;
 
-	name = filename_parentat(dfd, name, lookup_flags, path, &last, &type);
-	if (IS_ERR(name))
-		return ERR_CAST(name);
+	error = filename_parentat(dfd, name, lookup_flags, path, &last, &type);
+	if (error)
+		return ERR_PTR(error);
 
 	/*
 	 * Yucky last component or no last component at all?
@@ -3615,7 +3619,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		error = err2;
 		goto fail;
 	}
-	putname(name);
 	return dentry;
 fail:
 	dput(dentry);
@@ -3626,7 +3629,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		mnt_drop_write(path->mnt);
 out:
 	path_put(path);
-	putname(name);
 	return dentry;
 }
 
@@ -3917,59 +3919,59 @@ EXPORT_SYMBOL(vfs_rmdir);
 long do_rmdir(int dfd, struct filename *name)
 {
 	struct user_namespace *mnt_userns;
-	int error = 0;
+	int error;
 	struct dentry *dentry;
 	struct path path;
 	struct qstr last;
 	int type;
 	unsigned int lookup_flags = 0;
 retry:
-	name = filename_parentat(dfd, name, lookup_flags,
-				&path, &last, &type);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
+	error = __filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
+	if (error)
+		goto exit1;
 
 	switch (type) {
 	case LAST_DOTDOT:
 		error = -ENOTEMPTY;
-		goto exit1;
+		goto exit2;
 	case LAST_DOT:
 		error = -EINVAL;
-		goto exit1;
+		goto exit2;
 	case LAST_ROOT:
 		error = -EBUSY;
-		goto exit1;
+		goto exit2;
 	}
 
 	error = mnt_want_write(path.mnt);
 	if (error)
-		goto exit1;
+		goto exit2;
 
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
 	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto exit2;
+		goto exit3;
 	if (!dentry->d_inode) {
 		error = -ENOENT;
-		goto exit3;
+		goto exit4;
 	}
 	error = security_path_rmdir(&path, dentry);
 	if (error)
-		goto exit3;
+		goto exit4;
 	mnt_userns = mnt_user_ns(path.mnt);
 	error = vfs_rmdir(mnt_userns, path.dentry->d_inode, dentry);
-exit3:
+exit4:
 	dput(dentry);
-exit2:
+exit3:
 	inode_unlock(path.dentry->d_inode);
 	mnt_drop_write(path.mnt);
-exit1:
+exit2:
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+exit1:
 	putname(name);
 	return error;
 }
@@ -4063,17 +4065,17 @@ long do_unlinkat(int dfd, struct filename *name)
 	struct inode *delegated_inode = NULL;
 	unsigned int lookup_flags = 0;
 retry:
-	name = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
+	error = __filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
+	if (error)
+		goto exit1;
 
 	error = -EISDIR;
 	if (type != LAST_NORM)
-		goto exit1;
+		goto exit2;
 
 	error = mnt_want_write(path.mnt);
 	if (error)
-		goto exit1;
+		goto exit2;
 retry_deleg:
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
 	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
@@ -4090,11 +4092,11 @@ long do_unlinkat(int dfd, struct filename *name)
 		ihold(inode);
 		error = security_path_unlink(&path, dentry);
 		if (error)
-			goto exit2;
+			goto exit3;
 		mnt_userns = mnt_user_ns(path.mnt);
 		error = vfs_unlink(mnt_userns, path.dentry->d_inode, dentry,
 				   &delegated_inode);
-exit2:
+exit3:
 		dput(dentry);
 	}
 	inode_unlock(path.dentry->d_inode);
@@ -4107,13 +4109,14 @@ long do_unlinkat(int dfd, struct filename *name)
 			goto retry_deleg;
 	}
 	mnt_drop_write(path.mnt);
-exit1:
+exit2:
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		inode = NULL;
 		goto retry;
 	}
+exit1:
 	putname(name);
 	return error;
 
@@ -4124,7 +4127,7 @@ long do_unlinkat(int dfd, struct filename *name)
 		error = -EISDIR;
 	else
 		error = -ENOTDIR;
-	goto exit2;
+	goto exit3;
 }
 
 SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
@@ -4595,29 +4598,25 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	int error = -EINVAL;
 
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
-		goto put_both;
+		goto put_names;
 
 	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
 	    (flags & RENAME_EXCHANGE))
-		goto put_both;
+		goto put_names;
 
 	if (flags & RENAME_EXCHANGE)
 		target_flags = 0;
 
 retry:
-	from = filename_parentat(olddfd, from, lookup_flags, &old_path,
+	error = __filename_parentat(olddfd, from, lookup_flags, &old_path,
 					&old_last, &old_type);
-	if (IS_ERR(from)) {
-		error = PTR_ERR(from);
-		goto put_new;
-	}
+	if (error)
+		goto put_names;
 
-	to = filename_parentat(newdfd, to, lookup_flags, &new_path, &new_last,
+	error = __filename_parentat(newdfd, to, lookup_flags, &new_path, &new_last,
 				&new_type);
-	if (IS_ERR(to)) {
-		error = PTR_ERR(to);
+	if (error)
 		goto exit1;
-	}
 
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
@@ -4720,9 +4719,8 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-put_both:
+put_names:
 	putname(from);
-put_new:
 	putname(to);
 	return error;
 }
-- 
2.30.2

