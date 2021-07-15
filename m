Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0433C9D19
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241637AbhGOKsv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241633AbhGOKsv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:51 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C64C06175F;
        Thu, 15 Jul 2021 03:45:58 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id c17so8467186ejk.13;
        Thu, 15 Jul 2021 03:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QloIpUWxseObgf+NMoNExWhUt5BhExzUbRQoNBg+DnM=;
        b=ZHHH0UjigMOKSgiXRKFqrPd+X49KS5O60/nQIizlXVAhX9ONwUdnEX8KkT4hrHBvrc
         +yhB059rNqvDt5QxwGybJogTCNStSBbdNCEEs9Fm8ThHO82OA+vVN1lMMPcxHVBb+T+c
         nGBF+6cHYTStsaVz/LSqbLtboL8AnWKG+smAU8xdu0VwmwnVrXo9WnMHn++uZqNKJ8aX
         avOazwQkniKeDX7+JvVjuXiH0q/zYORsKOcnMxXG1g7hgVkhOYQcJ9+glbaHNaBcnPdH
         te0z/pditlZRSO1kIyPQoQK6kx/uKP667VXDtvpHtuBk5blcvabO1ImJ0jlqI0Uu2pxY
         y7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QloIpUWxseObgf+NMoNExWhUt5BhExzUbRQoNBg+DnM=;
        b=Zfw7V4y/hl7grg2BgkK21EG7ginzmIyojOGaCgOvus/6AWRBBjlVhk/Imc1kTnd9d3
         cQAS+arCrXxYj4C5QZ2ngR21fs7PLIppElekA8rhA3ABAJ6hLkWLZQPUUxPeyIEFxz/x
         thceVNB/vvSZK2ikKIPPs+GdHHADWTLPy/f6oFKqVWEZY/ttP9wwHmmEYwQpq0VslQyR
         UNzO8vaNIPlczV7oZ1SSh92QAH04FulBcoB+jtr+fkXS7SlZkwr+jf8Vw308IDl74Uo6
         UN32BztlPRk1cRSM+Jklz44yfyxtm5iffI0Bb9I5rlTS8+Ug83XffAlvykQBQlOVRWQ+
         9QuQ==
X-Gm-Message-State: AOAM530V7h2hNhde2AmJDbvQOLz1pctidIfLzDt8NO9Sfm8VbDG9JQwU
        VpoPj4xP6YptVW0UauY2pTM=
X-Google-Smtp-Source: ABdhPJyaBwgiqcBK8AFphL8KlFhQW1d2aliH82g9zIeRRXDzMnVuqNuP12o1K3NJAdbqFHwUl5ITUw==
X-Received: by 2002:a17:906:b6c5:: with SMTP id ec5mr4796651ejb.290.1626345956904;
        Thu, 15 Jul 2021 03:45:56 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:56 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 06/14] namei: clean up do_mkdirat retry logic
Date:   Thu, 15 Jul 2021 17:45:28 +0700
Message-Id: <20210715104536.3598130-7-dkadashev@gmail.com>
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

