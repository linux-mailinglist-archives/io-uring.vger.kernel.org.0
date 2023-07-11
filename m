Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B5574F927
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjGKUdk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjGKUdj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:33:39 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56125B7
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:38 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so540036a12.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689107617; x=1689712417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ixQUY57vnvYb5HvRH5ijyFihp5oJ/szTZ8856/uqLoU=;
        b=sI/EhwbO/KOMFb7uDzGESwMGWUkuorv7KqjZikEwkCW+0t36HgzSjPtaR7itUyd0M2
         SHnZ2gCDDMoHxCeO9HB1Z3MzwkTyeF3jBmz2F4QHoGwfa0yvgQrZa79pbXDxtYyVob1K
         HRAR0y/cbmJb62fG8vH5iKRyUuXhtWrVOD6nTA9i8SFhSBZnGn4GYmBRSbx2gsBy5CJk
         fNIK5hQGgLik6/2F4YzjVa829WpmPNBrQhYDN6PFnVLR2ArPoS7Eyn6d7Q3inkHCFF2U
         /AVXYeUiEnGnKC1NY6/qsKYspwRS4kDipl++OGWF0KYDplasu3M6dlE0DwIAOzX8z2j/
         hkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689107617; x=1689712417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ixQUY57vnvYb5HvRH5ijyFihp5oJ/szTZ8856/uqLoU=;
        b=dAHeGrrTt5AP4YjBlu8alSUuTX8U0c2M7XPyjDib/tVzqaExv1JUsBdHf4l1DVoO5S
         NPj0CvOHwMxiOLDXeTPemQ7GU/yhNhH5uzXAB/6L2cPp6/xrAoJWRzyUGNnlnT6BacT6
         V3QSTqNJDo2JfFnmTz57cKg4IENLlEju34h5XtbGfnXNcm+r5Hqazo0g+QJ92O0wxAlp
         HLx+NxGffJNDLJkwnO0f/CpGSMlYLOLCGPrP6r8FxPnV5qMCNpCYvn2FIU8NVmWl9aM9
         sAcO3Ue4bhc30xHZdViMkj4XIZTXVR0db6N4dJBy+suFQNMwfeDGGegFBRJ6Gs9ctefU
         qBow==
X-Gm-Message-State: ABy/qLaehiDjbxbaAs7xVHvoQK3LMFUzHqwiT/uA4GiwCBck2N5VEvcm
        td7cjKo3RmZl2Y5pwtvqs2A0IocZy3wl4ViixRw=
X-Google-Smtp-Source: APBJJlE0Fdjl9niH1fLBogzYDLzZpwQEuTCuENjw7d/RyTpMB94Vv2knTegxp7PH5nQo9z3SCc2jMg==
X-Received: by 2002:a05:6a20:4289:b0:12c:76d1:bcde with SMTP id o9-20020a056a20428900b0012c76d1bcdemr23311409pzj.4.1689107617361;
        Tue, 11 Jul 2023 13:33:37 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fk13-20020a056a003a8d00b0067903510abbsm2108081pfb.163.2023.07.11.13.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:33:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] iomap: support IOCB_DIO_DEFER
Date:   Tue, 11 Jul 2023 14:33:25 -0600
Message-Id: <20230711203325.208957-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230711203325.208957-1-axboe@kernel.dk>
References: <20230711203325.208957-1-axboe@kernel.dk>
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

If IOCB_DIO_DEFER is set, utilize that to set kiocb->dio_complete handler
and data for that callback. Rather than punt the completion to a
workqueue, we pass back the handler and data to the issuer and will get a
callback from a safe task context.

Using the following fio job to randomly dio write 4k blocks at
queue depths of 1..16:

fio --name=dio-write --filename=/data1/file --time_based=1 \
--runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
--cpus_allowed=4 --ioengine=io_uring --iodepth=16

shows the following results before and after this patch:

	Stock	Patched		Diff
=======================================
QD1	155K	162K		+ 4.5%
QD2	290K	313K		+ 7.9%
QD4	533K	597K		+12.0%
QD8	604K	827K		+36.9%
QD16	615K	845K		+37.4%

which shows nice wins all around. If we factored in per-IOP efficiency,
the wins look even nicer. This becomes apparent as queue depth rises,
as the offloaded workqueue completions runs out of steam.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 94ef78b25b76..bd7b948a29a7 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -130,6 +130,11 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 }
 EXPORT_SYMBOL_GPL(iomap_dio_complete);
 
+static ssize_t iomap_dio_deferred_complete(void *data)
+{
+	return iomap_dio_complete(data);
+}
+
 static void iomap_dio_complete_work(struct work_struct *work)
 {
 	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
@@ -167,6 +172,25 @@ void iomap_dio_bio_end_io(struct bio *bio)
 			   !(dio->flags & IOMAP_DIO_WRITE)) {
 			WRITE_ONCE(iocb->private, NULL);
 			iomap_dio_complete_work(&dio->aio.work);
+		} else if ((iocb->ki_flags & IOCB_DIO_DEFER) &&
+			   !(dio->flags & IOMAP_DIO_NEED_SYNC)) {
+			/* only polled IO cares about private cleared */
+			iocb->private = dio;
+			iocb->dio_complete = iomap_dio_deferred_complete;
+			/*
+			 * Invoke ->ki_complete() directly. We've assigned
+			 * out dio_complete callback handler, and since the
+			 * issuer set IOCB_DIO_DEFER, we know their
+			 * ki_complete handler will notice ->dio_complete
+			 * being set and will defer calling that handler
+			 * until it can be done from a safe task context.
+			 *
+			 * Note that the 'res' being passed in here is
+			 * not important for this case. The actual completion
+			 * value of the request will be gotten from dio_complete
+			 * when that is run by the issuer.
+			 */
+			iocb->ki_complete(iocb, 0);
 		} else {
 			struct inode *inode = file_inode(iocb->ki_filp);
 
-- 
2.40.1

