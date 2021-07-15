Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231153C9D16
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbhGOKst (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241620AbhGOKss (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:48 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EDBC06175F;
        Thu, 15 Jul 2021 03:45:55 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id c17so8466993ejk.13;
        Thu, 15 Jul 2021 03:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rr2ogX0F2b70BRK2G5XV9Y3jelCgb4ODEp6gY/X8CXA=;
        b=VUrcUNoojJdJfReNxHKdn1+Fy0YF4oc734QwFt5MzD2lo4SBZwBLHajYzAkxUNRrUa
         ZmzAP4hWrW0fFlSXneWaea+Z/IEsMoh2G9uEg6zvZjyIurSrbNy5GL6zQ2PTW0a563Jx
         5bDa4AW9jZ88Kv82Ns7Duq82YLLAIkpesvCgPNlaF6mxYa8N8eerQaXuz4FnlAv6zZYx
         twqHbp7AxNep0xmr1VJcr9f4wn07qIzpSV1O18LOX63S+tKadiXoF4IfPk9lbHN8347j
         4zTzIipY6CJDJw6aj3PpGK5iWuVaoZ3RXPn8mSPFv1EjiqwSadBzUoGeM9VHPG4rME3f
         23WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rr2ogX0F2b70BRK2G5XV9Y3jelCgb4ODEp6gY/X8CXA=;
        b=O5pebVqvEVqnTfG6G4yEFTjjzRhK4Sf3T98JYQemgaQnFPjNZEZMljgHg9V2OURdzU
         /0PT7mjxSlyv8XskJQLtNFF14guT2XRjP6vG+G/jEJxtRDTTwVaYqsnySEiY1pA7Kvnl
         kX1orsZjHvnDMZfUs47+fLx1y7UWPFqvuk8JKWhGFzXdmQ8JdvkHOfPLnGtCsBRAvu+/
         keTXimBIBrqzzyqIMTw+7VGI4Nghgiyodfuc+qU7ihlbz3IJteJPrELlbSbZ1MwxbCeO
         AZ2iMGOqBt4O8ixZXotEk/elDrgYlb52K9RpewQ2oh73hwtnXa9GUHtKBT4Fn0Lq1HCf
         PWDg==
X-Gm-Message-State: AOAM532RKZ62WWI3z/BpoOLE+0o9k1SszHuRELQJul4Zv36w1tJNLaum
        9WDD+T5B2nXi69nRzB+9FVA=
X-Google-Smtp-Source: ABdhPJypD0CKHsYzl4fyP2SF/zakWlrPZeMyq8KPeQdtkZGM5hwxwc+oFf0myGgkx78Az26nMGOZww==
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr4779177ejb.139.1626345953924;
        Thu, 15 Jul 2021 03:45:53 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:53 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 04/14] namei: clean up do_unlinkat retry logic
Date:   Thu, 15 Jul 2021 17:45:26 +0700
Message-Id: <20210715104536.3598130-5-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
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
Link: https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6253486718d5..703cce40d597 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4091,7 +4091,9 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-int do_unlinkat(int dfd, struct filename *name)
+
+static int try_unlinkat(int dfd, struct filename *name,
+			unsigned int lookup_flags)
 {
 	int error;
 	struct dentry *dentry;
@@ -4100,19 +4102,18 @@ int do_unlinkat(int dfd, struct filename *name)
 	int type;
 	struct inode *inode = NULL;
 	struct inode *delegated_inode = NULL;
-	unsigned int lookup_flags = 0;
-retry:
+
 	error = __filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
 	if (error)
-		goto exit1;
+		return error;
 
 	error = -EISDIR;
 	if (type != LAST_NORM)
-		goto exit2;
+		goto exit1;
 
 	error = mnt_want_write(path.mnt);
 	if (error)
-		goto exit2;
+		goto exit1;
 retry_deleg:
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
 	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
@@ -4129,11 +4130,11 @@ int do_unlinkat(int dfd, struct filename *name)
 		ihold(inode);
 		error = security_path_unlink(&path, dentry);
 		if (error)
-			goto exit3;
+			goto exit2;
 		mnt_userns = mnt_user_ns(path.mnt);
 		error = vfs_unlink(mnt_userns, path.dentry->d_inode, dentry,
 				   &delegated_inode);
-exit3:
+exit2:
 		dput(dentry);
 	}
 	inode_unlock(path.dentry->d_inode);
@@ -4146,17 +4147,9 @@ int do_unlinkat(int dfd, struct filename *name)
 			goto retry_deleg;
 	}
 	mnt_drop_write(path.mnt);
-exit2:
-	path_put(&path);
 exit1:
-	if (unlikely(retry_estale(error, lookup_flags))) {
-		lookup_flags |= LOOKUP_REVAL;
-		inode = NULL;
-		goto retry;
-	}
-	putname(name);
+	path_put(&path);
 	return error;
-
 slashes:
 	if (d_is_negative(dentry))
 		error = -ENOENT;
@@ -4164,7 +4157,20 @@ int do_unlinkat(int dfd, struct filename *name)
 		error = -EISDIR;
 	else
 		error = -ENOTDIR;
-	goto exit3;
+	goto exit2;
+}
+
+int do_unlinkat(int dfd, struct filename *name)
+{
+	int error;
+
+	error = try_unlinkat(dfd, name, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_unlinkat(dfd, name, LOOKUP_REVAL);
+
+	putname(name);
+	return error;
+
 }
 
 SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
-- 
2.30.2

