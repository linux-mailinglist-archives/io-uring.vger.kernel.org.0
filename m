Return-Path: <io-uring+bounces-13376-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAw4G2wzCmqMxgQAu9opvQ
	(envelope-from <io-uring+bounces-13376-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2026 23:30:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA597564022
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2026 23:30:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32FC53018D77
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2026 21:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B402D8399;
	Sun, 17 May 2026 21:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZSBRvGZP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B192BEC43
	for <io-uring@vger.kernel.org>; Sun, 17 May 2026 21:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779053417; cv=none; b=sOqhdvX7ThkG4sa02TvEyvefHJ/zZ9ueQGKln5XXCzkokmMDc1wszloZ2NV8txkAO1a8kRyOZ3B3F8VZoK0gkGlWw37rFc+uyDGURwTypX3NdlehrmM3U777rP80/d8rAOuXSdkctfrsmJuj1zm7wlWmWjDKfTjYAy+D91dKEhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779053417; c=relaxed/simple;
	bh=2cHKYn2f6w0kDULHSqK48+9/oXwCGs+d9elAlUxEX9I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Am8ydgneVFlA5hAPR/xtcJbg3w3G0MKZw+ecDfGoMHpEEYe5HgDvfNQTyPFYFOdB/U+GNsj/u1nYsT7rPtuWUQOcr4mDltpCTWmSkBOSIyjNFfA2ntw0VsWyZwz2nUpq5hz403hQri6k0wfOU/XwA7ojQ4ukOPTecd6qWcURbqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZSBRvGZP; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-912278ed3b5so185157985a.0
        for <io-uring@vger.kernel.org>; Sun, 17 May 2026 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779053415; x=1779658215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o2hXOV088N3HeC0bZzKE5fv3Wg815pFZ+IHEYgpTbM8=;
        b=ZSBRvGZPhjT4ig37wKQenTs1Ten/z4gFfuE7Ur0RzZAR2miFnNExhJbjRpr5L+MS73
         f4BDZPeeCnHEcml4IjJAEXqTAjENnWhrJY2v9e8DXrX5C7dHk4PZZG3+pVO/wpJ/bSjN
         DqYTU8Bgsrv/D53o36fduUNlAQ3JglPv14HSwhH8E8aOmxKDWKGNDXDkQGlCnOmnUB4J
         HdpjcqhyTYiLLPpexJcfko9X2bJBmUNBzRijuw7bruPhjcM3TLDBuK3PnPGzan+HOMOU
         Do+URYe5ca0b7a+LnAoqUAWs3F+rW34GRqxy5GrevWUcc4oF2zPJ1m/w7PeN3I25ccms
         W/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779053415; x=1779658215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2hXOV088N3HeC0bZzKE5fv3Wg815pFZ+IHEYgpTbM8=;
        b=p6J33zjMsUYOv2NuwJzlbsus7mp/VGyJHV/SF62l7arZWzlzin4Upj2O9PUBop6DC5
         ezDlBVHVHdJ85MFML/McAi25JPX6wUlZhq+hOa1Urs4EkOuU5In/tO6VSkujY0UW9YpF
         XZGC273eDHDpyjFFE7c93F+AFm5yc605EHHxw+fdKwnBzFHLQam+1FbIRMosj/+o9wRW
         nagv3LQd3s+mW2tzvdKMZ4YR1W/JvWAIEWnv47uU9ysIiOqDCf6u8/OnyeBEkQ4dyH5j
         fTAHjGFZAYdZYaUV/utnk/1yOHJs0RqLIYSJ4/7Xwh0MAqwlR7+ZB31Bajaae/AXCpW9
         nGAQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ztow0EeeUFO9CFbJnzUYNrd0J5qSP49IrRYNNYLGImc40VILAdUu6K69pMYRdSyURvftvJdAdHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEQmBzHviDa8Tp9OoeHB+xzq6RneSKNg0SXJQiG1D+jJpy02Tp
	+UeobsJ//pb5b8Z03Lf9Cj4HQ7/zHdA58XZFUBifP4AhNZsa7xPE8/o6
X-Gm-Gg: Acq92OHPJzZtOeSy2vGcBLvcCM5Arm3hozxCFQmFMqdqR0EtQGYtboP5xZoqcu12bYe
	6Bz1O+PMB3oLPZsGSYekoLRYM2I5lKRTcLIMWtgMex95MROSR8CmarHvMd+B8QYQ/HwZl0EfXm3
	7CdaUdx/hcTyi+fWJsMtnzVCzpBx+mP0pmzN5pDInh3sC2I4fWdKP/VLhziJzS3sTwLfrMPlWxL
	/8eIdnUYhf4wOmt6udGR4lN7MuE9k7BQtwU8jjpscq7HkGmy9TsYn/Dk2HaCJJmtZX+mOQQOuVM
	XgtcT1cAl35NNJj6RCUmDmKmD5a7Y+YkwCWZDx11w7Uhudnlc1gol6EbHixEF09qHWH+TldQo+n
	7PPSHiR3o8TgwbPKYR9PwklbgwawZdIgG/Xx8NDIpx/9tlj/dFV5Rf+1jldiGpO+lZwMOUZFXAh
	BIQio3jQMArbwVFidbrdHL9tcV39z5izrl5h0KXfLqv68hYeqyvawAxBYOBUDfY4Y+J2HBIyTRh
	xdstrOKDU4huLgto3L/lzWwsdp+nLT2BKKICMJrjR4=
X-Received: by 2002:a05:620a:2950:b0:90f:9cde:9788 with SMTP id af79cd13be357-911cda50d4dmr1955996785a.5.1779053415002;
        Sun, 17 May 2026 14:30:15 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bab3a207sm1265416685a.15.2026.05.17.14.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 14:30:14 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>,
	Keith Busch <kbusch@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: propagate array_index_nospec opcode into req->opcode
Date: Sun, 17 May 2026 17:30:10 -0400
Message-ID: <20260517213010.696135-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA597564022
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,huawei.com,kernel.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13376-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[michaelbommarito@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
array_index_nospec() to io_init_req(), but applied it only to a local
opcode variable. req->opcode is initialized from sqe->opcode before the
bounds check and remains the raw value.

Keep req->opcode as the canonical opcode in io_init_req(): reject
out-of-range values architecturally, then write the array_index_nospec()
result back to req->opcode before any table lookup. This keeps downstream
users of req->opcode from observing the raw user byte on a mispredicted
path.

No functional change: array_index_nospec() is a no-op for opcodes in
[0, IORING_OP_LAST), and out-of-range opcodes are still rejected at the
bounds check above the assignment. Boot-tested under UML (x86_64
defconfig) by building stock and patched kernels and running a 54-test
subset of liburing against each; pass/fail results were identical.

Fixes: 1e988c3fe126 ("io_uring: prevent opcode speculation")

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
v2:
- Fold the clamped value into req->opcode and use req->opcode for
  the io_issue_defs[] lookup, rather than keeping a second local
  opcode variable. Suggested by Jens.
- Keep the hardening-only framing; no functional behavior change.

 io_uring/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ed998d60c09c..84e16c3ad3f47 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1721,10 +1721,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	const struct io_issue_def *def;
 	unsigned int sqe_flags;
 	int personality;
-	u8 opcode;
 
 	req->ctx = ctx;
-	req->opcode = opcode = READ_ONCE(sqe->opcode);
+	req->opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	sqe_flags = READ_ONCE(sqe->flags);
 	req->flags = (__force io_req_flags_t) sqe_flags;
@@ -1734,13 +1733,13 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->cancel_seq_set = false;
 	req->async_data = NULL;
 
-	if (unlikely(opcode >= IORING_OP_LAST)) {
+	if (unlikely(req->opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
 		return io_init_fail_req(req, -EINVAL);
 	}
-	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+	req->opcode = array_index_nospec(req->opcode, IORING_OP_LAST);
 
-	def = &io_issue_defs[opcode];
+	def = &io_issue_defs[req->opcode];
 	if (def->is_128 && !(ctx->flags & IORING_SETUP_SQE128)) {
 		/*
 		 * A 128b op on a non-128b SQ requires mixed SQE support as
-- 
2.53.0

