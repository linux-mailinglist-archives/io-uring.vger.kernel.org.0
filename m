Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A8B74F91F
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjGKUdg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjGKUdd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:33:33 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216DB170B
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-66d6a9851f3so979242b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689107612; x=1691699612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7v97jP75G3VwqqaqjV+oC6sPS3RZEc8vaRf0s3+D/gs=;
        b=SKxCWLIvvazG4YGBjUsfWOM8s8h5mAXiIzp6mRiKRMhTC6fy9lP6a1x476z0fc7I5X
         UEaKtqJQ68ELCM+hVDG8qJ0ZEDJ2OlZbndwUqP1HAIdvVams6QKYWAxGEe9sv80jeA6s
         oejF779Hu5OCp8JwTGHcDPfwo4i2WwmP4uO+4vIKRq//FW0K8s8KpKrVRmeNIqjwLpae
         08zF967BVdEjjxkMZ2PCDdkhVcEpMNgRqAQWF2VA5iyT6Ywr0dQKB9/dinCBoTewq71w
         zzTKP9YW89BeeYJZRA7EixUds8407oiM7ysM8turbt5nckBTywDVguV3XiM3ujNdAAEB
         MeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689107612; x=1691699612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7v97jP75G3VwqqaqjV+oC6sPS3RZEc8vaRf0s3+D/gs=;
        b=Bk0wTAwCEN5f7noxmj2CcOlV31W6i4WeK3UkBBcCc6aljG87G2dX98PIqGAeOR3cnm
         J+T3/zJY5JrSMRS9WpjTKhBS7TcQGyuhFfTCCpH6vAj0N67uoSTZp54AHPz20JlWlpEV
         2cH9n9b+XIEfuKKMDjqBgjCHD+7rXNFOAqs8/sBokckUOYFilfw2C6H91Ac/Oq4G0Ina
         LIj1fyLMFctWgGuuYJvvFzWoxZ9e+QMCSycrRVM8bc87ffNDsXrTqwa6CvmPhbfd/bzK
         apwxu0BamKrVB6Wh8fpxJxo0Etvs0/i+SKv1apDj8pinaQiSdo31pFay2FPFsF4mlp4q
         sNEg==
X-Gm-Message-State: ABy/qLbcNgDLFG69IqtEtqHooV0pEY1JH6AzxLj2tBHQOXTHztrBXfaH
        FvhSUkjyv6EkPthy9NsIrOq1IOrjPBnHedJSnLM=
X-Google-Smtp-Source: APBJJlEICKTVTh1X1fQ6strVzMxv0XkAE3MjS2/04VOWMiSDEOodeDA0AM2Bgry1eJUu7HHw1QYL9g==
X-Received: by 2002:a05:6a00:3387:b0:675:8627:a291 with SMTP id cm7-20020a056a00338700b006758627a291mr16779088pfb.3.1689107612080;
        Tue, 11 Jul 2023 13:33:32 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fk13-20020a056a003a8d00b0067903510abbsm2108081pfb.163.2023.07.11.13.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:33:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] iomap: complete polled writes inline
Date:   Tue, 11 Jul 2023 14:33:21 -0600
Message-Id: <20230711203325.208957-2-axboe@kernel.dk>
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

Polled IO is always reaped in the context of the process itself, so it
does not need to be punted to a workqueue for the completion. This is
different than IRQ driven IO, where iomap_dio_bio_end_io() will be
invoked from hard/soft IRQ context. For those cases we currently need
to punt to a workqueue for further processing. For the polled case,
since it's the task itself reaping completions, we're already in task
context. That makes it identical to the sync completion case.

Testing a basic QD 1..8 dio random write with polled IO with the
following fio job:

fio --name=polled-dio-write --filename=/data1/file --time_based=1 \
--runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
--cpus_allowed=4 --ioengine=io_uring --iodepth=$depth --hipri=1

yields:

	Stock	Patched		Diff
=======================================
QD1	180K	201K		+11%
QD2	356K	394K		+10%
QD4	608K	650K		+7%
QD8	827K	831K		+0.5%

which shows a nice win, particularly for lower queue depth writes.
This is expected, as higher queue depths will be busy polling
completions while the offloaded workqueue completions can happen in
parallel.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ea3b868c8355..343bde5d50d3 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -161,15 +161,16 @@ void iomap_dio_bio_end_io(struct bio *bio)
 			struct task_struct *waiter = dio->submit.waiter;
 			WRITE_ONCE(dio->submit.waiter, NULL);
 			blk_wake_io_task(waiter);
-		} else if (dio->flags & IOMAP_DIO_WRITE) {
+		} else if ((bio->bi_opf & REQ_POLLED) ||
+			   !(dio->flags & IOMAP_DIO_WRITE)) {
+			WRITE_ONCE(dio->iocb->private, NULL);
+			iomap_dio_complete_work(&dio->aio.work);
+		} else {
 			struct inode *inode = file_inode(dio->iocb->ki_filp);
 
 			WRITE_ONCE(dio->iocb->private, NULL);
 			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
 			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
-		} else {
-			WRITE_ONCE(dio->iocb->private, NULL);
-			iomap_dio_complete_work(&dio->aio.work);
 		}
 	}
 
-- 
2.40.1

