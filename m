Return-Path: <io-uring+bounces-4075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D466F9B3452
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 802DE1F228BF
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8D31D9681;
	Mon, 28 Oct 2024 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kEongFck"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC90218FDB0
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127896; cv=none; b=a2LBOHgq6qf5esxD3wJ5Qnj1YIRMo9D8AvjmR/w+Z+dL7yiI8N1I3lAu557MAwzQizMQcQmNDeV0XGZKVLXOD/Mn8ANMbVr/gJcBbSmFosHFKWBNobc7CIw9i7sujAoWqzFIx7x0MifitxHZ226gOvgGFuOfps1RDu7j0dy+aMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127896; c=relaxed/simple;
	bh=aONGbiXI68zJwmEw4baPUiPbjsy3j7TKGRE5bSfm3Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvmlmegQtP6VnCijD7mbsurMv68XILMlPtw3UWeBL4hz0biycPfJfLlg0CtxkNRhN9nAKzoviZ6GYR1hb7hg2Ia/zld7SjZmwG+E7h+hK10TJas5Wy8Z5FUv8IIAdtvenaTsHieOXqunKLiyj9108zPRxIVOtDzs2ecDihyXRe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kEongFck; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a4ccfde548so12022955ab.1
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127893; x=1730732693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MeRQPNzBbEmZmIGWPgoBj0EMrrHCu/JDI5w42FbaIPQ=;
        b=kEongFckB9Sw4JPjbh3vRPYDynahNg2QeQDkoCGU/mcjsQP0iazT3lbwoEhjBl6mqK
         MvfnRzm5gSai63qoRDQ35SfvDqO9vW+cJJyyZBWQtrgghMyAzJq7eiy2YxoNYTonfjLo
         cVr9qJq0f6sRQEEQCb4LqKBBd5rYB32nBAPqx8dIaAN625tFCBCNwtOx9PvaJJ1Jn43d
         yMDzvKjxhopilucQwFbD79BzEKaCKPuIC0L4C2bqkW7//17MouRHeO1E6r/Q5ppz97ev
         TItfCvyyhaSZSnxP9MHmAqzG7anKeVi/bg0SLnRQM3wygkydveWxgQluZfafdXTAx+nO
         lO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127893; x=1730732693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MeRQPNzBbEmZmIGWPgoBj0EMrrHCu/JDI5w42FbaIPQ=;
        b=i9uLt+4bcNMehFnTGwCdJ30n9xUtT7sxmaFmWxRSqI5yr9FSnm2jT/9ONKVRotivX2
         kCcl85F6vvQkzwfBTj7JJ8kphxb7VmdJTAvyXU6MojOB/j26ve/tN5BEJWce1g2OHnG5
         ST1AIS/HudCBekk0D7GY6pltS0jNh65D4vXHxmjKOQhbwgtI1AaTQBrmAQd9X4njrHxK
         sHPnRuiEV6LoFM3vwTH0DfzDjGetGAWosJNjputDObr0pmvegkBVEQMVQHl8rH4W0nm8
         FpliGuu4EGUizJcL6nRcoGBA0sk1xPF1z+P4pUjijtNz+isFeYk6Jq6jJmbCge2yAN4e
         u3fw==
X-Gm-Message-State: AOJu0YyZNTfToiN6TciDIOsskoAk5F9Wvdycn3ef6ScPyLqiSy4LXOkC
	dK0mKInyi4Ak8LO7QDAiAlisOYfz7s6dk7sYMy0lX8TcABDwUxt/PmiBsOWBFRThj3EYN86w4em
	o
X-Google-Smtp-Source: AGHT+IGRb8sZ7gH5u1I6F9N7pvTnXCIt+fv3o1Z3QPo9orEJLP/rP67NbJ/L6Fb8/VwFl4gaiP58tw==
X-Received: by 2002:a05:6e02:198f:b0:39d:3c87:1435 with SMTP id e9e14a558f8ab-3a50896d7cemr1209965ab.1.1730127893156;
        Mon, 28 Oct 2024 08:04:53 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/13] io_uring: only initialize io_kiocb rsrc_nodes when needed
Date: Mon, 28 Oct 2024 08:52:39 -0600
Message-ID: <20241028150437.387667-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
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
index fb86f080ae5c..53907e142ae0 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -85,8 +85,14 @@ static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 
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


