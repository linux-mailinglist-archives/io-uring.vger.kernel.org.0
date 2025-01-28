Return-Path: <io-uring+bounces-6157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E18A20B6E
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B202C3A8EA6
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF9C1CDFAC;
	Tue, 28 Jan 2025 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="JgcDp4pK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5BD1A83E8
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071586; cv=none; b=GElKhfqqVKupC0rnjMeCmhA8OZtSjLkDNpGezx95TXGTpZ/z26T5ZfZAYidmiwhtxQZitybgiMHjid6kgTsXKTf5E0RJWit4tVNBqbI2b67splNmeoeuAoYgVoB+IfDUQRb0kG9WER86dbZNr+khguSOzzJVB1/mcal9oo+IATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071586; c=relaxed/simple;
	bh=lCqFDQKjXKQloLeJSNnPRtRIePgGsRGjnc4yAALoKf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM+5Hna8Qr0/rQXOUreDRgtU9CBzuwShElaBwkfz9dG/QEc2MvZhQ8X1CP849LDjvMR0/DMLsiG5zzTtnylX9fV+2G3Qr4BS63vNZDefpNJbJtfRjrFgjSS0Nqu3MXYbbKal1QNtpSONOfsy45ULT0VkBr778ryLHsjinMA/8FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=JgcDp4pK; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-385ef8b64b3so4939440f8f.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071583; x=1738676383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8ASk23Y98Dq5UqiMCsyxF3GOBUBf2YhS0lyIFI6nWA=;
        b=JgcDp4pKgH0uEHkU2IE3NgpRcakLBA7m7EWTv06DS8SONLB8hJT7/FVlrMYYOswOls
         rBkdb9yvVd2bButCIDldLO9mK6LwRyTtjvCCFlxMM+Sktg2LeqwXaIrFZmjZ/gNPPl2E
         hcY5jeptxEP3QwzaIHf8GamtHt/Ui/ekdvYegRrtbSX+VnpSof1/7uCz+tiEc86pZfTG
         kkYPeOu1IQIzuTJNLCbIdoAM5nYR90riPu3WUG4hXt3bym3wHozAOBQl3VjiWOwxT2Cn
         GAcO5Ig3NTMVWZMH+8PK5FZo+vYtHdQWJeudHUUiyRIKPR6ACHEGBEpAsnTQuC+zF7TK
         kM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071583; x=1738676383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i8ASk23Y98Dq5UqiMCsyxF3GOBUBf2YhS0lyIFI6nWA=;
        b=HowXEvypBFjtw0hOV1qkBo4y1O/CM4xb4/ZCaRydZiD9SKTInC1R7np+ngbfAq5+hJ
         L6O2jWVjSfO8znpL0CtBLMtRKWhZWptdG6jyhHpLfEPbtqHbTg07Hc9xNLLhgaIUjHQj
         7AasqiIpiLcuz6+bbSZZ3vq5GVp5IN1FAq2EkFEVFtyr3tW4h8cB6kSfe6H58Apowq3m
         Voer2yTE1aY4aeriPSQ9UloG9sobZLLIRi+Qkju5wAVMsiDJa3sUDN5XZjg6y1ObVllJ
         7QvA2bsBPPlPtSx+vE28W+WrIaP7xAQMXyKd/qEKUToKBKcrYSNMjVFmtYsDMNjIPohT
         fHtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLTUnmfPJhAIKMkyF875VIvGq7xm3e+DkI8eQDtq7udUCcUU9yvESiO0wFMNXMYmg2Y5LVTab94g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjkoR2H+3V3YWedv9uVEVXs9nJ7xuKv3++BsFUKZIA5pLQtqWy
	qlqm7S0cebh9CS2mbSJ/4j/RDhDD9c0nI53Kynbir4Os1g96aJrGryJCBLM47FU=
