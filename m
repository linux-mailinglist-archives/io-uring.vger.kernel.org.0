Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A923C9CEA
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241498AbhGOKjY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241493AbhGOKjX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:23 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63C2C061760;
        Thu, 15 Jul 2021 03:36:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t3so7388702edc.7;
        Thu, 15 Jul 2021 03:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YFvz8qx7mcSZDL2EvDSdDLDKIjaZI9QM888C94zIFc8=;
        b=dysuCdZ9+M/lL8BiM3bbb+PsJ4DjjeUx4ywWErmu6mpw/Lvm0TeRFh+j5Yq9zhlK+q
         7QJ8zo1ZPqZNNDA9WId9I0NK8Ax9fH9Q4y2trYDOxM5yPyG/6xx+0J64ROruUF6DbEOP
         ifOqxssZfJtWshtm+7+lQQssp/9Ud/Sz938Nkc/lxkierUrCX98d4+x2OizSzFbh+Kse
         DQnSsnMKX6B8FnMK6f48o/2WI7J4ZdqsSvcvhxIhqNzfFGkU5wwm3aohqgg2fgp2NclL
         R70y3r1rCR1Xu/dK+g1mkSoJbXUc81OpQLeKk9tfNRWjSWIZtNBE4Cq3DHHYP08Lf7f2
         yQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YFvz8qx7mcSZDL2EvDSdDLDKIjaZI9QM888C94zIFc8=;
        b=G9EqlcD4Ik+qTVCfKhzIAeaI5CGN5jqL+YJEyFm3oBZTDfYSyMrnJLf8yJQj84MmcN
         Sq34cd7hxumtuj/oTCwll9MsujrUN7mu+DnVYtVtIyzayBv1TaAVuHoW1oswkLJyHkbo
         jimI/LNS6b/vvd/0bM/H+x/bKbopp6uauhoJYmt24AYrIuaPR5iayBavH+J0VXnU7uup
         vuPdn2vYuWBT9mvK/GKMy1d9IEX9BW+54nvtyrChVyftrm97RTtn2t0iMPUjODC8TwA0
         Nr67H//yuy0L+T3JD1jFaCnvek+50m+8kPyM7xOeC59ebViOFNnWKFt9aYIC4NeDm9wh
         Q7xA==
X-Gm-Message-State: AOAM53270E2sc5iP45thAMMAJKYoqYi7oWbjDN7v/xjJtrdxRxBqPtzS
        +1dZjqeUHh16sszZpBjXxFQ=
X-Google-Smtp-Source: ABdhPJzdN3C5kubHqgHYrAki3GhuTgBqpuyNoH6lk5r6at810FYt+IMcNZe03X0QAW4rLppven/UbA==
X-Received: by 2002:aa7:d809:: with SMTP id v9mr6043941edq.146.1626345388437;
        Thu, 15 Jul 2021 03:36:28 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:28 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  13/14] namei: prepare do_renameat2 for refactoring
Date:   Thu, 15 Jul 2021 17:35:59 +0700
Message-Id: <20210715103600.3570667-14-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main renameat logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

Changes to the flow here:

1. Flags handling is moved into the retry loop. So it can be moved
into the function with the main logic. A few extra arithmetic checks
on a slow path should be OK.

2. Just like the similar patches for rmdir and others a few commits
before, previously on filename_create() and filename_lookup() error the
function used to exit immediately, and now it will check the return code
to see if ESTALE retry is appropriate. Both filename_create() and
filename_lookup() do their own retries on ESTALE (at least via
filename_parentat() used inside), but this extra check should be
completely fine. Invalid flags will now hit `if retry_estale()` as well.

3. unlikely() is added around the ESTALE check;

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com/
Link: https://lore.kernel.org/io-uring/CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b93e9623eb5d..a75abff5a9a6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4654,9 +4654,9 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	int old_type, new_type;
 	struct inode *delegated_inode = NULL;
 	unsigned int lookup_flags = 0, target_flags = LOOKUP_RENAME_TARGET;
-	bool should_retry = false;
 	int error = -EINVAL;
 
+retry:
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		goto put_names;
 
@@ -4667,7 +4667,6 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	if (flags & RENAME_EXCHANGE)
 		target_flags = 0;
 
-retry:
 	error = __filename_parentat(olddfd, from, lookup_flags, &old_path,
 					&old_last, &old_type);
 	if (error)
@@ -4769,17 +4768,14 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 	}
 	mnt_drop_write(old_path.mnt);
 exit2:
-	if (retry_estale(error, lookup_flags))
-		should_retry = true;
 	path_put(&new_path);
 exit1:
 	path_put(&old_path);
-	if (should_retry) {
-		should_retry = false;
+put_names:
+	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-put_names:
 	putname(from);
 	putname(to);
 	return error;
-- 
2.30.2

