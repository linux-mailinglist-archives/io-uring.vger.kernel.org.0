Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F28A3C9D1D
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241645AbhGOKsx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241632AbhGOKsx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:53 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9A5C061760;
        Thu, 15 Jul 2021 03:45:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hd33so8498291ejc.9;
        Thu, 15 Jul 2021 03:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SfC+DG3exxcIswvWTHcK8XQLBwJSVXknIHN8ZFcehb8=;
        b=c+o+LX1DFlAbZD+qqsWTz6DI42ihXnfV5hOU+zs8bqFce/oDkjJXstUrnJxTWvU/mk
         teOLEMNR6mVQhU8tWJRYBjUAtEp84oLewZHI5iDTSQsoTNQtYRZZTOBkLXSL6/iuDdY8
         IVOuq+teu53DTt9N+z9KVLswaGeatCDWTctyfJL7lJLhPo/AOEk41XEV4g51XLu4W1JJ
         KDN9arB/x/3SZ9wqB/sVhxdKMPJsGRoJHEBtyjp+xQCZr5erZZUh9Tn1xSgTIBwbFXqo
         vks/KUNMh5Q3B3boLm7DUlZrosFgSbOxzNopc1tEDo/1k1HKMyrKtfKUR3p1yzjB7nZ/
         4kjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SfC+DG3exxcIswvWTHcK8XQLBwJSVXknIHN8ZFcehb8=;
        b=VnKGTFDkRQJWHRohfchlrgpssZwpBt4OBj0B7J9SqQxmO+Y7Kbeb9vcEYrXejpn/OX
         1YTEs8m/Irmdi7aJUr5rRUnOVnZER7YMeqOqPHf9feOaBXIvdS4QFWi0MFBIJ41+FKI2
         7IBEWKqHOyb256l91TcNugv0fyLSOdJXbci2iNZ+K93Ns0yGXlU0gZDROuevi5yv9qYK
         ApNxcHJ3/THW8nKw06Y7UnrOSPNfqtadJWIqUTWzRlSEHIDcqCGo3nWFS0I+xIa6iqWQ
         dcyjMateU+HhMXqQ4ccDGn932Dap3tGbEdD56oCWAME8GFXbakbD9rypvq7un2oM+e18
         LcSw==
X-Gm-Message-State: AOAM533OhfqBXu+8T0xFfCcrblwUn8ePx2jwERBUVHVs17v5pNtYjzav
        qhjcrbIaB237INOK+E09xV4=
X-Google-Smtp-Source: ABdhPJy0j+IbVEkS+gzETwBblZcL1EsV8+WBrvFz1YGkTe22shWCJ4bobnDjIxeu8aWoE3peqb0eBw==
X-Received: by 2002:a17:906:e117:: with SMTP id gj23mr4905058ejb.131.1626345958349;
        Thu, 15 Jul 2021 03:45:58 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:58 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 07/14] namei: prepare do_mknodat for refactoring
Date:   Thu, 15 Jul 2021 17:45:29 +0700
Message-Id: <20210715104536.3598130-8-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main mknodat logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

There are 3 changes to the flow here:

1. may_mknod() call is repeated on ESTALE retry now. It's OK to do since
the call is very cheap (and ESTALE retry is a slow path) and the result
doesn't change;

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
Link: https://lore.kernel.org/io-uring/CAHk-=wijsw1QSsQHFu_6dEoZEr_zvT7++WJWohcuEkLqqXBGrQ@mail.gmail.com/
Link: https://lore.kernel.org/io-uring/CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 50ab1cd00983..4008867e516d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3754,10 +3754,10 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 	int error;
 	unsigned int lookup_flags = 0;
 
+retry:
 	error = may_mknod(mode);
 	if (error)
 		goto out1;
-retry:
 	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
@@ -3788,11 +3788,11 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 	}
 out2:
 	done_path_create(&path, dentry);
-	if (retry_estale(error, lookup_flags)) {
+out1:
+	if (unlikely(retry_estale(error, lookup_flags))) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-out1:
 	putname(name);
 	return error;
 }
-- 
2.30.2