X-Gm-Gg: ASbGncuUVYLH8UM1rjEBMe+lrpPNjBhLM0qFz1z8TbjnT1LzPNTnW66MECoHmwpahj2
	Boii/0ksTCITOw1NvM+wbL4xF9y/bl46Hi26z/eDD1JV4pF19+SVyKdDcKq0dfysE3TUyrIqDRp
	QYeYAujYuBg45xbvZEFiyiMkLM6E1xvzSiHrQaIG2DQTwRQtUA7pYayVNX7+lf6hTLf/oaWS5Ln
	t5DqIT/lpTnJUjZ4EUCp0PEdjtwkl5hFo6g69T1BrDTPDDUVn5t13TVynq/R8poZrFw+slKfjZZ
	Wv0dNkv0+TivMPMw5IVrZH55dupw+QKvJHhCDsUbFcqcJOEfr0xCCsWna+upPY3mPYt+Wxod1ww
	oBwYks9KNxQrMfHU=
X-Google-Smtp-Source: AGHT+IHpAzP2vf6kbCaoXmQHJGAOkxMfs8DyzeLyD8CLZ5Z45dMSg/qF6pExH7WRYEt401mL9rsxIA==
X-Received: by 2002:a5d:64ed:0:b0:386:3e87:2cd6 with SMTP id ffacd0b85a97d-38bf57b7633mr50074000f8f.38.1738071582763;
        Tue, 28 Jan 2025 05:39:42 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:41 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 7/8] io_uring: cache io_kiocb->flags in variable
