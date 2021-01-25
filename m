Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15831302160
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 05:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbhAYEu4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jan 2021 23:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbhAYEuz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jan 2021 23:50:55 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22F2C061573
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 20:50:14 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id i5so8120883pgo.1
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 20:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=u+ozg2KNyU2Bm32ky51PUNf99PBhAFafw9fJm016lpQ=;
        b=w7JFHynqUEYwILbOXyZ1g7pFzqM34cqMEEz1jR3z2HDMfmhs7+bJC/I5Ag/oGdpcTx
         Elu3l9XhMxbt7p9thl2IFTl5iZDEMXk266d1suTaFbYNOroGpYs1mNYHQEAEzMrdODOJ
         LWs8lK8qjO6PtsFLyzuxViLw7ZPp/t8qloDo5WRbmiZOk3ivIrbwvc75FFJPuzmxP6cE
         FWbkn1U/3DZEHehd7pbWEt3eSQ8UvKuskIBKS475ew5SKHxNq1shrlZhl07LjnAHmV2Z
         24XH9XKxPPZoWE6sR1gQX4vT1DRRSID34sUVGpKsezvhd657KL8X5X5qzY6rDJrZM6xc
         K9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=u+ozg2KNyU2Bm32ky51PUNf99PBhAFafw9fJm016lpQ=;
        b=b8LVikjavevhyJj1VuiHGH7xoLhTJUhXCLikGeo73hoZLnY0lfSC3evNGMRGcxReU4
         ZXnyzmHLOp52NOB2utXGcKr4hF7NH4wXrUEWmAT4KO2kYzjyyXfbCRA3GMXoWOw1utiY
         6PVDK80rNdHMpLVSibfuc53QmuWAklrergFDJIaXr9pU0DF6N75uBS/3DmwgreMAuIaH
         ruMBLWvtDqAGpyqqQcPy37SpFfgiaHVFNw1xKapibHg3UnswMBojkzQRMUBV2v20LY6I
         m2o06Ctp0BeG2mm11PjgfjINiVlRCein5MdVYg3Dl3/UFULZx2/Gh1CfPgXfjin2mO+/
         Q4dQ==
X-Gm-Message-State: AOAM5302sNgg4pvaWSaQuhIUq+GKHXOGqLcJE4XwWOPWytKIW/SeOO0h
        Di7rRf27rwtVgN9cqtzV8ULOv2RxgaCG5Q==
X-Google-Smtp-Source: ABdhPJyz6uJnLtKZqgsJFQxBldTHQGQrfaErNGiNjqgmzMwVjp/OkRgJdkRgfgZlLj1f/XQtHGtfLA==
X-Received: by 2002:a63:a12:: with SMTP id 18mr34793pgk.140.1611550214067;
        Sun, 24 Jan 2021 20:50:14 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id d10sm14823647pfn.218.2021.01.24.20.50.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 20:50:13 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: only call io_cqring_ev_posted() if events were
 posted
Message-ID: <84f8db0a-0e90-9ca8-1834-e3c805ebb98c@kernel.dk>
Date:   Sun, 24 Jan 2021 21:50:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This normally doesn't cause any extra harm, but it does mean that we'll
increment the eventfd notification count, if one has been registered
with the ring. This can confuse applications, when they see more
notifications on the eventfd side than are available in the ring.

Do the nice thing and only increment this count, if we actually posted
(or even overflowed) events.

Reported-and-tested-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 695fe00bafdc..2166c469789d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1779,12 +1779,13 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	struct io_kiocb *req, *tmp;
 	struct io_uring_cqe *cqe;
 	unsigned long flags;
-	bool all_flushed;
+	bool all_flushed, posted;
 	LIST_HEAD(list);
 
 	if (!force && __io_cqring_events(ctx) == rings->cq_ring_entries)
 		return false;
 
+	posted = false;
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
 		if (!io_match_task(req, tsk, files))
@@ -1804,6 +1805,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				   ctx->cached_cq_overflow);
 		}
+		posted = true;
 	}
 
 	all_flushed = list_empty(&ctx->cq_overflow_list);
@@ -1813,9 +1815,11 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 	}
 
-	io_commit_cqring(ctx);
+	if (posted)
+		io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	io_cqring_ev_posted(ctx);
+	if (posted)
+		io_cqring_ev_posted(ctx);
 
 	while (!list_empty(&list)) {
 		req = list_first_entry(&list, struct io_kiocb, compl.list);

-- 
Jens Axboe

