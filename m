Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99B3BD716
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbhGFMwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237916AbhGFMwD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:03 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCA8C061574;
        Tue,  6 Jul 2021 05:49:23 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id p16so10641902lfc.5;
        Tue, 06 Jul 2021 05:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S98nHxfTo5m/JgcsnAfUg1Ygblw/JMoWygfYueM6Umc=;
        b=MrXt27BmxMOQBKAlAqT0zPGmdNfqPvSARxppy+4+IDTnT737+TBI8mmTKOAWvd2VIT
         lyuD3a9ZiBQnJTzeAMmlE2lTO7s/u6+t0x13vce5CBOjD7Hy9C/CkKT2EIwxQKoAWujr
         MSyY4jyHhNitVW02QLh9F8+s5hN7dN7dM1ylVty1RgeYtcxMUOTyduFGxXEniIznS6sM
         226v8JHygEY4FvMMlG1VMpciuEekaliWdd4hzlmRAyGY3Pu0CF8rF8qVvlme7808T4zF
         WYqQ4FaV0dT+GU8njVx0PcLF+IVLvqOpiSUTXZ4HOJJReD4luPo5wpkE46N8QNnr4M8N
         t8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S98nHxfTo5m/JgcsnAfUg1Ygblw/JMoWygfYueM6Umc=;
        b=PxHQIujmy5MNZAOvdSpgqWgEVGuJsnadtjZdgAKYSLbuhYys8GCkfOiXJJDpA+L3Tu
         BYOiMC8qIHIh/Y++NJ/Fxt3a5S+3g332u8HoEtXEnqF4etHyAklwzmubeH2oiJKb/N3W
         yPrSHe5MX2iOo+2jv8VjEs3COyFjNiIMmYakio83hceWMlDLSMzxtWLq9UaoglnpC+G2
         SyNk7JKunCfulouEDUgjMT7Z5De1QuAtBQKJBvF6IU+5GmmU+tZSxbOEBLSxW2dn462x
         favBtyOV1e3Xl4UT+VVCO+P81LRfUMQ0H+P2U/N6KNxkKR67ZDSoS5mA4WegwBhNal8Y
         EJcg==
X-Gm-Message-State: AOAM532bkHXoZmFjSLWSW8A/Yasdj/NLBmpwzMFkZgCNm3neEmJvDPaT
        3hKgTUzqDJSO3PuVH6ksMrE=
X-Google-Smtp-Source: ABdhPJyqG6uE+oEJyNDPBOCXGOTQ7BN8D38K+NuQ9VGC1Pm5BilcmCzmxNNPsWg8GOthftIjx4hjww==
X-Received: by 2002:a05:6512:3582:: with SMTP id m2mr15569530lfr.532.1625575762313;
        Tue, 06 Jul 2021 05:49:22 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:21 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 02/10] fs: make do_mkdirat() take struct filename
Date:   Tue,  6 Jul 2021 19:48:53 +0700
Message-Id: <20210706124901.1360377-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
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
index 70caf4ef1134..8bc65fd357ad 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3559,7 +3559,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-static struct dentry *filename_create(int dfd, struct filename *name,
+static struct dentry *__filename_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3615,7 +3615,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 		error = err2;
 		goto fail;
 	}
-	putname(name);
 	return dentry;
 fail:
 	dput(dentry);
@@ -3630,6 +3629,16 @@ static struct dentry *filename_create(int dfd, struct filename *name,
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
@@ -3820,7 +3829,7 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
+long do_mkdirat(int dfd, struct filename *name, umode_t mode)
 {
 	struct dentry *dentry;
 	struct path path;
@@ -3828,7 +3837,7 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
+	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3846,17 +3855,18 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
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

