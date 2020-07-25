Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B3D22D71E
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 13:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGYLoC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 07:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGYLoC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 07:44:02 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D911C0619D3
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:02 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so12489354eje.7
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=siucFBffCucr0sTHAaz41rUxPS3Q5trrDLF/bepug3I=;
        b=ps0KVdq/ZDpPuiU/IK7UJY+tHaGgevlCfWd3jIkHUVJLr6HITijRCd1O5ddeR4EKz2
         4FyaFOmXWpIOmHuo3CXJV8S6PM0OH9X5XEjZo53cswZXkfdDUffEAcQyhDi5o6gQys6Z
         +ftO0tMr/Xu6+eiLW4COnKWK03mCASVAna36w9FLbRkzwTBh0I3E2DBpnJZ0MwwkkegX
         S66+2QGn2WPI+e+8XPeKtfskzlpoi5tSFjzKrDL2O9fet2bp5LcE1M3VQVdEXAcxsdDL
         7XmSGu0DX25jI6Duz1nRwFoBa6RHml7Zz0U3c71IecRjp3/KoHFHVnaFumID7bTHZ6bw
         l6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=siucFBffCucr0sTHAaz41rUxPS3Q5trrDLF/bepug3I=;
        b=J1I9oXa/EUF7RV9gcPv4Sgqto2G+I+3lj3l36C8HA+ymokfpEoY6laiU8C230bycxH
         zQUgDuZbSqRulsgBi7gf16e8oRNKVZER2+BgDDQm0aalHFtyzAUBJ53RltbskYQS2np5
         f28ICKIKrlGpvX2XHzzFh8bTWblYdVbhrmoAOPpoj5VvUQP42bc3jhOPLZXKRY47X5gd
         VVlyVRejTd1ntN7KgaNwc3vxYWs40aiUi0ojx/UXlcMgEMpEODNpTZGHRmdQehs2ACAr
         B6FDHOfNq7/2kVcJBuNWGlOIEz4ESU/p4wuLw5SafDZKp3xbTVHAxKV9HWcIlXtUxGcn
         DDug==
X-Gm-Message-State: AOAM531g5mPB6Wmm2qsW6HTMQszohkeziTKolE9VMZACUn7bnjlgEzlY
        ph+ROtz4ck3+kVZ/VpL2e2Y=
X-Google-Smtp-Source: ABdhPJzul+8MwYjFG/cxzLMVH29+NsiR67KEeGUecVlvMCmd0/jHXbdEkl2KUp2hwKNDTp1zo+a74A==
X-Received: by 2002:a17:906:8595:: with SMTP id v21mr13695544ejx.333.1595677440866;
        Sat, 25 Jul 2020 04:44:00 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id i7sm2743601eds.91.2020.07.25.04.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 04:44:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: fix missing io_queue_linked_timeout()
Date:   Sat, 25 Jul 2020 14:41:59 +0300
Message-Id: <9408827d175b704f27a7577f8d12e755f9910162.1595677308.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595677308.git.asml.silence@gmail.com>
References: <cover.1595677308.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Whoever called io_prep_linked_timeout() should also do
io_queue_linked_timeout(). __io_queue_sqe() doesn't follow that for the
punting path leaving linked timeouts prepared but never queued.

Fixes: 6df1db6b54243 ("io_uring: fix mis-refcounting linked timeouts")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 59f1f473ffc7..3e406bc1f855 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5987,20 +5987,20 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		if (io_arm_poll_handler(req)) {
-			if (linked_timeout)
-				io_queue_linked_timeout(linked_timeout);
-			goto exit;
-		}
+		if (!io_arm_poll_handler(req)) {
 punt:
-		ret = io_prep_work_files(req);
-		if (unlikely(ret))
-			goto err;
-		/*
-		 * Queued up for async execution, worker will release
-		 * submit reference when the iocb is actually submitted.
-		 */
-		io_queue_async_work(req);
+			ret = io_prep_work_files(req);
+			if (unlikely(ret))
+				goto err;
+			/*
+			 * Queued up for async execution, worker will release
+			 * submit reference when the iocb is actually submitted.
+			 */
+			io_queue_async_work(req);
+		}
+
+		if (linked_timeout)
+			io_queue_linked_timeout(linked_timeout);
 		goto exit;
 	}
 
-- 
2.24.0

