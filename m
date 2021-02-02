Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CED30B414
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhBBA0T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBBA0S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:18 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349BDC0613D6
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:38 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id m13so18566597wro.12
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zzXH2dUcSc6tPQjcDzuISAM1640PU3c18zS4EiqrSMk=;
        b=aU4X+zsQUuwe9W8Kl4RxeV+4RcXnDfcYe6U+SVqOVhsnOE4ZvlwlAzw6zPiQZGKQeY
         bOB0pkjtoUaZkMnshsE/P8XA5PokEMfxvr+wuyiNss3jUv6h4vxwimmMcLQ8p/aFFrT0
         j4Qq+aZEhh43k4hn43BYJec0Qhk+vn5KOVN1Ub04CPbnocOTjfMQELFWo3e7sNAVrgG8
         nX+Rt7feHqesJE3JGVHs4xCR+l5bxP4sb2Wcv3TQgJBTqbtZGG4z0J92v3mrCwQa7Jcj
         PbJ7eWpuZhjP3YdRnnHhF3YpeqndvxeLpo+Ot35Q+uuqEne0vuIE0Z1D792qJRzXKcAa
         ruyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzXH2dUcSc6tPQjcDzuISAM1640PU3c18zS4EiqrSMk=;
        b=LgydBFIU8wDAvthQ3lscj4IduYel5TVbHdLTE6vEvxMnhYl8esnV37tmdOMuiZebm/
         qUeEHSLhZEOhPKmyxn1ppjy6Xlz8GaJLpjCB5VaHoL0e+fjz5vvYT6NhwvKfbFO4C2/u
         q+ZbWDj8apIKVPDhzTXsuN3ZjsFF4Y2cAKxhH8fYKDh4KKBGKn/UaKZad+ghUA/ehBKC
         dxH8Edv8/lxwh94LWzNolwkOyF2IGepFYE+Uj67ko8eJJKg9R2GBp5GwF5ydMVrkrV/f
         zYuVReeXS6taEb+caJeEvHGhuVXlJ0tnGXGG26wF1T8jDauoVwT+NK7CgsmbH7egQori
         4YpA==
X-Gm-Message-State: AOAM532saO8tmZtpz5GJ+CmMicMi/tk4u+IQgThTsfjjq20IEepyHewY
        HPiWY2Tt9SSRj4tq3+gEF6ZiboX1f5U=
X-Google-Smtp-Source: ABdhPJwpZdsNO7MxGsDroScF5E23SDJR/kBSKZOnbpBSZHN5HAy8sMembxXwDqR+sTCZlCQIUnCNUw==
X-Received: by 2002:adf:f307:: with SMTP id i7mr20319710wro.367.1612225536985;
        Mon, 01 Feb 2021 16:25:36 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/8] io_uring: refactor scheduling in io_cqring_wait
Date:   Tue,  2 Feb 2021 00:21:40 +0000
Message-Id: <0322df69e7171d3ad659dff4579687d629b4e16f.1612223953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
References: <cover.1612223953.git.asml.silence@gmail.com>
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

