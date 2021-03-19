Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977BD3426FD
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 21:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhCSUfi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhCSUfZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 16:35:25 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94EFC06175F
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j25so6698967pfe.2
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 13:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fvZDWhbgnRvUg4VpOeDjsBFPpse/0PHAWQ4H/yzmwk8=;
        b=gs14YiQS4vjJCVYfYi+JyEIwjhSiAObGDgKB+XfxIfNBI/vs/f970fBJy5Nyk81Lv8
         VhFFW6kjHHJMpfgYcVUuG1GuK5oAvTKi8dmg9o5bLFtnnLVEjq94oGstQrv9zHal1qM2
         LEHWtY40XWXB5KD3j+qzDNC395761Wv/c17GukDHMYJ+0xfp4InCGCRqmX17utyinRGR
         g9BxOFYPpySIzqZrxY18jJauea0KTMbRNoeSPVKC31I79pLTtbi/vrGcVfsTgC+ySoqz
         kw5hjEG5CcL0bEoGPc9sKMdzSd74W1E7ZP/zrgCyjThGZdR7CJNTjf20QY+x15VoYFKi
         7asg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fvZDWhbgnRvUg4VpOeDjsBFPpse/0PHAWQ4H/yzmwk8=;
        b=GU1zhVtO9EqPFbl5LsQIM8RijjiDcC5biFVwS83F9UK9UGOaM5zI5ze/49Vswise1U
         i+wPmGLMOxGY19vpDwvAuTU13DqE9XpTvEmBtVZ05fwwlZeVALgHX2uYCe9fr+g1YMcG
         K+LsCTKX/8oR4ZHkpgW3oBAtcTf3ymqaK2aScR+8R0n6iOi4qUImbd5vF5NizdeqgHnj
         Qj4Wi9/MZmWJbRfRCUuQPx7Z9cn9BJh70pJffwCoi83CHFU7tX3ao1HEoESl2WcxIiMm
         Fu5nchOKivmtHkOCZvKdESJtcikOynQ7qbyUaYvByTxVuaiiZBP8S1DhH/UGQVXRHT1Z
         MzMw==
X-Gm-Message-State: AOAM532+i+IWcROG+XT7zQ0AsRHzvH8D3IsrelxNSBr/XuiaUS8975NH
        XfcndRZEbPHXCE5mzeo3fDP5BSGKoMiUBQ==
X-Google-Smtp-Source: ABdhPJwl6D59PhLzhDhJf44JujbCmFEVBRL5wie865tf3UX65O/MDkxXS2q6V+flCGNKEhJVikuiFg==
X-Received: by 2002:a63:e644:: with SMTP id p4mr4023598pgj.204.1616186125155;
        Fri, 19 Mar 2021 13:35:25 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b17sm6253498pfp.136.2021.03.19.13.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 13:35:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] io_uring: include cflags in completion trace event
Date:   Fri, 19 Mar 2021 14:35:11 -0600
Message-Id: <20210319203516.790984-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319203516.790984-1-axboe@kernel.dk>
References: <20210319203516.790984-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should be including the completion flags for better introspection on
exactly what completion event was logged.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                   |  2 +-
 include/trace/events/io_uring.h | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a91033cc62c3..a4987bbe523c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1519,7 +1519,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
 
-	trace_io_uring_complete(ctx, req->user_data, res);
+	trace_io_uring_complete(ctx, req->user_data, res, cflags);
 
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 9f0d3b7d56b0..bd528176a3d5 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -290,29 +290,32 @@ TRACE_EVENT(io_uring_fail_link,
  * @ctx:		pointer to a ring context structure
  * @user_data:		user data associated with the request
  * @res:		result of the request
+ * @cflags:		completion flags
  *
  */
 TRACE_EVENT(io_uring_complete,
 
-	TP_PROTO(void *ctx, u64 user_data, long res),
+	TP_PROTO(void *ctx, u64 user_data, long res, unsigned cflags),
 
-	TP_ARGS(ctx, user_data, res),
+	TP_ARGS(ctx, user_data, res, cflags),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
 		__field(  u64,		user_data	)
 		__field(  long,		res		)
+		__field(  unsigned,	cflags		)
 	),
 
 	TP_fast_assign(
 		__entry->ctx		= ctx;
 		__entry->user_data	= user_data;
 		__entry->res		= res;
+		__entry->cflags		= cflags;
 	),
 
-	TP_printk("ring %p, user_data 0x%llx, result %ld",
+	TP_printk("ring %p, user_data 0x%llx, result %ld, cflags %x",
 			  __entry->ctx, (unsigned long long)__entry->user_data,
-			  __entry->res)
+			  __entry->res, __entry->cflags)
 );
 
 
-- 
2.31.0

