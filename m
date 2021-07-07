Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DA03BE7DA
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhGGMam (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhGGMal (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:41 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB6CC061574;
        Wed,  7 Jul 2021 05:28:01 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nd37so2997591ejc.3;
        Wed, 07 Jul 2021 05:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gokPHawoPLTY7lmBlEah/J0yiKgx3oWjxOPrR9t5IgU=;
        b=t9eVwynTizdsD5g4JH2M1FqvC2lJ6kXbhvazfPPsL0b85XoyRGd60PajMsMDAv+Rgc
         Sux1e3WHt6vk5sXc1V9FKSQBsNBpGtApUz/ZTeQySIhaCUA1Aj9NVNQEaSWpMx3B8qxS
         a00sC1chLIE9VMgeC8qNbgH80fkoT9a3Z3RrpBEGA3igYh14xqmvZcq8FAcBl6UairgU
         nmyR3YpuKcy8i+d97SYk6hNnFG4z4Md1EgRfxw8QpuFfppHXHRFpg7vRpMYXNhuIppWo
         XPC5JCBaTZuRf80fajExSXSbzL8gRoquhgnNvjIOCmdJayrngmJtq1hLNizw/DlEBGLe
         L/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gokPHawoPLTY7lmBlEah/J0yiKgx3oWjxOPrR9t5IgU=;
        b=U+a4YWe7s0rHEYrCnhs6cdMs37gS8f8hyr/mUpebdkomfv88Dbon6BKtdlDwD4GzOb
         rcAfL0U9p+CGhGyuY5E9eJZcYqKdWAEE6psxWUpJhXNU/FUjyU3IGpcxs4UmFyYNwBg5
         e1D7R93tKjyQ4QLQmN73AU5YEwHyeWXwHkN0ghCNtcox7YlAp/OBq1/a/7sEuLRo3omw
         2UQ0NWHvG3qQWfXQfTpIUiAyw0yQkWYwTGyH1gFomcyIOGvyec2J2OFdNS0FhWpoMklD
         MnQZ1Ud9Warpf73uhNN7IvVMlynMJU+EunvonzLrwafQcMQlalAySzWrP/+BpZQFX1eh
         P5lA==
X-Gm-Message-State: AOAM530UA7ptnPfjE2W/PZQ8MLdyYKVKTUZ7EaRA4nj7Qz/Sr7JOy6Zs
        OF/1yCdWbrWGfZwESGyj6zw=
X-Google-Smtp-Source: ABdhPJxRRutHHWaZ2smQKcThl/HYwfHI+7qz4tjxEJ/ADqXGDjEK5hfxSx+7Nr5jiOJhbp3uzpRAEw==
X-Received: by 2002:a17:906:b0d4:: with SMTP id bk20mr23265328ejb.535.1625660879929;
        Wed, 07 Jul 2021 05:27:59 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:27:59 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 01/11] namei: ignore ERR/NULL names in putname()
Date:   Wed,  7 Jul 2021 19:27:37 +0700
Message-Id: <20210707122747.3292388-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
References: <20210707122747.3292388-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Supporting ERR/NULL names in putname() makes callers code cleaner, and
is what some other path walking functions already support for the same
reason.

This also removes a few existing IS_ERR checks before putname().

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com/
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 79b0ff9b151e..70caf4ef1134 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -247,6 +247,9 @@ getname_kernel(const char * filename)
 
 void putname(struct filename *name)
 {
+	if (IS_ERR_OR_NULL(name))
+		return;
+
 	BUG_ON(name->refcnt <= 0);
 
 	if (--name->refcnt > 0)
@@ -4718,11 +4721,9 @@ int do_renameat2(int olddfd, struct filename *from, int newdfd,
 		goto retry;
 	}
 put_both:
-	if (!IS_ERR(from))
-		putname(from);
+	putname(from);
 put_new:
-	if (!IS_ERR(to))
-		putname(to);
+	putname(to);
 	return error;
 }
 
-- 
2.30.2

