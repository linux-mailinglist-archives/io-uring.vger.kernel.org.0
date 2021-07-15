Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E743C9CE2
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241483AbhGOKjS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241480AbhGOKjR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF32C06175F;
        Thu, 15 Jul 2021 03:36:23 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t3so7388274edc.7;
        Thu, 15 Jul 2021 03:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0N8efY66+skeToBJjCOx9AdHtvBrjHdTGSW8mN497nw=;
        b=rgB6aPg12yqdBi1xOL1t1ILkBnA/IzRLVLK2fVjyyP01hd7JHGK9XrXN/qOCtMjNc7
         2B2MHbQC2sjhjATZooZ0d6onhFZNbeNIHyh/zW2BU1GeBr9jLFkekosPWyJLCgKeDB+O
         hPsTmlL92MsJ5c124k/+CUvKsPayfsMav98fFdsVd5FVoAiGX0CtzHOW4fDRZjsjZw8V
         NtnrxWeqMrGAYjn88JVFcfByFXfGf1xp8Arf/wwtHvIrJiKYAHAkWqrl/2P+2fBsZ/J2
         PsbUQJWXesEArqqXaMiujyPNsX4ugXdPrsiImnzUnqwFt7z9etYpx+ByD4BH8cqwtZe5
         ZaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0N8efY66+skeToBJjCOx9AdHtvBrjHdTGSW8mN497nw=;
        b=H+6CAVoXusdDa3/FumW/rgkmqAK8pllInZV12vvOZhn72FNLWNG356gE3K6jopGuzs
         DS+pJwysELq++c2vNA6LckLXWL8kaXs61PPPh4fbglgm3hHEfXHg7DKZBIKTHKU2qM1H
         PzcGMgkNEPws1G4R03Wa45NX8sSRht3lGwB8ea/GtgZE28FtFItjmYbRIIiUBz6VExPo
         lwwIHyBP0kw80Dujpima4LpyYO7deJY6B0sGJnI5mZj9NhH+mTM80zA747EYrC5EY1OK
         xThUw8jAFNCqXDxxmGQouAzw2/LqATn5+ZOteLr8acTHQ6GRLgivCh2/nk4OdLAkEfOx
         mTIg==
X-Gm-Message-State: AOAM5305KFzLT2RRGR0S99U46M/hm415q55IwqlLWKKxTothdYuurTih
        ao2RJ+YlsGkJDg0Z8VjF9E0=
X-Google-Smtp-Source: ABdhPJzZCxclpYFqrLNP/NUcjPStOA+SsYwm1W4pZ38ebWM85CaSDpFlFsHGG32hXG35vA1cjldUsg==
X-Received: by 2002:a50:d0cf:: with SMTP id g15mr5917691edf.219.1626345382580;
        Thu, 15 Jul 2021 03:36:22 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:22 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  09/14] namei: prepare do_symlinkat for refactoring
Date:   Thu, 15 Jul 2021 17:35:55 +0700
Message-Id: <20210715103600.3570667-10-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main symlinkat logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

There are 3 changes to the flow here:

1. IS_ERR(from) check is repeated on ESTALE retry now. It's OK to do
since the call is trivial (and ESTALE retry is a slow path);

2. Just like the similar patches for rmdir and others a few commits
before, previously on filename_create() error the function used to exit
immediately, and now it will check the return code to see if ESTALE
retry is appropriate. The filename_create() does its own retries on
ESTALE (at least via filename_parentat() used inside), but this extra
check should be completely fine.

3. The retry_estale() check is wrapped in unlikely(). Some other places
already have that and overall it seems to make sense

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com/
Link: https://lore.kernel.org/io-uring/CAHk-=whH4msnFkj=iYZ9NDmZEAiZKM+vii803M8gnEwEsF1-Yg@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f7cde1543b47..c4d75c94adce 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4241,15 +4241,15 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 	struct path path;
 	unsigned int lookup_flags = 0;
 
+retry:
 	if (IS_ERR(from)) {
 		error = PTR_ERR(from);
-		goto out_putnames;
+		goto out;
 	}
-retry:
 	dentry = __filename_create(newdfd, to, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putnames;
+		goto out;
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error) {
@@ -4260,11 +4260,11 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 				    from->name);
 	}
 	done_path_create(&path, dentry);
-	if (retry_estale(error, lookup_flags)) {
+out:
+	if (unlikely(retry_estale(error, lookup_flags))) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putnames:
 	putname(to);
 	putname(from);
 	return error;
-- 
2.30.2

