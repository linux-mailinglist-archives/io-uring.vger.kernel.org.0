Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B19630F465
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbhBDN6e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbhBDN4w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:56:52 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF2FC061794
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:01 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id z6so3563730wrq.10
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zzXH2dUcSc6tPQjcDzuISAM1640PU3c18zS4EiqrSMk=;
        b=Cmin0+NyPC4JiUTupN+ZdnJT8t3zRICZh03JzS38TMPPgR9Wi0J9PHY1z+btcnG5dz
         7huwU4/DIARaG9nxYQJGCK6Kcg/HMJFA7ZjsDjsoKvmExIxU3b3tWf7JhBL5MG8j/Mg9
         vFCOpX0rGz9PdzMA9MdwsaT7h8CzwhechFm0teVN+8otqwRUKcCgPtwY2OEeWMc6+wsP
         ffTdszme2y1r1GdiRWsbsg73oflkD7/z87xRjLEZJUGrSw+or95qAmAzfVWNDfHKKEKq
         GeBAxfm21rVxQ9PdzyXgEpbLTAoEU37lgd0C9sOpZAOS1rb99anb937799wYJUtmWwJp
         btSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzXH2dUcSc6tPQjcDzuISAM1640PU3c18zS4EiqrSMk=;
        b=Qe1Akxvsq8B4iNgakMyTdGQSB6PRg45XrYmKNE0iMJ9JocUwM4xBkAozmFj7LCHqnD
         De5UCLy/84GLmj/K46CXgEOulE6hMHu9VW/uKynJACeJ1QlI35JDwT4PM5WXQRgoEDiA
         sra6XvjP4q0JLFo7z1SCo7Q3L7Io31Vf2QqsaXvAMdnVSQAXBijcZLyTLTzfWvwXrxKe
         wZXlXoC3ET7UhncxTvJOs2NpNu8ovrubwo/iiYN54oJUiy1iVbrGsdba11aKO7AvoIho
         F5oREsN1O6E0q9XnEvDUfrsuCQKuxjZfGwpLV9zie9yUHk01jGXXCnxJmNkWwJDWQu95
         gsvg==
X-Gm-Message-State: AOAM532rJRh2yvKGZ9O3BCci6wkV+QOe82/TA0QFCEs5G1p3nsWgmFoy
        mAj/hpsvQiL+YGkFvHvaaeqDqsdhYQ+CmQ==
X-Google-Smtp-Source: ABdhPJwTe6kSFy8wLakUz2HoznZK8auCdCkEOvwCuMtew+LDb/BCms7ZFrtFFyGW1t7eizNJ6TnmPA==
X-Received: by 2002:adf:fc88:: with SMTP id g8mr9248101wrr.259.1612446960484;
        Thu, 04 Feb 2021 05:56:00 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 02/13] io_uring: refactor scheduling in io_cqring_wait
Date:   Thu,  4 Feb 2021 13:51:57 +0000
Message-Id: <5e57cb0908b3b94f0ea74d8f9bb31e708f68a975.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

schedule_timeout() with timeout=MAX_SCHEDULE_TIMEOUT is guaranteed to
work just as schedule(), so instead of hand-coding it based on arguments
always use the timeout version and simplify code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a750c504366d..5b735635b8f0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7213,9 +7213,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		.to_wait	= min_events,
 	};
 	struct io_rings *rings = ctx->rings;
-	struct timespec64 ts;
-	signed long timeout = 0;
-	int ret = 0;
+	signed long timeout = MAX_SCHEDULE_TIMEOUT;
+	int ret;
 
 	do {
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
@@ -7239,6 +7238,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	}
 
 	if (uts) {
+		struct timespec64 ts;
+
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
 		timeout = timespec64_to_jiffies(&ts);
@@ -7264,14 +7265,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			finish_wait(&ctx->wait, &iowq.wq);
 			continue;
 		}
-		if (uts) {
-			timeout = schedule_timeout(timeout);
-			if (timeout == 0) {
-				ret = -ETIME;
-				break;
-			}
-		} else {
-			schedule();
+		timeout = schedule_timeout(timeout);
+		if (timeout == 0) {
+			ret = -ETIME;
+			break;
 		}
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
-- 
2.24.0