Date: Tue, 28 Jan 2025 14:39:26 +0100
Message-ID: <20250128133927.3989681-8-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250128133927.3989681-1-max.kellermann@ionos.com>
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This eliminates several redundant reads, some of which probably cannot
be optimized away by the compiler.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 io_uring/io_uring.c | 59 +++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7bfbc7c22367..137c2066c5a3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -391,28 +391,30 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED) {
+	const unsigned int req_flags = req->flags;
+
+	if (req_flags & REQ_F_BUFFER_SELECTED) {
 		spin_lock(&req->ctx->completion_lock);
 		io_kbuf_drop(req);
 		spin_unlock(&req->ctx->completion_lock);
 	}
 
-	if (req->flags & REQ_F_NEED_CLEANUP) {
+	if (req_flags & REQ_F_NEED_CLEANUP) {
 		const struct io_cold_def *def = &io_cold_defs[req->opcode];
 
 		if (def->cleanup)
 			def->cleanup(req);
 	}
-	if ((req->flags & REQ_F_POLLED) && req->apoll) {
+	if ((req_flags & REQ_F_POLLED) && req->apoll) {
 		kfree(req->apoll->double_poll);
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
-	if (req->flags & REQ_F_INFLIGHT)
+	if (req_flags & REQ_F_INFLIGHT)
 		atomic_dec(&req->tctx->inflight_tracked);
-	if (req->flags & REQ_F_CREDS)
+	if (req_flags & REQ_F_CREDS)
 		put_cred(req->creds);
-	if (req->flags & REQ_F_ASYNC_DATA) {
+	if (req_flags & REQ_F_ASYNC_DATA) {
 		kfree(req->async_data);
 		req->async_data = NULL;
 	}
@@ -453,31 +455,37 @@ static noinline void __io_arm_ltimeout(struct io_kiocb *req)
 	io_queue_linked_timeout(__io_prep_linked_timeout(req));
 }
 
-static inline void io_arm_ltimeout(struct io_kiocb *req)
+static inline void _io_arm_ltimeout(struct io_kiocb *req, unsigned int req_flags)
 {
-	if (unlikely(req->flags & REQ_F_ARM_LTIMEOUT))
+	if (unlikely(req_flags & REQ_F_ARM_LTIMEOUT))
 		__io_arm_ltimeout(req);
 }
 
+static inline void io_arm_ltimeout(struct io_kiocb *req)
+{
+	_io_arm_ltimeout(req, req->flags);
+}
+
 static void io_prep_async_work(struct io_kiocb *req)
 {
+	unsigned int req_flags = req->flags;
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!(req->flags & REQ_F_CREDS)) {
-		req->flags |= REQ_F_CREDS;
+	if (!(req_flags & REQ_F_CREDS)) {
+		req_flags = req->flags |= REQ_F_CREDS;
 		req->creds = get_current_cred();
 	}
 
 	req->work.list.next = NULL;
 	atomic_set(&req->work.flags, 0);
-	if (req->flags & REQ_F_FORCE_ASYNC)
+	if (req_flags & REQ_F_FORCE_ASYNC)
 		atomic_or(IO_WQ_WORK_CONCURRENT, &req->work.flags);
 
-	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
-		req->flags |= io_file_get_flags(req->file);
+	if (req->file && !(req_flags & REQ_F_FIXED_FILE))
+		req_flags = req->flags |= io_file_get_flags(req->file);
 
-	if (req->file && (req->flags & REQ_F_ISREG)) {
+	if (req->file && (req_flags & REQ_F_ISREG)) {
 		bool should_hash = def->hash_reg_file;
 
 		/* don't serialize this request if the fs doesn't need it */
@@ -1703,13 +1711,14 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	spin_unlock(&ctx->completion_lock);
 }
 
-static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
+static bool io_assign_file(struct io_kiocb *req, unsigned int req_flags,
+			   const struct io_issue_def *def,
 			   unsigned int issue_flags)
 {
 	if (req->file || !def->needs_file)
 		return true;
 
-	if (req->flags & REQ_F_FIXED_FILE)
+	if (req_flags & REQ_F_FIXED_FILE)
 		req->file = io_file_get_fixed(req, req->cqe.fd, issue_flags);
 	else
 		req->file = io_file_get_normal(req, req->cqe.fd);
@@ -1719,14 +1728,15 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
+	const unsigned int req_flags = req->flags;
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	const struct cred *creds = NULL;
 	int ret;
 
-	if (unlikely(!io_assign_file(req, def, issue_flags)))
+	if (unlikely(!io_assign_file(req, req_flags, def, issue_flags)))
 		return -EBADF;
 
-	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
+	if (unlikely((req_flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
 	if (!def->audit_skip)
@@ -1783,18 +1793,19 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	const unsigned int req_flags = req->flags;
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	unsigned int issue_flags = IO_URING_F_UNLOCKED | IO_URING_F_IOWQ;
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
 
 	/* one will be dropped by ->io_wq_free_work() after returning to io-wq */
-	if (!(req->flags & REQ_F_REFCOUNT))
+	if (!(req_flags & REQ_F_REFCOUNT))
 		__io_req_set_refcount(req, 2);
 	else
 		req_ref_get(req);
 
-	io_arm_ltimeout(req);
+	_io_arm_ltimeout(req, req_flags);
 
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (atomic_read(&work->flags) & IO_WQ_WORK_CANCEL) {
@@ -1802,7 +1813,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 		io_req_task_queue_fail(req, err);
 		return;
 	}
-	if (!io_assign_file(req, def, issue_flags)) {
+	if (!io_assign_file(req, req_flags, def, issue_flags)) {
 		err = -EBADF;
 		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		goto fail;
@@ -1816,7 +1827,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	 * Don't allow any multishot execution from io-wq. It's more restrictive
 	 * than necessary and also cleaner.
 	 */
-	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+	if (req_flags & REQ_F_APOLL_MULTISHOT) {
 		err = -EBADFD;
 		if (!io_file_can_poll(req))
 			goto fail;
@@ -1831,7 +1842,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 		}
 	}
 
-	if (req->flags & REQ_F_FORCE_ASYNC) {
+	if (req_flags & REQ_F_FORCE_ASYNC) {
 		bool opcode_poll = def->pollin || def->pollout;
 
 		if (opcode_poll && io_file_can_poll(req)) {
@@ -1849,7 +1860,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 		 * If REQ_F_NOWAIT is set, then don't wait or retry with
 		 * poll. -EAGAIN is final for that case.
 		 */
-		if (req->flags & REQ_F_NOWAIT)
+		if (req_flags & REQ_F_NOWAIT)
 			break;
 
 		/*
-- 
2.45.2


