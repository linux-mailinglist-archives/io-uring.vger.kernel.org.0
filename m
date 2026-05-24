Return-Path: <io-uring+bounces-13495-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oNOhOmTcEmpO4wYAu9opvQ
	(envelope-from <io-uring+bounces-13495-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 13:09:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 537435C227E
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 13:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1BA2D3005770
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 11:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BFB2DF142;
	Sun, 24 May 2026 11:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGH8kiQj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593FC23D28C
	for <io-uring@vger.kernel.org>; Sun, 24 May 2026 11:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779620962; cv=none; b=WI4teuq2xjQRr10Vwh49ApMFxW0T0KQjq/kRoX7cn9AFm6drY6+HAYkl5DvM+/JaYcne1jGpyzZ+FW3gial9MGbx6tBv0QHisTm2u2V1pXywr9LPnGsGS3pQxaY53C4RCoAxfhd7F4jvXtAD+gH2H7g9wUD0oEHkuZkOPRkk4Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779620962; c=relaxed/simple;
	bh=pC9uN0BdqaLrdzaSjwcspwTpA+xTB/Mlz+hDXW8QjIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDp6yNfgz1o3VmiPxFksV+BFMoOO1XZ4Uu54xMfmN2Kld4E3V7Fiw5LJMpArnKx3ifmweUez4F/aCUDEmi1UQaCRavQvLcYLiC5oAsEzdIuwYnqqQ3EynmjtHPudvLVghYu1iCm3OKhe/hNr5Rt/IJeqsoezymlzS7AgSUQ9JK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gGH8kiQj; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c80167f5716so3771562a12.2
        for <io-uring@vger.kernel.org>; Sun, 24 May 2026 04:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779620961; x=1780225761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6c1z1yrRbK1lJKYRvmVq+VczYbzMwLJ1weWZUQ80ngg=;
        b=gGH8kiQjhfh8VTskwyFZ30wT+PbG0S+JixtFAFlhE84Z0UicrJb7W0qO4CD4Z0iqaX
         guCDQJcdxJkqeqrWOapoZ3jcWtdLTcWByyCjQNOAj8DXZDha1TQAq11u/OxlNkb8P3cK
         VNE7KE2kq1cYnsxjXeZiWZ6+562uxNfm+aNrKdE5PlqMQ3I3yQCrZsOkCuyckpt5rtb0
         fNkBiVdi8O+oZ3nV4rScbMR8gkaO9yUN9Qjer2bVb/SqKoh+WRGncOS+RKQfLdk63PS/
         KPVnWhioSv9mvhNjbBvvxZKrDB4f86tnyRm3yAqTxoXvgpeYDYylTi9dEgtmKdfTFpZZ
         kCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779620961; x=1780225761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6c1z1yrRbK1lJKYRvmVq+VczYbzMwLJ1weWZUQ80ngg=;
        b=UIpFKdYu/jH/uRN1JsYWc4TxtyykldBKlp5K0vs/fT9pBcUc+RCcDVuXfBUElQqRhI
         eQ3G9/RCX/JxoKpsk6j7zrM1Zg8VXW6UCZ/cjt50NH7XvohLXWME5KxHnellbp4XAHqc
         Ec3Mz36dyfC45x5un+ElFwqIWH449je+72oYyiCGq1AxyoCjQbFA0vBokrEa2AaNx1xh
         JG2nw7wjhZnm0xGcukGl2bojWkdn6r+yxB1Zmc727fZG4yZ9grH7vdtodzVs5p07aClc
         kVDXDzRR4ISSN8K9FX6vHiL5zFTEkI3iZ6xvDWFK50rKeD4/IGHrM05pD3PffDbZyH2K
         EgIA==
X-Forwarded-Encrypted: i=1; AFNElJ/IyZgCgKjBSgang6+1sDz7ApOXFxGibLJ3CPw1kgs+lIE3nWZHRaI5i5kUy0vMq0Ku/heHHzLIeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWxxOl1m5ONT27s47LTiIZi/G+CFJpvrKOzBnLbHF4mBsxyEEv
	Z5DFB9rqTOk7gsZFOvcOTTZ3SZX824iwLhVV5opSvnPgvcLD4QL2S4WQbmwwZg==
X-Gm-Gg: Acq92OH77FXxYEF+LOoB9aLpCBe/nMpyzOxuSChHR8uj8uBU6k0q+F6KebmmXLrfcEu
	uq64RvKiiWgKVGJY6M2YstBhi4uMelsin3qnPAPRiGNRtV7j08Z8JbIiYCIAmt/0EecHD61Uyd0
	wpTz1PBJrIBXKcWdn+gHvHMcgiMJX/UPwS5tHzktTrg5TxaB1r23m/FmQ3kR3TCpAYvZgNunhXe
	wMfGbKm7Et/Cs4JokOXhkoY5Ibo1BZaE3vy2VFP4orUUO4mjIgAQuE5fzY8apbpZzfT9tCA310Y
	aqUjV5KaTCE+XB4mAHBy9En1yhLGBxjj8yIYW3aCeqzoNOo7uNcVFPT0d0jiWUnL0aWQSr/GJFW
	v+Zd7lXSNnRWAuqdc9rNh8w5m5uUEPKUc/0FaObeYz5ecPedK3o/2klWPsam3o+CexfAsiLOOMR
	vG84CA1CoqJL3r9ufB+uZl9FFQZC8oaYksx0t8NOc=
X-Received: by 2002:a05:6300:2109:b0:3a2:f402:50df with SMTP id adf61e73a8af0-3b328f70584mr11082075637.44.1779620960540;
        Sun, 24 May 2026 04:09:20 -0700 (PDT)
Received: from localhost.tail2c6877.ts.net ([49.175.46.83])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85202902a6sm5438722a12.3.2026.05.24.04.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 04:09:20 -0700 (PDT)
From: Lim HyeonJun <shja0831@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Lim HyeonJun <shja0831@gmail.com>
Subject: [PATCH] io_uring/tctx: set ->io_uring before publishing the tctx node
Date: Sun, 24 May 2026 20:08:53 +0900
Message-ID: <20260524110853.115634-1-shja0831@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2af95968-bcb3-4ed5-9242-3f8358e71f9e@kernel.dk>
References: <2af95968-bcb3-4ed5-9242-3f8358e71f9e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13495-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shja0831@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 537435C227E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

io_register_iowq_max_workers() walks ctx->tctx_list under ctx->tctx_lock
and dereferences each node's task->io_uring without a NULL check:

	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
		tctx = node->task->io_uring;
		if (WARN_ON_ONCE(!tctx->io_wq))
			continue;
		...
	}

