Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4092E3C9D26
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbhGOKtA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241664AbhGOKs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:59 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF048C061760;
        Thu, 15 Jul 2021 03:46:05 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t3so7422915edc.7;
        Thu, 15 Jul 2021 03:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ioWuu96IeE32YNzL5QXexV2ZKLA96CBJT2HyMPWI7/c=;
        b=FYmbehir2pKczPV8ftJhOteSPZcnq4Jr140WuuGo2P2q+V8NTy6SYNPF8Xtycxe5Cv
         nxzDx4FIcRCTJsKR7VgYKnxD+43kFi0ZBd5UTgU5gddIAluCZxVfRt2JAUEorEJcZRgA
         7ZA3XHD5lKbCagneYYY28f98gH8NYPTseT4Teqjy8c3TFCCiYsYIqK1w32ZLvwQj3Ika
         h+dL6n0JmSf1FSsgMGyK3xdTuhy/jp7/x1aPO1ZBKOS9gfcyC34+n990V8ezyD6eT21s
         PuqynkNrccgpunzj+ockwSMi76658zjzxv6uaUJltrJWAvw+EWl65LjCxs5MNMtxnBQx
         ypZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ioWuu96IeE32YNzL5QXexV2ZKLA96CBJT2HyMPWI7/c=;
        b=Cf7jJ34LokeUUvwpMIYaXkynNAvIRs6YL2++RmYf4/Tdj2z8tHaISBhg6923vahU2p
         SRZyg8NLYJySOQ1a+UcyrhzZYRK286MGS9Hr4d5yyQKwr2yi9UtWHYBtfEIYYqakYt4M
         RIEVWiHXpJN2bpvAogdsDEzRope0ITp/6XS6R1oHW9QqUwLwQ8q4DJt09nkHTNTgzumM
         jExyVOLCJ5o2BKitMwhSVqta0wpoE8YN1LIPoEDZNKasl3jNCLNlI32Pi7lK5MRuSdwg
         0hg4W+vvp9m8c2iQXP9smAhPpHuCQjFWujB7K+TBGE5apknycuDTjfXny4+SO0z+OUp5
         qx0w==
X-Gm-Message-State: AOAM530cey2DxAe+gmZ7hs6wOJvhMxEeDqZQobpTfx4zFBLzD25Stu6n
        X9pZ/V0BBsw++27ZXS0wJzQ=
X-Google-Smtp-Source: ABdhPJxaUcufsy4j3Yr9RaDsKRdX9/LG5Dka2l5r+uWatmZ2XiXsejh9odp82NLWTF+Ab07zr/jioA==
X-Received: by 2002:a05:6402:2788:: with SMTP id b8mr6031146ede.244.1626345964336;
        Thu, 15 Jul 2021 03:46:04 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:46:04 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 11/14] namei: prepare do_linkat for refactoring
Date:   Thu, 15 Jul 2021 17:45:33 +0700
Message-Id: <20210715104536.3598130-12-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main linkat logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

Changes to the flow here:

1. Flags handling is moved into the retry loop. So it can be moved
into the function with the main logic. The cost here is mainly the
capabilities check on retry, but hopefully that is OK, ESTALE retries
are a slow path anyway.

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
Link https://lore.kernel.org/io-uring/CAHk-=wiE_JVny73KRZ6wuhL_5U0RRSmAw678_Cnkh3OHM8C7Jg@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 61cf6bbe1e5c..82cb6421b6df 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4391,6 +4391,7 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 	int how = 0;
 	int error;
 
+retry:
 	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0) {
 		error = -EINVAL;
 		goto out_putnames;
@@ -4407,7 +4408,7 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
-retry:
+
 	error = __filename_lookup(olddfd, old, how, &old_path, NULL);
 	if (error)
 		goto out_putnames;
@@ -4439,14 +4440,13 @@ int do_linkat(int olddfd, struct filename *old, int newdfd,
 			goto retry;
 		}
 	}
-	if (retry_estale(error, how)) {
-		path_put(&old_path);
-		how |= LOOKUP_REVAL;
-		goto retry;
-	}
 out_putpath:
 	path_put(&old_path);
 out_putnames:
+	if (unlikely(retry_estale(error, how))) {
+		how |= LOOKUP_REVAL;
+		goto retry;
+	}
 	putname(old);
 	putname(new);
 
-- 
2.30.2

