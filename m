Return-Path: <io-uring+bounces-1125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B55887F2DF
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C9221F22821
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9ED5A7A6;
	Mon, 18 Mar 2024 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ciUfa2gT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A1C5A7BC;
	Mon, 18 Mar 2024 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799348; cv=none; b=g8F1O5UDgys7XM6jrUOEHYcG+7zbBz8f8/sJW5bVX05bPPycO445zXAyfY9N1L3TfCM2ouzvaZmO2Gwgw9tq2m8Dnk7CT/Hwt5O/huQG2dv6NJWWfxChbzo5x1jbGtsiQ75YflQadSRGqkJ9bo7QNq+H1wW2IyrfdTvxnwhdxaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799348; c=relaxed/simple;
	bh=oqixOxrfdkDOvec1XoeBE2EM4nMZPOSKrMBoEnsSrdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXM54mq6XqXe5SAreygXKjUMB8SqVIn2TFg1nGALN8W0vw/1ya6Y52Vx7V1LHKHXTLF+M43vwqOEN4uk5SLe29CxRCAf3P2Edv0b2ow3XJ/NDtCnRAQZsdX74KBYrSZIWzfWXfp5D0taMMis75Oz2O27t/4WZAr1K1rGq2E6ml4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ciUfa2gT; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-41464711dc8so121745e9.1;
        Mon, 18 Mar 2024 15:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799344; x=1711404144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5jfmKec2lF2nW2r2UOqdUesI1xPrnav8F/FOUhv5is=;
        b=ciUfa2gTKfMmshEwuQUR2EgFbjXx8zFuL4tmaOasRZ9mevv5UoBIw2aZ22t5+VPpcv
         08OzWgvLTQbAPSJOkHi5Y617tUMJhWkT9ualuPPGVAuehlcADUJyOnJwpX0jjND4sbMK
         Mq/rn8godJwcdcWxVl2w/O7diC45ZZuEEGfzU8wLl86GkuYq8BDB3lNMIpF3WgFizNNe
         yf48OdYALU+exadz5NLfsd19hIE1UPn97XGmhV6SIZO3NXFqZolhzIMPe9IRnvPg5Sa3
         YWJHqHuiZRq929U8tPLYooN34EfIxMdXkjNVX9R70SaJyaxyNVuJSsUamdHR5UNZpAJJ
         kLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799344; x=1711404144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A5jfmKec2lF2nW2r2UOqdUesI1xPrnav8F/FOUhv5is=;
        b=nkI0c5VqagiGpY5TwwyXLdijlmp4C06hVBEIAIuCIvalY40hZjz88gn0W/mWjicw2E
         q2OmoUaYxoQL6SFphImsittgzn343FBh0aWAalLjDITlDkj7JGWuQmpeTt59M0+pm26/
         wMoD/5R1XLydDxOoylYIGzcX7HEexj330Q7xBLlXH5nfMyA9vgSa1MaOJ3JwlLsMuM90
         AQ/ei0Dhoemw650IetyZOfJNo2ICrX0iipabR7G+UoJcl/7myoMHW0AwZfEsCohY7pSj
         N62x0NF6mJTHruZbVenGiVItxTh5yxAVwShwsd4xEZq/zfyWgi+UP1bKQDJ9yF0uPYOy
         qeRg==
X-Gm-Message-State: AOJu0YzdBhb9M2JkXZICNSw37Wb56bOXllcKFSTyPIE4AxfyNluKutS5
	/sjbk2j/hy7ucWhK4W9GCt92mqJUD1qNWUPHWrE/sl2YKaDljO6ptmi0BgnW
X-Google-Smtp-Source: AGHT+IEEEHA0oXQ+dQrx9Ww9y2adlnS8rJNy7I1ljbMdN0OV9Yx1K5r/hrjClKbDyMet04dt1eTHVg==
X-Received: by 2002:adf:f406:0:b0:33e:3555:bb57 with SMTP id g6-20020adff406000000b0033e3555bb57mr538215wro.42.1710799344202;
        Mon, 18 Mar 2024 15:02:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 11/13] io_uring: remove current check from complete_post
Date: Mon, 18 Mar 2024 22:00:33 +0000
Message-ID: <24ec27f27db0d8f58c974d8118dca1d345314ddc.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

task_work execution is now always locked, and we shouldn't get into
io_req_complete_post() from them. That means that complete_post() is
always called out of the original task context and we don't even need to
check current.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f5e2b5bef10f..077c65757281 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -972,7 +972,7 @@ void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (ctx->task_complete && ctx->submitter_task != current) {
+	if (ctx->task_complete) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
-- 
2.44.0


