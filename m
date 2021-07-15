Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBBF3C9CE6
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241476AbhGOKjV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241486AbhGOKjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:19 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EC9C061760;
        Thu, 15 Jul 2021 03:36:26 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id k27so7384642edk.9;
        Thu, 15 Jul 2021 03:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ioWuu96IeE32YNzL5QXexV2ZKLA96CBJT2HyMPWI7/c=;
        b=s+XilJ2O3fS6QasUG+ghg1CKQFGtRl8D+XXiD/mo95pu5mcx4AbXG5qOBHdr8CIrhm
         N5ZzZnytO39Tu+lwPBt6oLz7G/wBZZ2gYLAaxDdW1lgKNHX9p0wl5hoG8A7Hf1Q2EsTa
         LruAHV1eWAf9f62JP9XhRyPcMp/0rKRmm8K0ImzsJRagqJLlnXNveerfeQ32ed88xKQV
         qVMRPavT8WeGdoeWmanLgfmsU5yExZiO06Vsqfbn73iDa/6Tf8ijkped6SbxYh41E4rR
         d+Dc4FWZzioOhWBkTQYHoBxHTCwCdmrsSgvIaSN9TF9p4lMH+VrXIu9kaFfkXDAjH1AC
         FLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ioWuu96IeE32YNzL5QXexV2ZKLA96CBJT2HyMPWI7/c=;
        b=afQuof4dgiRCbQ7Qj9ylY9xIMVdsDjRk0r5Dv5rtLNLmB0cV4xH/Fm15dxoJgf1bu4
         AZZHw6Kmno5wYfc6QX5bjS0fd7m7mkX9kKld9jBHd9KecMZlp/Oxrck7maS3U9IWAImm
         3PTrc1SPtnrfebXvHjdpAQ6UrHtzYZcqzRanBtYIIZEtDDCjqpj5TgOX2M/975ShAq99
         iYnO/vUpQSR0bi400QKyHqEbl4+vZAeboKjK8JBjMYAqzEtBNJu4/HciRfzgFpL9yFX4
         q3ErCamyA9wCuOyphRU7SJVdsOb9VUivgHdwPP1zXlLsPcLbi+x3fB+EVH1wQrTPpJVG
         TF9w==
X-Gm-Message-State: AOAM530KbpsvULdOvwLVk9udNeXw4aD87y+9NG7yBUhll1Py5ec1/ec1
        7d5jgKXyKiPOpMdfmqFMoiE=
X-Google-Smtp-Source: ABdhPJyHlyKyvONwlcsyODLQ+bLUDBzXdiBnDodEXJQJamd81fw3KLw6Pq+wzZznxVkgtMSa0HWL4w==
X-Received: by 2002:a05:6402:270d:: with SMTP id y13mr6080261edd.66.1626345385467;
        Thu, 15 Jul 2021 03:36:25 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:25 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  11/14] namei: prepare do_linkat for refactoring
Date:   Thu, 15 Jul 2021 17:35:57 +0700
Message-Id: <20210715103600.3570667-12-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
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

