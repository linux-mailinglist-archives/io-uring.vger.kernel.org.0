Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEA73C9D2B
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbhGOKtD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241666AbhGOKtB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:49:01 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16F1C06175F;
        Thu, 15 Jul 2021 03:46:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hd33so8498915ejc.9;
        Thu, 15 Jul 2021 03:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YFvz8qx7mcSZDL2EvDSdDLDKIjaZI9QM888C94zIFc8=;
        b=Dbztf1nwQhEqhAwI69bvytJqvwVkDA6RugBGa5Ak+G0KK6l8rd6jiSXRMXaOvY2iTV
         sJ5l8fIBdg8zZfuJsFdWUZXloqY8eEMmQiDJWNZTw52wHaQxrf0bpr+Q7REECkcbg+nz
         ND1OxLXMqbSKjQAz+90NK7c5m7hq+8NYgdmP7A0pzlJAzoDh/4G33eqmpfThFoSr9Y72
         oIfCxqhQo+AUNQ3IZlfMWss+2gzL0X+DBxmDwMWaVHKJi4pSxkn/4+peef41dcD/XpMG
         uFZSu7qK2J6c8H5vPcwOS60VraeICpzKGLF037/9R/echpkyPcmx0Qz/ParLBULZ4+xh
         gObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YFvz8qx7mcSZDL2EvDSdDLDKIjaZI9QM888C94zIFc8=;
        b=sftM+dxOgAm2KjLcdEqAQKs3DXvVQjiUCZqytmN9HuO2oHq1nEM6CODkCrbfqHX0Nd
         GsTX/qvFy98Lrg/xeLbeyf1r5f7FKDX41dgaV0V4j7qwZrBUvOQAXiZu46X4T2YqCwwZ
         Jn5NBuUoqVoXOQg/oTSXkKRcP9Csl4op5iStHDfDSb4tHW26SMOTiXc/o4W3NL+CDcqt
         EUCkYOxaPWYDJwQF8IHi0aQgNR8oiuIKMJ3lggPlM3bx3OEde4ssPTyhl5f8VgvVjuSx
         GsLpJEwEv17avfeBCqCJ9xZvUofA6Q+ESdP8saoq7xAAhpv4TFBtYVXsYcjZ7v8K+qbQ
         eF2Q==
X-Gm-Message-State: AOAM531tzhBWwzDRUMtQ9EMZSQWaK8w3uGOq1Ekp1ObMyB/bcpiwJuWQ
        cS8ymcKtgzIHgRUnKrioAuA=
X-Google-Smtp-Source: ABdhPJwjCk0ZiATJtOEfaUzzsjhu/lIahfKkJpXrGAd3qnaj6Qr93ylYe8hRlWVu+oYQI8WjKB3I6w==
X-Received: by 2002:a17:906:7302:: with SMTP id di2mr4782179ejc.409.1626345967293;
        Thu, 15 Jul 2021 03:46:07 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:46:07 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 13/14] namei: prepare do_renameat2 for refactoring
Date:   Thu, 15 Jul 2021 17:45:35 +0700
Message-Id: <20210715104536.3598130-14-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
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

