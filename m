Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36F53C9D25
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbhGOKs5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241656AbhGOKs5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:57 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41478C06175F;
        Thu, 15 Jul 2021 03:46:04 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id c17so8467532ejk.13;
        Thu, 15 Jul 2021 03:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EHG39bGGVJfcCHnCV+DYwcxM8Y412mNnw+khYb5tB2Y=;
        b=SZk4DOX0jqnKexk8NF6TvR+H2/qpz/5RT4AHZEA72GMcvb5OwQ8Ta3p+Z0WD+8zOZE
         +fVPJCEcaFZARI4+KpUO91I8+wru3oPDVk2QE00DtkOuLV082+Bo6O3sWHRyRTRFJxjd
         EWGkx3/W6ixqJLbGryk6uuQ7OWkr+oc4przZGM56CbjUtxcweOJAqHF2cjp9RhLbM0gC
         nHBQIgIvbNA0bQ9tdZaEBSvFinDtGwshfmpg7rbYOHhsopQMuAWbocRRbFxBGDab+x2W
         6/6w+46Ucr8h26XN9Oio/qT8LcO7R8XaKUP5yo3UhXwS7yp0m4PrLMV9mlmVdwDMlkEL
         Wn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EHG39bGGVJfcCHnCV+DYwcxM8Y412mNnw+khYb5tB2Y=;
        b=jRScQgu1n8zgfqqWz0CP/oUWNzWu0BbJfsGuP47wPXjenxFTduKohCKWJFVNwjqajo
         cwo8xrvTcHuwVXEVxwcAlRsqiCaIXSWF1r3HdZG6eNG5LV3FuYamnG82eKRAKTmHd+9S
         BD/q3kB/FMr0CmYejedvTOwasmXxdYfo85DUK5+xydac8/TMQTMu/kixKiudnF29csI4
         GcZFpSgZmAuwH8Ui/4UqUAO3Deraafw22KbQGXhwdnj0lXZGNzGiqJ12Hhv+C2rsCPWn
         6A+9MsdlnTm1/wnH7VK2FmkGCxtSBLcU+ts8O7xweHk4CvjXqc7o/IFjEJD9GrqYboNg
         zzbA==
X-Gm-Message-State: AOAM530U8yvtUj4aDxiWuKIlFxIyYkEruV0ErwtyPARyT3fkYMSUlPeA
        E3aWzlmGFK+B09D9qQ6MFFo=
X-Google-Smtp-Source: ABdhPJztfnHXYPlJqjrpHD3hnIH74hi/0GnPqzwJP9ssqx/7Biq7ciKwrFbEvuLxwIz2TDCOrGJ8Cg==
X-Received: by 2002:a17:906:4ad9:: with SMTP id u25mr4827809ejt.174.1626345962859;
        Thu, 15 Jul 2021 03:46:02 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:46:02 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 10/14] namei: clean up do_symlinkat retry logic
Date:   Thu, 15 Jul 2021 17:45:32 +0700
Message-Id: <20210715104536.3598130-11-dkadashev@gmail.com>
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
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c4d75c94adce..61cf6bbe1e5c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4234,22 +4234,18 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
+static int try_symlinkat(struct filename *from, int newdfd, struct filename *to,
+			 unsigned int lookup_flags)
 {
 	int error;
 	struct dentry *dentry;
 	struct path path;
-	unsigned int lookup_flags = 0;
 
-retry:
-	if (IS_ERR(from)) {
-		error = PTR_ERR(from);
-		goto out;
-	}
+	if (IS_ERR(from))
+		return PTR_ERR(from);
 	dentry = __filename_create(newdfd, to, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out;
+		return PTR_ERR(dentry);
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error) {
@@ -4260,11 +4256,17 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 				    from->name);
 	}
 	done_path_create(&path, dentry);
-out:
-	if (unlikely(retry_estale(error, lookup_flags))) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
+	return error;
+}
+
+int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
+{
+	int error;
+
+	error = try_symlinkat(from, newdfd, to, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_symlinkat(from, newdfd, to, LOOKUP_REVAL);
+
 	putname(to);
 	putname(from);
 	return error;
-- 
2.30.2

