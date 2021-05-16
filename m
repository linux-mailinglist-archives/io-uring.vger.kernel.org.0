Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9289738215A
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhEPV7w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhEPV7t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:49 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6441BC061760
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:33 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x8so4405906wrq.9
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7Mr71EcLC9a9fHhG6ppxGYPFQioSU4tRBj7Rvl8eXuE=;
        b=LyuajfGISEpFissk+PAKrlzOjwKqIFDAs3a4bTojtUMOLdm/CtHRMjAYI10Z1O45uq
         fo3d+cl4Q9/rYKsGDotzpYGN0pi9P7Fdvvx5xEVVKm2eD57worlzrXUmmVrQ0dcs0oz+
         R09rNsECvYAeWl3Dznk3REUN3HxXfHNTO8WL2EiDl3sEu7FoYm/IJYadRygvV6YLF+0V
         Nhxt5clCQY23wYhyUsa3A2A3veZsVEOlH0u3VLmp+gvGbhRy5iWbB5RvuFTeIl9bkvQz
         MfbbfIyMazviSj0et26ti2/zu0ohZKp4J0f2LUb7hYZA/QHO17LJBTmLJHaChjX9JRRE
         5F/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Mr71EcLC9a9fHhG6ppxGYPFQioSU4tRBj7Rvl8eXuE=;
        b=uoFLsyuKu4PEwG89GGKZcOzFjmP8/yghF2EC4UKsdb20srKOPebvvP3L5FYWMAl/Jd
         kEY5Il2LH1KifamKdc714eXBstt5TeN9M/HSEtMz128as1UWIjMhQjPi2TTp4hXjrrz6
         sHA2U5gJXsKa4cA9Mj/fxCUTLA26S5Pmfo+U2/Bx0bB5Rdg9qh32YfuKihGGOgCMdK8V
         fcB3jyKRqYmDhOaO80uzKyDsOiZnAsmxdfMgX0RoeucNEEKHgnMvewj9gUBh0M3LtL4/
         ZLzb9OXyKdukVEnZpN46rCMW9Nf2tqv1KlJIIKwSjZD9sSKl86YEyI69MunnDqe7SetN
         0e1Q==
X-Gm-Message-State: AOAM531TSrq5QJPLdjLtlr76Yq0TrCUDFK0e3Ea9coGVkiHgorrxdAU5
        nQt1xiwah+p0yLeJ9qUD72JsO4JHzCs=
X-Google-Smtp-Source: ABdhPJwYktDG/dwg4hyosIoatZlyPxKFc3S76q/pW0ZiuQZfjYE2iVAJRGUFb/io/V9yBAVNG++BmA==
X-Received: by 2002:adf:9069:: with SMTP id h96mr70055985wrh.322.1621202312182;
        Sun, 16 May 2021 14:58:32 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/13] io_uring: shuffle rarely used ctx fields
Date:   Sun, 16 May 2021 22:58:06 +0100
Message-Id: <782ff94b00355923eae757d58b1a47821b5b46d4.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
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
index 1ab28224d896..83104f3a009e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -368,9 +368,6 @@ struct io_ring_ctx {
 		unsigned		cached_cq_overflow;
 		unsigned long		sq_check_overflow;
 
-		/* hashed buffered write serialization */
-		struct io_wq_hash	*hash_map;
-
 		struct list_head	defer_list;
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
@@ -387,9 +384,6 @@ struct io_ring_ctx {
 
 	struct io_rings	*rings;
 
-	/* Only used for accounting purposes */
-	struct mm_struct	*mm_account;
-
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
@@ -410,14 +404,6 @@ struct io_ring_ctx {
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
@@ -461,12 +447,24 @@ struct io_ring_ctx {
 
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

