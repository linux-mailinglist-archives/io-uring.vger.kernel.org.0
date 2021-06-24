Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02F3B2D84
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhFXLRf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbhFXLRb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:31 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3EAC061574;
        Thu, 24 Jun 2021 04:15:12 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id d16so9615011lfn.3;
        Thu, 24 Jun 2021 04:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L2KbzsLRkfXUNVSPy7TFTX4HqFkjy2iFgmcesZmodrg=;
        b=BSGo4b7VCQS1gF53MLnCET69aQIZx2s3Pw33dnaeODLCV63de/FDNU7zavQgHvO+5v
         hEdq9PbHtSknuEQMI/8AYjPcY81bUMkDiG4B2MQb30ETS3uDK3XgUdVBytuQDdAwhFf6
         59ydi3e9d6Zt4soPiQ1fyrDVIDZL8Au7fFkwtNxHlVJAq3P/jyfGGybQXm9ladnWUPFq
         v10DWKn8Ldm09D0L/LcsuYjvOlsH+rBPKWsZ2FVfbq37hVCmFwm9Y5GvgC/6k+KIOgoF
         IUGGzNHHFSQj+MZpx0o9pE1cnW5NRWxh7O2TBLUJjfn48/QOdGk8DUoqlFkk6QK4ruI5
         57Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L2KbzsLRkfXUNVSPy7TFTX4HqFkjy2iFgmcesZmodrg=;
        b=SGNun0SbG7OnCF5Ax9slR/t7dZUcGCa3CQ1fdyUP+It0aiIKF4798FR+yDMhkx2PIQ
         90/IUM9Nsv3SCgurqnZM0NmSAe5X8tqsu3b1OXQRSdzALR7NMvuSBX7G7I4JC5FP/spV
         qQ+r3LrQnh+9cM5rEPqNsuo8F2dCMyipiwjV/uAfvqgOCcvV+VUQOrmwiBS4nIUSRnV4
         UPHxewEs7BV11IXXLL1R53yHD3JFpPTgLNYmSbjwakdTrezrv6lfmhq58WMb83Dh0DXN
         lsQlHkO3cP85zscnokeRzwc6ubhOsKyWRRI3S6jHO+IKh/0QHcQ1FDhLPZYJtBMcjZTB
         h/zg==
X-Gm-Message-State: AOAM532tJKxIpFZXdycez0J3fdp5cDWQosUpxN6MiBfYH7clsEHbKuUq
        Vc+nEM5Jw995qBtdrn2cFWw=
X-Google-Smtp-Source: ABdhPJxrjV8b5v3JrHUurMP5IS4mnUdZN3dELmfIr2Xm31ltf7lYeL7ggZMu1SUHkEJHjgjA1cBFHw==
X-Received: by 2002:a05:6512:169f:: with SMTP id bu31mr3484958lfb.486.1624533311049;
        Thu, 24 Jun 2021 04:15:11 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:10 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 4/9] fs: make do_symlinkat() take struct filename
Date:   Thu, 24 Jun 2021 18:14:47 +0700
Message-Id: <20210624111452.658342-5-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with the recently converted do_mkdnodat(), do_unlinkat(),
do_renameat(), do_mkdirat().

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9fc981e28788..76572d703e82 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4189,23 +4189,23 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
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
+		goto out_putboth;
+	}
 retry:
-	dentry = user_path_create(newdfd, newname, &path, lookup_flags);
+	dentry = __filename_create(newdfd, to, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		goto out_putfrom;
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error) {
@@ -4220,20 +4220,24 @@ static long do_symlinkat(const char __user *oldname, int newdfd,
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putname:
-	putname(from);
+out_putboth:
+	if (!IS_ERR(to))
+		putname(to);
+out_putfrom:
+	if (!IS_ERR(from))
+		putname(from);
 	return error;
 }
 
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

