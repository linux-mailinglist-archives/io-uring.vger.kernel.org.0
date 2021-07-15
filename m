Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076773C9CEC
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbhGOKj0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241493AbhGOKjZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:25 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462C0C06175F;
        Thu, 15 Jul 2021 03:36:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h8so7428876eds.4;
        Thu, 15 Jul 2021 03:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/XgiQe0Wv3FtiAdsvVsEc/R5dgx1mVv6tXWWM5MWLsk=;
        b=O56oVOWsi/W5Nh3heNWAcuJoEQzWWYaDbIranLJK5Z9i6AeSnGssKrTIqjVV5yNm4t
         vJADxRX12IMbvrmN5nYEHQrHat/k4XmWXiv6TIEqavId5SBEEsk8MpPymYktT9t3YtNC
         EydaPcLSVXtR4hxc0OGVBQGxQLKklVjlFqwICDRygT11p7Jj51cU4OafzqPJv3k7tQt7
         gBXIDrz7hQ/7H/KCFND5+BaJuR1CO3m2c/BYXXaJv+5MlFVjLxHJ4MA/O97meec5VRVh
         /EAW8Eo2mLUgwPye9E0Wd2zFlTHbC0seM+HPEmxketDYYNnMT3R9J05tmSZeR/YOEqWF
         DMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/XgiQe0Wv3FtiAdsvVsEc/R5dgx1mVv6tXWWM5MWLsk=;
        b=ROZdtkpcGQ4ANj3kJH814vQrRvX+SniOOQYxpkUNQ+HOIlu/QDztIrKU0VFWPJM2fO
         jnoc2p1/NBnlaT3ZLA0H2EKDmimiTYl4wi+UIkSAgt7p6D0Zx5XIVqyC/oKEuJ3fmR7e
         vSE+efpIVrfIjwoPooOM1HQSDICii7zQ2twV8sjiyXeb2DpT2NEbwBneGRGsnaJf7J79
         +JGWKoemnltNv6vwlsMQvNJ4vcnaser3GIHL2wqPQRnU0Stp/DwUnJb04qyUSRXdzOJO
         TS6BG3eTNaVN1/tH7/2GXrvzq6lhY1iznxKZNee8OzuB5jkPh7ebVoyRcHfYh34nZAc7
         F+jw==
X-Gm-Message-State: AOAM533QjrggSf3O0n5huRPbdFOXxr2px1koRa9DgefPLG2HkiudU6cg
        uRRgmq3aE+dVhRSmSD/Pllo=
X-Google-Smtp-Source: ABdhPJyUOrFleDMyWUpwtsbAnsRMARGJL8IvHIFhgalLz0KsxbQYNnsVdN1ah8K5Nhvo/6/zZv3tBg==
X-Received: by 2002:a05:6402:2228:: with SMTP id cr8mr6026553edb.309.1626345389967;
        Thu, 15 Jul 2021 03:36:29 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:29 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  14/14] namei: clean up do_renameat2 retry logic
Date:   Thu, 15 Jul 2021 17:36:00 +0700
Message-Id: <20210715103600.3570667-15-dkadashev@gmail.com>
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
Link: https://lore.kernel.org/io-uring/CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a75abff5a9a6..dce0e427b95a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4643,8 +4643,9 @@ int vfs_rename(struct renamedata *rd)
 }
 EXPORT_SYMBOL(vfs_rename);
 
-int do_renameat2(int olddfd, struct filename *from, int newdfd,
-		 struct filename *to, unsigned int flags)
+static int try_renameat(int olddfd, struct filename *from, int newdfd,
+			struct filename *to, unsigned int flags,
+			unsigned int lookup_flags)
 {
 	struct renamedata rd;
 	struct dentry *old_dentry, *new_dentry;
@@ -4653,16 +4654,15 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	struct qstr old_last, new_last;
 	int old_type, new_type;
 	struct inode *delegated_inode = NULL;
-	unsigned int lookup_flags = 0, target_flags = LOOKUP_RENAME_TARGET;
-	int error = -EINVAL;
+	unsigned int target_flags = LOOKUP_RENAME_TARGET;
+	int error;
 
-retry:
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
-		goto put_names;
+		return -EINVAL;
 
 	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
 	    (flags & RENAME_EXCHANGE))
-		goto put_names;
+		return -EINVAL;
 
 	if (flags & RENAME_EXCHANGE)
 		target_flags = 0;
@@ -4670,7 +4670,7 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	error = __filename_parentat(olddfd, from, lookup_flags, &old_path,
 					&old_last, &old_type);
 	if (error)
-		goto put_names;
+		return error;
 
 	error = __filename_parentat(newdfd, to, lookup_flags, &new_path, &new_last,
 				&new_type);
@@ -4771,11 +4771,19 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	path_put(&new_path);
 exit1:
 	path_put(&old_path);
-put_names:
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
+	return error;
+}
+
+int do_renameat2(int olddfd, struct filename *from, int newdfd,
+		 struct filename *to, unsigned int flags)
+{
+	int error;
+
+	error = try_renameat(olddfd, from, newdfd, to, flags, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_renameat(olddfd, from, newdfd, to, flags,
+				     LOOKUP_REVAL);
+
 	putname(from);
 	putname(to);
 	return error;
-- 
2.30.2

