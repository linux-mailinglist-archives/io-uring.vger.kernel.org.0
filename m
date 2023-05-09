Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8ED6FCA19
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 17:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbjEIPTT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 11:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbjEIPTS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 11:19:18 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C6640CE
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 08:19:17 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-760b6765f36so21049939f.0
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 08:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683645556; x=1686237556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/jkxiCP4JthB71tD2UnyEZpZa4CleF0O3E0hHUUj2s=;
        b=J6MxwIbuqm1FKPUVMo9wqx01RiXxThePQKhHVy9j81JKUdegB1fL4DBWREmXRH+rZ4
         qZv7P7RINWlFaZ9Cz2qLfTP+9QGOotFhAcP7QnL/KU4QbjumB5po5OqR0GoygqKGuKwI
         RoKETRjpu8bcVE3sGs+IFxNkdLn7MCCl0Tr8Nvhdl+zLaxgboAdYFeozzfYSosKLTwd+
         /3rbddUSD0rRtgtrW9G+Rzh1nKJOIgE3BVmWzJnTXWrrNtj2Na2rkwJhm3kYupLgJWyB
         5RdTqpFXpXCg0swOFL0t3sOa7xXLTcFEUV/F43oTl/uTDNmqYjL8NLdBl4re/AS8bXL9
         vR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645556; x=1686237556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/jkxiCP4JthB71tD2UnyEZpZa4CleF0O3E0hHUUj2s=;
        b=bfkwW9dLnVWDdDqMyqd58AcXN6M7V9Ubh53I/A9RMmce1Ibf5CzodhiaSAu0rrk+45
         QsXpMHG5fslYdn8h1LF980RuIeD5j8p6RwTbonjmqMndmmq0MZODPDCayyNz85mTBbIP
         V7b5qnLPO84FCtI4XxQb7ZDpejYfhKdWPhuQG1bqawu8N2CsZREtDGmrAHCK6VMQN3jH
         O+wTv+OBl8XpXWPuo6NMlHCVo31bbGokdRcOynt0ZrYK6J3lUdVcIORM5qeEpb9GAmcq
         xBPvKBo/hLm2l3iEtajdRoMEYN87TROA5nvzw8yhVrE2cC7qzeI2NDHQD71QQOqheIGl
         MnLQ==
X-Gm-Message-State: AC+VfDxn+YEaA6J4VJD6uyQaRqBej5HjNFdgmpDuqGU/mKWv8bO10JPp
        7iboAMYjI4cTrCt6El9E3fsTeNBso1EujDsK4Xg=
X-Google-Smtp-Source: ACHHUZ42L5EZpZexHnQ9E+vXfaofOXLtZIeIku+36oDtyPUueapg5a63UVr1ieq5fEbsZx2fBD0DhQ==
X-Received: by 2002:a6b:5f09:0:b0:760:f7e4:7941 with SMTP id t9-20020a6b5f09000000b00760f7e47941mr6891056iob.0.1683645556246;
        Tue, 09 May 2023 08:19:16 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z1-20020a056638240100b0041659b1e2afsm677390jat.14.2023.05.09.08.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:19:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: [PATCH 2/3] block: mark bdev files as FMODE_NOWAIT if underlying device supports it
Date:   Tue,  9 May 2023 09:19:09 -0600
Message-Id: <20230509151910.183637-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509151910.183637-1-axboe@kernel.dk>
References: <20230509151910.183637-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We set this unconditionally, but it really should be dependent on if
the underlying device is nowait compliant.

Cc: linux-block@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/fops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index d2e6be4e3d1c..ab750e8a040f 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -481,7 +481,7 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	 * during an unstable branch.
 	 */
 	filp->f_flags |= O_LARGEFILE;
-	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	filp->f_mode |= FMODE_BUF_RASYNC;
 
 	if (filp->f_flags & O_NDELAY)
 		filp->f_mode |= FMODE_NDELAY;
@@ -494,6 +494,9 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
+	if (bdev_nowait(bdev))
+		filp->f_mode |= FMODE_NOWAIT;
+
 	filp->private_data = bdev;
 	filp->f_mapping = bdev->bd_inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
-- 
2.39.2

