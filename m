Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E763C5C47
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhGLMkE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbhGLMkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:40:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAFDC0613E5;
        Mon, 12 Jul 2021 05:37:13 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so14469979eds.4;
        Mon, 12 Jul 2021 05:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vC58AVc/NhhJOKA7Yh7SWfXysIpU3vPsScegx0pCGWE=;
        b=Fa4zFPsc02vUDf2immYT4UvzykeRlQPbUmcP1tV+ScpfUGt/om6n03HULkRXIJWceZ
         9AHe4hZjIsxGYfGCAL4ktMP7BXr1T1t4xNTcprB+WSRkZIgJSmiCElVfdKZRUuNeSP6v
         PxDSX+IK2EMRhXfOKGk61Eevm63cODg0izoNZNf1Xy/J21DIkTiA4lhOpNkSGSMernwD
         In1+nimmCB1hzkkv/ejz2K5KOPxUo7LHFhjbtns3PvFQQLzB5KHa0bnQHbGZSP0RRb/g
         b4VxSACp++mSj6AQZTgPgveAwFAUOYl9WhqbQxf3HjMh+oBGfPPbRadJ7yETkmOTXIBL
         TZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vC58AVc/NhhJOKA7Yh7SWfXysIpU3vPsScegx0pCGWE=;
        b=pO9d/9hfm35WgoI14Wilr9N7JRjtMeJHwzq1Rs4cs3oMPcUBqfQ7w3uIyda67OM2/H
         x9U0kgMlrRDdVKfw/AUTmAMwv1o0Vw7yMQW6iuz8cB6q2jJ1MjeMz7omoSnSbgU3jcja
         szZvDNVvOm5XrxqKaTZ+f0JxDpNmFOx+DPc+UBqUmnsnprubDArAkcxIoMIG9/UOwEUx
         wmnmzLWsL6BuCVukgiU9PIP7TFXvGtVspiJzCezGY5yt/DpiC1HWc4TQ5ReBJyjbxPY0
         /Hbe+/oij5ADFbuAM2jsKwAbx88v9YUcQGIzmOSMncuggpqKU1KCrfOuCx2TrabWOu6D
         a0Ow==
X-Gm-Message-State: AOAM533i9nhzArNVFDiqH0YVK5QYeNvap9+Sq4YroP5mmVk0z7aWachj
        xVFQBuBIa7ZOCjPaVCHsmVE=
X-Google-Smtp-Source: ABdhPJykeKPq8P2k1oF92zViTVtPyvhg3xF5BegK2w0ma7J5GPUD1NxDsAiy1uR/t3CZz4uUlJ69cw==
X-Received: by 2002:aa7:d746:: with SMTP id a6mr12033450eds.296.1626093432339;
        Mon, 12 Jul 2021 05:37:12 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id y7sm6785216edc.86.2021.07.12.05.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:37:12 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  3/7] namei: clean up do_mkdirat retry logic
Date:   Mon, 12 Jul 2021 19:36:45 +0700
Message-Id: <20210712123649.1102392-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712123649.1102392-1-dkadashev@gmail.com>
References: <20210712123649.1102392-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Moving the main logic to a helper function makes the whole thing much
easier to follow.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wijsw1QSsQHFu_6dEoZEr_zvT7++WJWohcuEkLqqXBGrQ@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index bb18b1adfea5..b9762e2cf3b9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3850,18 +3850,16 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_mkdir);
 
-int do_mkdirat(int dfd, struct filename *name, umode_t mode)
+static int mkdirat_helper(int dfd, struct filename *name, umode_t mode,
+			  unsigned int lookup_flags)
 {
 	struct dentry *dentry;
 	struct path path;
 	int error;
-	unsigned int lookup_flags = LOOKUP_DIRECTORY;
 
-retry:
 	dentry = __filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		return PTR_ERR(dentry);
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
@@ -3873,11 +3871,21 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 				  mode);
 	}
 	done_path_create(&path, dentry);
+
+	return error;
+}
+
+int do_mkdirat(int dfd, struct filename *name, umode_t mode)
+{
+	unsigned int lookup_flags = LOOKUP_DIRECTORY;
+	int error;
+
+	error = mkdirat_helper(dfd, name, mode, lookup_flags);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
+		error = mkdirat_helper(dfd, name, mode, lookup_flags);
 	}
-out_putname:
+
 	putname(name);
 	return error;
 }
-- 
2.30.2