__io_uring_add_tctx_node() installs the node into ctx->tctx_list (via
io_tctx_install_node(), which does the list_add() under tctx_lock) and
only assigns current->io_uring = tctx afterwards. A task doing its first
io_uring operation on a shared ring therefore has a window in which its
node is already visible on ctx->tctx_list while node->task->io_uring is
still NULL. A concurrent IORING_REGISTER_IOWQ_MAX_WORKERS on the same
ring reads that NULL and dereferences tctx->io_wq:

  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  RIP: io_register_iowq_max_workers io_uring/register.c:423

Publish current->io_uring = tctx before installing the node, so any node
visible on ctx->tctx_list always has a valid task->io_uring. The
tctx_lock taken in io_tctx_install_node() orders this store before the
node becomes visible to other iterators. On the install/limits failure
paths the freshly allocated tctx is freed, so clear current->io_uring
there as well to avoid leaving a dangling pointer.

The bug reproduces on an SMP+KASAN build with a plain (non-SQPOLL) ring
shared across threads: a stream of fresh threads each do their first
io_uring_enter() while two threads spam IORING_REGISTER_IOWQ_MAX_WORKERS;
it GPFs within seconds.

Fixes: 7880174e1e5e ("io_uring/tctx: clean up __io_uring_add_tctx_node() error handling")
Signed-off-by: Lim HyeonJun <shja0831@gmail.com>
---
 io_uring/tctx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 6af62ca9baba..42b219b34aa8 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -139,12 +139,14 @@ static int io_tctx_install_node(struct io_ring_ctx *ctx,
 int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	bool new_tctx = false;
 	int ret;
 
 	if (unlikely(!tctx)) {
 		tctx = io_uring_alloc_task_context(current, ctx);
 		if (IS_ERR(tctx))
 			return PTR_ERR(tctx);
+		new_tctx = true;
 
 		if (data_race(ctx->int_flags) & IO_RING_F_IOWQ_LIMITS_SET) {
 			unsigned int limits[2];
@@ -168,13 +170,15 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 	if (tctx->io_wq)
 		io_wq_set_exit_on_idle(tctx->io_wq, false);
 
-	ret = io_tctx_install_node(ctx, tctx);
-	if (!ret) {
+	if (new_tctx)
 		current->io_uring = tctx;
+
+	ret = io_tctx_install_node(ctx, tctx);
+	if (!ret)
 		return 0;
-	}
-	if (!current->io_uring) {
 err_free:
+	if (new_tctx) {
+		current->io_uring = NULL;
 		if (tctx->io_wq) {
 			io_wq_exit_start(tctx->io_wq);
 			io_wq_put_and_exit(tctx->io_wq);
-- 
2.53.0


