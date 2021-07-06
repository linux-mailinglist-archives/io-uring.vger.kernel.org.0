Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364863BD715
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbhGFMwR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241502AbhGFMwC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:02 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EC1C061768;
        Tue,  6 Jul 2021 05:49:22 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q4so28930708ljp.13;
        Tue, 06 Jul 2021 05:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gokPHawoPLTY7lmBlEah/J0yiKgx3oWjxOPrR9t5IgU=;
        b=MqXgNCdr+kZhNTjqZVDlKAKMa5+TLT1szNdAUkPLEYxYyZtS3gAYcEAwZltk3fYFEq
         2McJqPRqeIesDJ2dXRFY01pR1wN/Jaw3PLESKqWg6G5QxHJ7+mQ6545auM1B05JFfa9Z
         5vqhvCSxVfI5bW3bQhlmiN1exmN9yUL4BtI8tcseUa/0GwV+5arBoeq2aBrZulODf44i
         LHp8lznVyi24hLRnp5jgzUzdcEBXkEhQVJLRXC568gNy0fRurERZzyp9u9VcOM89wu6K
         XTcL/CTOAisoSJxgXs9zaGQhcrG9Pq7/V0qiEkrlOieIbpSLm8e5TciPZGgNaS04Bak1
         eQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gokPHawoPLTY7lmBlEah/J0yiKgx3oWjxOPrR9t5IgU=;
        b=jqo7Rks1X3oPqZpbOMVl0nStAczvXNJud4O/8CFteqWMVk23Wguxi/kxrdqd9RnJy7
         VKoMTy6rWHiD4ZS//seB/JT0pUKWP7SAmViOW4LYp8rOtYQhYOHwedpwIg0xUezGEFyk
         xf1VytTXRLiqewbU87LB/mtFyuinI3BGCZAd9cGzkL/ckkpi/Yxra6E6L7HjzlN0qGFl
         FadkqFwuAqD5CqpC4FrJAxzKzndQdnl2//HymcFbDMejiTZxDe+qg8Fvo7ihWIuSH4iO
         DrqIIn297OCMyuj9tarq+WQooJrqI759q3kAg1fbNKNaqjUy1DmR/zAoryfOZ9G1JTFF
         NvRg==
X-Gm-Message-State: AOAM532O0uvFgjW0fU+aUos0f4HtqGTDyllTIYLgZUAsiIzSTNf4G7yd
        1vdEWBvEO4nYKcFeq7RW9jY=
X-Google-Smtp-Source: ABdhPJzqe5nGomo9mScYt++JBnJqdZzufy5Q2ROyfA97txyzBIGWS7LsGImyN1qS1V4cTzRMvZqluQ==
X-Received: by 2002:a2e:a30b:: with SMTP id l11mr14723382lje.453.1625575761106;
        Tue, 06 Jul 2021 05:49:21 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:20 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 01/10] namei: ignore ERR/NULL names in putname()
Date:   Tue,  6 Jul 2021 19:48:52 +0700
Message-Id: <20210706124901.1360377-2-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
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

