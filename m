Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B013C9D22
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbhGOKs4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbhGOKsz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:55 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C015BC061760;
        Thu, 15 Jul 2021 03:46:02 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id c17so8467447ejk.13;
        Thu, 15 Jul 2021 03:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0N8efY66+skeToBJjCOx9AdHtvBrjHdTGSW8mN497nw=;
        b=d/obLiIK4cONRFb3+nisZ4RSwOUnxlbMhbp+atFFDSldraI2mMSeVUlty9vKHT23qg
         6Z6V1vp76jALWdH7RnujBAUtpbpO3EA7PcYxWV4OgaLxIynrJk3lF5rsGRjWhdhOK8XS
         a80sD3bpjkMPPvJe3471PYl/CNjTjIoEO80VGIHWZVLHZDR94CkGj8bRIgrwRT6vQ2mL
         vEZsECgJFalw6Tx97jgMqpNcJ6dt1t6Zu0YtPksF0NVLqpGTa87JPH/PgjycAlvaE2/B
         BEHFiiEB7zmvHgnOJPjJDrfR9+2zzyn6B+hcPKDsEKRHemeyH8GxwMqzm9F8/PDBwqDU
         zvQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0N8efY66+skeToBJjCOx9AdHtvBrjHdTGSW8mN497nw=;
        b=s7t1KLKwfdr0LTXV1PhZ2k7St6e/CuY7UmBq99rHVgLT7XXH8oJA8jSW7TqwNFMxBN
         cQ28w9yx+/cgEbRadNTZKJEff721mYcN8PdG822NOjw1gl8Rlw8O6BjTTT2qTw2DdAe2
         jzQz5oGDbsrSSeixMuc2mhC48QvA1kxqm5pHuNJx4U2/Y1bbDZlC3sSLzdFqOZSPg1dE
         IJ86GEK15e+j6cUvxv+JGS7vKMbwS3E/2zx2ouvPbyy/OVVJMNnRiFGF5ZseKGf47G6W
         gDzIB4Mrf77V/Vir+y/ZuE17dpO/RBB9+oHTxcK2p+erYgsPJz51ywRs7kUP2ar7dgxM
         4aRA==
X-Gm-Message-State: AOAM533pXsnbxfVCGOc12KSj8fOg39ZuZq2o7yjVaPoN0BUZzPzrS2k9
        pFFemxFy8lkbBN97RwWTqMk=
X-Google-Smtp-Source: ABdhPJzms5OPKKoGFdRkyYUNXdPWeLKCJe3whtABrEsxdh6BLV+G1zRDIqkX1D2rameC5R42flFzng==
X-Received: by 2002:a17:906:6b8a:: with SMTP id l10mr4852391ejr.509.1626345961398;
        Thu, 15 Jul 2021 03:46:01 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:46:01 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 09/14] namei: prepare do_symlinkat for refactoring
Date:   Thu, 15 Jul 2021 17:45:31 +0700
Message-Id: <20210715104536.3598130-10-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
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

