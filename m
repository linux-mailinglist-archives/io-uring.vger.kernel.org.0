Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BC32FBA85
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391762AbhASOzo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 09:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394463AbhASNiF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 08:38:05 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B96C061795
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:43 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c124so16483805wma.5
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 05:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Y+CUjGduMtmbcDyNvW6X2Kezn910c3L4r1bKCai2S4A=;
        b=cItWf7mHhUuoarKT5Rplj22xdGqdP7Zke0a68ZfErhIER7Ar3zAucQNJeDIUOlkYFR
         vkUx5CU9eHmPCYbR1qZgjiG+wDlVegmjz9im6LC82NeurL6FD6BUyoFZGU3gZwAhge0G
         /l8xZJzzfOk3O5f/sOqP51RxURpCfS8g1Vi3zkpR9ASPevGqYoClpYWUxiAu3l8TjjE7
         jfHV5ItD9Oaa9X2pIMnN0b4LbApM7zfpbt4Oaqce09+W3Da/T4ltZibqel7OH9RfC8mU
         4c1oKbsKsHUdjJLIjT9i1qV25gp1BkP8u28JGGNv6oSV0D3G8LDlIC9Pjor4mv8FwYhT
         er4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y+CUjGduMtmbcDyNvW6X2Kezn910c3L4r1bKCai2S4A=;
        b=LNLQQyUmOmOs+/shtohNlTMZy7Ybz+ywzsTd7XWsw5AJhmo3GpKohhe3wDarJu+xB/
         yqVhWcm4KrXBQ3BDbLrU1akfVpSprI/NrG7l8RLsutoznj3QduSq9AHLdLQPCrfq9AqE
         XDPpkSRlz8MIx6lTlPu5PRwG1swiLzmxPab7OcTBL/VBNPROvCuHnRXz3c/TRIPDtvZv
         W7s/iSyfb1IKo5Y69RzZ+nSUR7o0jpmg2saMYJza0lbDJolUYEh6TfBZzlsUJ8CGcXit
         3ckVi2E/n7SCUOg0H1BovBcO8E/enbUSkFqJpuYUWP5H1hAQ7fRz64fMxABqGj82T5H5
         YBVw==
X-Gm-Message-State: AOAM532BDchEUn33f2LBQBPI+AFP4Gb5fdCcoe36QNzfCHmhXIHXzOCA
        E1apOh7LHkZL2pnoeeV/bDfOTup3glQzkw==
X-Google-Smtp-Source: ABdhPJz7t2ZtcdGRgvDNl6RznEIXzw6c9qsl+1SJpOGv/G8m1jYdCzkGIWC92SLeDBd11r3dqRxR5Q==
X-Received: by 2002:a05:600c:20c6:: with SMTP id y6mr4076575wmm.97.1611063402306;
        Tue, 19 Jan 2021 05:36:42 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id f68sm4988443wmf.6.2021.01.19.05.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 05:36:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/14] io_uring: add a helper timeout mode calculation
Date:   Tue, 19 Jan 2021 13:32:44 +0000
Message-Id: <94cb8adc214f838b69175cbe678cdd9994c47f59.1611062505.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611062505.git.asml.silence@gmail.com>
References: <cover.1611062505.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Deduplicates translation of timeout flags into hrtimer_mode.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9720e38b5b97..a004102fbbde 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5744,6 +5744,12 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 	return 0;
 }
 
+static inline enum hrtimer_mode io_translate_timeout_mode(unsigned int flags)
+{
+	return (flags & IORING_TIMEOUT_ABS) ? HRTIMER_MODE_ABS
+					    : HRTIMER_MODE_REL;
+}
+
 /*
  * Remove or update an existing timeout command
  */
@@ -5754,14 +5760,11 @@ static int io_timeout_remove(struct io_kiocb *req)
 	int ret;
 
 	spin_lock_irq(&ctx->completion_lock);
-	if (req->timeout_rem.flags & IORING_TIMEOUT_UPDATE) {
-		enum hrtimer_mode mode = (tr->flags & IORING_TIMEOUT_ABS)
-					? HRTIMER_MODE_ABS : HRTIMER_MODE_REL;
-
-		ret = io_timeout_update(ctx, tr->addr, &tr->ts, mode);
-	} else {
+	if (!(req->timeout_rem.flags & IORING_TIMEOUT_UPDATE))
 		ret = io_timeout_cancel(ctx, tr->addr);
-	}
+	else
+		ret = io_timeout_update(ctx, tr->addr, &tr->ts,
+					io_translate_timeout_mode(tr->flags));
 
 	io_cqring_fill_event(req, ret);
 	io_commit_cqring(ctx);
@@ -5801,11 +5804,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
 
-	if (flags & IORING_TIMEOUT_ABS)
-		data->mode = HRTIMER_MODE_ABS;
-	else
-		data->mode = HRTIMER_MODE_REL;
-
+	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
 	return 0;
 }
-- 
2.24.0

