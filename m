Return-Path: <io-uring+bounces-4054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C97179B1B4B
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 00:24:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68CA21F21B89
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 22:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6673E146013;
	Sat, 26 Oct 2024 22:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KgESfgPj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0BB13D246
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 22:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729981447; cv=none; b=IoraH4Ingst0AsYnz1LREuS2GZ1tmZzEAa0JG1qC48X4B0kzirtfLBj4SnUtbZHpsRXcD2mxEHnn4Gs7h0wsAEJBONGqAOLM7mwE4IWWVwtTFZdB9/STDwnVCmUEH4tq4ePrj2l7+Cg7vgY7NwZsUnzqy8OYiNlBo2z3IJz2zws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729981447; c=relaxed/simple;
	bh=4h2usiU+oTkKcOTaeSE92V+Xzo604kYzN6f9pKvR8sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo1JzEocjRbWgFUgR4PEaEoMZHhY+nXsCclIsQkG4ibeZ4jzmy4yF8p+oILjqfguqLGL3kPCggDnaAbtROOFkEFZNWBTzObruL2bL38IOXs8sg3+zT3Ev9h3qGuKJW3VP/Gin+j1g+Nb4Y+ROEkXm4W8/vkB2bDGBoToW9daBCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KgESfgPj; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cdda5cfb6so29069305ad.3
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 15:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729981444; x=1730586244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zj0zfjZqT3t67RpWHrpfOHG+T//anNh4xzNNUBis8XY=;
        b=KgESfgPj7r9ucKVqn5Siz4X2t77TA2npTNfl9cpIq6qA8ZbCGiCSaFKzxoZSgbDnVu
         pvCZuxHOfXGSW6SqylBuMl/C6XJ97ZN7pF96BiSKOaJe5oQaQGaMTW5aXz5Fm0BDexqj
         zBIovYePTREDdDnmLmPn01vpAchYqavc6GsPGMenTqCrQKCJ4QBcekSwcdiJx3WUX3UJ
         iFRDbqpbzmYR3kqoRBLq7tgAWYOdFVEEP0vbSbjTGM3yKByJMRKwzGeAr1MME++dNg0y
         SxW/5t02xa6P4vnSPp5aRSTTG3SixId5AjNcTWfoi9I6ga2V1mfhhIRO9syXCT+8tolk
         Zt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729981444; x=1730586244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zj0zfjZqT3t67RpWHrpfOHG+T//anNh4xzNNUBis8XY=;
        b=XAp+fe35PmQHzDH3+V4m5uDgOYqfJRc8h1loA3txMzlZI9riJhpHRAqqFmglvf9Yt8
         HvrFXgN/hhuVerzSbeNW7xsuwYEidGlQ8PWgfdCBH20ZXrrI2Gb8Vwjo74IOGTAuE1SK
         Wr6lZ7UL7UJD34ipHz4i6y38qUgz2ExhSHipokxouk3M/3/+eLYFuzHMa2l1WZkYl0X1
         mjth/KncnY24f+jOr0sPKbkCrH5GTcY3BSehpliQWC6iU69wq2FRZkTQ6k+FBvxo+tG+
         D6ihx5e9qLCW0WtP9VWHL9o//9aQUIYKRZ7GGZLEtCsLAhYuY+ttCw5/26LxUPb9oX6M
         zwVw==
X-Gm-Message-State: AOJu0Yw3h2WH3v1EZUww30dOJasnsO4t0Nc0Yg0fHNJOW7CMJ78zd82y
	dZazv23H5wYifcYzuvNu4xhSWJBgfE04uPv0N9pt/HyQ9dWBlh5tfZ43hZEVmlg1uFN0XtSSpDP
	C
X-Google-Smtp-Source: AGHT+IEiw2reVnl5wOfECrWVUAi9M9fs9XZrKVeGirykLyYuoRv71/F36iruj3rpJD/QTUIHiyFq1Q==
X-Received: by 2002:a17:903:41c2:b0:20b:54cc:b34e with SMTP id d9443c01a7336-210c6cff16bmr55105185ad.51.1729981444333;
        Sat, 26 Oct 2024 15:24:04 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf44321sm28134705ad.30.2024.10.26.15.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 15:24:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring: only initialize io_kiocb rsrc_nodes when needed
Date: Sat, 26 Oct 2024 16:08:31 -0600
Message-ID: <20241026222348.90331-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241026222348.90331-1-axboe@kernel.dk>
References: <20241026222348.90331-1-axboe@kernel.dk>
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
index 603fd51d170f..0956401acd26 100644
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
index 69d4111d5f07..d62d086331d2 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -86,8 +86,14 @@ static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 
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


