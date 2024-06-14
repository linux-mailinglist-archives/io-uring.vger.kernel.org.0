Return-Path: <io-uring+bounces-2204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECC290800B
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 02:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E10C01F220E5
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 00:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81026170;
	Fri, 14 Jun 2024 00:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mlb0C6DT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA489163
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 00:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718323477; cv=none; b=jcggPdzkvNwD/LB3TbqmQDbyVtSfz+JOVJy3Ba66JTJmdVTOMiaD3xB3lbNys8ncUTgosKogT+4Eqsz85hOTCEZcLIJr51hFCab1qJMmtNKKMVoyXO6EAw3oLjMrfGfWc79yTBXbnJDOy+HVMHMmGPpnlXxyKyZQW17EiGqcVgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718323477; c=relaxed/simple;
	bh=T800op7/TYm9oXI7yOyhOyRypBroa1sC49VDpHwKYMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gZaujgx7vsLLv3p4hTnd+clut95tKphkllbXWlVpiJ8dHReLUL+k/dZDRZT0/2dPNdZqa6IOsaFoMJDHc6DdnAlldoKMLlVW5lKzbO9KUtFzNzqL2p0KEtxmd6iyiqljPaBIHxS3q4bm3EBUQcRvkUqLNOvVIJEoFlrWq+rpeH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mlb0C6DT; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-421bb51d81aso13365405e9.3
        for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 17:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718323473; x=1718928273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hf0HVy3ZwMI9me5laJ9SiAUrFT+30Hg6vJmub+dgTkA=;
        b=mlb0C6DTE8wdoNPfXCpT0X8Du6LjK2YXvYcoWmmsPx9ianxV7+KR1WdbQ64xnukAei
         lpF6+EH0GFZK5SLGlazQ8Owp0za0U43P0eUCQcPuYUYPBkF6fLMEcQtCCgThAWglipOR
         rircfsHHjaf1J5VGQzUlq5SbrLcWyhus7JdFGxz9VY2s7tO2oWovszx22a46GvCNtRYv
         eGhuIzFUuBWXJWum7nMmpop2LLGleLloSE1R6GGF+D4UFHwU5WKzgOM+x9TVzerM6855
         O3HeHkBLy8maGs5Bfs5D1oM2ivChIWYf8WIloRHRKLTWtfF3rKpr0qIvYYedsSRYCpge
         yO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718323473; x=1718928273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hf0HVy3ZwMI9me5laJ9SiAUrFT+30Hg6vJmub+dgTkA=;
        b=rRIDsgjAg7L/Nqbtwcs+TRphICDeQs4lplA6vvIGUd0qjWEqS9yjl8FhkRLiyXeC6u
         EkV6FlY12Trz3OnTgsG8rPqbMiM7wRICkrZxhxNnQ2qlDdSFHOzo0D6eoaTJMamcoYmz
         U+KV7zyqPx8t9KMty3gVdZL5xB6NkgFqPNJktaCUWWFvNTAee73psm11vxOKSGQuKBOg
         6GngWQvIzl+TUnrBYpsV8HujMaDUnu20PfPFcpuZEi182By5s9PXfeGJE+Z3wct9TsW4
         ef/7QGKlijhA1HCemyd779doi6Us/+SZ8ef1O5qRvFR4lfXulpnQnnLqZgdNMlP2C2QL
         zLoA==
X-Gm-Message-State: AOJu0YyVEwo0RmRiEoteDq08rmVjoKvoZhTepR3rr3jnJcv6RYy1Gtiw
	XIzxtKN+7BPrWT6zVpDIrSkZ17UEwirowI6dYKLTDMJKd2/DpcZPJHmQ+g==
X-Google-Smtp-Source: AGHT+IGM6yQIWd27RUkxAMbiXgt5mhDAPUubho5m5Axk8yA1rnLlODSpE8jnfLuwRYuH5WKEa+fEBg==
X-Received: by 2002:a5d:54d0:0:b0:360:8200:858e with SMTP id ffacd0b85a97d-36082008647mr203751f8f.55.1718323473170;
        Thu, 13 Jun 2024 17:04:33 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.187])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c790sm2919170f8f.38.2024.06.13.17.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 17:04:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Li Shi <sl1589472800@gmail.com>
Subject: [PATCH] io_uring: fix cancellation overwriting req->flags
Date: Fri, 14 Jun 2024 01:04:29 +0100
Message-ID: <6827b129f8f0ad76fa9d1f0a773de938b240ffab.1718323430.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only the current owner of a request is allowed to write into req->flags.
Hence, the cancellation path should never touch it. Add a new field
instead of the flag, move it into the 3rd cache line because it should
always be initialised. poll_refs can move further as polling is an
involved process anyway.

It's a minimal patch, in the future we can and should find a better
place for it and remove now unused REQ_F_CANCEL_SEQ.

Fixes: 521223d7c229f ("io_uring/cancel: don't default to setting req->work.cancel_seq")
Cc: <stable@vger.kernel.org>
Reported-by: Li Shi <sl1589472800@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 3 ++-
 io_uring/cancel.h              | 4 ++--
 io_uring/io_uring.c            | 1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ac333ea81d31..327d7f43c1fb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -653,7 +653,7 @@ struct io_kiocb {
 	struct io_rsrc_node		*rsrc_node;
 
 	atomic_t			refs;
-	atomic_t			poll_refs;
+	bool				cancel_seq_set;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
@@ -662,6 +662,7 @@ struct io_kiocb {
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
 	/* linked requests, IFF REQ_F_HARDLINK or REQ_F_LINK are set */
+	atomic_t			poll_refs;
 	struct io_kiocb			*link;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 76b32e65c03c..b33995e00ba9 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -27,10 +27,10 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
 
 static inline bool io_cancel_match_sequence(struct io_kiocb *req, int sequence)
 {
-	if ((req->flags & REQ_F_CANCEL_SEQ) && sequence == req->work.cancel_seq)
+	if (req->cancel_seq_set && sequence == req->work.cancel_seq)
 		return true;
 
-	req->flags |= REQ_F_CANCEL_SEQ;
+	req->cancel_seq_set = true;
 	req->work.cancel_seq = sequence;
 	return false;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c170a2b8d2cf..8a216b1d6dc1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2211,6 +2211,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->file = NULL;
 	req->rsrc_node = NULL;
 	req->task = current;
+	req->cancel_seq_set = false;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
-- 
2.44.0


