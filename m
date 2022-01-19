Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A900493314
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 03:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351048AbiASCmu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 21:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351045AbiASCmt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 21:42:49 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFEEC06161C
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:49 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id i82so1092929ioa.8
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UsLJjNEyTCtuxLztO4+4TNxfRVom4/pkvewZLCOxBkw=;
        b=bYSZIEb7FB6Ot7MRAFRP570hXjHEbRNUHot862ij5XTdOyrx885/vnxWZO57qLbdMW
         n0DpcEcgpFvK43snwbdg+x/9Nk4HQ9pd08buF6Oh/c4cOEWZE/8kKhVHPzs3SFZVqUNr
         4LrecWkTyf/Soau8kY6vocbewAQy2+tXVssM0wUPSZAufGp2nfqxcJydNCPjvAKgEC2h
         Hb32ASeBY2nd3dIw2hf/ls5S/kW95elGB0y4utH4b123rDKrJcwqLp554Bu6WrxjBSCY
         x96XQiKsBTXZjNHDR/ke19ROpwhxKRfzzxsyAdgzNi7Fl91zfPOpWybZFIQ/moTmBn7Y
         6DWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UsLJjNEyTCtuxLztO4+4TNxfRVom4/pkvewZLCOxBkw=;
        b=PmLkxMeG9rebjeVFpVGALCEciJdMI60DtwJQ87xZ1khsrVJ5nwF4uPCa4ztG1OKYv8
         fkSxJbqOVRuMdLcHW1QHIbRWz7wIx+f/vPUcg3Q8mUhi3u0J/75OBNhTdJVs9LAmZ1uz
         AA6GVA6iD3A7a4qi62rel/IbxsBC8g71MaBimQU9pnmkCG3MVvgY+6RQ4ddLjqWbpk/l
         MVcprrU8plgWd5KaJ8Ix/BJNGJnRJLDe+2b9d+jnAOrgJwpQh4kvvIFAqcSZNmzETVsE
         wlVH7K2fQAaBdL3FFQx5CQsa6CKNGJUeW9v51prdeTpb1HtysglwtaLY+PNqJWbxzCOR
         txuQ==
X-Gm-Message-State: AOAM53372EB1JRNz1n3N+LAVPd1eiYMyxotQ5D2sukaJsK6Itgqzinp1
        G4zhZS3u8jDFrbXGabY15FmKVk9QcL4L6w==
X-Google-Smtp-Source: ABdhPJxYKreHLXZuLa8F+UJ9pVBz8yUqg62HVasav/+hrkGiEXJ6cAPkYfXladN+9DIocxQMOHU2OA==
X-Received: by 2002:a5d:8d89:: with SMTP id b9mr13596731ioj.205.1642560169071;
        Tue, 18 Jan 2022 18:42:49 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v5sm9863704ile.72.2022.01.18.18.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 18:42:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Florian Fischer <florian.fl.fischer@fau.de>
Subject: [PATCH 6/6] io_uring: perform poll removal even if async work removal is successful
Date:   Tue, 18 Jan 2022 19:42:41 -0700
Message-Id: <20220119024241.609233-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119024241.609233-1-axboe@kernel.dk>
References: <20220119024241.609233-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

An active work can have poll armed, hence it's not enough to just do
the async work removal and return the value if it's different from "not
found". Rather than make poll removal special, just fall through to do
the remaining type lookups and removals.

Reported-by: Florian Fischer <florian.fl.fischer@fau.de>
Link: https://lore.kernel.org/io-uring/20220118151337.fac6cthvbnu7icoc@pasture/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 422d6de48688..e54c4127422e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6386,16 +6386,21 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	if (ret != -ENOENT)
-		return ret;
+	/*
+	 * Fall-through even for -EALREADY, as we may have poll armed
+	 * that need unarming.
+	 */
+	if (!ret)
+		return 0;
 
 	spin_lock(&ctx->completion_lock);
+	ret = io_poll_cancel(ctx, sqe_addr, false);
+	if (ret != -ENOENT)
+		goto out;
+
 	spin_lock_irq(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	spin_unlock_irq(&ctx->timeout_lock);
-	if (ret != -ENOENT)
-		goto out;
-	ret = io_poll_cancel(ctx, sqe_addr, false);
 out:
 	spin_unlock(&ctx->completion_lock);
 	return ret;
-- 
2.34.1

