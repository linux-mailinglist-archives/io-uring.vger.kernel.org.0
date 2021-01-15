Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E982F82BA
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 18:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbhAORm6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 12:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbhAORm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 12:42:57 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0A9C06179B
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:45 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id u14so4109851wmq.4
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 09:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G8CIu+dB2YYHBr8RHkuTep0IxU5re7m1ZpOWeB1NB0w=;
        b=plVf3JDu1c+532YGMT3UKP5/0MeDsn8QwSaozuSuV3DzM4wvYtCsvkos7p4uEKNpom
         o8Wmu4Smuce+VwYIrikZdMlQ18iGAavsCJSWAd5J0K1ALEvtnrfP1UkZxt5t/EkOuYMV
         sTb1z8QuOg2T6Gwuph+IzyQEseQd7pMYjLBWEVhKdKiBjynNC4BbvM2JRjBLq5UBpN1T
         oSTLH8qXx8+UDyCyYBbGhOyRt+RH79wr5ed1V7+yamSWxfaIfOEsRAyPI2LrjTrLgYwI
         mhsDIpdYMJKEYefLepGLmbbc5ywpoedBt+JY2QoERegsfXA9isH4p14IJ+8HBGGfuUeA
         I70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8CIu+dB2YYHBr8RHkuTep0IxU5re7m1ZpOWeB1NB0w=;
        b=LeXpY1asigcDBGCEKPVAG6iD6aF74Z7fOAGO7ODx6BAIgaUbIeMWlg+hSJCZ+acpyp
         rG/+e2hSo75p9YZuAEj5rBJWcpjL+fTm7bf2Sln0Y38x2VRglSQUsBg4EQivldAKiv8k
         irIbpki166/lTGPUoE7O5kQ8oQ8xjNwHr7SSo+9hu2QcqSX+vStJcW8Y6U7rU4y/IVro
         lYT8JOL+Eeow8YB6cZ5JlOBfKcuw2HDAmLKdwb34HaMbtW9XHJQ7Rt2C3iv8cTEoRGVr
         cXBs6cb+f1n+/+eUnQ5BBgGPgHqD6j8l7QZ6d8Q6OybW0QHeRpjReQOJQgrYOj5dOTNV
         DkCg==
X-Gm-Message-State: AOAM531MBKwWMdxzGsYtz0DmNalMjpLFetK+eGVQwY01gVyZyREVIRcv
        XCM3iVOvkf4XA4po/Lrb42k=
X-Google-Smtp-Source: ABdhPJzE5Zb0q04+EMObhOYMEhntqX85+6hrFd6iVFnnajKNmebXtXZhN5kWlpvOw6geCgC9Xy8BxA==
X-Received: by 2002:a7b:c751:: with SMTP id w17mr9451903wmk.121.1610732503956;
        Fri, 15 Jan 2021 09:41:43 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id f7sm2060426wmg.43.2021.01.15.09.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:41:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 9/9] io_uring: make percpu_ref_release names consistent
Date:   Fri, 15 Jan 2021 17:37:52 +0000
Message-Id: <254d9f2d839d573b0109c499abdf70d15995ce92.1610729503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610729502.git.asml.silence@gmail.com>
References: <cover.1610729502.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

Make the percpu ref release function names consistent between rsrc data
and nodes.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b83f689051b..02d7a987e43d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7268,7 +7268,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 #endif
 }
 
-static void io_rsrc_ref_kill(struct percpu_ref *ref)
+static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_rsrc_data *data;
 
@@ -7339,7 +7339,7 @@ static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
 	if (!data)
 		return NULL;
 
-	if (percpu_ref_init(&data->refs, io_rsrc_ref_kill,
+	if (percpu_ref_init(&data->refs, io_rsrc_data_ref_zero,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
 		kfree(data);
 		return NULL;
@@ -7728,7 +7728,7 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
-static void io_rsrc_data_ref_zero(struct percpu_ref *ref)
+static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_rsrc_ref_node *ref_node;
 	struct fixed_rsrc_data *data;
@@ -7772,7 +7772,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 	if (!ref_node)
 		return NULL;
 
-	if (percpu_ref_init(&ref_node->refs, io_rsrc_data_ref_zero,
+	if (percpu_ref_init(&ref_node->refs, io_rsrc_node_ref_zero,
 			    0, GFP_KERNEL)) {
 		kfree(ref_node);
 		return NULL;
-- 
2.24.0

