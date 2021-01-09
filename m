Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C862F012B
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbhAIQHc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbhAIQHb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:07:31 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57198C0617A4;
        Sat,  9 Jan 2021 08:06:51 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 190so10216049wmz.0;
        Sat, 09 Jan 2021 08:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LOsfOtb4JF9iqyizeOjm4tVRPPo2GoTdvRn37AEB3XM=;
        b=Naupq7MH/QGjgYPNZ6nDh8HfOkE4n+5H8WjdQV22O4U+GN5oR8Ixv+Gl0qgQdk/j5c
         ror5a9etqnkRwbLZtFecJMcJzPkfKyMpprD4UzKGG7SSMj0Wi+vldVDQD03UCr6cRo7n
         XslEbcpU4b29/jvNvkfRRV425pGdOV5ri/XWO0dOpB0xSe9yp0uF+JUkgxBHlG0EVsSJ
         vh6OV5OVGJxasK4c8MsZ0f0UaF7d5DdwAcf3iB4vuMr/Bo932nWihR9VgM3blH1dJpvR
         guhwKvbCGPS3CqatmW254sYwWbBHH7dCEoXtGD9igJm7GWNOpYe5oppH34AB0Kbgxc3c
         vGbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LOsfOtb4JF9iqyizeOjm4tVRPPo2GoTdvRn37AEB3XM=;
        b=j8MFP6gGghrGEaOUgrKW1uX0oott1K/p4BNb2FJJ0065VQQx3j5jkUZQi7w/wbrQP/
         FUtKUfIYToAM0F9cuUW7AJ6hiKlRyILiXMNouEkq+wHiF5LVZSjWBwDH8knhgzBRU+8E
         5pMrsTasAqD6HQXWrfwlVIzGSDwl1DJy+tk2zubp3Bs2JJCIUjmyv9tr1+7e8nEiaoj3
         5EILJK82RIuvQLAp6oXrlP7q84pJklWplG5InfkScdHKV+HgTBnxGvxfiJDajG54QnlO
         Ufewxd+ilTy77L5vUYyMuRQE2Mq0AbF90ROlokFfSpa0s4soiOHe7lyvAJ/Tlfa/RmB0
         VPcg==
X-Gm-Message-State: AOAM531ziyyhi+zFizpCjKv3M6qZGMRFl3fAdT1FnoLFHusc9eCmmq6S
        q4xEnuX6u127MMxxRxodSeBhp6cvq3bI2GGx
X-Google-Smtp-Source: ABdhPJwTh8SgrJgP2KLlExaCfgCAEBrNfjWruyuIlYMsHFTOuOfOCftaIufrH3TPb7KFf9qH55pOLg==
X-Received: by 2002:a1c:7d94:: with SMTP id y142mr7810148wmc.105.1610208409857;
        Sat, 09 Jan 2021 08:06:49 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id j9sm17403866wrm.14.2021.01.09.08.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 08:06:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 4/7] target/file: allocate the bvec array as part of struct target_core_file_cmd
Date:   Sat,  9 Jan 2021 16:03:00 +0000
Message-Id: <2650722037cd756690f2e398468420bbaa26ed7f.1610170479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610170479.git.asml.silence@gmail.com>
References: <cover.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

This saves one memory allocation, and ensures the bvecs aren't freed
before the AIO completion.  This will allow the lower level code to be
optimized so that it can avoid allocating another bvec array.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/target/target_core_file.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index b0cb5b95e892..cce455929778 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -241,6 +241,7 @@ struct target_core_file_cmd {
 	unsigned long	len;
 	struct se_cmd	*cmd;
 	struct kiocb	iocb;
+	struct bio_vec	bvecs[];
 };
 
 static void cmd_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
@@ -268,29 +269,22 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct target_core_file_cmd *aio_cmd;
 	struct iov_iter iter = {};
 	struct scatterlist *sg;
-	struct bio_vec *bvec;
 	ssize_t len = 0;
 	int ret = 0, i;
 
-	aio_cmd = kmalloc(sizeof(struct target_core_file_cmd), GFP_KERNEL);
+	aio_cmd = kmalloc(struct_size(aio_cmd, bvecs, sgl_nents), GFP_KERNEL);
 	if (!aio_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
-	if (!bvec) {
-		kfree(aio_cmd);
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	}
-
 	for_each_sg(sgl, sg, sgl_nents, i) {
-		bvec[i].bv_page = sg_page(sg);
-		bvec[i].bv_len = sg->length;
-		bvec[i].bv_offset = sg->offset;
+		aio_cmd->bvecs[i].bv_page = sg_page(sg);
+		aio_cmd->bvecs[i].bv_len = sg->length;
+		aio_cmd->bvecs[i].bv_offset = sg->offset;
 
 		len += sg->length;
 	}
 
-	iov_iter_bvec(&iter, is_write, bvec, sgl_nents, len);
+	iov_iter_bvec(&iter, is_write, aio_cmd->bvecs, sgl_nents, len);
 
 	aio_cmd->cmd = cmd;
 	aio_cmd->len = len;
@@ -307,8 +301,6 @@ fd_execute_rw_aio(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	else
 		ret = call_read_iter(file, &aio_cmd->iocb, &iter);
 
-	kfree(bvec);
-
 	if (ret != -EIOCBQUEUED)
 		cmd_rw_aio_complete(&aio_cmd->iocb, ret, 0);
 
-- 
2.24.0

