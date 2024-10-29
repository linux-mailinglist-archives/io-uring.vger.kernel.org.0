Return-Path: <io-uring+bounces-4110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E96129B4DBA
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD16C281C11
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A73A1714DF;
	Tue, 29 Oct 2024 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yQW+Pycr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582C91957E2
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215397; cv=none; b=S6REgANBaH3vKqXOk6aAEhPCdhMVFgrYwzuhS41VKk9zncx7wA6uIqDKGUXoFNlybdPcKxbBzucRDvS/6+1fSoBTbmwps82UF/K/7BrnK/Obch0wVf1XrNYtRejiuHX+vgzlqD9gzgQ2xpfgqMu8B1uiCtG403kly122iBev2hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215397; c=relaxed/simple;
	bh=lkzxSGPhE74nEna4hhBDxfxOMVtN4Eja2fRQ8mJUNWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC853yJHwgNh5ZeMwP15vSNICO4R993KYNSsNLrfnEH5yI8jQNLNhy88f69Yz9lI9ETP38XHGxCdFGUg5L2/su1AIyI3jIeVxxX61chicTg5oj5YXJcAIpri8zy6kCXb9yUv1Q8JqEA/F4c1wTv9oggGqGKX2o5Zv80q7PVtFcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yQW+Pycr; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-83aa3ced341so213630539f.0
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215394; x=1730820194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jx0+s/FuypCRBo+RK3Xr0Fm1dzG80IoiEOq/Q+n3Eik=;
        b=yQW+Pycr6UFbOWnyJExYECR1q4UaiAl2pm1cNKFKCHKAkRfJYXNmBMwyI3SfI+i0/C
         2/hFdWClToPtBbUXYw3qSZEIiDwdJGCErtCIamf/NVxN5bZROd8PwfqxAyhqrP4ost33
         2c9+SGgsq6/IFvHYI/f8p2g1Bv66ROTfZuWK/IkfKclj5GgBV5iJjD+g5yF6ebFe2FUO
         mHg2LQ4kP7U8hQkcz5HSGsnx9I2hfxUmJF+UUMRP4dYisiYV3e61re6HuJXEIPHZ/CVw
         2Mthq1xMTOXl2RDLOVmu2KFfuuUrc0cIEWAd+zFegBb/XKPJYHLzsRcv/C+tEX+RGLTd
         qCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215394; x=1730820194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jx0+s/FuypCRBo+RK3Xr0Fm1dzG80IoiEOq/Q+n3Eik=;
        b=rbWEnN5wTjCeSJPTLHWRucWO8f6dOqBDuU2rTIy6xF74OWC1oyuoltBSj7kGHfixHK
         rFef2RKqL7lWttF/SGVMLj3Ly2E3W/vcmXKs+giG8JgTengO8Zl5CU7aDNs3SK7kTVo0
         q+sTUDEbjMA5tj7k2/Sb6orLB9gqt53dFoPFOs2HVq8WgfmGy8nNp997sG1WVdu0vt0U
         FvR89/sS1E51ywIGRqFB5G4LSrYiA7IfiOLrHnM/Lv2oVFzmRJ8R5Se3CUh6evCXvOjR
         k+FEvIwTo2K2UhEZHIiate2c6EIR3Xy9Ea+XuOBtmbZGUiQhVxZYOCrfDOHRkFAZaNMf
         KYaw==
X-Gm-Message-State: AOJu0YwjdwKmEoHDQ8KLEc0ZdqOEI/LAJ16jSSDfcb05wGvcIM/PzS7X
	rBoEuyUnoRr24IYEau9cef7VlJLsjeUDSJU/Xh0FgMNSxaLsMYvZ8JrSwa0dnwCEcGNTdLfa0Si
	7
X-Google-Smtp-Source: AGHT+IGRY+yogxpysuuwYWJPRY0gcrg9WQGX5VIC1nO5YRPPFH/gegjvROZac8zUkZrx107sYNNAdg==
X-Received: by 2002:a05:6602:29c4:b0:83a:a8ac:a2bc with SMTP id ca18e2360f4ac-83b1c5fd3f0mr1311469039f.16.1730215394015;
        Tue, 29 Oct 2024 08:23:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/14] io_uring: only initialize io_kiocb rsrc_nodes when needed
Date: Tue, 29 Oct 2024 09:16:38 -0600
Message-ID: <20241029152249.667290-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the empty node initializing to the preinit part of the io_kiocb
allocation, and reset them if they have been used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  4 ++--
 io_uring/rsrc.h     | 10 ++++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9282d5fa45d3..60c947114fa3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -947,6 +947,8 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
 	req->ctx = ctx;
+	req->rsrc_nodes[IORING_RSRC_FILE] = rsrc_empty_node;
+	req->rsrc_nodes[IORING_RSRC_BUFFER] = rsrc_empty_node;
 	req->link = NULL;
 	req->async_data = NULL;
 	/* not necessary, but safer to zero */
@@ -2032,8 +2034,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->flags = (__force io_req_flags_t) sqe_flags;
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
-	req->rsrc_nodes[IORING_RSRC_FILE] = rsrc_empty_node;
-	req->rsrc_nodes[IORING_RSRC_BUFFER] = rsrc_empty_node;
 	req->task = current;
 	req->cancel_seq_set = false;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index db04d04d4799..6a7863f13ea9 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -82,8 +82,14 @@ static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 
 static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 {
-	io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_FILE]);
-	io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_BUFFER]);
+	if (req->rsrc_nodes[IORING_RSRC_FILE] != rsrc_empty_node) {
+		io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_FILE]);
+		req->rsrc_nodes[IORING_RSRC_FILE] = rsrc_empty_node;
+	}
+	if (req->rsrc_nodes[IORING_RSRC_BUFFER] != rsrc_empty_node) {
+		io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_BUFFER]);
+		req->rsrc_nodes[IORING_RSRC_BUFFER] = rsrc_empty_node;
+	}
 }
 
 static inline void io_req_assign_rsrc_node(struct io_kiocb *req,
-- 
2.45.2


