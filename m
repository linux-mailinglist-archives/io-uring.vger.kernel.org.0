Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A553A721E
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhFNWkO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhFNWkL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:11 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C9FC061767
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:37:54 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id h11-20020a05600c350bb02901b59c28e8b4so423312wmq.1
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YzCCXCiHihTT66N4h8Go0PrqLeZDHSfGY0fmIg2SukY=;
        b=alZvPUiDSey6Q6mJx/OD+8YDo/xAKAXKF7WT/kN27nVrknC2+Wk9OL780kBS3XACW8
         KZJG4c8VxULKr9nKt5b7Fct30xRunOEbEbB2pAgTMMe2GxBwgRaWp9EYpBbFmG1rYMSJ
         LZ/mQmQhRn9cCLlISLiXI1YfFTQ1QZ/9ccYRZeLNVhDjTylkhNDPGLytafkUj/2L5DkV
         e7F/xHcZ37cnNOJHInIMO32KSm0H3qAMZrtZDrU8NnDA/nldhprNWM9F++td5q6UrFUN
         EfLM61NWrrgDjd6E8U11L6mJzGbj3p54UXG4JgDaj5I9sU9aFDRG+HQaN7DgH2sexKsW
         jTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YzCCXCiHihTT66N4h8Go0PrqLeZDHSfGY0fmIg2SukY=;
        b=BeonMr6MNhXCfkX4+PteWnFMoo5K1LyhZM28BbcyUtSxfRvhrMJlLPLL2bO2E5V35p
         b5kg4iQigADLHM5f5EYnsNlEvOqpSUBnFOR7WFH7rUdeHbM8LP/r0v8vRbyu8+0YJUvb
         tU8QovUVZ7O66jDeApZO4M1LUeg2u3YtPZKdDvev78YY1/xZAFUf+egBf1hxxymwz/Wr
         GoswBI0sVl7pZS1HkVMxWlsovqpGozzEnLgzxEOFma49xjdjihXRyP0cJvSF0A20wX25
         7fDw9Xy6W7oy3yNg5sqzWIBDMd8VRRTc2XCLRBhF2oA9g19xlZEfNEHutWzMOWAhOv7/
         0qJw==
X-Gm-Message-State: AOAM531UThkV/3kaxX3Rj04gMPHKr4VX/WRTOJYyBiOW+TG2b056gJsl
        Ye41xhlc+Pp/5b6WU8NYTFPAQ7r8IQkIXJ2X
X-Google-Smtp-Source: ABdhPJxUp4pRVoYp0aDOxasz4pEKCo3AId7NDiaigf/ssrZmVniRcqdsNLYxvA+PQ09qB7kEh1e7hA==
X-Received: by 2002:a1c:9ac5:: with SMTP id c188mr1414227wme.17.1623710272825;
        Mon, 14 Jun 2021 15:37:52 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/12] io_uring: move ctx->flags from SQ cacheline
Date:   Mon, 14 Jun 2021 23:37:21 +0100
Message-Id: <4c48c173e63d35591383ba2b87e8b8e8dfdbd23d.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ctx->flags are heavily used by both, completion and submission sides, so
move it out from the ctx fields related to submissions. Instead, place
it together with ctx->refs, because it's already cacheline-aligned and
so pads lots of space, and both almost never change. Also, in most
occasions they are accessed together as refs are taken at submission
time and put back during completion.

Do same with ctx->rings, where the pointer itself is never modified
apart from ring init/free.

Note: in percpu mode, struct percpu_ref doesn't modify the struct itself
but takes indirection with ref->percpu_count_ptr.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3c827cd8ff8..a4460383bd25 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -341,17 +341,19 @@ struct io_submit_state {
 };
 
 struct io_ring_ctx {
+	/* const or read-mostly hot data */
 	struct {
 		struct percpu_ref	refs;
-	} ____cacheline_aligned_in_smp;
 
-	struct {
+		struct io_rings		*rings;
 		unsigned int		flags;
 		unsigned int		compat: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
+	} ____cacheline_aligned_in_smp;
 
+	struct {
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
 		 * mmapped by the application using the IORING_OFF_SQES offset.
@@ -386,8 +388,6 @@ struct io_ring_ctx {
 	struct list_head	locked_free_list;
 	unsigned int		locked_free_nr;
 
-	struct io_rings	*rings;
-
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
-- 
2.31.1

