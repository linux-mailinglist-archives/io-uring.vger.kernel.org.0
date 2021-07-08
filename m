Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F333BF59F
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhGHGiC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhGHGh7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:37:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3803DC061574;
        Wed,  7 Jul 2021 23:35:17 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id cy23so1902101edb.4;
        Wed, 07 Jul 2021 23:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7wVETDFdeZlwqopZKc4dLFFstHCEoM9cJ3/d5EEJtEs=;
        b=BCYibFVeg5tC7gxx2iFLd7LbdbcgIjoYIoKioYBHIqV1Bu1cd9KqyRQLhN2mvf/eze
         eCRot3vbK8PLwWSh36ZBXUE6hdg0+lD8Vl1NNPPhy5FZaSFxpK/ufiTEXs+e6lmXFmA9
         LNcg7bvhoRR+mC15fQbD4753lSNkgy7Y9LH18HdriStk3FdcHtJEeBr0SyCmJQuFRpTf
         0n/vj1yMwfNVTHTUseDqqEtj0EKZ2VcxH4E5y0hSpUbMeM2AGU/O/OnBO1IgqCJ06BCg
         lc1b/SdTrVSHiAzTrL1QdUTRPt3ROl7QNxOsIS+kubjl5uitCbypQCEEeFBHypguXwLZ
         iwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wVETDFdeZlwqopZKc4dLFFstHCEoM9cJ3/d5EEJtEs=;
        b=hP0LlK1x1Me0hEv5+bEsYFFfn8EqEU9P40gpUAjVrA/E71LOmgbKG1IkjmIAW8bJY5
         NiHL5eZPm+/th7pOEcQz4iHlTOeR082y1k4VC++7fkzJ3vU4U3je8Ae868nt4lz2Iu7N
         nvm6Ik5ruvIIiO4jQrirQM1/zDpcSn4vsTUw2rpwLOfUQA7Xq4176z2cMuyQkcGMASLg
         A6jaNBtdW8gcULZ9/IIMBwM16l5IjFhfvCEpS10PY2RO0uhn723SxyJ1ejZU60blexAr
         hnJdDfCLYI/JzgIWMhpArWL5KJEtf6x5NbYNmmY72vCuQLKId0O6qPK7mgZI4h7yE+Bt
         XH4w==
X-Gm-Message-State: AOAM5336iGGqiA9Ba15vG6s+c5yYzW+a66RWlmX8wB3zHhkS9iSWuwur
        HirF/k4OWk/aAgUSeRl978I=
X-Google-Smtp-Source: ABdhPJy9gc9t5QBGIeTrIjPBiu2sEiu2mawXbKqcytDFF6v4yEOMc16l3BpMYbjfhCc5MAPOCmPbjA==
X-Received: by 2002:aa7:d283:: with SMTP id w3mr19816028edq.153.1625726115917;
        Wed, 07 Jul 2021 23:35:15 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:15 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 05/11] namei: make do_symlinkat() take struct filename
Date:   Thu,  8 Jul 2021 13:34:41 +0700
Message-Id: <20210708063447.3556403-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with the recently converted do_mkdnodat(), do_unlinkat(),
do_renameat(), do_mkdirat().

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0bc8ff637934..add984e4bfd0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4197,23 +4197,23 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-static long do_symlinkat(const char __user *oldname, int newdfd,
-		  const char __user *newname)
+static long do_symlinkat(struct filename *from, int newdfd,
+		  struct filename *to)
 {
 	int error;
-	struct filename *from;
 	struct dentry *dentry;
 	struct path path;
 	unsigned int lookup_flags = 0;
 
-	from = getname(oldname);
-	if (IS_ERR(from))
-		return PTR_ERR(from);
+	if (IS_ERR(from)) {
+		error = PTR_ERR(from);
+		goto out_putnames;
+	}
 retry:
-	dentry = user_path_create(newdfd, newname, &path, lookup_flags);
+	dentry = __filename_create(newdfd, to, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		goto out_putnames;
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error) {
@@ -4228,7 +4228,8 @@ static long do_symlinkat(const char __user *oldname, int newdfd,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putname:
+out_putnames:
+	putname(to);
 	putname(from);
 	return error;
 }
@@ -4236,12 +4237,12 @@ static long do_symlinkat(const char __user *oldname, int newdfd,
 SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
-	return do_symlinkat(oldname, newdfd, newname);
+	return do_symlinkat(getname(oldname), newdfd, getname(newname));
 }
 
 SYSCALL_DEFINE2(symlink, const char __user *, oldname, const char __user *, newname)
 {
-	return do_symlinkat(oldname, AT_FDCWD, newname);
+	return do_symlinkat(getname(oldname), AT_FDCWD, getname(newname));
 }
 
 /**
-- 
2.30.2

