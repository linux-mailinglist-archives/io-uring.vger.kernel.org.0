Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08720333D85
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 14:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhCJNSK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 08:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhCJNSA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 08:18:00 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53129C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:18:00 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id l12so23260575wry.2
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 05:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3U46CIycAQEjIF7HUjoPCoXy6J5B+eHyNGjsMCAfqsY=;
        b=EckAZkHw9RKdLCKLHzZhMyTqHt8w3iAwghGzShP8diylPVQzP9MmY/uK7zwWvXpJo0
         u7+BAs8sNYK+qIyDvDffPUEqkl+5xK9IB4LaLH80F4DHiyC2vol55ZkuxoxBm6191R0Y
         pf//gwFo74fa9sIx2XtSkGvDUIv3pWoFyUvh5gNgHm1xTKrBgBHBRJ6viGK5Z7GpjaCk
         YJj8RuELiZJovR0fqEoVqOQ9oAsF3C2w2CKiVTwLj00Xy5vzQMGOBzzEur/BSYXLPgEA
         g3M8ywP4+E6/2pfHmX7S7/GrVrMzRgnHQBucHx3KyJ7Td1S3JdCH9mtOrxZz27qB141p
         7aAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3U46CIycAQEjIF7HUjoPCoXy6J5B+eHyNGjsMCAfqsY=;
        b=t3Eg62mUTNRRHKi1plUSrbbQeArk75LrBpvuG/RSqnS+IJBi3ocdJC3hziT46e2uNJ
         IlhTTNawVTOXLr0qWsxp1/sg9OCmlmR5V+xQ1M8J8tuBwx938qADPsQauQTduiHDMNCW
         9KFuhcBxRKdJK4yJe72C6vSaUL86zuc4s7Ap2CTc9i5bPh8kdkdGb4BZ2vV85VIAjvhI
         PVmKDf6fsjs18Ue3XWWC/Q9Rypgxj18zrFaxWJyascJs1sUn3WljJ3nSixrTDg3zT7h9
         yGetMpWwGYIm91ZQozaP2uQqYWCaFovLsuPtU3kFijKiz2VnJN0QWN/1bsHqILoyvCLt
         7x4w==
X-Gm-Message-State: AOAM530RZrmwRY+tVB65NSf5QHMBQlNlfmdDbBSzClgBiDBGXFX++3wJ
        rD4qVWZZS+4TvnusS9k6tEE=
X-Google-Smtp-Source: ABdhPJwSm9wqDRYyS6cmMujCW77IT8nAwiFB1nd125798pj53zFwIY7yk+xs+k6tALXU9O/i+zR2uA==
X-Received: by 2002:a05:6000:1363:: with SMTP id q3mr3540176wrz.74.1615382279192;
        Wed, 10 Mar 2021 05:17:59 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id u63sm9328004wmg.24.2021.03.10.05.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 05:17:58 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: simplify io_sqd_update_thread_idle()
Date:   Wed, 10 Mar 2021 13:13:55 +0000
Message-Id: <6982cecd8d4d1493894dbe41f774651891020528.1615381765.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615381765.git.asml.silence@gmail.com>
References: <cover.1615381765.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use a more comprehensible() max instead of hand coding it with ifs in
io_sqd_update_thread_idle().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2a26faa3bda..42b2ba8e0f55 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6621,11 +6621,8 @@ static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
 	struct io_ring_ctx *ctx;
 	unsigned sq_thread_idle = 0;
 
-	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-		if (sq_thread_idle < ctx->sq_thread_idle)
-			sq_thread_idle = ctx->sq_thread_idle;
-	}
-
+	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+		sq_thread_idle = max(sq_thread_idle, ctx->sq_thread_idle);
 	sqd->sq_thread_idle = sq_thread_idle;
 }
 
-- 
2.24.0

