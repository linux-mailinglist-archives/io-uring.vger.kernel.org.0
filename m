Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4BA3C9CDE
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbhGOKjP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241469AbhGOKjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:14 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9894C061760;
        Thu, 15 Jul 2021 03:36:20 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gb6so8503284ejc.5;
        Thu, 15 Jul 2021 03:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SfC+DG3exxcIswvWTHcK8XQLBwJSVXknIHN8ZFcehb8=;
        b=kxSGFZLcvGwhFJExWa2Ln0x5mMaG5ThCRIQpWO40H2wIQ1914p/TUwfg6iMLbKZ26W
         DbSfBnGcV+mUE7nIdBaAH2ZA86vqNlurUdBqr9+vEqh6GRQkSXUbnKIDzrORuWnHfE79
         aiu7aAc7b4YMqKP48zgakL0V8tGY2A6VhNQSpqRiemFGOIaMqFaLMhHDkeyoT4T/CUtl
         AvxvagQTGP5wstdzY3NSIAP/+QFiq28SDKXxY1UsfR5lrrf4HN8GTMhAr6gC/Rb3F1MK
         p2AdKPEoFtCsU7XZXOSC+f/JP49garHg+WrI0IjAQI6F4QOXrKSOQzpAdeq/Jlg6onal
         Ah5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SfC+DG3exxcIswvWTHcK8XQLBwJSVXknIHN8ZFcehb8=;
        b=VhSLU8/4iIDaJBADk/wxHmGpdaBuU1OzjI+yDZxHCbwHRChQku8+DPK8iZ9rk34/gb
         Ywd7CKg7fZbYXuKFocQa5d1Ra4yvd0BSc2PjgE9px8kI6pyD1nnAT9mrQSmKuOP2UtA0
         Pgs00Xh7wvmbZHr1EkSCT4lceMky1UP+YOTDvDXOYS9puQVDUnWDxXkSluMMC/jJVRuN
         f5rS3/5OcYL9JVS0xDfXsTLkXisWr1UxvOnWwjZdcIMgo6r+b+++pYjzc4V+5kbYCXX5
         UbhVAMwuhvuK3egHWBLIH53IdTBw4tyKL7JhfLsy/dF+yZk7xFBLdKcHSht4ap9iV5AL
         ByNw==
X-Gm-Message-State: AOAM530eFYQDnKwzWo7BHSdoTrQqxc/PkynPXM+DCo2V2LW7R+epI7TU
        Zy41y7GjbUBJkUz7emMq0mQ=
X-Google-Smtp-Source: ABdhPJwKI/5Kk/4B7Sa/dvujcS7sMkaStCUPNOikANS5TInOVNLNxYMTI5GQOcuqlloAfyosHJA16A==
X-Received: by 2002:a17:906:1390:: with SMTP id f16mr4763836ejc.441.1626345379518;
        Thu, 15 Jul 2021 03:36:19 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:19 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  07/14] namei: prepare do_mknodat for refactoring
Date:   Thu, 15 Jul 2021 17:35:53 +0700
Message-Id: <20210715103600.3570667-8-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
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

