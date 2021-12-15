Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DC1476572
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhLOWJJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhLOWJI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:09:08 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9D1C06173E
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:08 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y13so79669281edd.13
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WyoOiAq7+vahI1LhfFUzi/TCr5tNRPzOU7lEO2TmvsA=;
        b=A6N/RLgHhAU0XlqBsQjt/e4JYbL51N7wvrxpNxhxLqe21uh0KVgUoZNrzBOUnPjluD
         znhT8aRhi1SwEN7UrVUyO9oZSh6WLcXlx5m5XNOwwVyZc2deg5k5J+h3Z4Sjo5UOQeBg
         hdrPrvnUXoQj6sNMr7HxPguSo0C2w7rr5eKgcztUEcuwIykAfhHMBXIBl0qH1xlbjay+
         pGhVvqWLv5Qv10bcaMnYUgeQGlbERerdA+n8fJ4ucw2NJltjSH2cp6M3u2kFmTl/sVxX
         9jvKaojGq7V3O1cllYiwQwx22kXiF3LsO79NWacwd0bbDVMTLZ8MWML+r1y+PRHI14xt
         ljhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WyoOiAq7+vahI1LhfFUzi/TCr5tNRPzOU7lEO2TmvsA=;
        b=iET5gCMxrdtfy5gSU9LJXPmh/Ed7bpkHeaaItA5qpyRpf8RGQbFYFCVrgOBx1IOdgE
         Zrhe9q0Azcf3kX4NBT9uO/r2NSvIieeztqS0JOGYXUVJIjJGXX6KEkWJKyfF9UfYBl6M
         XsMNLwf9tr1ikCpS2ZPkl3lh2fVMPWxrXnfL+HOMm4OYWCkRQ8Esg3bgT0c0ZpWB9Plc
         MRsQ3UZvkP0Hc4fO+avS56yNzrSYoH7QjF3vrb9sJfSGE+5LdMhAsLh/1enC4v5AxLib
         MBkwCayucRHQ4Ba1tMjp3EgvtvfgV/aaecQT0/IbsqKBStS61sfVRJ2pFP9y57JvKd8n
         zeIA==
X-Gm-Message-State: AOAM531ueRKPUpoVmp0TCUhDsat++ywsBmMucI2317R+hS6fbINFtvNy
        n0EW0hk6XQXyoRBMnj4hvKUIPn7Yw1U=
X-Google-Smtp-Source: ABdhPJxixyJp5t5R+nSipN6AZNvM9rwbatYgZi3jJLA6xNNI22vlfU0Xkpm77XOhW9ljqQ/TC2bIjw==
X-Received: by 2002:a17:906:ccc5:: with SMTP id ot5mr2402054ejb.303.1639606146937;
        Wed, 15 Dec 2021 14:09:06 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1572006edb.59.2021.12.15.14.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:09:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 6/7] io_uring: single shot poll removal optimisation
Date:   Wed, 15 Dec 2021 22:08:49 +0000
Message-Id: <ee170a344a18c9ef36b554d806c64caadfd61c31.1639605189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
References: <cover.1639605189.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need to poll oneshot request if we've got a desired mask in
io_poll_wake(), task_work will clean it up correctly, but as we already
hold a wq spinlock, we can remove ourselves and save on additional
spinlocking in io_poll_remove_entries().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d59d3fa93c9c..20feca3d86ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5568,8 +5568,14 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (mask && !(mask & poll->events))
 		return 0;
 
-	if (io_poll_get_ownership(req))
+	if (io_poll_get_ownership(req)) {
+		/* optional, saves extra locking for removal in tw handler */
+		if (mask && poll->events & EPOLLONESHOT) {
+			list_del_init(&poll->wait.entry);
+			poll->head = NULL;
+		}
 		__io_poll_execute(req, mask);
+	}
 	return 1;
 }
 
-- 
2.34.0

