Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00ADE3C9CDC
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241475AbhGOKjP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241457AbhGOKjN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:13 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDD2C06175F;
        Thu, 15 Jul 2021 03:36:19 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t3so7388018edc.7;
        Thu, 15 Jul 2021 03:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QloIpUWxseObgf+NMoNExWhUt5BhExzUbRQoNBg+DnM=;
        b=HjzfgZQuJ6pJxmDT6LBjCl4hrO4OefafBEsuVA/3bHTEmH2nIy+EHZE4u5Cz1B87qM
         zwj8zrevc23vnx6lGCU0rTPLyX2nU4YTNTYJ45biqd9ZxiHuGKYI0Q6O1yH0hWb7cA26
         CBX85l5K0YzaHr1tMTVdr0C3qs8409fYH9I/ZrfTCSE2V83pqCblp9hmCtZ1ApBRi8Cz
         wMPDOjxAEkhZu7+wv/tDMLWzmf+boUOGCQIAMpnAPGtaSiviG8hNAo4rhoM77sE0GlYP
         jDCVAtRLfghpebd7jR4qt9hwEMB/ap3HrR604CqEzem6qxNyhSGySUkVop+AzGQ2qcsj
         omng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QloIpUWxseObgf+NMoNExWhUt5BhExzUbRQoNBg+DnM=;
        b=J2CgIiKWRyNvEjYid5cAA3yIKx5zUmpRM0/TizpfRLyavz+7b004DEafCIDMFNNzum
         EiMfCfULwKImlhVvef7/xyg4TKVKc9M94cbHjPxPRxlRV7C5xjE/7kmd7w5LrQRKhUGX
         wMc5N3eCrEt/8geo2TQ9HoV+QqrOqbFa6pwnwK1fESJzVVHPIikw1Rrs7uf+pD3GnT5U
         1jwZk/Mdw5Wi5vYVHE5yzmXRgYZOZbGRUOceW9JzlfX3wCn5dpv5tfTwlGgf8T3Owu3M
         p6dGX3eTt/LGHIpZOsfP4ZPkYEb9VY9vLy7tH08Z58wJTt8S8cGBjBuL/rKyyYw01iGZ
         2eig==
X-Gm-Message-State: AOAM532ApjCTIxEg641LnCS9RYHMBJZvc5FIR7MqqxGC+MfhkEO8yv6n
        qAv9o2/tFDT6xHUcmswjTbo=
X-Google-Smtp-Source: ABdhPJzlCsjHWw2lS/zZ3UvwlRwneo18nxg34fNv1KRzboEIyHF+mPMxoKeOcuvkdS63ANOlUleofg==
X-Received: by 2002:a05:6402:34cd:: with SMTP id w13mr5924390edc.377.1626345378057;
        Thu, 15 Jul 2021 03:36:18 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:17 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  06/14] namei: clean up do_mkdirat retry logic
Date:   Thu, 15 Jul 2021 17:35:52 +0700
Message-Id: <20210715103600.3570667-7-dkadashev@gmail.com>
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
Link: https://lore.kernel.org/io-uring/CAHk-=wijsw1QSsQHFu_6dEoZEr_zvT7++WJWohcuEkLqqXBGrQ@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 54dbd1e38298..50ab1cd00983 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3850,18 +3850,16 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-int do_mkdirat(int dfd, struct filename *name, umode_t mode)
+static int try_mkdirat(int dfd, struct filename *name, umode_t mode,
+		       unsigned int lookup_flags)
 {
 	struct dentry *dentry;
 	struct path path;
 	int error;
-	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
-retry:
 	dentry = __filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out;
+		return PTR_ERR(dentry);
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
@@ -3873,11 +3871,18 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 				  mode);
 	}
 	done_path_create(&path, dentry);
-out:
-	if (unlikely(retry_estale(error, lookup_flags))) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
+
+	return error;
+}
+
+int do_mkdirat(int dfd, struct filename *name, umode_t mode)
+{
+	int error;
+
+	error = try_mkdirat(dfd, name, mode, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_mkdirat(dfd, name, mode, LOOKUP_REVAL);
+
 	putname(name);
 	return error;
 }
-- 
2.30.2

