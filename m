Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BE3468B6D
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 15:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhLEOmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 09:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbhLEOmp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 09:42:45 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC9CC061714
        for <io-uring@vger.kernel.org>; Sun,  5 Dec 2021 06:39:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v1so32436023edx.2
        for <io-uring@vger.kernel.org>; Sun, 05 Dec 2021 06:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pBDiJuBesGkI/74BWQjzmA+8NCGeoGwJJacLXJ58R1o=;
        b=jGOSuNuYca6ZsnzxTkgB2U4/5Andyl/1yJkAimrS5DSOreM1Dd3oj5ISHDLZsJp7dK
         IlxO7pMaZbpxgTSHejMgj/yLX7rNQFP1uUcSwg6x6LV8kiW8X/TNkwKgFErJlQeJXLQ9
         cZtMaXv78+NqFusoEjkAwv1bf5aQpPxXRLdy24ln/NRKUdCrJVrhL6J+X0HSAsjbGiff
         xBX842OElkl33DKP5WfdvWVo6Os3C6K0cf/7Wkwc8vcaZYcFw30YmNnmV4M4jzPWx2g/
         lbdXDvO/utoOSw2x+Tf0r6xAt56oH6pjB3bgJg7hJgmBqW8kuohywtAyvul0+oNNtXC1
         y2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pBDiJuBesGkI/74BWQjzmA+8NCGeoGwJJacLXJ58R1o=;
        b=eiU/tfPS9u/VdH40/qsMBCutx6aChDdb0wU/FJZT0NIlYRxApf0P3+pRavDpXX2eWZ
         cUGnX0VyaPJ/hneteo7hLtbTHHnAWnmswLed+wc4FhNK3QTjdTe6nVA25p7sYXNHVTE7
         KYbxWVnPae7qvvoFcdclc+p8vGE7xFGlHv7fB3CAVzAQuxQe+pQtE1uU9jz0CAZKfkWj
         zUrnyjsapzum8QHsHT2UXoWCPmsNmSMUUutHKJOxAQbl1lqOKoQk6HFyB0Z6JMqaNweC
         MLGSqeTjqhfM17oak1uGPViFoxslpNI8DW6nLssa3qQ2Kzrn3nTTd9gv80jSDvleoyX1
         STUw==
X-Gm-Message-State: AOAM5334gMEDSSdH4eRlkszpnk+QDHuJRQXLFYkW6vQhmVy9NFw8HRx0
        VhUpQj+pHp+HiK90HEpOEU4nP2FO+Gg=
X-Google-Smtp-Source: ABdhPJw7bwCHDGX4tHUUfpq+eMLeASmjpB9ySxlhR534GA6K+PA1I0zhrav4NTGIKrpazvHDGB3dyg==
X-Received: by 2002:a17:907:c0e:: with SMTP id ga14mr38487711ejc.26.1638715156136;
        Sun, 05 Dec 2021 06:39:16 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.50])
        by smtp.gmail.com with ESMTPSA id ar2sm5224935ejc.20.2021.12.05.06.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:39:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH v2 4/4] io_uring: reuse io_req_task_complete for timeouts
Date:   Sun,  5 Dec 2021 14:38:00 +0000
Message-Id: <7142fa3cbaf3a4140d59bcba45cbe168cf40fac2.1638714983.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638714983.git.asml.silence@gmail.com>
References: <cover.1638714983.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With kbuf unification io_req_task_complete() is now a generic function,
use it for timeout's tw completions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea7a0daa0b3b..1265dc1942eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5953,15 +5953,6 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
-{
-	struct io_timeout_data *data = req->async_data;
-
-	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
-		req_set_fail(req);
-	io_req_complete_post(req, -ETIME, 0);
-}
-
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -5976,7 +5967,11 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 		atomic_read(&req->ctx->cq_timeouts) + 1);
 	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
-	req->io_task_work.func = io_req_task_timeout;
+	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
+		req_set_fail(req);
+
+	req->result = -ETIME;
+	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 	return HRTIMER_NORESTART;
 }
-- 
2.34.0

