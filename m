Return-Path: <io-uring+bounces-7698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A775A9ABB3
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 13:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A671B923A36
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 11:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D706D433A8;
	Thu, 24 Apr 2025 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akBiBvdC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F706225A20
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 11:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745494053; cv=none; b=eMPHl7stJWZMxMJlOZoIRr3uEfoNZgCPupn1jxuzR7KIUuqXQyJkRAM31CL7+xsEkcGMPadAn7IPBqLOXfgd9T/KPqC0NefSA9cGOd0/y1dG4t8hAVGZGkTpGZVzcLYbHQRt8G7fHSIbAUgwSHDOXHVAZHBuxxmvqVw8MUzDjSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745494053; c=relaxed/simple;
	bh=QomfrEesLMFDWWkHiZJErvl00Bz18weV2p4FbHG0YYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ODe1NzPZ0SW2roC5oywZkpwHuo0qgjrXl0MzaS5XgcIh9lDNtjFT9cYGQXC7TE8qQDEBpeiME0Igu9LtP/qtAC5JeYh0WBUzNyort3YuAf7rnLlmqS1tkYvKqBLf3//l/g2M+p38vgnYhxqbrhAWiZ39b0Vws8K8ENsrwkITqCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=akBiBvdC; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so147316866b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 04:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745494050; x=1746098850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LhaxkqqJXsY4OnyG+eJUl1tLNjYiEeIg1F6nezVIae4=;
        b=akBiBvdCZvAvVqzNWueXKGjnMsvfa9on9vAOYDnUqp3Pza/k7EiU9ma4QumE/lwT1g
         +8vHqnSozKuqu1iNlKg1NAh9eSBjtHXYUDZhETIeWGzLKkUq/g0GMiGl4VuT83cPvKwh
         ys0IhSeelRPm+YkUbwxezurGhQ6y6isVGIF6fIiE79xlfITVyCQcuPjJ9U1cA/r0jR1s
         m+RBcaFfMPwtpycaNiipSnkO3hbYi5Q5HORDrHue/Ce2IKanwMDue99TkUh9RCk1iALk
         03+UGrZSjRtSMth/J5GiRPfNMXxFLEzfSkIBn/hJTks7xXoQa3lTcuP5ufjhlhNJ2SAP
         pG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745494050; x=1746098850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LhaxkqqJXsY4OnyG+eJUl1tLNjYiEeIg1F6nezVIae4=;
        b=uPjPR9yp7dJIDDtI/geFeL3qGQMOKEiQUBETjzOasGo54s4JdIrHeUcDS3f0aAKU/O
         +rZitvDQwuKkH5nSjitYp60ztSPC9F8pkKU/MSFPdWpHuxGj7CPlq6/mGKM5ugmpCtAb
         QgbogmKP2l9aS4dHuuJgD4e0NGnXNUn/QERYIUIQAkkUoohNQINv9FNMR64Oxc9DM4Gg
         8jmBu5/N/VCTg4XHsb6CbZ6ixzFpSwhBGxUUP2fspjMy7uYX9qEFE6WOCxMtgeTTQn5f
         Xsc3QJP6dDTww0DO7TlCwQFNP3I0y1/lkrvxJxmjitDvsOaBN/R9XnFBE9wnOBEtqt+A
         HBqw==
X-Gm-Message-State: AOJu0YzlbK0T+gw7rVq5MLBZn99fCPsn67zqrXRtO8LE30CN0waOT5V8
	KZNEZxKPno/P1uJ9MYuK5bIeqY2wrLS9h2KxKQjiwCqwlr4sGHcLToD4YQ==
X-Gm-Gg: ASbGnctVTsPh8z3u+6e3xpllTX1f5YXEvns0ZJao0yfIRjkaI0Otv0f/aLuNcYjwj8m
	aaD0koh3OWBu4ZGHJa39hRg7EJ4Sk2ZgohMti2viSIGDzHkp3LugLCzmcR8q9Rg9uq+HfO97nrT
	N5pfUKU1z02bH5D3AGlQilnyzBJhXAoXOACjN1UaAwSQPDG7GZ3SVo4v5Kq0BJA/EicbWT9/K3R
	XRvj85fBjd7JSMQZG5AToY5erDy108Om7PcYLUN5DYLWL+KGJlDCQzZj1daPYSHEbB1mhmuKrOC
	GvPT6S9XAr1V1K+5PnA0bLqy
X-Google-Smtp-Source: AGHT+IHga0vxGrxLRiag4a4V/aJdLSbsSRvH8grVgGoQ6oC10cNn/bA6VAqq4oEt5bxA7YFiZcqHSQ==
X-Received: by 2002:a17:906:c10e:b0:ac3:853e:4345 with SMTP id a640c23a62f3a-ace573bad5amr227247466b.45.1745494049703;
        Thu, 24 Apr 2025 04:27:29 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c716])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace598980easm92997966b.40.2025.04.24.04.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 04:27:28 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: don't duplicate flushing in io_req_post_cqe
Date: Thu, 24 Apr 2025 12:28:39 +0100
Message-ID: <41c416660c509cee676b6cad96081274bcb459f3.1745493861.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_req_post_cqe() sets submit_state.cq_flush so that
*flush_completions() can take care of batch commiting CQEs. Don't commit
it twice by using __io_cq_unlock_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0dc6c2f1295e..7099b488c5e1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -873,10 +873,15 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
-	__io_cq_lock(ctx);
-	posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	if (!ctx->lockless_cq) {
+		spin_lock(&ctx->completion_lock);
+		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	}
+
 	ctx->submit_state.cq_flush = true;
-	__io_cq_unlock_post(ctx);
 	return posted;
 }
 
-- 
2.48.1


