Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D14636FB36
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhD3NLK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 09:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhD3NLK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 09:11:10 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DE0C06174A
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 06:10:22 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso369014wmc.1
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 06:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=W9EYZvn1oRhr3lWYXl4myHsIDMtwjcONNzCESAVv/Ws=;
        b=qqfNBJFwMZOhngLmgu1xOpGXEd2i95UhLB9XB4MEYF/qnWbXzoMJTEzlrX16Ne5S50
         SBE0Y3rAQztsetOYnqkn7atB7ap+CviJg+3n0FNbz5/pl/B5gcehd//r1GAl0pcyrQ1Y
         qyKiMp1zu/96dO9jA40rpXVQDe/Xb5Og/d4JRy6JZuhgTG4d0bBTfl/Rq4Eyz1JIf34B
         qe4zDJYr+C4qDep7pTRO1PsJUvIqzM04UScLs0QWUVp38O2QfDi2MYG1VkUnrSxPhoDV
         oPI9ZigLHpw4Rc7cGYt839uFYkerhQLT++Cw/SFkW8Gid1qDEgigw8c9wJFgC94AsQTB
         DSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W9EYZvn1oRhr3lWYXl4myHsIDMtwjcONNzCESAVv/Ws=;
        b=WPQb3bvaZKk7ToSZQYNH057uA6qMa2gGha3UdVwsMIVUTjNH6OODkdNbfAsocurzKJ
         0MSRt5mynCBet21TF0jfouU8cLzej0izRzvyz6f3QUZp0WPqgBS7sTDmFhXtosKh5kBg
         JYh2imnMLgHefbIzu32GGq1ijstuMMlMnzucJOqnHquR1afnzEuhlZO1+vGvpae+tOG3
         iXBzgIOC8bZX7X4GQ3TPgAPRQ/X8fsyHVIWLZkbL8TYeQ/5TKqVZ6G2JoowazCwmJ4bb
         aBP9yq7GD399Fv3lipHeLdp4Mcz7TELeQLq6eb2eeVJidkfpbmNWHufJ+nCWsNaKjeW4
         VxFg==
X-Gm-Message-State: AOAM5332TzjFBOWWHkqgjeNdMMvreNipNYU/T+hrTdpXfZeZv8J1MX5G
        iG8ulOzO/+JRap67yUYad1MtseEOan0=
X-Google-Smtp-Source: ABdhPJx+yoN5s1MjNVJ+TU+4C/FHBJNmvuUmTpAIcPtH+PlVQohOUy8lj9BvKSwlFBmugbwQTzZ4fg==
X-Received: by 2002:a05:600c:4fd4:: with SMTP id o20mr17025958wmq.166.1619788220986;
        Fri, 30 Apr 2021 06:10:20 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id v13sm2292925wrt.65.2021.04.30.06.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 06:10:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: shuffle rarely used ctx fields to end
Date:   Fri, 30 Apr 2021 14:10:07 +0100
Message-Id: <6d1ed324a10ae4933c65b9f78762838715ef37bc.1619788055.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619788055.git.asml.silence@gmail.com>
References: <cover.1619788055.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a bunch of scattered around ctx fields that are almost never
used, e.g. only on ring exit, plunge them to the end, better locality,
better aesthetically.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8925182f3865..ff5d0757b5c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -367,9 +367,6 @@ struct io_ring_ctx {
 		unsigned		cached_cq_overflow;
 		unsigned long		sq_check_overflow;
 
-		/* hashed buffered write serialization */
-		struct io_wq_hash	*hash_map;
-
 		struct list_head	defer_list;
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
@@ -386,9 +383,6 @@ struct io_ring_ctx {
 
 	struct io_rings	*rings;
 
-	/* Only used for accounting purposes */
-	struct mm_struct	*mm_account;
-
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
@@ -409,14 +403,6 @@ struct io_ring_ctx {
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	**user_bufs;
 
-	struct user_struct	*user;
-
-	struct completion	ref_comp;
-
-#if defined(CONFIG_UNIX)
-	struct socket		*ring_sock;
-#endif
-
 	struct xarray		io_buffers;
 
 	struct xarray		personalities;
@@ -460,12 +446,24 @@ struct io_ring_ctx {
 
 	struct io_restriction		restrictions;
 
-	/* exit task_work */
-	struct callback_head		*exit_task_work;
-
 	/* Keep this last, we don't need it for the fast path */
-	struct work_struct		exit_work;
-	struct list_head		tctx_list;
+	struct {
+		#if defined(CONFIG_UNIX)
+			struct socket		*ring_sock;
+		#endif
+		/* hashed buffered write serialization */
+		struct io_wq_hash		*hash_map;
+
+		/* Only used for accounting purposes */
+		struct user_struct		*user;
+		struct mm_struct		*mm_account;
+
+		/* ctx exit and cancelation */
+		struct callback_head		*exit_task_work;
+		struct work_struct		exit_work;
+		struct list_head		tctx_list;
+		struct completion		ref_comp;
+	};
 };
 
 struct io_uring_task {
-- 
2.31.1

