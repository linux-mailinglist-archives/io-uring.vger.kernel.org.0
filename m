Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EFC123A4D
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLQWyw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:54:52 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42836 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLQWyw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:54:52 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so108609pgb.9
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 14:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cQLqLFL+RdJb0fUHc/sTKR5bKAbloMIZIrT3HC1SvA8=;
        b=Af4LLuuYNL1SWU/J5vI651o+X+E1fXo0aTN4WQC2ZRrQcy0d/Oe9L6FcSJ3b6q5g7h
         QcONlvGDQqv1P7jR2pVYDhhIxjDI0nvqas0edF8wTSsCJZIK7QDNEl9BL1s54WCFjrJo
         PooLgROZGFaWraOxl8i1abBDo3glaATMP5gEh0E0RESDYvj9ATKDCZP8yY7PISWfG5g9
         ball6tFPRRQ7ZBOgGB+Y1bCiWR4E3SN3CtcTkjO+tbOBzrvgvIxVKC/VsEIA4QG8dnAg
         K2zvhYCgyHUELrQeeZ42YyM33ezbz8Fb/POz+9aggIfVYwNUgQUny8AuVxUpKsyJtDxY
         pPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cQLqLFL+RdJb0fUHc/sTKR5bKAbloMIZIrT3HC1SvA8=;
        b=n4Y/cL6ILnnPDv7niDRtufzrNa6Y+TjRciZh3zgvzjGGTFx9PKzHGi8QXKSq353P7m
         g9CetrBtDbadwK0nRa6t1rMNS31KsGEBKY3HJhTMR8GdP1s380bOX+gbzDXro7mrEa0F
         VnnSWsF4h3shiZjdQqbUmFvRre+kW08DW/ejfsjRdqJrWylsEII3FU/6TeOr7cdc9vBc
         XsgBrhZNSq5jG+T8Iux0oYE9uPsu7z7QdBJ/4q7ow7DPnTM7Knm3qiJTpN7/rk/NAFN5
         IpzmQkSp9X1b3bn+6J093LowblgbfuLoEVe2O9Y1ssFR3Ek0u7bHqf2Bhc6Th/BSTIgJ
         +Dkw==
X-Gm-Message-State: APjAAAWZqNnB5+SBeSq7jUQTmT7WfPHFjuKdL81NgiT8XK/iYCNXWsjW
        T9D2uYBxGz+LOA9FTbBke7Dhtmfx7GthsA==
X-Google-Smtp-Source: APXvYqxAfFspEi7MJ15ANxjJYMVJ5I6hyIhfceqTLXvWko3DC9AslwvKoSBk/ZJxvypf89vNaob03g==
X-Received: by 2002:a62:a118:: with SMTP id b24mr88340pff.71.1576623291180;
        Tue, 17 Dec 2019 14:54:51 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e188sm59320pfe.113.2019.12.17.14.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:54:50 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] io_uring: don't wait when under-submitting
Date:   Tue, 17 Dec 2019 15:54:41 -0700
Message-Id: <20191217225445.10739-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217225445.10739-1-axboe@kernel.dk>
References: <20191217225445.10739-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

There is no reliable way to submit and wait in a single syscall, as
io_submit_sqes() may under-consume sqes (in case of an early error).
Then it will wait for not-yet-submitted requests, deadlocking the user
in most cases.

In such cases adjust min_complete, so it won't wait for more than
what have been submitted in the current io_uring_enter() call. It
may be less than total in-flight, but that up to a user to handle.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e01cdc8a120..0085cf86dbd8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4896,11 +4896,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+		if (submitted <= 0)
+			goto done;
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
 
 		min_complete = min(min_complete, ctx->cq_entries);
+		if (submitted != to_submit)
+			min_complete = min(min_complete, (u32)submitted);
 
 		if (ctx->flags & IORING_SETUP_IOPOLL) {
 			ret = io_iopoll_check(ctx, &nr_events, min_complete);
@@ -4908,7 +4912,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
 		}
 	}
-
+done:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);
-- 
2.24.1

