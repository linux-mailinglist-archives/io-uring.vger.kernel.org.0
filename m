Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842873C9D2D
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbhGOKtF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241668AbhGOKtD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:49:03 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378C1C06175F;
        Thu, 15 Jul 2021 03:46:10 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id qb4so8484261ejc.11;
        Thu, 15 Jul 2021 03:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/XgiQe0Wv3FtiAdsvVsEc/R5dgx1mVv6tXWWM5MWLsk=;
        b=juqdp6oXw2gdRl/WZyFBQaK/lOW3x4Jl4/hQ0ahmPlTb5ICOHgvD4KyrK7PClzbQic
         GQ6AWVGtNBT7r9xrh8HN8mcqamFZCBxTP8xBYU4GgDUmaPe5jMymSl9GuzGIplo7VIjZ
         ooPpgsV6GA4GSbx+2EhE+Y3YMeiZigoGCcV90vTDT/Wc8W6zPgQN7HonG1txz06NGfR1
         Nd5n6oAsp2hQRY9t8sTuZid5opd9D7jl5wDH0uC8SkMZBpDXshLI6MiVhDn7dKGPQz5O
         6ue4xzDvYubgP1HWbPswiCQgMJEEAKjwwRxV4wllerfwEW6Fg9S5a8kYVDvQVz6n8akg
         +ISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/XgiQe0Wv3FtiAdsvVsEc/R5dgx1mVv6tXWWM5MWLsk=;
        b=YDDDh08G1Gf+EPUla0y1YP+78YLDEH/WwGPm73VzipLGzjMVfeyRTA4IudJeVa7Efl
         zLWsYwLD+uetbKTpr4I0VlyxZJJGIDSlv58ZIYYV5ac5UKumIoRP9yzq+JFgXpTVijRD
         mXXcHJODBiiok35WY+hW2FH7kIL5iqurky6dnQWaI6BTVIhOs2rMeIBv9xcIk0sfYSbu
         VGlMpDN/s8H6/ot7VDM/RFUwrkRtsUaoxveepQt3zOiMAj6BbqlIP4MKQz5/UtmyPRyT
         MQIaD9xQ6yBawX6snSL5H9ie80wdNm4fjv6UPWo9+SBa/Wfhn/9n5YDpPz9oA765BFZ/
         NxCw==
X-Gm-Message-State: AOAM531T2lxGl+NBrRlrPtGUVp5PemUz94sGT+Q9dFaBmJfiqKOEN+BZ
        EmWqwYPKWc5XkaeCS794fIM=
X-Google-Smtp-Source: ABdhPJwq4fu1DOev/CZX+6O1LfB87sWvhqFET0ffqeX+nV47pLnJdjB+OAW1jT6W/vKVpdEdZ79u5A==
X-Received: by 2002:a17:906:8252:: with SMTP id f18mr4793118ejx.261.1626345968849;
        Thu, 15 Jul 2021 03:46:08 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:46:08 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 14/14] namei: clean up do_renameat2 retry logic
Date:   Thu, 15 Jul 2021 17:45:36 +0700
Message-Id: <20210715104536.3598130-15-dkadashev@gmail.com>
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

