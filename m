Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04CA171543
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 11:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgB0KnR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 05:43:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728844AbgB0KnR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Feb 2020 05:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582800196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IrJcrhhYfiQc6y8fLPUb1oRUTJ6Fmb0iUUMWLAOf368=;
        b=TK1ucRWLSNFs+lI7ePwAHVu+01DgmsszXJ4rAA+5769L6BeJEqpZrV90XF5rrPSrZZSrqC
        uSipvkitAyXiKmyXUOar1KO2/9zVa7Sabbu+p5zK0L9x1mjdd8jEez4mcuXj2+Po1s4A7m
        062cUXR5OcYlVf/E0oFs5gFAQv7iWaE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-eHEyxOasPZCirqdffbqp6A-1; Thu, 27 Feb 2020 05:43:14 -0500
X-MC-Unique: eHEyxOasPZCirqdffbqp6A-1
Received: by mail-wr1-f70.google.com with SMTP id n12so1122149wrp.19
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2020 02:43:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IrJcrhhYfiQc6y8fLPUb1oRUTJ6Fmb0iUUMWLAOf368=;
        b=JAG9Jmy26Y+HFtyEDTfEpvwXY4KEPkCRzYWc/zlgxjD8LaAd71PEQjKkpjxvGtJmVq
         Nj29XBfg3nAfhRpRPKDXV901yTOyDOXDJG0aBK7zaFeFmjqEYiB/T5FkT2VLfNMp9nJ1
         5Qfv7xpkAfcBgai+gQQzVUjGGQG3MK0cPV4tQXr5OHszq1FS5RX1BqoY0ktk5It9e7dR
         1xpC/Ik7QN+T2NMtkvassL71NJxt8KHPHsyfiJQ8tinjud8JRFqDIXWMeHuF7si/RWdD
         cwchSE33ZFmfkjCT60wE7ocqvKUsfqLffMqAx4jcJrGRQL4uaQOOmTAoZau+ZUQNUGFD
         TfdA==
X-Gm-Message-State: APjAAAViCgYGreNQ+M5iMNb98CZponitxrQ/zhhlIaTUz/J5Ecww02Lc
        G3DQXLgsYSHcqzlSMZVR77c6VsI3Qs2pF7cC9U0EChDsSoRj+ZW9OOzP3IGxn42xXE5trBJWLpd
        R84blxumiBaO78K3sw0U=
X-Received: by 2002:a5d:6a8d:: with SMTP id s13mr4345564wru.55.1582800193459;
        Thu, 27 Feb 2020 02:43:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/Fgr41aGA87g7TTMig1Q0RU/cjHCqHP5TMJnPt3+vt+sWz2gzoHa0qjaXIj1I4SNYz2NVAA==
X-Received: by 2002:a5d:6a8d:: with SMTP id s13mr4345536wru.55.1582800193207;
        Thu, 27 Feb 2020 02:43:13 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id m19sm7171101wmc.34.2020.02.27.02.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 02:43:12 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, io-uring@vger.kernel.org,
        axboe@kernel.dk
Subject: [PATCH 5.4] io_uring: prevent sq_thread from spinning when it should stop
Date:   Thu, 27 Feb 2020 11:43:11 +0100
Message-Id: <20200227104311.76533-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[ Upstream commit 7143b5ac5750f404ff3a594b34fdf3fc2f99f828 ]

This patch drops 'cur_mm' before calling cond_resched(), to prevent
the sq_thread from spinning even when the user process is finished.

Before this patch, if the user process ended without closing the
io_uring fd, the sq_thread continues to spin until the
'sq_thread_idle' timeout ends.

In the worst case where the 'sq_thread_idle' parameter is bigger than
INT_MAX, the sq_thread will spin forever.

Fixes: 6c271ce2f1d5 ("io_uring: add submission polling")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 709671faaed6..33a95e1ffb15 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2740,16 +2740,6 @@ static int io_sq_thread(void *data)
 
 		to_submit = io_sqring_entries(ctx);
 		if (!to_submit) {
-			/*
-			 * We're polling. If we're within the defined idle
-			 * period, then let us spin without work before going
-			 * to sleep.
-			 */
-			if (inflight || !time_after(jiffies, timeout)) {
-				cond_resched();
-				continue;
-			}
-
 			/*
 			 * Drop cur_mm before scheduling, we can't hold it for
 			 * long periods (or over schedule()). Do this before
@@ -2762,6 +2752,16 @@ static int io_sq_thread(void *data)
 				cur_mm = NULL;
 			}
 
+			/*
+			 * We're polling. If we're within the defined idle
+			 * period, then let us spin without work before going
+			 * to sleep.
+			 */
+			if (inflight || !time_after(jiffies, timeout)) {
+				cond_resched();
+				continue;
+			}
+
 			prepare_to_wait(&ctx->sqo_wait, &wait,
 						TASK_INTERRUPTIBLE);
 
-- 
2.24.1

