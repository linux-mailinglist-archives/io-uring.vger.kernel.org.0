Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F572E87C0
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 16:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbhABPWV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 10:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbhABPWK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 10:22:10 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B46DC06179E;
        Sat,  2 Jan 2021 07:21:29 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c133so13165857wme.4;
        Sat, 02 Jan 2021 07:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LOsfOtb4JF9iqyizeOjm4tVRPPo2GoTdvRn37AEB3XM=;
        b=OLiALIisaOX66Ofzuml3kC66wCIP9u2t1hFkBs0dEBL0aE8EBdga0VD5prANc6xETp
         TY9aUheJWJU6uSTxBN1daNkHXTUP8NPrlmGmVJdVYe26hS8drmoIrX5bVt+YOFOK7NS0
         06iG4NlowbWLhJVZAv+YLXnsI8CN9SlFibCIW1Nsqv3OfI1Ox8k/kWFmOAfT8uxCMkSG
         CjagviERoypCMSqVlCZv2T+vPztbjieZK6tfDQXtVy8OUNP6Nfux0P87TYecslC5aXw2
         uHkgUOKe4hizjipjPcmVFUCvtLfvEZTcgKXJkIGHO4xWKdCj6r0iQb+tUxmLTZSFwh+q
         WSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LOsfOtb4JF9iqyizeOjm4tVRPPo2GoTdvRn37AEB3XM=;
        b=gahcAZUpuy5xzI3niP5Bm+Tnnz0xCTtmvKttLE+HUEZQnwsxRcZqVTCHmpwbt46ysu
         w+2khoW6X7V8/SeX5qT8GQl28c4PAEn8OlU3OQAAclMxOFLtmJqXD2211ePCCz5LoPla
         qY/F51ZYaD5IeTXMZnQWijJKjjTXZIwDl0D0GCPKCEAOIrB5PMFwr1QaZTAQt17jXw25
         iwwq7JqU4zuG/OzpWgxFpC9MqEbbWgn5FmoYWq8lqZcABdqw8/ElI3i1jJtb4wxxGCLn
         JLsnqK3V49pRNpXj/AlpmxskFTEvO8vK8LU774GAVUKDp5mH6Q2wMja2+w353epGd4CB
         6SEQ==
X-Gm-Message-State: AOAM532wPq4MQkWEJ6wIOw0krZkGZaOg7dqYCZlbVS18WOsRh+lBlsk3
        Fgu3h5iOsFTJadr6As7nyjNVJUlfOxxsTw==
X-Google-Smtp-Source: ABdhPJwLJ+vihedFjGQ3PU8Cex40WtPYz+zy0eYCghrDXR8HINdOVHJnDEzOjzgkOrGDOmWYk/f8TQ==
X-Received: by 2002:a1c:6055:: with SMTP id u82mr20245480wmb.61.1609600887976;
        Sat, 02 Jan 2021 07:21:27 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id h13sm78671243wrm.28.2021.01.02.07.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 07:21:27 -0800 (PST)
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
Subject: [PATCH v2 4/7] target/file: allocate the bvec array as part of struct target_core_file_cmd
Date:   Sat,  2 Jan 2021 15:17:36 +0000
Message-Id: <20d31d34eb6fb8a10ac001e5e6c3812eddd24aa3.1609461359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609461359.git.asml.silence@gmail.com>
References: <cover.1609461359.git.asml.silence@gmail.com>
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

