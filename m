Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C1D3C9CE0
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241477AbhGOKjQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbhGOKjQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:16 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE1CC06175F;
        Thu, 15 Jul 2021 03:36:22 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x17so7353040edd.12;
        Thu, 15 Jul 2021 03:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eg5z+PqQJCS7nsIZodl87fjo91xdwFW+8QRSOZStkvM=;
        b=KGQFqN3a2QKaesxR5+vKGk5wlPuQovOOUscmn+ic7mxuEKKkgOJ/Dp07GeToxQGyfx
         NQZ0BjEbzdYJ2Hh+mDBtJuDUyFpB0PvV/Xs4O9PZS157HSjjsWHVTT1IHbnYdJtk9Rvg
         ign8Anj6jkz+BsXssX8GmVolBbUVETXNZS0VFRRSGHpusIUCK8GZ1W8JXyaFl6AjnyI1
         LZccNTVeNEQzVtvbc7yDJOuK2Qe6+p+7j+DSv4Rj0KLMFz4K2nlcap3kotGpdiRgmAPz
         4/0w9EGGPxVFskIpvSfIt1sTLRgyYoAryIfSUM4pccyBnK/AdIXl4PnJdTPlKkpGg68m
         FRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eg5z+PqQJCS7nsIZodl87fjo91xdwFW+8QRSOZStkvM=;
        b=l7bRqDGziNQcrOgI2F3ntjJpOlucgraYPBh4YDyITU7tYdfeGYgf6vYRtuMwWD1dPD
         ofTjhgwVDcS3vFDjqhv8ZLvBtselACewsPZcN1F7RcfHu2xca0oJRdSpA8uyehS7wa5I
         9nkMVVUU6ReLza8/AIQAK1qY8/fiiSc19a3uZHvroxcGKZnNMpyODXj3TQJY7khnmpvO
         jOkjD+MUtwrC1t3vCQa7BVXlWtylvt0gp3Gr4AvFaX0QpdA1U7a/1WUm9LwR0we09s9j
         rsNpzY1XqS5qTAeFh+HJFFPPraRJOVfZQ1wfim47g1qvF2thAm6QSOo59LqkC9vtUxvj
         GFow==
X-Gm-Message-State: AOAM530+3P3jmLEyVJpcv760xG9T2DT2n83t9Mpt3xA9+GZhPDUDu9wk
        NZnJldaJYeK6CSoD5+LiOZI=
X-Google-Smtp-Source: ABdhPJz1iKIVAVOJeBFenzwcatzN7pytnkxH4rF8/hEXk4X+WpjQOua4+S8j01TVCzXGgxBbNBueKQ==
X-Received: by 2002:aa7:c412:: with SMTP id j18mr5756249edq.119.1626345381078;
        Thu, 15 Jul 2021 03:36:21 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:20 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  08/14] namei: clean up do_mknodat retry logic
Date:   Thu, 15 Jul 2021 17:35:54 +0700
Message-Id: <20210715103600.3570667-9-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes, just move the main logic to a helper function to
make the whole thing easier to follow.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4008867e516d..f7cde1543b47 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3745,29 +3745,26 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static int do_mknodat(int dfd, struct filename *name, umode_t mode,
-		unsigned int dev)
+static int try_mknodat(int dfd, struct filename *name, umode_t mode,
+		       unsigned int dev, unsigned int lookup_flags)
 {
 	struct user_namespace *mnt_userns;
 	struct dentry *dentry;
 	struct path path;
 	int error;
-	unsigned int lookup_flags = 0;
 
-retry:
 	error = may_mknod(mode);
 	if (error)
-		goto out1;
+		return error;
 	dentry = __filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out1;
+		return PTR_ERR(dentry);
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
-		goto out2;
+		goto out;
 
 	mnt_userns = mnt_user_ns(path.mnt);
 	switch (mode & S_IFMT) {
@@ -3786,13 +3783,20 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 					  dentry, mode, 0);
 			break;
 	}
-out2:
+out:
 	done_path_create(&path, dentry);
-out1:
-	if (unlikely(retry_estale(error, lookup_flags))) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
+	return error;
+}
+
+static int do_mknodat(int dfd, struct filename *name, umode_t mode,
+		unsigned int dev)
+{
+	int error;
+
+	error = try_mknodat(dfd, name, mode, dev, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_mknodat(dfd, name, mode, dev, LOOKUP_REVAL);
+
 	putname(name);
 	return error;
 }
-- 
2.30.2

