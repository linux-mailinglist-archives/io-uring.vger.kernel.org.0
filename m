Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297823C9D14
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbhGOKsr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241620AbhGOKsr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:47 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8929C061760;
        Thu, 15 Jul 2021 03:45:53 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dp20so6617161ejc.7;
        Thu, 15 Jul 2021 03:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gv8tSwp/UrSv6bP9FmaW3UOv2WYkCE+hVRpziUUM44U=;
        b=VOFZabhX6UGXXHGitS4GHVJ9g5fm+VVzw7fJhpTIagio6lea/PD0JUkjCHyoSCKZtz
         khXQRT1JyOa4dVhB1kMzF3BEKuyO74n/NHvKz8GI8V2QtUcddEQl+/z8yxHhovyTNnQb
         G6Rhs3ViqxNkJSKxKcTBBwDuav/uzabneUE21TespT1x76Urwp2TyX+Ar8w4/eIxNx7C
         d5eoFY8WgHmvM607K1jgqbIT0mNeiKTLkSuCpcNisJlwWYk4P0ua9t5vvl5pxwyELXEj
         3CwbkGI3+E+i3SbTnahtThfqvFOLHLnVRGZQFkYl1RWrz/B86+QtlIJDncvFNz53dPwN
         rQIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gv8tSwp/UrSv6bP9FmaW3UOv2WYkCE+hVRpziUUM44U=;
        b=rzKZ3yxoZS6zSJCpySEDtWlTOFjUZq1MvN+xMgpasqpFgojajHwik/ovWZMZNaaXd1
         JoafIj0A3exwe18B2LuTy0ywibnDm6d/TDIWAV1xVDrKJBNvC9vyuxpW4BNUoPqaP6HD
         P8/6szyHStTEJLNGWEQ5DaAlQ4p2fdx658pQowP6BukfAoWO85eBTHyZe98li/x931Tt
         pCimSrtGyfonemXLlJa0nRGvbW0cgHZNEjTB6ZyAEm2zOUrJWvYVPZiFHcBn6vDJ9Xzq
         FAGTpcMuLvjNXIl9eRcCgE0fMk+vsY9/IDtvwqh+qkS5zadZVqK3YF3KdxlQdbiElKc4
         KWGw==
X-Gm-Message-State: AOAM5307oNiB/m4hG7MHpKUNmwQtONg+BNabkKFM8MC/yo6r4HkvtKS0
        7YnlJ6qv0pAzC7pvVSHw0FsxI7eAwvBBwoIU
X-Google-Smtp-Source: ABdhPJwd4P2A7ar44tXH7NKXjhhAVKfwLe0/e4KnnyfNo5tMfOTme7BI5lXssN9FWMwbpJ7r84aqTg==
X-Received: by 2002:a17:906:3acb:: with SMTP id z11mr4968721ejd.0.1626345952458;
        Thu, 15 Jul 2021 03:45:52 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:52 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 03/14] namei: prepare do_unlinkat for refactoring
Date:   Thu, 15 Jul 2021 17:45:25 +0700
Message-Id: <20210715104536.3598130-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is just a preparation for the move of the main unlinkat logic to a
separate function to make the logic easier to follow.  This change
contains the flow changes so that the actual change to move the main
logic to a separate function does no change the flow at all.

Just like the similar patch for rmdir a few commits before, there are
two changes here:

1. Previously on filename_parentat() error the function used to exit
immediately, and now it will check the return code to see if ESTALE
retry is appropriate. The filename_parentat() does its own retries on
ESTALE, but this extra check should be completely fine.

2. The retry_estale() check is wrapped in unlikely(). Some other places
already have that and overall it seems to make sense.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/
Link: https://lore.kernel.org/io-uring/CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fbae4e9fcf53..6253486718d5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4148,12 +4148,12 @@ int do_unlinkat(int dfd, struct filename *name)
 	mnt_drop_write(path.mnt);
 exit2:
 	path_put(&path);
-	if (retry_estale(error, lookup_flags)) {
+exit1:
+	if (unlikely(retry_estale(error, lookup_flags))) {
 		lookup_flags |= LOOKUP_REVAL;
 		inode = NULL;
 		goto retry;
 	}
-exit1:
 	putname(name);
 	return error;
 
-- 
2.30.2

