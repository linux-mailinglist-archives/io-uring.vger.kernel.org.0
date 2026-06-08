Return-Path: <io-uring+bounces-13638-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id EGOBC7LEJmoYkQIAu9opvQ
	(envelope-from <io-uring+bounces-13638-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 15:33:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B82A7656AD1
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 15:33:37 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XroM7rti;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13638-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13638-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CAA36300D4D9
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 13:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5575936CE19;
	Mon,  8 Jun 2026 13:33:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0571A2F39B4
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 13:33:32 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780925614; cv=none; b=T0bxc16VAA7n+owylzjPUWC8bBlMKXdYSVDApoq2ul6qThQ83a7E7NaobdlMTWOBZg9+zaugQWzXIUKxyVVtgt8FHNSo1PT9jwMp4B7v+Pdc/qdbeZmhGnEz9NQFOds65MnBtbdphA0WIEg5pPGo17MISd9OaZMus1+C2H4rSl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780925614; c=relaxed/simple;
	bh=Xmn251nvSpJo0undebzXVap0KXqK+G3jWZlPawuj8fg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RzOSTL0/qTs/lw8mB5R2SmE6NsZiLJdTlcJQesIVjojKSKXJpI7iQmAi/nDjLvip5KSJZQEB0ENAIpDRI/VbvgIgJ31bmzmOw5y8AgfwBRnrQSxhyGkH9y9/obtgWt5ViDZIKTOj6SnTk+PKRarfsJr+jzfGFmKDqg5oVDlXn/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XroM7rti; arc=none smtp.client-ip=209.85.216.54
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-36d5fd50d20so2735480a91.1
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 06:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780925612; x=1781530412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jE4e+Ch7YZ/ecmySo10mEfolKNwDMzJHte9df/q8qqk=;
        b=XroM7rti2XYztFPW+x69RSxj0QdNYcr/b+VDMJWn0L+PQk1r5tkx6R63urg3Nb562/
         D5J9P2OPUwbO0Ov9fjXUoOGUI5bmrz/Rnh+Bhji/kBA1qcGTFFXm5evaglLzIXB6+v2V
         gC9Fctxi+NxQ5ePSplUhCITBPIwAmbG9sOOEnOBaTPELf6185uKRwciT7/YxNHOBB6go
         o1PKVvCJ1gRrBDqThZGUtfraw+Dp9wshRWMv9Hf0QKhnrmZtqbdvOUdqmgTgG5YGyn3u
         ZflBfBCTzHvxdq30j+2aHyFdQbdeYHAS2tpFonEdxhYDxJlBtPy24+cFdCf16wpzks6E
         HafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780925612; x=1781530412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jE4e+Ch7YZ/ecmySo10mEfolKNwDMzJHte9df/q8qqk=;
        b=DMWJ+yKxdAZK+tZ0gisrmaEsZzTl36M91d+tbOXGmFhP0qRoqtWKdHA8St/JLb6r8Y
         5QQdd4GclD0FOsAB8Rc+OmAKI8DvpFvtF//sVDYLv0WDLmM/TjtJ4rio5yZAcGTXMfFg
         l4t+hiGU5jD8/h+7ZXAshiai1rp857nGcH8kwLxr09XB4+XjwJvrsIg4ALI4ODDtsASH
         Szbtl/TIPPVNQJgDwIqnY/ot9QJwCVM+ofcTdoFSo4tXqhziyXoGfcasVMnuNfdHD3pq
         OFLb3IrHwaqwREyIycr37hIXPR5g8qGKF795Vcfow+4FXV++R0Vs2rq7Oh4IHp0k72UJ
         0yWw==
X-Gm-Message-State: AOJu0YzWZO8H92/govZbZB9Vk7ps8wikywnwXKWKcekAXEoBC1HPB5d9
	Qz7SAGpi06KeXy64heOZxnUP3q0ANnFtGMyJkxpRzrKepZtY30GNgd65
X-Gm-Gg: Acq92OHkx8dN34SGM42KNkn/wVjTH6WvES5bpUf6tRuad8WMlNfD4mEw239Lx8bmHMp
	F4zvi2R3OBdPar9Dn2ulcdBFVYY2JjbAPL60fFAZKDrEk5xsNMdx+QRYPzqS4q2KyTVJOk6CI6o
	d9DE3URlRVZT1gvj51YWVUmHbYdEheCaTtOnJS0NZeRFMgUY0au7w2XHCzDPilS9shKgWY61fyG
	RhQ7wmLZ6PoSslVg2+khMffN3k320UERSWYmIS/+2VgkDFYXrfXhJO6da5WXZbB2oaYmOTQwpc1
	tPxAwgifMmSQtqcDN9qca4t8+icZoRPkbaflcfDgoSmjz53n+vJVQK9NZucdv7pTEoFi1v6Bf6M
	/iVvqOFdOMOdI9hXy5aYA3geP3N005yA4TmN1S5RtiMRX1YtWkItlCL5PVDzV5l0lyhh//N9Ce+
	hnNn8Cx0e3aicydVlLWEFNYlv1mEXVrxuxK7JALg4l1uu8cmZuyTo+
X-Received: by 2002:a17:90b:2d4e:b0:369:7421:75c3 with SMTP id 98e67ed59e1d1-370f096ab5emr14716407a91.16.1780925612269;
        Mon, 08 Jun 2026 06:33:32 -0700 (PDT)
Received: from n232-175-066.byted.org ([36.110.163.106])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282379db0sm17284571b3a.24.2026.06.08.06.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 06:33:31 -0700 (PDT)
From: guzebing <guzebing1612@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guzebing <guzebing1612@gmail.com>
Subject: [PATCH] io_uring/register: preserve SQ array entries on resize
Date: Mon,  8 Jun 2026 21:33:16 +0800
Message-Id: <20260608133316.3656440-1-guzebing1612@gmail.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13638-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[guzebing1612@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:guzebing1612@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[guzebing1612@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B82A7656AD1

Ring resizing copies pending SQEs from the old SQE array into the new
one so submissions queued before the resize can still be consumed
afterwards.

That copy currently walks the SQ head/tail range directly. This is only
correct when there is no SQ array indirection. With a regular SQ array,
each pending SQ entry contains an index into the SQE array. After resize,
ctx->sq_array is repointed at the newly allocated array, so pending
entries lose their old logical-to-physical mapping and may submit the
wrong SQE.

Remember the old and new SQ arrays while migrating pending SQ entries. For
each pending entry, copy the SQE selected by the old array into the new
destination slot and rebuild the new array entry to point at the copied
SQE. Keep invalid user-provided entries invalid so the normal submission
path still drops them after resize.

Fixes: 79cfe9e59c2a1 ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Signed-off-by: guzebing <guzebing1612@gmail.com>
---
 io_uring/register.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index dce5e2f9cf770..02bc103bcc9d5 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -503,6 +503,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	unsigned i, tail, old_head;
 	struct io_uring_params *p = &config.p;
 	struct io_rings_layout *rl = &config.layout;
+	u32 *o_sq_array, *n_sq_array = NULL;
 	int ret;
 
 	memset(&config, 0, sizeof(config));
@@ -589,6 +590,9 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->rings = NULL;
 	o.sq_sqes = ctx->sq_sqes;
 	ctx->sq_sqes = NULL;
+	o_sq_array = ctx->sq_array;
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		n_sq_array = (u32 *)((char *)n.rings + rl->sq_array_offset);
 
 	/*
 	 * Now copy SQ and CQ entries, if any. If either of the destination
@@ -599,20 +603,27 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (tail - old_head > p->sq_entries)
 		goto overflow;
 	for (i = old_head; i < tail; i++) {
-		unsigned index, dst_mask, src_mask;
+		unsigned int dst, src;
 		size_t sq_size;
 
-		index = i;
+		dst = i & (p->sq_entries - 1);
+		src = i & (ctx->sq_entries - 1);
+		if (n_sq_array) {
+			src = READ_ONCE(o_sq_array[src]);
+			if (unlikely(src >= ctx->sq_entries)) {
+				WRITE_ONCE(n_sq_array[dst], UINT_MAX);
+				continue;
+			}
+			WRITE_ONCE(n_sq_array[dst], dst);
+		}
+
 		sq_size = sizeof(struct io_uring_sqe);
-		src_mask = ctx->sq_entries - 1;
-		dst_mask = p->sq_entries - 1;
 		if (ctx->flags & IORING_SETUP_SQE128) {
-			index <<= 1;
+			dst <<= 1;
+			src <<= 1;
 			sq_size <<= 1;
-			src_mask = (ctx->sq_entries << 1) - 1;
-			dst_mask = (p->sq_entries << 1) - 1;
 		}
-		memcpy(&n.sq_sqes[index & dst_mask], &o.sq_sqes[index & src_mask], sq_size);
+		memcpy(&n.sq_sqes[dst], &o.sq_sqes[src], sq_size);
 	}
 	WRITE_ONCE(n.rings->sq.head, old_head);
 	WRITE_ONCE(n.rings->sq.tail, tail);
@@ -655,8 +666,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	WRITE_ONCE(n.rings->cq_overflow, READ_ONCE(o.rings->cq_overflow));
 
 	/* all done, store old pointers and assign new ones */
-	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		ctx->sq_array = (u32 *)((char *)n.rings + rl->sq_array_offset);
+	if (n_sq_array)
+		ctx->sq_array = n_sq_array;
 
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
-- 
2.20.1


