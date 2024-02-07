Return-Path: <io-uring+bounces-576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8855584CFA4
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 18:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FE7828EA1F
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 17:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F02F823B8;
	Wed,  7 Feb 2024 17:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dzuuLnUQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCF87A70E
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707326389; cv=none; b=RyTpXS3utOJSuKrFT1Ai8yol6CFSceBBA8/Bk9xtfF1hXko5C0qcMjEGXLevhHMPykqxDf3ZETuag/hQojKBAWrNTZFvMIFD55eZqCB2NHS47dokt6K3QAnpEuU1fdF+3rZkLnSTqWA22kcxynNDNTg/YySrrKsciFZEBqCDq+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707326389; c=relaxed/simple;
	bh=i8Qdi8ws8Pdi0xD/DCla8fIwg3048KoTZDGnwE9ukZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqcIsen8E0JHbzxW6HFu/wNJaAUs0vm6yDLPXpdSbcsl+AcWCsWN9efApdL9Cs7kEdCQsZVEYA1my2JbUsqpZp4exSP5E6db+Rmo5S+PyhxzCnQZG4FxGfjYkizCJeiBeouv+keHGU22T6ODjb2qTacjfgIRqa69ZsvGq/P/DGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dzuuLnUQ; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso17088839f.1
        for <io-uring@vger.kernel.org>; Wed, 07 Feb 2024 09:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707326386; x=1707931186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+BvvT/bLt+Dtd4p+a8eUflunBIdVoGheioMCSSBG2o=;
        b=dzuuLnUQ0XIITZBcl37S8zN5RG8cQMZSp/aMCoYV8m78I9WDJD55/cwWWAuH6y9oaS
         I7oNBQOb8eCd1h1uACSHr9f/oostXAUbR62297QkfZOuceUFPuxDqN8h/hG6xAY6xQgi
         8OUczQjl1vZYxRNtSuf2RDN8BDScgmxoHh5A/CMA+P4m4/o6kepCI+bNg7L+lXA4GoHP
         Iu0VOOLul1q/jI+cZbYCjrjBla+b/E/q7XFj2ygfCudx950Q887OgLHXBc7OXNlQGUXq
         nlnXGdf/mc/A5s/gpJtIx09YDIbMtredCg9ImZZshQylhPbYsMGLVPvZLhjOAe4kUb1m
         xgXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707326386; x=1707931186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+BvvT/bLt+Dtd4p+a8eUflunBIdVoGheioMCSSBG2o=;
        b=Xw+MIfZfzfOhkMVj53Dby1Lm2Xs7f1u1x3RCcnpECcyL6OKyaIbXR7Hp1clFsoF7ew
         YGgU2iBsI8KIWh4K1etinFgq4MKjal2b0ebnYE9TWuDxQ0iQGlGL9ZovWfziUrC1BO92
         QZhHfwG14u2MJRGbI6d0u+bBLM4zGgHI3cPAiKZ7JUrpdhGUIksTMLZ7EyROnca5ZzWf
         xRUpqm/svTFWpeoWkGuo57kanFluYhsPnbzT9AgYg+POeATSaO6B7FYMwGWkisHhXrHY
         dsCKiVuOWVomzPGkR55Vo8EnOhpxJdH0aoMzg7eCiqo7FbFYbGurwcSoKl7IeDWh1CSB
         K+qA==
X-Gm-Message-State: AOJu0Yy9LkllmKxDV99yTisaEyt5+ceuOoIJtjQvBW7xl3D9fifXqPCH
	q39IFFrgVDVWhvMiJxoLptYDVuz2s/TpXssvjulu0a8xX3dTYjUwYPDGk7VkSGdT51G/an8YN2Y
	Gpow=
X-Google-Smtp-Source: AGHT+IHccnQl1OtD19qC7e2B/NbF0WJmELn0D5flhBJM0XNTL/7fjod7hH2kiTMUgAfwPCW1HXGLiA==
X-Received: by 2002:a05:6602:155:b0:7c4:655:6e05 with SMTP id v21-20020a056602015500b007c406556e05mr472627iot.2.1707326386238;
        Wed, 07 Feb 2024 09:19:46 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g22-20020a6b7616000000b007bc4622d199sm421131iom.22.2024.02.07.09.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 09:19:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring/cancel: don't default to setting req->work.cancel_seq
Date: Wed,  7 Feb 2024 10:17:36 -0700
Message-ID: <20240207171941.1091453-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240207171941.1091453-1-axboe@kernel.dk>
References: <20240207171941.1091453-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just leave it unset by default, avoiding dipping into the last
cacheline (which is otherwise untouched) for the fast path of using
poll to drive networked traffic. Add a flag that tells us if the
sequence is valid or not, and then we can defer actually assigning
the flag and sequence until someone runs cancelations.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/cancel.c              |  3 +--
 io_uring/cancel.h              | 10 ++++++++++
 io_uring/io_uring.c            |  1 -
 io_uring/poll.c                |  6 +-----
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 56bf733d3ee6..e19698daae1a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -463,6 +463,7 @@ enum {
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
 	REQ_F_POLL_NO_LAZY_BIT,
+	REQ_F_CANCEL_SEQ_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -535,6 +536,8 @@ enum {
 	REQ_F_HASH_LOCKED	= IO_REQ_FLAG(REQ_F_HASH_LOCKED_BIT),
 	/* don't use lazy poll wake for this request */
 	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
+	/* cancel sequence is set and valid */
+	REQ_F_CANCEL_SEQ	= IO_REQ_FLAG(REQ_F_CANCEL_SEQ_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 8a8b07dfc444..acfcdd7f059a 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -58,9 +58,8 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
 check_seq:
-		if (cd->seq == req->work.cancel_seq)
+		if (io_cancel_match_sequence(req, cd->seq))
 			return false;
-		req->work.cancel_seq = cd->seq;
 	}
 
 	return true;
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index c0a8e7c520b6..76b32e65c03c 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -25,4 +25,14 @@ void init_hash_table(struct io_hash_table *table, unsigned size);
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
 
+static inline bool io_cancel_match_sequence(struct io_kiocb *req, int sequence)
+{
+	if ((req->flags & REQ_F_CANCEL_SEQ) && sequence == req->work.cancel_seq)
+		return true;
+
+	req->flags |= REQ_F_CANCEL_SEQ;
+	req->work.cancel_seq = sequence;
+	return false;
+}
+
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b8ca907b77eb..fd552b260eef 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -463,7 +463,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
-	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7513afc7b702..c2b0a2d0762b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -588,10 +588,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 				 struct io_poll_table *ipt, __poll_t mask,
 				 unsigned issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	INIT_HLIST_NODE(&req->hash_node);
-	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	io_init_poll_iocb(poll, mask);
 	poll->file = req->file;
 	req->apoll_events = poll->events;
@@ -818,9 +815,8 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
 			continue;
 		if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
-			if (cd->seq == req->work.cancel_seq)
+			if (io_cancel_match_sequence(req, cd->seq))
 				continue;
-			req->work.cancel_seq = cd->seq;
 		}
 		*out_bucket = hb;
 		return req;
-- 
2.43.0


