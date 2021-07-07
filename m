Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CE83BE7E4
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhGGMay (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhGGMav (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:51 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A94C06175F;
        Wed,  7 Jul 2021 05:28:09 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l24so3105181edr.11;
        Wed, 07 Jul 2021 05:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7wVETDFdeZlwqopZKc4dLFFstHCEoM9cJ3/d5EEJtEs=;
        b=o26a/sN73pzd68//3tLy/fcfbxaxMhSLVEvBySUFIn6BBtndAjWyO20rq1GmAKSzbd
         cGR7UEzWDskDjOOt8lFu7Lb+X6CsKQ3IyHafu4RKe55x268UBpXoEkEvW87Z4vFgL25c
         i6BPrxWTf0RXBjzoNgtWNS23hYfCxxBznDK5dbC9HBW0ZXl817OXDnpasIt4XCGRT9tg
         37vZDBRsOvExb0DHj42j2EvlgBDYFp081FYKkkZ/h/ZwKoHma/0AlE1f3QZsW2Oz6yRU
         vO6jy46RYkqygTniFnRousld4jAm+g/aaMwimt5iHMqw2Hm2tCaxW3D9r31pWYjtGV8d
         f1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wVETDFdeZlwqopZKc4dLFFstHCEoM9cJ3/d5EEJtEs=;
        b=KybiftMKgLAwZzocgKdkRqsrMGtkTsFeOOMk9RimPlD3XXAt5EgmI5J56KKFEbwwIM
         ezzxMKKl655PqpFPPDluJtWoAVuMb4Ix0h9M/AWnmLSo+hMFdMNQZKiNueyWHTrHbm7y
         bfID5WjB4M9bO6LK35LRbhn923f+Fb4Ci/m3qiUsdtfdCpKPnWh8KUSCemvhHO+oYl1k
         XGa9F2ESG+jJFQb8191x3V6lzNf18tjo86UKcYlXjR4QOh8THUjU8fXlK74qyEkPDnw8
         A2H03pGyQ5kW8mMxXQCAt+54gFF6DsYg6nrbV3W37p7H1TPnsvGWWDFL+rw15dBawn/j
         ziJA==
X-Gm-Message-State: AOAM5310nhCTjwI7ld02Pe/lObsgyQNMNADbA0jzRWOPdAO2TeVs7rLK
        UM7bnjiHicjH9wkGV17g2Oo=
X-Google-Smtp-Source: ABdhPJwChZRJB+gJm+mp5dEg4wM/N5zLrtv86l5Cs2ufFxmBXdS3uHO77psCbzOlD/nlCSc6foNH8Q==
X-Received: by 2002:a05:6402:448:: with SMTP id p8mr28965001edw.60.1625660888354;
        Wed, 07 Jul 2021 05:28:08 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:28:08 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 06/11] fs: make do_symlinkat() take struct filename
Date:   Wed,  7 Jul 2021 19:27:42 +0700
Message-Id: <20210707122747.3292388-7-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
References: <20210707122747.3292388-1-dkadashev@gmail.com>
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

