Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBE32DA4DC
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 01:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgLOAYu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 19:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgLOAYp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 19:24:45 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D32DC06179C;
        Mon, 14 Dec 2020 16:24:05 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id c5so14509321wrp.6;
        Mon, 14 Dec 2020 16:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LOsfOtb4JF9iqyizeOjm4tVRPPo2GoTdvRn37AEB3XM=;
        b=kG976mlGUAT54hMTsT4qHl3ePNNRWB9LFy2HmmL+t6mfRSKdk5umZ6WYomCULDQW9E
         YuWby+j3W4gWivHpVQQOA/7aIwmkSSLngHeQdb6klQaCptqFG/YV5ejnTwIwlz9HFf2m
         eDUwq7Rwt+h66HV9wnAS1sesppf+Fpl+3qYXxpDR3ZoWJ27/ZiY4pBb1I/35pIXw34kB
         Lbi1nxTdy0WE+OGKwC0NKqucdKqyJIKuQSjNNW99pLcDkW/m1CtBI/gMiqbPxZ8kxwzH
         aobpyU6IKfyxV7UT1aOSZWNXNJ0RQdHNyYaHbm5kYkm08wWJNvMk2ZyFR9EbrghRw0A9
         lUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LOsfOtb4JF9iqyizeOjm4tVRPPo2GoTdvRn37AEB3XM=;
        b=LyijsfZas5MN+fpGuiUTO2FGEottJJAESBvtic/a74zNus+hT0RmsfyFSUK/1AXLtt
         BwgEPKOIqMUawCsaUeJe51wCCKbEmIToRqcdSeH2QD1JSSYG5p/YBvOxfjeSECtGAXq2
         gaBQBFsBPryLWtXPTZAWW9n8eWtbZhDL/LkhpxirHRb5ht4e6rkIoXbqkS3yA8YQjJdd
         bipuX84mikhLIsUMWpzLhPqdcBsjnQgpRyTwvGIdst0+EEX6rIR3gT1e9LBoNpQi/Hts
         PnMYShvisPWzWcwRMaO2qozvZkWs5mgJ0KetUkMRSjTv5yD8I8wYmLbSgDK1+fwYNfrs
         R8Kw==
X-Gm-Message-State: AOAM5314kP+8hivUKxxpB6HXY4NsKLXshXfQw7XVXM4vuxIrcGrtOATG
        Y7GlEtTcTvO6jv7s3urnRORnRks6gjzeGgEL
X-Google-Smtp-Source: ABdhPJz/AygAoS74uaniu7lJWQGPmncFabpUEeaVcLaoDdNn4iTUPpmUbiF5aWlFvAES8KDtC5RTLg==
X-Received: by 2002:a5d:4c4e:: with SMTP id n14mr31759423wrt.209.1607991843559;
        Mon, 14 Dec 2020 16:24:03 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id b19sm5362012wmj.37.2020.12.14.16.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 16:24:03 -0800 (PST)
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
Subject: [PATCH v1 1/6] target/file: allocate the bvec array as part of struct target_core_file_cmd
Date:   Tue, 15 Dec 2020 00:20:20 +0000
Message-Id: <ea68179b3f896ed1800c0a315bb4276e0ac77f7d.1607976425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607976425.git.asml.silence@gmail.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
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

