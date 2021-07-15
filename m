Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEBA3C9D18
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbhGOKsv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241632AbhGOKsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:50 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D1EC06175F;
        Thu, 15 Jul 2021 03:45:56 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bu12so8609599ejb.0;
        Thu, 15 Jul 2021 03:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+MzqW1FGpWE2/HiJKOcK3CZTGi1+seN/N4XAEsKSZdc=;
        b=Ta4DYJlqXq9iplYXdZB3LW+xfWxJxbf+ojWnk4ZVrcXd84ag/Fbu/SPxbzZMYVdq9u
         m1B/bZSy1URZR/Ax6xErXeTy9AZvRa13Yk3Fe0bLFobm9YUoHdtk+0AGEw4MazaAUEil
         RDxuiqMdELlWptBeZ/UqpBJKYofq7dFE/fZCYOrnbEoRMcl47ziDGgWw6rBXQMTRym4f
         1c+2XINzSaDHLaZCLG8t9nq71gpOBDMiK9S3vRkjVgUEfyEeJcNB1qcOaZFTxYe40XZM
         G6q58gk5t2qfA0srqQJ3qRT1C/Pd+T80OYFQovpVnBu9FFYl7dnssQApFfbRrAgO9fw0
         BZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+MzqW1FGpWE2/HiJKOcK3CZTGi1+seN/N4XAEsKSZdc=;
        b=eWsaob43jO6jRDMEHjk1PRBTdvG+rvsWc/MbAzS2C4nnDT5+4yVMbXb0ZMUMQ+a/2u
         uqlLKgNBZbAmTD+D5QHXMnkSEGm48x8W636jQjJeCb5zIIdxOeEYT/0aXKDBI8HxwDx5
         md3gN5qcXzSc56Mu8MkLe1MvD6KdoWiISy1QnXkaHBCPPFsDM980+OMINwqsrgPKVbHr
         H9poPbjcnTC0o3vvglYc03HLFY/0pX7hXR8dRL3UuEQRzQ+LmL2nHLRzkSL76x5SIsps
         PZjdePZDsuGJCBKZFddqxAVd/gXN4RLcOtBHM4cG4GcChSdmmpx9iHWO5k/0244x2Zgn
         DykA==
X-Gm-Message-State: AOAM533ZBYBdr5gt+Sl4JkRF8V9wU+zwlgvW8wN4GTXfb5hCdmRW0FXZ
        /4T+6rjhquBcdTIibEmOFfQ=
X-Google-Smtp-Source: ABdhPJwKAto5nuGVQO3oSTP04S00UvJ90twAOWO1Y4Yf99C85d1mqBznvk6XlmbXUvtcF70tSp35Pw==
X-Received: by 2002:a17:906:c7d6:: with SMTP id dc22mr4882611ejb.517.1626345955384;
        Thu, 15 Jul 2021 03:45:55 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:55 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 05/14] namei: prepare do_mkdirat for refactoring
Date:   Thu, 15 Jul 2021 17:45:27 +0700
Message-Id: <20210715104536.3598130-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main mkdirat logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

Just like the similar patches for rmdir and unlink a few commits before,
there two changes here:

1. Previously on filename_create() error the function used to exit
immediately, and now it will check the return code to see if ESTALE
retry is appropriate. The filename_create() does its own retries on
ESTALE (at least via filename_parentat() used inside), but this extra
check should be completely fine.

2. The retry_estale() check is wrapped in unlikely(). Some other places
already have that and overall it seems to make sense

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wijsw1QSsQHFu_6dEoZEr_zvT7++WJWohcuEkLqqXBGrQ@mail.gmail.com/
Link: https://lore.kernel.org/io-uring/CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 703cce40d597..54dbd1e38298 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3861,7 +3861,7 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putname;
+		goto out;
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
@@ -3873,11 +3873,11 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 				  mode);
 	}
 	done_path_create(&path, dentry);
-	if (retry_estale(error, lookup_flags)) {
+out:
+	if (unlikely(retry_estale(error, lookup_flags))) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out_putname:
 	putname(name);
 	return error;
 }
-- 
2.30.2

