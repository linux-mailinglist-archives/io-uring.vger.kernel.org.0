Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A4111F253
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 15:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfLNOxm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 09:53:42 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36878 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfLNOxm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 09:53:42 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so1313792lfc.4;
        Sat, 14 Dec 2019 06:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LtP8axFgRqFzauZbZkt21kxhVbu1x/apgV9RLv9E/DQ=;
        b=OA1qGASgsSIpKlr/o/6TKcWH/VY+zcBPwUz5lPJxoCObhk9koCvbAraNki+N8M323y
         V1npiOLFbqo0JgJiDKWCqJTCu/wJQXq3OiNyC6QrQk9+gAcvAtd3W44q8NmE5pxry/Yh
         vlPwQeu0Qq4EAXXf64Z7AbzQPztqYv6ycl+SpXGnzzLz8wNYcbeZ9Ffnm6Ztabe7cBs0
         06c1k29iRaTbRCSEDMGwnbXzozVv19/8f6TMdOV3PtxnfHBlsmkeYlqV3AlIr4Vmo4od
         GffNLL/YoSMkHQa75DoHDe8NQGhoX8BFQAi9ehHWiecQ1jP4NQJMNe25l2jPEW0F2kuS
         i6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LtP8axFgRqFzauZbZkt21kxhVbu1x/apgV9RLv9E/DQ=;
        b=LVkn/4iEX3Lw7HU8HMMylhFSQKyXvEsw6Gg2RIe+mKjDSGkoSwj8v8tuHHjVDF2XkQ
         MqmPUt50RmmeY7QWgRVzJB/zOjANLUOC/7s8igPuDnrQ6KaLOMErnDV/2v3+Zcq++NGA
         S0ispmeZnv4Zncv0DyDLauelEYaETWwomdmqQDO2HsNZvEqYKD3XJza38v0UwAwM6AEA
         F/opQDMn8SG+dyAVwlL5nt1CPT/yyJXPGZmbBN9V3rtwtsledyAC8pYJyv+DPy2W2J5b
         EVGCne1IZzW+3nDOv8Ob6CGyJsbWY9tbUdaaqAbDKC3sowMfGTS8apqaRczWBGlQSBgx
         bSZg==
X-Gm-Message-State: APjAAAW3Q6IAkE52PwKX3jNPa5/UIlnF3TV4/JtEfBTazcRwDqdEaWs7
        Brj4PpfuExYIipbwrysZw/E=
X-Google-Smtp-Source: APXvYqwHOwTLEmzguOMBkv/bixIiSVVQLsRatRso9F0PQ4xDdWTJ7Zf/4xTHWceJQgmy71rf2GAGrA==
X-Received: by 2002:ac2:4945:: with SMTP id o5mr11368865lfi.93.1576335219887;
        Sat, 14 Dec 2019 06:53:39 -0800 (PST)
Received: from localhost.localdomain ([212.122.72.247])
        by smtp.gmail.com with ESMTPSA id h19sm6771480ljl.57.2019.12.14.06.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 06:53:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] io_uring: don't wait when under-submitting
Date:   Sat, 14 Dec 2019 17:53:14 +0300
Message-Id: <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no reliable way to submit and wait in a single syscall, as
io_submit_sqes() may under-consume sqes (in case of an early error).
Then it will wait for not-yet-submitted requests, deadlocking the user
in most cases.

In such cases adjust min_complete, so it won't wait for more than
what have been submitted in the current call to io_uring_enter(). It
may be less than totally in-flight including previous submissions,
but this shouldn't do harm and up to a user.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: cap min_complete if submitted partially (Jens Axboe)
v3: update commit message (Jens Axboe)

 fs/io_uring.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 81219a631a6d..5dfc805ec31c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3763,11 +3763,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		unsigned int sqe_flags;
 
 		req = io_get_req(ctx, statep);
-		if (unlikely(!req)) {
-			if (!submitted)
-				submitted = -EAGAIN;
+		if (unlikely(!req))
 			break;
-		}
 		if (!io_get_sqring(ctx, req)) {
 			__io_free_req(req);
 			break;
@@ -5272,6 +5269,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+
+		if (submitted != to_submit) {
+			if (!submitted) {
+				submitted = -EAGAIN;
+				goto done;
+			}
+			min_complete = min(min_complete, (u32)submitted);
+		}
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
@@ -5284,7 +5289,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
 		}
 	}
-
+done:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);
-- 
2.24.0

