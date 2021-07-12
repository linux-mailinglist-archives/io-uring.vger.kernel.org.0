Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C2C3C5C4D
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhGLMkH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbhGLMkF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:40:05 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ACEC0613E5;
        Mon, 12 Jul 2021 05:37:16 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id v20so34266782eji.10;
        Mon, 12 Jul 2021 05:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLayrQO+mTaUbe//gUAUHc4BMWB+ynRAnjTwBUP1IZM=;
        b=gHX+iRJl46owT4GbuOoATSUnT1Y1riwnxD730nQCdPyFdhKPS83Vedjuni0IwmsWyE
         wS3j6fn7Ze5AkBpuyl10mwFItaWMPsKYCtaDbAGylMCsnwcvi5S+Os7vFZ4n4G0r59R5
         ua9NL96GTIi8/3r9OirRSui8kGcNwoh4den0agpLt0N+QBfFGomNSKcXLNe8rs0CfE4Q
         /j6+0meBJn/ATwYY+8HRLE0LaB1mhF+n43fgiM1dLYFbyQLOv6jAqQbBF4qMCmSLe6S4
         jlmerJeYsW1tzUL+Ii1pdC48aLdXxq6FRE1b7NZCq8DeFgxylZQJU8Z7jx0bwt+cdnEL
         OOZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JLayrQO+mTaUbe//gUAUHc4BMWB+ynRAnjTwBUP1IZM=;
        b=jqCpOzXUPk3klepxQQ/w+lRQMpxv4CbegU3zF+pmDV8wAaXvqiYtelsf6Tgut3PTGK
         hYoVSVOk8IzyBJr7uo95o1auOZuuo4vljpx31cYMw1dxZTV1qj/zkflC5UCSEjWueRI1
         isKQOT1Eg55+zZb0bgN8NqkDvFDSDukDnYEjQjSZvoVcVsAXi2uveS4CUbDYeJ7qbVtN
         cfEbLr062oA+26RXfbb4wdCWk/NpJBU3op/3ez8gmcYywnjJp7PS2FJoZ0TJbUMLJwUo
         MSQlWZA1mqE9Eq6EKS52NaikpcIKqwzJBdNgHo5TuBc8EN1GFe3KEsD6fKKFEz09kZ/P
         IXJg==
X-Gm-Message-State: AOAM532aqEJOgFuRAgMGovgP9l2Ka9k+1WvuI3yxoAQm3bq86zsobKzZ
        ZAgton6mFcPV6NmaH+bVcOU=
X-Google-Smtp-Source: ABdhPJynDeE/sFQHKdHxUniBQcy1/zJqNGteXGfHH0AqyApaUus0V+nYNKT/4nb+25mZiiptMtRFjg==
X-Received: by 2002:a17:906:351b:: with SMTP id r27mr8707352eja.100.1626093435452;
        Mon, 12 Jul 2021 05:37:15 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id y7sm6785216edc.86.2021.07.12.05.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:37:15 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  5/7] namei: clean up do_symlinkat retry logic
Date:   Mon, 12 Jul 2021 19:36:47 +0700
Message-Id: <20210712123649.1102392-6-dkadashev@gmail.com>
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
Link: https://lore.kernel.org/io-uring/CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7bf7a9f38ce2..c9110ac83ccb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4237,22 +4237,17 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
+static int symlinkat_helper(struct filename *from, int newdfd,
+			    struct filename *to, unsigned int lookup_flags)
 {
 	int error;
 	struct dentry *dentry;
 	struct path path;
-	unsigned int lookup_flags = 0;
 
-	if (IS_ERR(from)) {
-		error = PTR_ERR(from);
-		goto out_putnames;
-	}
-retry:
 	dentry = __filename_create(newdfd, to, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out_putnames;
+		return error;
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error) {
@@ -4263,11 +4258,23 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 				    from->name);
 	}
 	done_path_create(&path, dentry);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
+	return error;
+}
+
+int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
+{
+	int error;
+
+	if (IS_ERR(from)) {
+		error = PTR_ERR(from);
+		goto out;
 	}
-out_putnames:
+
+	error = symlinkat_helper(from, newdfd, to, 0);
+	if (retry_estale(error, 0))
+		error = symlinkat_helper(from, newdfd, to, LOOKUP_REVAL);
+
+out:
 	putname(to);
 	putname(from);
 	return error;
-- 
2.30.2

