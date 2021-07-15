Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8913C9CE8
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241494AbhGOKjX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241493AbhGOKjW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B361C06175F;
        Thu, 15 Jul 2021 03:36:28 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t3so7388616edc.7;
        Thu, 15 Jul 2021 03:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oHTyVssJOKOMNYLoKsanZl5rYRQNpuGGGknPYRfBiFQ=;
        b=Sr1BdiTRr7X0v1emBZxtE0dDFQRHtKMWu786pF9dTi12DBrba1KqxnMbyxhXr4phAt
         eggBG/KeM1J55dXzlr1NlI97ysZT0cfOs5muT2J5E9hwfvcd7D4b0ODNGGLk/2uWF9wu
         YLucI+JvgW71hZ1msUL67+y9axYx8JUtuK6NxdE+Ii1M0OaR4Gks3YfiG342hacQp7SX
         b+tyr9WAoXPBaf2eVZitd/SrBr/zZcvVw8bGNoUEbjKb3WdLfCQpeu4nPv+WC0LH5tId
         9QRHbhWc4MP4kjpBcX/CY/+H3CClsuyQIe5GnpmvhNaMLgDCl9sub1hhUUIxisHq1zxC
         Ht0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oHTyVssJOKOMNYLoKsanZl5rYRQNpuGGGknPYRfBiFQ=;
        b=FmQ9tMMvx9g28as00MEC8j4RKIIjcenAF8btqjKHWJXtCm8/Jlxir5KgzZ0xGTTZME
         Z8KuFGgeT+2bVUGOyJKBaCF8ReLP+Qz1NM9FQSvwHrYkZb2P38NUVJ+9u1ts5YkD9NfB
         98AnhlH/P1ocbJamje3JseTVHHtIwHSNZX8q3u7bIVClRujAS1vDvGqQeEuasQC66z1U
         RT94o+RxXNS2aMg2El2+RxD0I8e1ipU5ZwU801lV48kTPlKnxfcRHs8jdWBJGwJ95rJ0
         F9NjuneSysxn8E1SPZEd+yF/A9U65dmT1+5ac327xnYSoLy3fjieeeZTSD4GdqWREiod
         Z96w==
X-Gm-Message-State: AOAM53176Edd1CPFg6PTV9vMA3eJYWFqVwCzWnXlNsWJExmbQE6CEkIt
        6JflBHpNFiQGK1GYenLz8Nc=
X-Google-Smtp-Source: ABdhPJzjDCzEegYaHoJmNPP4e06JKigfijNKs49EqKmF+N6BMvFwXNiqNVNr/lI+bWuU5bp4HaAHSA==
X-Received: by 2002:aa7:d990:: with SMTP id u16mr5911586eds.263.1626345386936;
        Thu, 15 Jul 2021 03:36:26 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:26 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  12/14] namei: clean up do_linkat retry logic
Date:   Thu, 15 Jul 2021 17:35:58 +0700
Message-Id: <20210715103600.3570667-13-dkadashev@gmail.com>
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
Link: https://lore.kernel.org/io-uring/CAHk-=wiE_JVny73KRZ6wuhL_5U0RRSmAw678_Cnkh3OHM8C7Jg@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 82cb6421b6df..b93e9623eb5d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4381,37 +4381,32 @@ EXPORT_SYMBOL(vfs_link);
  * with linux 2.0, and to avoid hard-linking to directories
  * and other special files.  --ADM
  */
-int do_linkat(int olddfd, struct filename *old, int newdfd,
-	      struct filename *new, int flags)
+static int try_linkat(int olddfd, struct filename *old, int newdfd,
+		      struct filename *new, int flags, unsigned int how)
 {
 	struct user_namespace *mnt_userns;
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
 	struct inode *delegated_inode = NULL;
-	int how = 0;
 	int error;
 
 retry:
-	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0) {
-		error = -EINVAL;
-		goto out_putnames;
-	}
+	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH
 	 * This ensures that not everyone will be able to create
 	 * handlink using the passed filedescriptor.
 	 */
-	if (flags & AT_EMPTY_PATH && !capable(CAP_DAC_READ_SEARCH)) {
-		error = -ENOENT;
-		goto out_putnames;
-	}
+	if (flags & AT_EMPTY_PATH && !capable(CAP_DAC_READ_SEARCH))
+		return -ENOENT;
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
 
 	error = __filename_lookup(olddfd, old, how, &old_path, NULL);
 	if (error)
-		goto out_putnames;
+		return error;
 
 	new_dentry = __filename_create(newdfd, new, &new_path,
 					(how & LOOKUP_REVAL));
@@ -4442,14 +4437,20 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 	}
 out_putpath:
 	path_put(&old_path);
-out_putnames:
-	if (unlikely(retry_estale(error, how))) {
-		how |= LOOKUP_REVAL;
-		goto retry;
-	}
+	return error;
+}
+
+int do_linkat(int olddfd, struct filename *old, int newdfd,
+	      struct filename *new, int flags)
+{
+	int error;
+
+	error = try_linkat(olddfd, old, newdfd, new, flags, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_linkat(olddfd, old, newdfd, new, flags, LOOKUP_REVAL);
+
 	putname(old);
 	putname(new);
-
 	return error;
 }
 
-- 
2.30.2

