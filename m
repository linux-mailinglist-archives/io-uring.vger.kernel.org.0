Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E301C75CE2A
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjGUQSl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjGUQSI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:18:08 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D004227
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:06 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-78706966220so20986139f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956221; x=1690561021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Ml0myyraRmhTLtQmcxe+g3vSgtvxsjWF8x/ZfCtD8A=;
        b=4+ik4qcnknrZ2pBI823ys5bfjbDA0eKf1HwuFJb5qEwuLL/GknLELm7RnzBWEq6x0j
         EzxyjTatcLiofyhdoxiCFXazgpyy2K6+yXOwe2ii4HCDphMgaTT5WI5dMt+Q7PJcXztT
         B2NLamjAWVsHxQUSTLBQvNRbyBn49MsSm0X9VmRJIEzDTlsEiitNGbkLM2NpbUVkGlku
         ScJwDYH6cUeGRFObbVLo6WFGbSZTGS59Wve0uDyqZ3e+I14X8OrrvKO2frrmDBIxWdHm
         wqBntbhc610Em4847+Dj06OkihyM1YH95RtRgk2peZ7zdwpoFORWbng2NXSmj9HKJKzv
         1pnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956221; x=1690561021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Ml0myyraRmhTLtQmcxe+g3vSgtvxsjWF8x/ZfCtD8A=;
        b=RIoTSdwKvuHt9/Cd+KSsbwR8mXz/LkjEEr334A4j4/CkzQcKRcorWTnN4rBFVHFw0t
         fl2BS0aK+EzDohEWqXiwYbZCf3jTsSIA1Snxyz1YHO0FzMe9ZsLzB4eklsyGDiVlksB4
         YXE0cDnBm5p2HVgntEcnNn31Nln0XAShcLu7/mqeKbKchLBUO4BNS0wbTpvwTDZsLPv3
         NEoOJacwCA1110Bo6QVkwqriyjxoet5GB8bfzwkSqZWDTCEZVGRvtJg2iu5wClY56A4M
         b7dekglPNR0XsVowVBgFMEYqMrVyhC9Sr9SQitm7wqPTPYZHwECmXoJ+JLyfGZjXjfbV
         hQoA==
X-Gm-Message-State: ABy/qLZ3iYoN8QLQRxYWzOBAMceaObr3r5OAO5HbUJMe+0q+YTMzW075
        cyZn58v2Wu0uygM3mRWHOkvsGyRXmZ2Od+xlWko=
X-Google-Smtp-Source: APBJJlGQn8MOj48TbeVTtv5LQAKVB2KD+GpZ/ZTqKNKeiMYFyZOz3Du19utC4HqplV51LvT1jhuErQ==
X-Received: by 2002:a6b:b4d5:0:b0:788:2d78:813c with SMTP id d204-20020a6bb4d5000000b007882d78813cmr2386295iof.0.1689956220838;
        Fri, 21 Jul 2023 09:17:00 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:16:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] iomap: completed polled IO inline
Date:   Fri, 21 Jul 2023 10:16:45 -0600
Message-Id: <20230721161650.319414-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Polled IO is only allowed for conditions where task completion is safe
anyway, so we can always complete it inline. This cannot easily be
checked with a submission side flag, as the block layer may clear the
polled flag and turn it into a regular IO instead. Hence we need to
check this at completion time. If REQ_POLLED is still set, then we know
that this IO was successfully polled, and is completing in task context.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 17b695b0e9d6..2b453e12dc16 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -173,9 +173,19 @@ void iomap_dio_bio_end_io(struct bio *bio)
 	}
 
 	/*
-	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
+	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline.
+	 * Ditto for polled requests - if the flag is still at completion
+	 * time, then we know the request was actually polled and completion
+	 * is called from the task itself. This is why we need to check it
+	 * here rather than flag it at issue time.
 	 */
-	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
+	if ((dio->flags & IOMAP_DIO_INLINE_COMP) || (bio->bi_opf & REQ_POLLED)) {
+		/*
+		 * For polled IO, we need to clear ->private as it points to
+		 * the bio being polled for. The completion side uses it to
+		 * know if a given request has been found yet or not. For
+		 * non-polled IO, ->private isn't applicable.
+		 */
 		WRITE_ONCE(iocb->private, NULL);
 		iomap_dio_complete_work(&dio->aio.work);
 		goto release_bio;
-- 
2.40.1

