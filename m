Return-Path: <io-uring+bounces-13666-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ITH/Fv0NKmrVhwMAu9opvQ
	(envelope-from <io-uring+bounces-13666-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:23:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F09E866DA0F
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:23:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=T8NM6Gi8;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13666-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13666-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2D22307864F
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 01:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9992AD16;
	Thu, 11 Jun 2026 01:23:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144C840D593
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 01:23:00 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781140982; cv=none; b=dox/HqCd5BYMFrXAAjrJd4baGLhHmwx2SInCEuwAQPUvxE6lqFkuXlHkeKKSeplipl5FVRxzZvS3g6VnJXIul1nx3DWgxMNMEEvA636PoSgqNM/jxIvCAcR/0tV5FTNPkUcl0Td6Qzb3E0orFMDLuCcbvwfhwrDSsplhWNzzkBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781140982; c=relaxed/simple;
	bh=54E5soerW4WFvKqnvrtiTFY188BHz9ASyX/StPeL3Eg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qkpWsdpXmGYNUbE3CQwThTJgixCf8z0RNSe5jzZOQO7dUDZSEbZfJ1X4buJ/nKL5UH2lBpmhK4lg9sTimbclgxZvKe0PkB2HTowuiM5bLc9JSQ187FSq2PYnW1ymLgEUhnYt2NvW7CKOsQYHtOvEqQP4mASKFo1J+ASqNWZYlOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=T8NM6Gi8; arc=none smtp.client-ip=220.197.31.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=LG
	4aYjWV+6uAVkyULemzAIzmBdM3t7+4VuvjTO5Z6F0=; b=T8NM6Gi8ZMub/DND07
	sdABvVEI5rzIAX0pkzRYR/MLVYKCePWnLXOUMHMsyReu1zyw/IvC2kOrOocOBmmv
	2NKjs3ehRuegEslj9QJpbsnzPd41aSbiMEl7zLGGVrGHNAEsd939jlCt1dLUpZc1
	URW3FTpd39p3Abb9642xSK3aQ=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDH773gDSpqbsY_Bg--.28099S4;
	Thu, 11 Jun 2026 09:22:44 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 2/2] io_uring/timeout: cancel pending link timeouts from ltimeout_list
Date: Thu, 11 Jun 2026 09:22:36 +0800
Message-Id: <20260611012236.3020181-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260611012236.3020181-1-yangxiuwei@kylinos.cn>
References: <20260611012236.3020181-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDH773gDSpqbsY_Bg--.28099S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFWrCF4xXw43tF15tr4DCFg_yoW8Kr18pF
	Z093s8Xry8Xr42ga4fJF4DCF4a9F10kr47Ar9xWrWvyrn7Xrs2gr48t3sYqFy7Jr1kAr43
	XF40gFW5ur4UZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1tCwUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gShMmoqDeSrhgAA35
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13666-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F09E866DA0F

TIMEOUT_REMOVE and IORING_OP_ASYNC_CANCEL look up pending timeouts via
io_timeout_cancel(), but that path only scans timeout_list. Pending
link timeouts live on ltimeout_list instead, so cancel/remove by
user_data returns -ENOENT.

Fall back to ltimeout_list when the initial lookup fails, reusing
__io_disarm_linked_timeout(). Complete the disarmed link timeout via
io_req_queue_tw_complete() rather than io_req_task_queue_fail(), and
clean up the link timeout state on the head request.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 io_uring/timeout.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index c4dd26cf342d..8ecc9a7f1597 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -348,18 +348,52 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	return req;
 }
 
+static struct io_kiocb *io_linked_timeout_cancel(struct io_ring_ctx *ctx,
+						 struct io_cancel_data *cd)
+	__must_hold(&ctx->completion_lock)
+	__must_hold(&ctx->timeout_lock)
+{
+	struct io_timeout *timeout;
+
+	list_for_each_entry(timeout, &ctx->ltimeout_list, list) {
+		struct io_kiocb *link = cmd_to_io_kiocb(timeout);
+		struct io_kiocb *head;
+
+		if (!io_cancel_req_match(link, cd))
+			continue;
+		head = timeout->head;
+		if (!head)
+			return ERR_PTR(-EALREADY);
+		link = __io_disarm_linked_timeout(head, link);
+		if (!link)
+			return ERR_PTR(-EALREADY);
+		head->flags &= ~REQ_F_LINK_TIMEOUT;
+		return link;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
 int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req;
+	bool linked = false;
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
 	req = io_timeout_extract(ctx, cd);
+	if (req == ERR_PTR(-ENOENT)) {
+		req = io_linked_timeout_cancel(ctx, cd);
+		if (!IS_ERR(req))
+			linked = true;
+	}
 	raw_spin_unlock_irq(&ctx->timeout_lock);
 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-	io_req_task_queue_fail(req, -ECANCELED);
+	if (linked)
+		io_req_queue_tw_complete(req, -ECANCELED);
+	else
+		io_req_task_queue_fail(req, -ECANCELED);
 	return 0;
 }
 
-- 
2.25.1


