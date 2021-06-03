Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AA13999B9
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFCFUz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhFCFUz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:20:55 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2258FC061761;
        Wed,  2 Jun 2021 22:19:02 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id o5so5633472edc.5;
        Wed, 02 Jun 2021 22:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1gTNac3jobz9d5k3GILSgSEapm+k+pjGiF70eN3Yn3M=;
        b=X+laeIg+nigSlOYKSBNpnPfaHFAKaYf/Cggen6MyU8PRmSRzciuwhyWLgz5wDdATuP
         fp7He/E4AXlKe8Y7a8KZlz94Z/DBY4CMOFjPTfjtNDv7niyOzIkPP8jV0RGDpwC/MW5U
         vsx/uLOKbCGWtHeM5YPGcDz+LXtB6pbRmyUyh3Vzd0MepejXp+DocCc8yxLCXqxzSjR1
         n7K55mmzIF4lw4JQrDJ6PfmwSpst9qqlxummXGOHAt4XEMayHCGJa2rjJlscmxDbWeBa
         HKnLQxdXYgyfWGbV6bhYGxTPtPZkgS47aXiZ+Xm0aYUKM10BlErIuH7tPgO2VsFBdKZU
         eQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1gTNac3jobz9d5k3GILSgSEapm+k+pjGiF70eN3Yn3M=;
        b=piMsC7AlBDkoEap/xDZYzjhh82ofy5dt8YXywROawMaXQjSPLh/rmtDkb2BMHKo4LW
         S+McLV1OKNXbqb51+jFkbNiwVm2yN+IUE7Emc6ty557D51eRTOY4Ocxq2OXIcDEDgm76
         NcO4fNX6XheUfZ0T4XXh5gtfvSzkPeN/LNWtJuOboAD/bgRHAKNY/YA+67N9Na+kZMAL
         Qw9csO7ME5OK84ef8blnU2avO6jbnU5xMGmpVlQr1+dG+HECA/wJN23uTAes9dlEaybM
         Sre5qpp7FckuYvMXpdQ+NO0HW9QJF6/78fUoddG+0DokgqLjPLrb1NMaxEniJ27zFMP9
         r4ow==
X-Gm-Message-State: AOAM5313RKh2BIKyED2PL8vGJyyaRUITDkpPVZxNlbvRMmpuL1+n0hHI
        STFyvYa4AnbseO8r84Nn/rc=
X-Google-Smtp-Source: ABdhPJx3cnPxYHvbBBT+53ATg2Pg90+FwAEOeX9+MI5ekVGiJ2ZqdeOi0Sk3zDKzRyFKg6HSuRVb4w==
X-Received: by 2002:a05:6402:26d1:: with SMTP id x17mr42069339edd.14.1622697540735;
        Wed, 02 Jun 2021 22:19:00 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:19:00 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 04/10] fs: make do_symlinkat() take struct filename
Date:   Thu,  3 Jun 2021 12:18:30 +0700
Message-Id: <20210603051836.2614535-5-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
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

