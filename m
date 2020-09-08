Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3589426181E
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 19:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgIHRtC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 13:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731755AbgIHRsV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 13:48:21 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC8FC061573
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 10:48:21 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j2so237457ioj.7
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 10:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BTI+F5yceSr0OqtSyG95Y54U3M0mVX50CFa1xQon8tM=;
        b=hg+2ZZoFQzMEZ0qD7aOfRYMl9/001K3dAAXwRgb1OgoJv7YAuGZCBxokpBDFhwzny0
         6IbHg0PZ3KJYnCcnyptVxOAOus/eKD0nM7gb1Kbfq1UfYKzhDsOqLL/F7kuRmKJabjuu
         v2F+qiVXR3BkIBlXee0FsZMsNPJJ/2STXOSou1L47PPqa2Dk2OyV+179ZQ4YspQnpK3g
         bjh+0idfi+OuHUU9lDcabNdL0CveMOD2ptPxZ623MtGg4+DHBqfPLs4tAYqHXi3OS3bX
         8mzTrdN9tzcmN4FZXvJh1MBZh9sbynyb9aTvIiGPeLEdt0HqF5OeCnU3z+YaX6HWIE/N
         JZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BTI+F5yceSr0OqtSyG95Y54U3M0mVX50CFa1xQon8tM=;
        b=opHrCrdpSxmOor99i4MHpJ77cw5YWu3SRAkhHL6p7PMT4iYcerEZVokG1c07dvPRzm
         X53jqkPVCPiV+Jid+sOLRcIyaPcLc71QOpOQ4ZsA/g4beOKj5hNUphTSatY5LgX8MZqN
         YVNQmXYKgEnC5EN20rDuEUvMDLuuyoIQQ6O3mXs4cvAwULeRJ+E/FMNhHNiwPVol4RWI
         JoSqePtULxRqjFo95dubOOo4bqwov6pFCHkJwfXIFmZUh4q8Us3B75Q/kVl9davFbdtm
         FphN5ndxv721/hq7DQiNL4vRTmZm23XiaSiea3H0lg3DWX9YeQY/fbnzvnPENW5L8DOf
         aDgA==
X-Gm-Message-State: AOAM533iNa7SWLTT0CS9UgFuIIqXUUxho0y0PGRu0ZhXMQrWHkaNXDVA
        gwQYli2FyH7pNNh4LHCadc0/8dh8Vo/fyQPA
X-Google-Smtp-Source: ABdhPJxE7tYWEFHyc7AeuMp0+4+fy4OTcOcY5IerYNEKIKIguVcCp4JDFKkSIM7caqsFCMFxBi887A==
X-Received: by 2002:a6b:6309:: with SMTP id p9mr28333iog.78.1599587300647;
        Tue, 08 Sep 2020 10:48:20 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s85sm2645774ilk.35.2020.09.08.10.48.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 10:48:20 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
Message-ID: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
Date:   Tue, 8 Sep 2020 11:48:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
the ring fd/file appropriately so we can defer grab them.

Reported-by: Josef Grieb <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 80913973337a..e21a7a9c6a59 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6757,7 +6757,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 
 	mutex_lock(&ctx->uring_lock);
 	if (likely(!percpu_ref_is_dying(&ctx->refs)))
-		ret = io_submit_sqes(ctx, to_submit, NULL, -1);
+		ret = io_submit_sqes(ctx, to_submit, ctx->ring_file, ctx->ring_fd);
 	mutex_unlock(&ctx->uring_lock);
 
 	if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
@@ -8966,6 +8966,11 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
+	if (p->flags & IORING_SETUP_SQPOLL) {
+		ctx->ring_fd = fd;
+		ctx->ring_file = file;
+	}
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
-- 
2.28.0

-- 
Jens Axboe

