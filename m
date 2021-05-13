Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAE537F66C
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 13:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhEMLJq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 07:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhEMLIz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 07:08:55 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0165C06175F;
        Thu, 13 May 2021 04:07:43 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id t4so39389386ejo.0;
        Thu, 13 May 2021 04:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7iHdlJNVs1mHtxNTViODVM3OgdtFQvAu7GvdndkdvXo=;
        b=YPCbmU3kOgKSB4WLogsYB0YyhtPlZ/2ooOjQxZcFP/8N9jhBTBgOdxK7CsnWeo/b56
         VILnYR38CXvTTYH1wypIOXbwE/X275eXxy2jN3HQE6PUK02PV2vY+dtceRyElJvV8PTm
         l5tiR1FiNbP6CYuVur1delZLHD9Ae0Zt1vWoiRULU1CWPrQZXbFF8QAaTij7rGfz1Fe9
         OVgCqihOsjnckrrw2f9mdeVy/cNjANt5zcaBmgYe1PYVDjumpjEugaO05DHMalSTwBLH
         e/RLXHi/cUCcD+4TbvspuLUriSYO0W6KbSiMcdy9NnWdZA06yugWLftsRr7z6RWXwnn1
         LXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7iHdlJNVs1mHtxNTViODVM3OgdtFQvAu7GvdndkdvXo=;
        b=f34Ixlj71TkrF25oFLRy/GgSyuYDSOw972Nst4suzO288jeju0J6oOnNlnmdulVYOF
         6rft62fSCBO9szPeVOh41uS8N9DYkyhkLggdINQSFdVXPTobS1Mny6+V+ty28Dq3RZqd
         abI8dgzzP5oeQKhRkKOvQD5KiQrl+3+MXViSBfskeo8Dd/hkPipQncw+YO/4S2SfUktq
         0L3Lg5h+uVTj+t4pevPgrO/aVp+Q4KlEc5LnfVCLwMTh00W/oOBjgjVaT8bhsoHzD1Gv
         U9s8GdVixe86+MrAYqhgoe//jls3fCu1XohbC3On61K8qHpUAUTtntA8+u8FDXE5qyIy
         v82w==
X-Gm-Message-State: AOAM533wzddSg3LK+pyCZvo7CzzAiKZCX+wx6uDzWJT/+r6EpUqD0xJu
        l2f7o9tZwnHnPqC8CBU4Z+s=
X-Google-Smtp-Source: ABdhPJyXOQbAKVG6mSbS/034meVPHZAzJ9lz3gXnrkXi1/QlcvOLCTU8RM9RFfQj9SFKG7QlipsCSg==
X-Received: by 2002:a17:907:a076:: with SMTP id ia22mr42688070ejc.233.1620904062709;
        Thu, 13 May 2021 04:07:42 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id bn7sm1670864ejb.111.2021.05.13.04.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:07:42 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v4 4/6] fs: make do_symlinkat() take struct filename
Date:   Thu, 13 May 2021 18:06:10 +0700
Message-Id: <20210513110612.688851-5-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513110612.688851-1-dkadashev@gmail.com>
References: <20210513110612.688851-1-dkadashev@gmail.com>
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
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
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

